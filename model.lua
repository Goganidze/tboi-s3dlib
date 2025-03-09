---@param s3dlib s3dlib
return function(s3dlib)
    ---@type s3dlib.vec3func
    local vec3 = s3dlib.vec3
    ---@type s3dlib.quatfunc
    local quat = s3dlib.quat
    local mat4 = s3dlib.mat4
    local pi = math.pi

    local vec3New,vec3add, vc = vec3.new, vec3.add, vec3.copy
    local rad,deg = math.rad, math.deg
    local fromRotationV3, rotateVec3 = quat.fromRotationV3, quat.rotateVec3

    local tabCopy = function(tab)
        local newTab = {}
        for i,k in pairs(tab) do
            newTab[i] = k
        end
        return newTab
    end


    ---@class s3dlib.modelfunc
    local model = {}

    ---@class s3dlib.model
    ---@field IsModel boolean
    ---@field pos s3dlib.vec3
    ---@field rot s3dlib.vec3
    ---@field origrot s3dlib.vec3
    ---@field rot_updated boolean
    ---@field pivotFromParent? s3dlib.vec3
    ---@field parent? s3dlib.model
    ---@field vertices s3dlib.vec3[]
    ---@field roted_vertices s3dlib.vec3[]
    ---@field id_to_vertex any[]
    ---@field orig_vertices s3dlib.vec3[]
    ---@field polygons s3dlib.polygon[]
    ---@field childs s3dlib.model[]


    ---@class s3dlib.constructorPolygonInData
    ---@field id integer
    ---@field verticespointers number[]
    ---@field spr Sprite
    ---@field shader s3dlib.shader

    ---@class s3dlib.polygon
    ---@field id integer
    ---@field verticespointers number[]
    ---@field spr Sprite
    ---@field shader s3dlib.shader

    function model.CreateConstructor()
        ---@class s3dlib.modelConstructor
        local constructor = {
            vertices = {},
            vertexByID = {},
            polygons = {},
        }
        local vercs, vercIds = constructor.vertices, constructor.vertexByID

        constructor.AddVertex = function(id, pos)
            vercs[#vercs+1] = pos
            vercIds[id] = #vercs
        end

        constructor.AddVertices = function(tab)
            for _, dat in pairs(tab) do
                constructor.AddVertex(dat[1], dat[2])
            end
        end

        ---@param data s3dlib.constructorPolygonInData
        constructor.AddPolygon = function(data)
            local poly = {
                id = data.id,
                verticespointers = data.verticespointers,
                spr = data.spr,
                shader = data.shader 
            }
            if poly.spr then
                poly.spr:SetCustomShader(data.shader.path)
            end
            
            constructor.polygons[#constructor.polygons + 1] = poly
        end

        constructor.AddChildModel = function(constr, pivot)
            constructor.childs = constructor.childs or {}
            constructor.childs[#constructor.childs + 1] = {model = constr, pivotFromParent = pivot}
        end
        
        return constructor
    end

    ---@param constructor s3dlib.modelConstructor
    ---@return s3dlib.model
    function model.FromConstructor(constructor)
        local newModel = {
            IsModel = true,
            pos = vec3New(0,0,0),
            rot = vec3New(0,0,0),
            origrot = vec3New(0,0,0),
            --pivot = vec3New(0,0,0),
            orig_vertices = constructor.vertices,
            roted_vertices = tabCopy(constructor.vertices),
            vertices = tabCopy(constructor.vertices),
            rot_updated = false,
            id_to_vertex = constructor.vertexByID,
            polygons = constructor.polygons
        }
        if constructor.childs then
            newModel.childs = {}
            for _, child in pairs(constructor.childs) do
                local childModel = model.FromConstructor(child.model)
                childModel.parent = newModel
                childModel.pivotFromParent = child.pivotFromParent
                newModel.childs[#newModel.childs + 1] = childModel
            end
        end
        return newModel
    end

    ---@param self s3dlib.model
    ---@param delta s3dlib.vec3
    function model.Move(self, delta)
        self.pos[1] = self.pos[1] + delta[1]
        self.pos[2] = self.pos[2] + delta[2]
        self.pos[3] = self.pos[3] + delta[3]
    end

     ---@param self s3dlib.model
    function model.SetPosition(self, pos)
        self.pos = pos
    end

    ---@param self s3dlib.model
    function model.Rotate(self, angleX, angleY, angleZ)
        local tpi = 2 * pi
        self.rot_updated = false
        self.origrot[1] = (self.origrot[1] + rad(angleX or 0)) % tpi
        self.origrot[2] = (self.origrot[2] + rad(angleY or 0)) % tpi
        self.origrot[3] = (self.origrot[3] + rad(angleZ or 0)) % tpi
    end

    ---@param self s3dlib.model
    function model.SetRotation(self, rot)
        self.origrot = rot
    end

    ---@param self s3dlib.model
    function model.UpdateVertices(self)
        local pos = self.pos
        self.rot = vc(self.origrot)
        local rotation_quat = fromRotationV3(self.rot)

        for i = 1, #self.orig_vertices do
            local origvertex = self.orig_vertices[i]

            local vertex = rotateVec3(rotation_quat,origvertex)
            self.vertices[i] = vec3add(vertex, pos)
        end
        if self.childs then
            for _, child in ipairs(self.childs) do
                model.UpdateChildVertices(child, self, rotation_quat)
            end
        end
    end

    ---@param self s3dlib.model
    ---@param parent s3dlib.model
    function model.UpdateChildVertices(self, parent, parent_rotation_quat)
        --self.pos = parent.pos + self.pivotFromParent
        --local pos = parent.pos
        self.rot = vec3add(parent.rot,self.origrot)
        local rotation_quat = fromRotationV3(self.rot)   --fromRotationV3(vec3add(parent.rot,self.rot))
        self.pos = vec3add(parent.pos, rotateVec3(parent_rotation_quat, self.pivotFromParent))
        local pos = self.pos

        for i = 1, #self.orig_vertices do
            local origvertex = self.orig_vertices[i]

            local vertex = rotateVec3(rotation_quat,origvertex)
            self.vertices[i] = vec3add(vertex, pos)
        end
        if self.childs then
            for _, child in ipairs(self.childs) do
                model.UpdateChildVertices(child, self, rotation_quat)
            end
        end
    end

    local ZOFFSET = 0.001
    local renderOrder = 1

    ---@param self s3dlib.model
    function model.RenderModel(self)
        local modelvertxs = self.vertices
        local modelvertById = self.id_to_vertex
        for i = 1, #self.polygons do
            local poly = self.polygons[i]
            local polyverxs = poly.verticespointers
            if poly.spr then
                local v1,v2,v3,v4 = polyverxs[1], polyverxs[2], polyverxs[3], polyverxs[4]
                local id1,id2,id3,id4 = v1 and modelvertById[v1], v2 and modelvertById[v2], v3 and modelvertById[v3], v4 and modelvertById[v4]
                local ver1,ver2,ver3,ver4 = id1 and modelvertxs[id1], id2 and modelvertxs[id2], id3 and modelvertxs[id3], id4 and modelvertxs[id4]
                poly.shader.SetParamsToShader(poly.spr, poly, ver1, ver2, ver3, ver4, ZOFFSET + renderOrder * -0.00001) --ZOFFSET + #self.polygons*0.1 + renderOrder * -0.1
---@diagnostic disable-next-line: param-type-mismatch
                poly.spr:Render(Vector(ver1[1],ver1[2]))

                renderOrder = renderOrder + 1
            end
        end
        if self.childs then
            for _, child in ipairs(self.childs) do
                model.RenderModel(child)
            end
        end
    end

    function s3dlib.BeginRender()
        renderOrder = 0
    end


    return model
end
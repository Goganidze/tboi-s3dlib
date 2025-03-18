---@param s3dlib s3dlib
return function(s3dlib)
    ---@type s3dlib.vec3func
    local vec3 = s3dlib.vec3
    ---@type s3dlib.quatfunc
    local quat = s3dlib.quat
    local mat4 = s3dlib.mat4
    local pi = math.pi

    local vec3New,vec3add, vc, vec3mul3 = vec3.new, vec3.add, vec3.copy, vec3.mulV3
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

    function model.CreateConstructor()
        ---@class s3dlib.modelConstructor
        local constructor = {
            vertices = {},
            vertexByID = {},
            polygons = {},
            polygonsById = {},
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
            constructor.polygonsById[poly.id] = poly
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
            scale = vec3New(1,1,1),
            orig_scale = vec3New(1,1,1),
            --pivot = vec3New(0,0,0),
            orig_vertices = constructor.vertices,
            roted_vertices = tabCopy(constructor.vertices),
            vertices = tabCopy(constructor.vertices),
            rot_updated = false,
            id_to_vertex = constructor.vertexByID,
            polygons = constructor.polygons,
            polygonsById = constructor.polygonsById,
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
    function model.SetScale(self, scale)
        self.scale = scale
    end

    ---@param self s3dlib.model
    function model.UpdateVertices(self)
        local pos = self.pos
        self.rot = vc(self.origrot)
        local rotation_quat = fromRotationV3(self.rot)

        local scale = self.scale
        local useScale = scale[1] ~= 1 or scale[2] ~= 1 or scale[3] ~= 1

        if useScale then
            for i = 1, #self.orig_vertices do
                local origvertex = self.orig_vertices[i]
                local scaledvertex = vec3mul3(origvertex, scale)
    
                local vertex = rotateVec3(rotation_quat,scaledvertex)
                self.vertices[i] = vec3add(vertex, pos)
            end
            if self.childs then
                for _, child in ipairs(self.childs) do
                    model.UpdateChildVertices(child, self, rotation_quat, scale)
                end
            end

        else
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
    end

    ---@param self s3dlib.model
    ---@param parent s3dlib.model
    function model.UpdateChildVertices(self, parent, parent_rotation_quat, scale)
        --self.pos = parent.pos + self.pivotFromParent
        --local pos = parent.pos

        local ChildScale = self.scale
        local pivotFromParent = self.pivotFromParent
        if scale then
            pivotFromParent = vec3mul3(pivotFromParent, scale)
            ChildScale = vec3mul3(ChildScale, scale)
        end
        self.rot = vec3add(parent.rot,self.origrot)
        local rotation_quat = fromRotationV3(self.rot)
        self.pos = vec3add(parent.pos, rotateVec3(parent_rotation_quat, pivotFromParent))
        local pos = self.pos

        if scale then
            for i = 1, #self.orig_vertices do
                local origvertex = self.orig_vertices[i]
                origvertex = vec3mul3(origvertex, ChildScale)

                local vertex = rotateVec3(rotation_quat,origvertex)
                self.vertices[i] = vec3add(vertex, pos)
            end
            if self.childs then
                for _, child in ipairs(self.childs) do
                    model.UpdateChildVertices(child, self, rotation_quat)
                end
            end
        else
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
    end

    local ZOFFSET = 65.5
    local renderOrder = 1

    ---@param self s3dlib.model
    function model.RenderModel(self)
        local modelvertxs = self.vertices
        local modelvertById = self.id_to_vertex
        --local prespr
        for i = 1, #self.polygons do
            local poly = self.polygons[i]
            local polyverxs = poly.verticespointers
            if poly.spr then
                local v1,v2,v3,v4 = polyverxs[1], polyverxs[2], polyverxs[3], polyverxs[4]
                local id1,id2,id3,id4 = v1 and modelvertById[v1], v2 and modelvertById[v2], v3 and modelvertById[v3], v4 and modelvertById[v4]
                local ver1,ver2,ver3,ver4 = id1 and modelvertxs[id1], id2 and modelvertxs[id2], id3 and modelvertxs[id3], id4 and modelvertxs[id4]
                poly.shader.SetParamsToShader(poly.spr, poly, ver1, ver2, ver3, ver4, ZOFFSET + renderOrder ) --  * -0.00001   --ZOFFSET + #self.polygons*0.1 + renderOrder * -0.1
---@diagnostic disable-next-line: param-type-mismatch
                poly.spr:Render(Vector(ver1[1] ,ver1[2]))
                
                renderOrder = renderOrder + 1
                --prespr = poly.spr
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
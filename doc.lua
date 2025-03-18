local s3dlib = {}

---@class s3dlib
---@field BeginRender fun()
---@field path string
---@field folderpath string
---@field InternalElementType InternalElementType
---@field vec3 s3dlib.vec3func
---@field mat4 s3dlib.mat4func
---@field quat s3dlib.quatfunc
---@field shader s3dlib.shaderfunc
---@field model s3dlib.modelfunc

---@class s3dlib.vec3
---@field [1] "X"|number X
---@field [2] "Y"|number Y
---@field [3] "Z"|number Z\
---@field t InternalElementType

---@class s3dlib.vec3func
---@field new fun(x, y, z):s3dlib.vec3
---@field add fun(a, b):s3dlib.vec3
---@field sub fun(a, b):s3dlib.vec3
---@field copy fun(a: any):s3dlib.vec3
---@field cross fun(a, b):s3dlib.vec3
---@field dot fun(a, b):number
---@field length fun(a):number
---@field mul fun(a:s3dlib.vec3, b:number):s3dlib.vec3
---@field mulV3 fun(a: s3dlib.vec3, b: s3dlib.vec3):s3dlib.vec3
---@field normalize fun(x:s3dlib.vec3):s3dlib.vec3
---@field rotateX fun(a:s3dlib.vec3, angle:number):s3dlib.vec3 Rotate Y-Z
---@field rotateY fun(a:s3dlib.vec3, angle:number):s3dlib.vec3 Rotate X-Z
---@field rotateZ fun(a:s3dlib.vec3, angle:number):s3dlib.vec3 Rotate X-Y

---@class s3dlib.mat4
---@field [1] number
---@field [2] number
---@field [3] number
---@field [4] number
---@field [5] number
---@field [6] number
---@field [7] number
---@field [8] number
---@field [9] number
---@field [10] number
---@field [11] number
---@field [12] number
---@field [13] number
---@field [14] number
---@field [15] number
---@field [16] number
---@field t InternalElementType

---@class s3dlib.mat4func
---@field new fun(x, y, z, w):s3dlib.mat4
---@field mul fun(a:s3dlib.mat4, b:s3dlib.mat4):s3dlib.mat4
---@field mulV3 fun(a:s3dlib.mat4, b):s3dlib.vec3
---@field addNum fun(a:s3dlib.mat4, b:number):s3dlib.mat4
---@field addMat4 fun(a:s3dlib.mat4, b:s3dlib.mat4):s3dlib.mat4
---@field subMat4 fun(a:s3dlib.mat4, b:s3dlib.mat4):s3dlib.mat4
---@field subNum fun(a:s3dlib.mat4, b:number):s3dlib.mat4
---@field translate fun(t:s3dlib.vec3):s3dlib.mat4
---@field scale fun(s:s3dlib.vec3):s3dlib.mat4

---@class s3dlib.quat
---@field [1] "X"|number
---@field [2] "Y"|number
---@field [3] "Z"|number
---@field [4] "W"|number
---@field t InternalElementType

---@class s3dlib.quatfunc
---@field new fun(x, y, z, w):s3dlib.quat
---@field fromAxisAngle fun(axis:s3dlib.vec3, angle:number):s3dlib.quat
---@field mul fun(a:s3dlib.quat, b:s3dlib.quat):s3dlib.quat
---@field toMat4 fun(a:s3dlib.quat):s3dlib.mat4
---@field fromRotation fun(x:number, y:number, z:number):s3dlib.quat
---@field fromRotationV3 fun(a:s3dlib.vec3):s3dlib.quat
---@field rotateVec3 fun(a:s3dlib.quat, b:s3dlib.vec3):s3dlib.vec3

---@class s3dlib.shaderfunc
---@field Constructor fun(data:s3dlib.shaderConstructorData):s3dlib.shader
---@field DefauldShaders table
---@field shaderRequestParamType s3dlib.shaderRequestParamType|table

---@class s3dlib.shaderConstructorData
---@field path string
---@field RequestParams s3dlib.shaderParams
---@field RequestFunc? fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number return params in order FuncReturn_

---@class s3dlib.shader
---@field path string
---@field RequestParams s3dlib.shaderParams
---@field SetParamsToShader fun(spr, poly, Vertex1Pos:s3dlib.vec3, Vertex2Pos:s3dlib.vec3, Vertex3Pos:s3dlib.vec3, Vertex4Pos:s3dlib.vec3, Z_Offset)

---@class s3dlib.shaderParams
---@field Color_R s3dlib.shaderRequestParamType|(fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number)?
---@field Color_G s3dlib.shaderRequestParamType|(fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number)?
---@field Color_B s3dlib.shaderRequestParamType|(fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number)?
---@field Color_A s3dlib.shaderRequestParamType|(fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number)?
---@field ColorColorize_R s3dlib.shaderRequestParamType|(fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number)?
---@field ColorColorize_G s3dlib.shaderRequestParamType|(fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number)?
---@field ColorColorize_B s3dlib.shaderRequestParamType|(fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number)?
---@field ColorColorize_A s3dlib.shaderRequestParamType|(fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number)?
---@field ColorOffset_R s3dlib.shaderRequestParamType|(fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number)?
---@field ColorOffset_G s3dlib.shaderRequestParamType|(fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number)?
---@field ColorOffset_B s3dlib.shaderRequestParamType|(fun(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos):number)?

---@class s3dlib.modelfunc
---@field CreateConstructor fun():s3dlib.modelConstructor
---@field FromConstructor fun(constructor:s3dlib.modelConstructor):s3dlib.model
---@field Move fun(model:s3dlib.model, pos:s3dlib.vec3)
---@field RenderModel fun(model:s3dlib.model) Don't forget to call s3dlib.BeginRender()
---@field Rotate fun(model:s3dlib.model, angleX:number, angleY:number, angleZ:number)
---@field SetPosition fun(model:s3dlib.model, pos:s3dlib.vec3)
---@field SetRotation fun(model:s3dlib.model, rot:s3dlib.vec3)
---@field SetScale fun(model:s3dlib.model, scale:s3dlib.vec3)
----@field UpdateChildVertices fun(model:s3dlib.model)
---@field UpdateVertices fun(model:s3dlib.model)

---@class s3dlib.model
---@field IsModel boolean
---@field pos s3dlib.vec3
---@field rot s3dlib.vec3
---@field scale s3dlib.vec3
---@field origrot s3dlib.vec3
---@field rot_updated boolean
---@field pivotFromParent? s3dlib.vec3
---@field parent? s3dlib.model
---@field vertices s3dlib.vec3[]
---@field roted_vertices s3dlib.vec3[]
---@field id_to_vertex any[]
---@field orig_vertices s3dlib.vec3[]
---@field polygons s3dlib.polygon[]
---@field polygonsById s3dlib.polygon[]
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




---@enum s3dlib.shaderRequestParamType
local shaderRequestParamType = {
    Vertex1_X = 1,
    Vertex1_Y = 2,
    Vertex1_Z = 3,
    Vertex2_X = 4,
    Vertex2_Y = 5,
    Vertex2_Z = 6,
    Vertex3_X = 7,
    Vertex3_Y = 8,
    Vertex3_Z = 9,
    Vertex4_X = 10,
    Vertex4_Y = 11,
    Vertex4_Z = 12,
    FuncReturn_1 = 30,
    FuncReturn_2 = 31,
    FuncReturn_3 = 32,
    FuncReturn_4 = 33,
    FuncReturn_5 = 34,
    FuncReturn_6 = 35,
    FuncReturn_7 = 36,
    FuncReturn_8 = 37,
    FuncReturn_9 = 38,
    FuncReturn_10 = 39,
    FuncReturn_11 = 40,
    Z_Offset = 100,
}


---@enum InternalElementType
local InternalElementType = {vec3 = 1,
    mat4 = 2,
    quat = 3
}




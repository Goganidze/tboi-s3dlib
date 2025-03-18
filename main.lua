return function(path, shaderspath)

if not path then
    path = "resources/shaders/3dlib_v3/"
elseif path then
    if path:sub(-1) ~= "/" then
        path = path .. "/"
    end
end


---@class s3dlib
---@field BeginRender fun()
local s3dlib = {
    path = path,
    folderpath = "resources/"..path,

---@diagnostic disable-next-line: assign-type-mismatch
    InternalElementType = {
        vec3 = 1,
        mat4 = 2,
        quat = 3
    },
}
local folderpath = s3dlib.folderpath

---@type s3dlib.vec3func
local vec3 = include(folderpath.."vec3")
---@type s3dlib.mat4func
local mat4 = include(folderpath.."mat4")
---@type s3dlib.quatfunc
local quat = include(folderpath.."quat")

s3dlib.vec3 = vec3
s3dlib.mat4 = mat4
s3dlib.quat = quat

local shader = include(folderpath.."shader")
shader = shader(s3dlib)
---@type s3dlib.shaderfunc
s3dlib.shader = shader
local model = include(folderpath.."model")
---@type s3dlib.modelfunc
model = model(s3dlib)

s3dlib.model = model

return s3dlib

end
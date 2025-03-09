---@class s3dlib.vec3func
local vec3 = {}

---@class s3dlib.vec3
---@field [1] "X"|number X
---@field [2] "Y"|number Y
---@field [3] "Z"|number Z

---@return s3dlib.vec3
function vec3.new(x, y, z)
    return {x or 0, y or 0, z or 0, t=1}
end
local new = vec3.new

function vec3.copy(v)
    return {v[1], v[2], v[3], t=1}
end

function vec3.add(a, b)
    return new(a[1] + b[1], a[2] + b[2], a[3] + b[3])
end

function vec3.sub(a, b)
    return new(a[1] - b[1], a[2] - b[2], a[3] - b[3])
end

function vec3.mul(a, scalar)
    return new(a[1] * scalar, a[2] * scalar, a[3] * scalar)
end
local mul = vec3.mul

function vec3.dot(a, b)
    return a[1] * b[1] + a[2] * b[2] + a[3] * b[3]
end

function vec3.cross(a, b)
    return new(a[2] * b[3] - a[3] * b[2], a[3] * b[1] - a[1] * b[3], a[1] * b[2] - a[2] * b[1])
end

function vec3.length(v)
    return math.sqrt(v[1] * v[1] + v[2] * v[2] + v[3] * v[3])
end
local length = vec3.length

function vec3.normalize(v)
    local len = length(v)
    if len == 0 then return new() end
    return mul(v, 1 / len)
end

return vec3
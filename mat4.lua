---@class s3dlib.mat4func
local mat4 = {}


function mat4.new(m)
    m = m or {
        t=2,
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    }
    return m
end
local new = mat4.new

function mat4.addMat4(a, b)
    local result = {t=2,}
    for i = 0, 3 do
        for j = 1, 4 do
            result[i*4 + j] = a[i*4 + j] + b[i*4 + j]
        end
    end
    return result
end

function mat4.addNum(a, b)
    local result = {t=2,}
    for i = 0, 3 do
        for j = 1, 4 do
            result[i*4 + j] = a[i*4 + j] + b
        end
    end
    return result
end

function mat4.mul(a, b)
    local result = {t=2,}
    for i = 1, 4 do
        for j = 1, 4 do
            result[(i-1) * 4 + j] = a[(i-1) * 4 + 1] * 
                b[4*0 + j] + a[(i-1) * 4 + 2] * 
                b[4*1 + j] + a[(i-1) * 4 + 3] * 
                b[4*2 + j] + a[(i-1) * 4 + 4] * 
                b[4*3 + j]
        end
    end
    return result
end
function mat4.mulV3(a, b)
    local result = {0,0,0,0,t=1}
    result[1] = a[4*0 + 1] * b[1] + a[4*0 + 2] * b[2] + a[4*0 + 3] * b[3] + a[4*0 + 4] * 1.0
    result[2] = a[4*1 + 1] * b[1] + a[4*1 + 2] * b[2] + a[4*1 + 3] * b[3] + a[4*1 + 4] * 1.0
    result[3] = a[4*2 + 1] * b[1] + a[4*2 + 2] * b[2] + a[4*2 + 3] * b[3] + a[4*2 + 4] * 1.0
    return result
end


function mat4.translate(t)
    return new({
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        t[1], t[2], t[3], 1
    })
end
function mat4.translate(t)
    return new({
        1, 0, 0, t[1],
        0, 1, 0, t[2],
        0, 0, 1, t[3],
        0, 0, 0, 1
    })
end

function mat4.scale(s)
    return new({
        s[1], 0, 0, 0,
        0, s[2], 0, 0,
        0, 0, s[3], 0,
        0, 0, 0, 1
    })
end

function mat4.perspective(fov, aspect, near, far)
    local f = 1 / math.tan(fov * 0.5)
    return mat4.new({
        f / aspect, 0, 0, 0,
        0, f, 0, 0,
        0, 0, (far + near) / (near - far), -1,
        0, 0, (2 * far * near) / (near - far), 0
    })
end

return mat4
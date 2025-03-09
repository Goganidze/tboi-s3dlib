---@class s3dlib.quatfunc
local quat = {}

---@class s3dlib.quat
---@field [1] "X"|number
---@field [2] "Y"|number
---@field [3] "Z"|number
---@field [4] "W"|number


---@return s3dlib.quat
function quat.new(x, y, z, w)
    return {x or 0, y or 0, z or 0, w or 1, t=3}
end

---@return s3dlib.quat
function quat.fromAxisAngle(axis, angle)
    local halfAngle = angle / 2
    local s = math.sin(halfAngle)
    return {
        axis[1] * s,
        axis[2] * s,
        axis[3] * s,
        math.cos(halfAngle)
    }
end

---@return s3dlib.quat
function quat.mul(a, b)
    return {
        a[4] * b[1] + a[1] * b[4] + a[2] * b[3] - a[3] * b[2],
        a[4] * b[2] - a[1] * b[3] + a[2] * b[4] + a[3] * b[1],
        a[4] * b[3] + a[1] * b[2] - a[2] * b[1] + a[3] * b[4],
        a[4] * b[4] - a[1] * b[1] - a[2] * b[2] - a[3] * b[3],
        t=3
    }
end

---@return s3dlib.mat4
function quat.toMat4(q)
    local x, y, z, w = q[1], q[2], q[3], q[4]
    return {
        1 - 2 * y * y - 2 * z * z, 2 * x * y - 2 * z * w,       2 * x * z + 2 * y * w,       0,
        2 * x * y + 2 * z * w,       1 - 2 * x * x - 2 * z * z, 2 * y * z - 2 * x * w,       0,
        2 * x * z - 2 * y * w,       2 * y * z + 2 * x * w,       1 - 2 * x * x - 2 * y * y, 0,
        0,                          0,                          0,                          1,
        t=2
    }
end

---@return s3dlib.quat
function quat.fromRotation(x, y, z)
    local halfX = x * 0.5
    local halfY = y * 0.5
    local halfZ = z * 0.5

    local sinX = math.sin(halfX)
    local cosX = math.cos(halfX)
    local sinY = math.sin(halfY)
    local cosY = math.cos(halfY)
    local sinZ = math.sin(halfZ)
    local cosZ = math.cos(halfZ)

    local w = cosX * cosY * cosZ + sinX * sinY * sinZ
    local x = sinX * cosY * cosZ - cosX * sinY * sinZ
    local y = cosX * sinY * cosZ + sinX * cosY * sinZ
    local z = cosX * cosY * sinZ - sinX * sinY * cosZ

    return {x, y, z, w, t=3}
end

---@return s3dlib.quat
function quat.fromRotationV3(vec3)
    local halfX = vec3[1] * 0.5
    local halfY = vec3[2] * 0.5
    local halfZ = vec3[3] * 0.5

    local sinX = math.sin(halfX)
    local cosX = math.cos(halfX)
    local sinY = math.sin(halfY)
    local cosY = math.cos(halfY)
    local sinZ = math.sin(halfZ)
    local cosZ = math.cos(halfZ)

    local w = cosX * cosY * cosZ + sinX * sinY * sinZ
    local x = sinX * cosY * cosZ - cosX * sinY * sinZ
    local y = cosX * sinY * cosZ + sinX * cosY * sinZ
    local z = cosX * cosY * sinZ - sinX * sinY * cosZ

    return {x, y, z, w, t=3}
end

---@param q s3dlib.quat
---@param vec s3dlib.vec3
---@return s3dlib.vec3
function quat.rotateVec3(q, vec)
    local x, y, z, w = q[1], q[2], q[3], q[4]
    local vx, vy, vz = vec[1], vec[2], vec[3]

    local ax = y * vz - z * vy
    local ay = z * vx - x * vz
    local az = x * vy - y * vx

    local t1x = 2 * w * ax
    local t1y = 2 * w * ay
    local t1z = 2 * w * az

    local dot = x * vx + y * vy + z * vz
    local qxyzLenSq = x*x + y*y + z*z

    local t2x = 2 * (dot * x - qxyzLenSq * vx)
    local t2y = 2 * (dot * y - qxyzLenSq * vy)
    local t2z = 2 * (dot * z - qxyzLenSq * vz)

    local rx = vx + t1x + t2x
    local ry = vy + t1y + t2y
    local rz = vz + t1z + t2z

    return { rx, ry, rz, t=1 }
end



return quat
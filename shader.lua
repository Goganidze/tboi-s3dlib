return function (s3dlib)

local Options = Options
local floor = math.floor

local path = s3dlib.path

---@class s3dlib.shaderfunc
local shader = {}

----@enum s3dlib.shaderRequestParamType
shader.shaderRequestParamType = {
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
local shaderRequestParamType = shader.shaderRequestParamType

local shaderRequestParamTypeToString = {
    [shaderRequestParamType.Vertex1_X] = "Vertex1Pos[1]",
    [shaderRequestParamType.Vertex1_Y] = "Vertex1Pos[2]",
    [shaderRequestParamType.Vertex1_Z] = "Vertex1Pos[3]",
    [shaderRequestParamType.Vertex2_X] = "Vertex2Pos[1]",
    [shaderRequestParamType.Vertex2_Y] = "Vertex2Pos[2]",
    [shaderRequestParamType.Vertex2_Z] = "Vertex2Pos[3]",
    [shaderRequestParamType.Vertex3_X] = "Vertex3Pos[1]",
    [shaderRequestParamType.Vertex3_Y] = "Vertex3Pos[2]",
    [shaderRequestParamType.Vertex3_Z] = "Vertex3Pos[3]",
    [shaderRequestParamType.Vertex4_X] = "Vertex4Pos[1]",
    [shaderRequestParamType.Vertex4_Y] = "Vertex4Pos[2]",
    [shaderRequestParamType.Vertex4_Z] = "Vertex4Pos[3]",
    [shaderRequestParamType.Z_Offset] = "Z_Offset",
    [shaderRequestParamType.FuncReturn_1] = "FuncReturn_1",
    [shaderRequestParamType.FuncReturn_2] = "FuncReturn_2",
    [shaderRequestParamType.FuncReturn_3] = "FuncReturn_3",
    [shaderRequestParamType.FuncReturn_4] = "FuncReturn_4",
    [shaderRequestParamType.FuncReturn_5] = "FuncReturn_5",
    [shaderRequestParamType.FuncReturn_6] = "FuncReturn_6", 
    [shaderRequestParamType.FuncReturn_7] = "FuncReturn_7",
    [shaderRequestParamType.FuncReturn_8] = "FuncReturn_8",
    [shaderRequestParamType.FuncReturn_9] = "FuncReturn_9",
    [shaderRequestParamType.FuncReturn_10] = "FuncReturn_10",
    [shaderRequestParamType.FuncReturn_11] = "FuncReturn_11",
}

local idkhowname = {
    "Color_R","Color_G","Color_B","Color_A","ColorColorize_R","ColorColorize_G",
    "ColorColorize_B","ColorColorize_A","ColorOffset_R","ColorOffset_G","ColorOffset_B",
}


local function GSOfRP(param, num)  --GetStrOfRequestParam\
    if param then
        if type(param) == "function" then
            return "RequestParams." .. idkhowname[num] .. "(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos)"
        elseif type(param) == "number" then
            return shaderRequestParamTypeToString[param]
        end
    else
        return "0"
    end
end


---@param data s3dlib.shaderConstructorData
---@return s3dlib.shader
function shader.Constructor(data)
    local shade = {
        path = data.path,
        RequestParams = data.RequestParams
    }

    --[[shade.SetParamsToShader = function(spr, params)
        local sprCol = spr.Color
        sprCol:SetTint(params[1], params[2], params[3], params[4])
        sprCol:SetColorize(params[5], params[6], params[7], params[8])
        sprCol:SetOffset( params[9], params[10], params[11] )
    end]]

    --shade.SetParamsToShader = function(spr, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos, Z_Offset)

    local hasFuncReturns = data.RequestFunc or data.RequestParams.RequestFunc
    local RequestFuncreturns = {}
    local RequestFuncreturnsByNum = {}
    if hasFuncReturns then
        for i,k in pairs(data.RequestParams) do
            --if i:find"FuncReturn_" then
            if type(k) == "number" and k >= shader.shaderRequestParamType.FuncReturn_1 and k <= shader.shaderRequestParamType.FuncReturn_11 then
                RequestFuncreturns[#RequestFuncreturns+1] = k-shader.shaderRequestParamType.FuncReturn_1+1 -- {i, k-shader.shaderRequestParamType.FuncReturn_1+1}
                --RequestFuncreturnsByNum[tonumber(i:sub(12))] = i
            end
        end
        table.sort(RequestFuncreturnsByNum, function(a,b) return a:sub(12)<b:sub(12) end )
    end
    local returnedParamsStr = ""

    if #RequestFuncreturns > 0 then
        returnedParamsStr = "local "
        for i,k in ipairs(RequestFuncreturns) do
            returnedParamsStr = returnedParamsStr .. "FuncReturn_".. k .. ", "
        end
        if returnedParamsStr:sub(-2) == ", " then
            returnedParamsStr = returnedParamsStr:sub(1, -3)
        end
        returnedParamsStr = returnedParamsStr .. " = RequestFunc(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos, Z_Offset)\n"
    end

    local refSetParamsToShader = "return function(RequestParams, RequestFunc) return function(spr, poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos, Z_Offset) local sprCol = spr.Color \n" ..
        returnedParamsStr .. --" print(Vertex4Pos[1],Vertex4Pos[2],Vertex4Pos[3]) "..
        "sprCol:SetTint(" .. GSOfRP(data.RequestParams.Color_R, 1)..", "..GSOfRP(data.RequestParams.Color_G, 2)..", "..
            GSOfRP(data.RequestParams.Color_B, 3)..", "..GSOfRP(data.RequestParams.Color_A, 4)..")\n"..
        "sprCol:SetColorize(" .. GSOfRP(data.RequestParams.ColorColorize_R, 5)..", "..GSOfRP(data.RequestParams.ColorColorize_G, 6)..", "..
            GSOfRP(data.RequestParams.ColorColorize_B, 7)..", "..GSOfRP(data.RequestParams.ColorColorize_A, 8)..")\n"..
        "sprCol:SetOffset( "..GSOfRP(data.RequestParams.ColorOffset_R, 9)..", "..GSOfRP(data.RequestParams.ColorOffset_G, 10)..", "..
            GSOfRP(data.RequestParams.ColorOffset_B, 11)..")\n end end"

    shade.SetParamsToShader = load(refSetParamsToShader)()(data.RequestParams, hasFuncReturns)

    return shade
end

local packQual = function (x,y)
    local y1 = y<<11
    local packed = y1 + x
    return packed
end



shader.DefauldShaders = {
    ["3Vertices"] = shader.Constructor{
        path = path.."shaders/WDM_def_3v",
        RequestParams = {
            Color_R = shaderRequestParamType.Vertex3_X,
            Color_G = shaderRequestParamType.Vertex3_Y,
            Color_B = shaderRequestParamType.Vertex3_Z,
            Color_A = shaderRequestParamType.Vertex1_Z,
            ColorColorize_R = shaderRequestParamType.Vertex2_X,
            ColorColorize_G = shaderRequestParamType.Vertex2_Y,
            ColorColorize_B = shaderRequestParamType.Vertex2_Z,
            ColorColorize_A = shaderRequestParamType.Z_Offset,
            ColorOffset_R = function() return Options.MaxRenderScale end,
        }
    },
    ["4Vertices"] = shader.Constructor{
        path = path.."shaders/WDM_def_4v",
        RequestParams = {
            Color_R = shaderRequestParamType.Vertex4_X,
            Color_G = shaderRequestParamType.Vertex4_Y,
            Color_B = shaderRequestParamType.Vertex4_Z,
            Color_A = shaderRequestParamType.Vertex1_Z,
            ColorColorize_R = shaderRequestParamType.Vertex2_X,
            ColorColorize_G = shaderRequestParamType.Vertex2_Y,
            ColorColorize_B = shaderRequestParamType.Vertex2_Z,
            ColorColorize_A = function(poly, Vertex1Pos, Vertex2Pos, Vertex3Pos, Vertex4Pos, Z_Offset) 
                return packQual(Z_Offset,Options.MaxRenderScale) 
            end,  --shaderRequestParamType.Z_Offset,
            ColorOffset_R = shaderRequestParamType.Vertex3_X,
            ColorOffset_G = shaderRequestParamType.Vertex3_Y,
            ColorOffset_B = shaderRequestParamType.Vertex3_Z
        }
    },
    ["test"] = shader.Constructor{
        path = path.."shaders/PhysHairWhiteOutline",
        RequestParams = {
            Color_R = function() return 1 end,
            Color_G = function() return 1 end,
            Color_B = function() return 1 end,
            Color_A = function() return 1 end,
        }
    }
}






return shader
end
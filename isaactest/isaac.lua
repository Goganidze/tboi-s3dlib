return function (mod, path)

    local isaacgfxpath = path.."isaactest/isaactest.anm2"

    path = path:gsub("resources/", "", 1)

    local function GenSprite(gfx,anim,frame)
        if gfx and anim then
        local spr = Sprite()
        spr:Load(gfx, true)
        spr:Play(anim)
        if frame then
            spr:SetFrame(frame)
        end
        return spr
        end
    end


    local s3dlib = include("resources/"..path.."main")
    ---@type s3dlib
    s3dlib = s3dlib(path)

    local v3n, v3r, v3rZ, v3a = s3dlib.vec3.new, s3dlib.vec3.rotateY, s3dlib.vec3.rotateZ, s3dlib.vec3.add

    local modelfunc = s3dlib.model
    
    local isaachead_const = modelfunc.CreateConstructor()
    isaachead_const.AddVertices{
        {0, v3n(-0, 0, 0)},

        {1, v3r(v3n(-0, -2, 9), 0)},
        {2, v3r(v3n(-0, -2, 9), 45)},
        {3, v3r(v3n(-0, -2, 9), 90)},
        {4, v3r(v3n(-0, -2, 9), 135)},
        {5, v3r(v3n(-0, -2, 9), 180)},
        {6, v3r(v3n(-0, -2, 9), 225)},
        {7, v3r(v3n(-0, -2, 9), 270)},
        {8, v3r(v3n(-0, -2, 9), 315)},

        {9, v3r(v3n(-0, -9, 14), 45)},
        {10, v3r(v3n(-0, -9, 15), 90)},
        {11, v3r(v3n(-0, -9, 15), 135)},
        {12, v3r(v3n(-0, -9, 15), 180)},
        {13, v3r(v3n(-0, -9, 15), 225)},
        {14, v3r(v3n(-0, -9, 15), 270)},
        {15, v3r(v3n(-0, -9, 14), 315)},
        {16, v3r(v3n(-0, -9, 14), 360)},

        {17, v3r(v3n(-0, -18, 14), 45)},
        {18, v3r(v3n(-0, -18, 15), 90)},
        {19, v3r(v3n(-0, -18, 15), 135)},
        {20, v3r(v3n(-0, -18, 15), 180)},
        {21, v3r(v3n(-0, -18, 15), 225)},
        {22, v3r(v3n(-0, -18, 15), 270)},
        {23, v3r(v3n(-0, -18, 14), 315)},
        {24, v3r(v3n(-0, -18, 14), 360)},

        {25, v3r(v3n(-0, -25, 9), 45)},
        {26, v3r(v3n(-0, -25, 9), 90)},
        {27, v3r(v3n(-0, -25, 9), 135)},
        {28, v3r(v3n(-0, -25, 9), 180)},
        {29, v3r(v3n(-0, -25, 9), 225)},
        {30, v3r(v3n(-0, -25, 9), 270)},
        {31, v3r(v3n(-0, -25, 9), 315)},
        {32, v3r(v3n(-0, -25, 9), 360)},

        {33, v3n(-0, -27, 0)},

        {100, v3n(-13, -18+1.5, 10)},
        {101, v3n(-5, -18+1.5, 13)},
        {102, v3n(-13, -12+1.5, 10)},
        {103, v3n(-5, -12+1.5, 13)},

        {112, v3n(-10, -2.5, 10-2)},
        {113, v3n(-5, -2.5, 13-2)},
        
        {104, v3n(5, -18+1.5, 13)},
        {105, v3n(13, -18+1.5, 10)},
        {106, v3n(5, -12+1.5, 13)},
        {107, v3n(13, -12+1.5, 10)},

        {116, v3n(5, -2.5, 13-2)},
        {117, v3n(10, -2.5, 10-2)},

        {140, v3n(-4, -12, 14.05)},
        {141, v3n(4, -12, 14.05)},
        {142, v3n(-4, -7, 14.05)},
        {143, v3n(4, -7, 14.05)},

        {201, v3n(-10, -32, -10)},
        {202, v3n(10, -32, -10)},
        {203, v3n(-10, -32, 10)},
        {204, v3n(10, -32, 10)},

    }

    local bodysprv3 = GenSprite(isaacgfxpath, "4v")
    local bodysprv4 = GenSprite(isaacgfxpath, "4v")
    local bodysprv4d = GenSprite(isaacgfxpath, "4vd")
    bodysprv4.Scale = Vector(2,2)

    local n = 0
    local function qadd(v1,v2,v3,v4)
        n = n + 1
        if v4 then
            isaachead_const.AddPolygon{
                id = n,
                verticespointers = {v1, v2, v3, v4},
                spr = bodysprv4,
                shader = s3dlib.shader.DefauldShaders["4Vertices"]
            }
        else
            isaachead_const.AddPolygon{
                id = n,
                verticespointers = {v1, v2, v3},
                spr = bodysprv3,
                shader = s3dlib.shader.DefauldShaders["3Vertices"]
            }
        end
    end

    --[[isaachead_const.AddPolygon{
        id = 0,
        verticespointers = {25, 18, 17},
        spr = bodysprv3,
        shader = s3dlib.shader.DefauldShaders["3Vertices"]
    }]]
    qadd(25,33,26)
    qadd(26,33,27)
    qadd(27,33,28)
    qadd(28,33,29)
    qadd(29,33,30)
    qadd(30,33,31)
    qadd(31,33,32)
    qadd(32,33,25)

    qadd(25, 32, 17, 24)
    qadd(26, 25, 18, 17)
    qadd(27, 26, 19, 18)
    qadd(28, 27, 20, 19)
    qadd(29, 28, 21, 20)
    qadd(30, 29, 22, 21)
    qadd(31, 30, 23, 22)
    qadd(32, 31, 24, 23)

    qadd(19, 18, 10, 9)
    qadd(20, 19, 11, 10)
    qadd(21, 20, 12, 11)
    qadd(22, 21, 13, 12)
    qadd(23, 22, 14, 13)
    qadd(24, 23, 15, 14)
    qadd(17, 24, 16, 15)
    qadd(18, 17, 9, 16)

    qadd(10, 9, 2, 1)
    qadd(11, 10, 3, 2)
    qadd(12, 11, 4, 3)
    qadd(13, 12, 5, 4)
    qadd(14, 13, 6, 5)
    qadd(15, 14, 7, 6)
    qadd(16, 15, 8, 7)
    qadd(9, 16, 1, 8)

    qadd( 1, 0, 8)
    qadd( 2, 0, 1)
    qadd( 3, 0, 2)
    qadd( 4, 0, 3)
    qadd( 5, 0, 4)
    qadd( 6, 0, 5)
    qadd( 7, 0, 6)
    qadd( 8, 0, 7)


    isaachead_const.AddPolygon{
        id = 10,
        verticespointers = {100, 101, 102, 103},
        spr = GenSprite(isaacgfxpath, "eye"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    isaachead_const.AddPolygon{
        id = 0,
        verticespointers = {102, 103, 112, 113},
        spr = GenSprite(isaacgfxpath, "teer"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    isaachead_const.AddPolygon{
        id = 11,
        verticespointers = {104, 105, 106, 107},
        spr = GenSprite(isaacgfxpath, "eye"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    isaachead_const.AddPolygon{
        id = 0,
        verticespointers = {106, 107, 116, 117},
        spr = GenSprite(isaacgfxpath, "teer"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }

    isaachead_const.AddPolygon{
        id = 0,
        verticespointers = {140, 141, 142, 143},
        spr = GenSprite(isaacgfxpath, "рот"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    
    local isaacbody_const = modelfunc.CreateConstructor()
    isaacbody_const.AddVertices{
        {0, v3n(-2, 2, 10)},
        {1, v3n(2, 2, 10)},
        {2, v3n(2, -2, 10)},
        {3, v3n(-2, -2, 10)},

        {4, v3rZ(v3n(-0, 6, 5), 180+45)},
        {5, v3rZ(v3n(-0, 6, 5), 180+90)},
        {6, v3rZ(v3n(-0, 6, 5), 180+135)},
        {7, v3rZ(v3n(-0, 6, 5), 180+180)},
        {8, v3rZ(v3n(-0, 6, 5), 180+225)},
        {9, v3rZ(v3n(-0, 6, 5), 180+270)},
        {10, v3rZ(v3n(-0, 6, 5), 180+315)},
        {11, v3rZ(v3n(-0, 6, 5), 180+360)},

        {12, v3n(-2, 2, 0)},
        {13, v3n(2, 2, 0)},
        {14, v3n(2, -2, 0)},
        {15, v3n(-2, -2, 0)},
    }

    local n = 0
    local function qadd2(v1,v2,v3,v4)
        n = n + 1
        if v4 then
            isaacbody_const.AddPolygon{
                id = n,
                verticespointers = {v1, v2, v3, v4},
                spr = bodysprv4,
                shader = s3dlib.shader.DefauldShaders["4Vertices"]
            }
        else
            isaacbody_const.AddPolygon{
                id = n,
                verticespointers = {v1, v2, v3},
                spr = bodysprv3,
                shader = s3dlib.shader.DefauldShaders["3Vertices"]
            }
        end
    end

    qadd2(3,2,0,1)
    
    qadd2(2,1,5)
    qadd2(1,0,7)
    qadd2(0,3,9)
    qadd2(3,2,11)

    qadd2(7,1,6,5)
    qadd2(5,2,4,11)
    qadd2(11,3,10,9)
    qadd2(9,0,8,7)

    qadd2(7,12,13)
    qadd2(5,13,14)
    qadd2(11,14,15)
    qadd2(9,15,12)

    qadd2(7,6,13,5)
    qadd2(5,4,14,11)
    qadd2(11,10,15,9)
    qadd2(9,8,12,7)

    qadd2(14,15,13,12)


    local isaacBodyModel = modelfunc.FromConstructor(isaacbody_const)
    modelfunc.SetScale(isaacBodyModel, v3n(1.3,1.2,1.3))



    local isaacModel = modelfunc.FromConstructor(isaachead_const)

    local bodyrot, headRot = v3n( math.rad(10), 0, 0), v3n(math.rad(-60),0,0)
    local bodyVecAngle = Vector(0,1)

    GtestVec = {265.,145, 195}
    GSCALE = 1
    local headScale = 0.8

    local curFrame = 0

    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
        if curFrame ~= Isaac.GetFrameCount() then
            s3dlib.BeginRender()
            curFrame = Isaac.GetFrameCount()
        end

        local shootvector = player:GetShootingJoystick()
        local bodyangle = player:GetSmoothBodyRotation()
        if shootvector:Length() < 0.1 then
            shootvector = Vector.FromAngle(bodyangle)  -- Vector(0,1)
        end
        local IsShootFrame = player:GetSprite():GetOverlayFrame() > 1

        isaacModel.polygonsById[10].spr:SetFrame(IsShootFrame and 1 or 0)
        isaacModel.polygonsById[11].spr:SetFrame(IsShootFrame and 1 or 0)

        local playerPos =  Isaac.WorldToScreen(player.Position)
        modelfunc.SetPosition(isaacModel, v3n(playerPos.X, playerPos.Y, 10))
        modelfunc.SetRotation(isaacModel, headRot)  --math.rad(0), math.rad(45), math.rad(0))
        --modelfunc.SetRotation(isaacModel.childs[1], headRot)   --math.rad(45), math.rad(0), math.rad(0))
        modelfunc.SetScale(isaacModel, IsShootFrame and v3n(1*headScale, 0.8*headScale, 1*headScale) or v3n(1*headScale, 1*headScale, 1*headScale))
        modelfunc.UpdateVertices(isaacModel)
        modelfunc.RenderModel(isaacModel)

        modelfunc.SetPosition(isaacBodyModel, v3n(playerPos.X, playerPos.Y, 5))
        modelfunc.SetRotation(isaacBodyModel, bodyrot)
        modelfunc.UpdateVertices(isaacBodyModel)
        modelfunc.RenderModel(isaacBodyModel)
        

        bodyVecAngle.X = bodyVecAngle.X * 0.8 + shootvector.X * 0.2
        bodyVecAngle.Y = bodyVecAngle.Y * 0.8 + shootvector.Y * 0.2

        headRot[3] = math.rad(bodyVecAngle:GetAngleDegrees()-90)
        bodyrot[3] = math.rad(bodyangle-90)

        Isaac.DrawLine(playerPos, playerPos+bodyVecAngle*30, KColor(.5,1,1,1), KColor(.5,1,1,1), 2)
        
    end)

    local _3dTest = {name = "ExtraDebug_3dchesttest", size = Vector(160,112), curface = 1}
        local self
        self = WORSTDEBUGMENU.AddButtonOnDebugBar("3dTest_Menu", Vector(32,32), WORSTDEBUGMENU.UIs.luamod_debug, function(button) 
            if button ~= 0 then return end
            ---@type Window
            _3dTest.wind = WORSTDEBUGMENU.wma.ShowWindow(_3dTest.name, self.pos+Vector(0,15), _3dTest.size)
        end, nil)

        local self
        self = WORSTDEBUGMENU.wma.AddGragFloat(_3dTest.name, "XPovorot", Vector(4, 20), Vector(140, 8), nil, 
        nil, function (btn, value)
            headRot[1] = math.rad(value*360) -- 0.5
        end, function (pos)
            WORSTDEBUGMENU.wma.RenderCustomButton2(pos, self)
            WORSTDEBUGMENU.wma.DrawText(0, "head.X: " .. math.deg(headRot[1]), pos.X, pos.Y+5, nil, nil, nil)
        end, 0)

        local self
        self = WORSTDEBUGMENU.wma.AddGragFloat(_3dTest.name, "zoof2X", Vector(4, 20 + 16), Vector(140, 8), nil, 
        nil, function (btn, value)
            headRot[1] = math.rad(value*360) -- 0.5
        end, function (pos)
            WORSTDEBUGMENU.wma.RenderCustomButton2(pos, self)
            WORSTDEBUGMENU.wma.DrawText(0, "headRot.X: " .. headRot[1], pos.X, pos.Y+5, nil, nil, nil)
        end, 0)

        local self
        self = WORSTDEBUGMENU.wma.AddGragFloat(_3dTest.name, "zoof2", Vector(4, 20 + 32), Vector(140, 8), nil, 
        nil, function (btn, value)
            headRot[2] = math.rad(value*360) -- 0.5
        end, function (pos)
            WORSTDEBUGMENU.wma.RenderCustomButton2(pos, self)
            WORSTDEBUGMENU.wma.DrawText(0, "headRot.Y: " .. headRot[2], pos.X, pos.Y+5, nil, nil, nil)
        end, 0)

        local self
        self = WORSTDEBUGMENU.wma.AddGragFloat(_3dTest.name, "zoof3", Vector(4, 20 + 48), Vector(140, 8), nil, 
        nil, function (btn, value)
            headRot[3] = math.rad(value*360) -- 0.5
        end, function (pos)
            WORSTDEBUGMENU.wma.RenderCustomButton2(pos, self)
            WORSTDEBUGMENU.wma.DrawText(0, "headRot.Z: " .. headRot[3], pos.X, pos.Y+5, nil, nil, nil)
        end, 0)

end
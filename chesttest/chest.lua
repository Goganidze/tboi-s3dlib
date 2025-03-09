return function (mod, GenSprite)

    local chestgfxpath = "shaders/3dlib_v3/chesttest/chest_test2.anm2"


    local s3dlib = include"resources/shaders/3dlib_v3/main"
    ---@type s3dlib
    s3dlib = s3dlib("shaders/3dlib_v3")

    local v3n = s3dlib.vec3.new

    local modelfunc = s3dlib.model

    local chest_const = modelfunc.CreateConstructor()

    chest_const.AddVertex(0, v3n(-12, 0, 12))
    chest_const.AddVertex(1, v3n(12, 0, 12))
    chest_const.AddVertex(2, v3n(-12, 16, 12))
    chest_const.AddVertex(3, v3n(12, 16, 12))

    chest_const.AddVertex(4, v3n(-12, 0, -12))
    chest_const.AddVertex(5, v3n(12, 0, -12))
    chest_const.AddVertex(6, v3n(-12, 16, -12))
    chest_const.AddVertex(7, v3n(12, 16, -12))
    

    chest_const.AddPolygon{
        id = 0,
        verticespointers = {0, 1, 2, 3},
        spr = GenSprite(chestgfxpath, "main_front"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chest_const.AddPolygon{
        id = 1,
        verticespointers = {4, 0, 6, 2},
        spr = GenSprite(chestgfxpath, "main_left"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chest_const.AddPolygon{
        id = 1,
        verticespointers = {1, 5, 3, 7},
        spr = GenSprite(chestgfxpath, "main_right"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chest_const.AddPolygon{
        id = 2,
        verticespointers = {5, 4, 7, 6},
        spr = GenSprite(chestgfxpath, "main_back"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chest_const.AddPolygon{
        id = 3,
        verticespointers = {4, 5, 0, 1},
        spr = GenSprite(chestgfxpath, "main_up"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chest_const.AddPolygon{
        id = 4,
        verticespointers = {2, 3, 6, 7},
        spr = GenSprite(chestgfxpath, "main_down"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }

    
    local chesthead_const = modelfunc.CreateConstructor()
    chesthead_const.AddVertices{
        {0, v3n(-12, -9, 24)},
        {1, v3n(12, -9, 24)},
        {2, v3n(-12, 0, 24)},
        {3, v3n(12, 0, 24)},
        {4, v3n(-12, -9, 0)},
        {5, v3n(12, -9, 0)},
        {6, v3n(-12, 0, 0)},
        {7, v3n(12, 0, 0)}
    }
    chesthead_const.AddPolygon{
        id = 0,
        verticespointers = {0, 1, 2, 3},
        spr = GenSprite(chestgfxpath, "head_front"), 
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chesthead_const.AddPolygon{
        id = 1,
        verticespointers = {4, 0, 6, 2},
        spr = GenSprite(chestgfxpath, "head_left"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chesthead_const.AddPolygon{
        id = 1,
        verticespointers = {1, 5, 3, 7},
        spr = GenSprite(chestgfxpath, "head_right"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chesthead_const.AddPolygon{
        id = 2,
        verticespointers = {5, 4, 7, 6},
        spr = GenSprite(chestgfxpath, "head_back"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chesthead_const.AddPolygon{
        id = 3,
        verticespointers = {4, 5, 0, 1},
        spr = GenSprite(chestgfxpath, "head_up"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chesthead_const.AddPolygon{
        id = 4,
        verticespointers = {2, 3, 6, 7},
        spr = GenSprite(chestgfxpath, "head_down"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chest_const.AddChildModel(chesthead_const, v3n(0,0,-12))

    local chestheadlock_const = modelfunc.CreateConstructor()
    chestheadlock_const.AddVertices{
        {0, v3n(-3, -8, 2)},
        {1, v3n(3, -8, 2)},
        {2, v3n(-3, 0, 2)},
        {3, v3n(3, 0, 2)},
        {4, v3n(-3, -8, 0)},
        {5, v3n(3, -8, 0)},
        {6, v3n(-3, 0, 0)},
        {7, v3n(3, 0, 0)}
    }
    chestheadlock_const.AddPolygon{
        id = 0,
        verticespointers = {0, 1, 2, 3},
        spr = GenSprite(chestgfxpath, "lock_front"), 
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chestheadlock_const.AddPolygon{
        id = 1,
        verticespointers = {4, 0, 6, 2},
        spr = GenSprite(chestgfxpath, "lock_right"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chestheadlock_const.AddPolygon{
        id = 1,
        verticespointers = {1, 5, 3, 7},
        spr = GenSprite(chestgfxpath, "lock_right"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chestheadlock_const.AddPolygon{
        id = 2,
        verticespointers = {5, 4, 7, 6},
        spr = GenSprite(chestgfxpath, "lock_front"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chestheadlock_const.AddPolygon{
        id = 3,
        verticespointers = {4, 5, 0, 1},
        spr = GenSprite(chestgfxpath, "lock_up"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chestheadlock_const.AddPolygon{
        id = 4,
        verticespointers = {2, 3, 6, 7},
        spr = GenSprite(chestgfxpath, "lock_down"),
        shader = s3dlib.shader.DefauldShaders["4Vertices"]
    }
    chesthead_const.AddChildModel(chestheadlock_const, v3n(0,4,24))



    local chestModel = modelfunc.FromConstructor(chest_const)

    local bodyrot, headRot = v3n(0,0,0), v3n(0,0,0)

    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, player)
        s3dlib.BeginRender()

        local playerPos =  Isaac.WorldToScreen(player.Position)
        modelfunc.SetPosition(chestModel, v3n(playerPos.X, playerPos.Y - 10, 1))
        modelfunc.SetRotation(chestModel, bodyrot)  --math.rad(0), math.rad(45), math.rad(0))
        modelfunc.SetRotation(chestModel.childs[1], headRot)   --math.rad(45), math.rad(0), math.rad(0))
        modelfunc.UpdateVertices(chestModel)
        modelfunc.RenderModel(chestModel)

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
            bodyrot[1] = math.rad(value*360) -- 0.5
        end, function (pos)
            WORSTDEBUGMENU.wma.RenderCustomButton2(pos, self)
            WORSTDEBUGMENU.wma.DrawText(0, "bodyrot.X: " .. bodyrot[1], pos.X, pos.Y+5, nil, nil, nil)
        end, 0)

        local self
        self = WORSTDEBUGMENU.wma.AddGragFloat(_3dTest.name, "zoof2", Vector(4, 20 + 32), Vector(140, 8), nil, 
        nil, function (btn, value)
            bodyrot[2] = math.rad(value*360) -- 0.5
        end, function (pos)
            WORSTDEBUGMENU.wma.RenderCustomButton2(pos, self)
            WORSTDEBUGMENU.wma.DrawText(0, "bodyrot.Y: " .. bodyrot[2], pos.X, pos.Y+5, nil, nil, nil)
        end, 0)

        local self
        self = WORSTDEBUGMENU.wma.AddGragFloat(_3dTest.name, "zoof3", Vector(4, 20 + 48), Vector(140, 8), nil, 
        nil, function (btn, value)
            bodyrot[3] = math.rad(value*360) -- 0.5
        end, function (pos)
            WORSTDEBUGMENU.wma.RenderCustomButton2(pos, self)
            WORSTDEBUGMENU.wma.DrawText(0, "bodyrot.Z: " .. bodyrot[3], pos.X, pos.Y+5, nil, nil, nil)
        end, 0)

end
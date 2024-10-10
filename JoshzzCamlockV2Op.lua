local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CamlockState = false
local Prediction = 0.18474847487487474
local HorizontalPrediction = 0.827282
local VerticalPrediction = 0.174747743774747474737737373773
local XPrediction = 20
local YPrediction = 200

local Locked = true
getgenv().Key = "q"

local enemy = nil
local strafeAngle = 0
local Locking = true

local camera = workspace.CurrentCamera
local delayTime = 0.2
local smoothFactor = 0.1
local isJumping = false
local jumpStartTime = 0
local originalTargetPosition = nil

function FindNearestEnemy()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    local CenterPosition = Vector2.new(
        game:GetService("GuiService"):GetScreenResolution().X / 2,
        game:GetService("GuiService"):GetScreenResolution().Y / 2
    )

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") and Character.Humanoid.Health > 0 then
                local Position, IsVisibleOnViewport = workspace.CurrentCamera:WorldToViewportPoint(Character.HumanoidRootPart.Position)

                if IsVisibleOnViewport then
                    local Distance = (CenterPosition - Vector2.new(Position.X, Position.Y)).Magnitude
                    if Distance < ClosestDistance then
                        ClosestPlayer = Character.HumanoidRootPart
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end

    return ClosestPlayer
end

local function smoothLockOn(targetPos)
    local startTime = tick()

    RunService.RenderStepped:Connect(function()
        if CamlockState and enemy then
            local elapsedTime = tick() - startTime
            if elapsedTime >= delayTime then
                local currentPos = camera.CFrame.Position
                local direction = (targetPos - currentPos).unit
                local newPos = currentPos + (direction * smoothFactor)

                camera.CFrame = CFrame.new(newPos, targetPos)
            end
        end
    end)
end

local function onPlayerJump()
    isJumping = true
    jumpStartTime = tick()

    if CamlockState and enemy then
        local targetTorso = enemy.Parent:FindFirstChild("HumanoidRootPart")
        if targetTorso then
            originalTargetPosition = targetTorso.Position
            local jumpOffset = Vector3.new(0, 5, 0)
            local upwardPosition = targetTorso.Position + jumpOffset
            
            camera.CFrame = CFrame.new(camera.CFrame.Position, upwardPosition)
            wait(delayTime)
            smoothLockOn(originalTargetPosition)
        end
    end
end

local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
humanoid.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Jumping then
        onPlayerJump()
    end
end)

RunService.Heartbeat:Connect(function()
    if CamlockState and enemy then
        camera.CFrame = CFrame.new(camera.CFrame.p, enemy.Position + enemy.Velocity * Prediction)

        if getgenv().Elysian['HvH']['Target Strafe']['Enabled'] and Locking and enemy and enemy.Parent and enemy.Parent:FindFirstChild("HumanoidRootPart") then
            local targetHRP = enemy
            strafeAngle = strafeAngle + math.rad(getgenv().Elysian['HvH']['Target Strafe']['Speed'])

            local distance = getgenv().Elysian['HvH']['Target Strafe']['Distance']
            local height = getgenv().Elysian['HvH']['Target Strafe']['Height']

            local offsetX = math.sin(strafeAngle) * distance
            local offsetZ = math.cos(strafeAngle) * distance
            local offsetY = math.sin(strafeAngle * 2) * height

            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetHRP.Position + Vector3.new(offsetX, offsetY, offsetZ), targetHRP.Position)
            end
        end
    end
end)

Mouse.KeyDown:Connect(function(k)    
    if k == getgenv().Key then    
        Locked = not Locked    
        if Locked then    
            enemy = FindNearestEnemy()
            CamlockState = true
            if enemy then
                Locking = true
            end
        else    
            enemy = nil    
            CamlockState = false
            Locking = false
        end    
    end    
end)

local JoshzzV2 = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Logo = Instance.new("ImageLabel")
local TextButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")

JoshzzV2.Name = "JoshzzV2"
JoshzzV2.Parent = game.CoreGui
JoshzzV2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = JoshzzV2
Frame.BackgroundColor3 = Color3.fromRGB(1, 1, 1)
Frame.BorderColor3 = Color3.fromRGB(1, 1, 1)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.133798108, 0, 0.20107238, 0)
Frame.Size = UDim2.new(0, 202, 0, 70)
Frame.Active = true
Frame.Draggable = true

local function TopContainer()
    Frame.Position = UDim2.new(0.5, -Frame.AbsoluteSize.X / 2, 0, -Frame.AbsoluteSize.Y / 2)
end

TopContainer()
Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(TopContainer)

UICorner.Parent = Frame

Logo.Name = "Logo"
Logo.Parent = Frame
Logo.BackgroundColor3 = Color3.fromRGB(188, 255, 188)
Logo.BackgroundTransparency = 3.000
Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
Logo.BorderSizePixel = 0
Logo.Position = UDim2.new(0.326732665, 0, 0, 0)
Logo.Size = UDim2.new(0, 70, 0, 70)
Logo.Image = "rbxassetid://96576458328757"
Logo.ImageTransparency = 0.300

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TextButton.BackgroundTransparency = 5.000
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.0792079195, 0, 0.18571429, 0)
TextButton.Size = UDim2.new(0, 170, 0, 44)
TextButton.Font = Enum.Font.SourceSansSemibold
TextButton.Text = "Toggle JoshzzV2"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 18.000
TextButton.TextWrapped = true

local state = true
TextButton.MouseButton1Click:Connect(function()
    state = not state
    if not state then
        TextButton.Text = "JoshzzV2 ON"
        CamlockState = true
        enemy = FindNearestEnemy()
        Locking = true
    else
        TextButton.Text = "JoshzzV2 OFF"
        CamlockState = false
        enemy = nil
        Locking = false
    end
end)
-- Laser Eyes Mobile com FLING Fortalecido - Delta Executor
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local head = character:WaitForChild("Head")

local RANGE = 500
local COLOR = Color3.fromRGB(255, 0, 0)
local THICKNESS = 0.6
local DURATION = 0.2
local FLING_POWER = 15000  -- Aumentei pra garantir um fling forte
local FLING_DURATION = 0.5 -- Tempo pra manter o efeito

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://142945938"
sound.Volume = 1
sound.Parent = head

local gui = Instance.new("ScreenGui")
gui.Name = "LaserFlingGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 130, 0, 130)
btn.Position = UDim2.new(0.8, 0, 0.7, 0)
btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
btn.Text = "FLING\nLASER"
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.Font = Enum.Font.GothamBlack
btn.Parent = gui

local firing = false

local function shoot()
    if firing then return end
    firing = true
    
    sound:Play()
    
    local origin = head.Position + Vector3.new(0, 0.5, 0)
    local direction = head.CFrame.LookVector * RANGE
    
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(origin, direction, params)
    local endPos = result and result.Position or (origin + direction)
    
    -- Feixe visual
    local beam = Instance.new("Part")
    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.Neon
    beam.Color = COLOR
    beam.Transparency = 0.1
    beam.Size = Vector3.new(THICKNESS, THICKNESS, (endPos - origin).Magnitude)
    beam.CFrame = CFrame.new(origin, endPos) * CFrame.new(0, 0, -beam.Size.Z/2)
    beam.Parent = workspace
    Debris:AddItem(beam, DURATION)
    
    -- FLING com força extra
    if result then
        local hitPart = result.Instance
        local targetChar = hitPart.Parent
        local targetHumanoid = targetChar:FindFirstChild("Humanoid")
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso")
        
        if targetHumanoid and targetRoot and targetChar ~= character then
            -- Aplica fling forte
            local flingDirection = (endPos - origin).Unit * FLING_POWER + Vector3.new(0, FLING_POWER / 3, 0)
            targetRoot.Velocity = flingDirection
            
            -- Gira loucamente
            targetRoot.AngularVelocity = Vector3.new(math.random(-200, 200), math.random(-200, 200), math.random(-200, 200))
            
            -- Mantém o efeito por um tempo
            task.wait(FLING_DURATION)
            targetRoot.Velocity = Vector3.new(0, 0, 0) -- Para o movimento depois
            targetRoot.AngularVelocity = Vector3.new(0, 0, 0)
        end
    end
    
    task.wait(0.3)
    firing = false
end

btn.MouseButton1Click:Connect(shoot)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    head = newChar:WaitForChild("Head")
    sound.Parent = head
end)

btn.MouseButton1Down:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)
btn.MouseButton1Up:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(180, 0, 0)}):Play()
end)

print("Laser Fling Fortalecido carregado! Toque no botão pra arremessar os outros!")


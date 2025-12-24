-- Laser Eyes Mobile - Funciona no Delta (Celular)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local head = character:WaitForChild("Head")

local RANGE = 300
local COLOR = Color3.fromRGB(255, 0, 0)
local THICKNESS = 0.5
local DURATION = 0.2

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://142945938"
sound.Volume = 0.8
sound.Parent = head

local gui = Instance.new("ScreenGui")
gui.Name = "LaserGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 120)
btn.Position = UDim2.new(0.8, 0, 0.7, 0)
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btn.Text = "LASER"
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
    
    task.wait(0.35)
    firing = false
end

btn.MouseButton1Click:Connect(shoot)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    head = newChar:WaitForChild("Head")
    sound.Parent = head
end)

btn.MouseButton1Down:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)
btn.MouseButton1Up:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play()
end)

print("Laser Eyes carregado! Toque no botão vermelho na tela.")

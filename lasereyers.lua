-- Laser Eyes Mobile com Botão Menor e Móvel - Delta Executor
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")

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
btn.Size = UDim2.new(0, 80, 0, 80)  -- Botão menor (80x80 pixels)
btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
btn.Text = "LASER"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.TextScaled = true
btn.Font = Enum.Font.GothamBlack
btn.Parent = gui

local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = btn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

btn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and dragging then
        dragInput = input
        UserInputService.TouchMoved:Connect(updateDrag)
    end
end)

local firing = false

local function shoot()
    if firing then return end
    firing = true
    
    sound:Play()
    
    local origin = head.Position + Vector3.new(0, 0.5,

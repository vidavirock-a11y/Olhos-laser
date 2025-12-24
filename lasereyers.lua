-- Script de Olho Laser do Capitão Pátria com Botão Móvel - Para Delta Executor
-- Botão menor e arrastável na tela

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "HomelanderLaserGui"

local laserActive = false
local beams = {}
local sound = nil

-- Configurações
local LASER_COLOR = Color3.fromRGB(255, 0, 0)  -- Vermelho intenso
local LASER_WIDTH = 0.8
local LASER_DAMAGE = 100  -- Mata instantaneamente
local LASER_RANGE = 500
local LASER_SOUND_ID = "rbxassetid://1835343205"  -- Som de laser

-- Configurações do botão
local BUTTON_SIZE = UDim2.new(0, 50, 0, 50)  -- Tamanho menor (50x50 pixels)
local BUTTON_COLOR = Color3.fromRGB(255, 50, 50)  -- Vermelho com transparência
local BUTTON_TEXT = "🔥"

-- Criar botão na tela
local button = Instance.new("TextButton")
button.Size = BUTTON_SIZE
button.Position = UDim2.new(0.5, -25, 0.8, -25)  -- Centro-inferior inicial
button.BackgroundColor3 = BUTTON_COLOR
button.BackgroundTransparency = 0.3
button.Text = BUTTON_TEXT
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Parent = screenGui
button.RoundCornerRadius = UDim.new(0, 10)  -- Bordas arredondadas

-- Função para tornar o botão arrastável
local dragging = false
local dragStart = nil
local startPos = nil

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        button.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset

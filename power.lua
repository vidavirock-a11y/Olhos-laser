-- Carregar Objetos em Natural Disaster Survival - Delta Executor Mobile
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local RANGE = 8  -- Distância menor pra objetos do mapa
local HOLD_OFFSET = Vector3.new(0, 0, -1.5)  -- Ajuste pra frente do peito
local MAX_WEIGHT = 300  -- Peso menor pra objetos do jogo

local gui = Instance.new("ScreenGui")
gui.Name = "GrabGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 140, 0, 140)
btn.Position = UDim2.new(0.8, 0, 0.7, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
btn.Text = "PEGAR\nOBJETO"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.TextScaled = true
btn.Font = Enum.Font.GothamBlack
btn.Parent = gui

local holding = false
local grabbedPart = nil
local weld = nil

local function grabObject()
    if holding then
        -- Soltar o objeto
        if weld then weld:Destroy() end
        if grabbedPart then
            grabbedPart.CanCollide = true
            grabbedPart.Anchored = false
            if grabbedPart.Parent:IsA("Model") then
                for _, part in pairs(grabbedPart.Parent:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
        holding = false
        grabbedPart = nil
        return
    end
    
    -- Pegar novo objeto
    local origin = root.Position + Vector3.new(0, 1, 0)
    local direction = root.CFrame.LookVector * RANGE
    
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(origin, direction, params)
    if result and result.Instance then
        local part = result.Instance
        local model = part.Parent
        if (part:IsA("BasePart") or model:IsA("Model")) and not part.Anchored then
            local mass = 0
            if part:IsA("BasePart") then
                mass = part:GetMass()
            elseif model.PrimaryPart then
                mass = model.PrimaryPart:GetMass()
            end
            
            if mass <= MAX_WEIGHT then
                -- Desativa colisão pra carregar
                part.CanCollide = false
                if model.PrimaryPart then
                    model.PrimaryPart.CanCollide = false
                    for _, p in pairs(model:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                        end
                    end
                end
                
                -- Cria weld pra segurar
                weld = Instance.new("WeldConstraint")
                weld.Part0 = root
                weld.Part1 = part:IsA("BasePart") and part or model.PrimaryPart
                weld.C0 = CFrame.new(HOLD_OFFSET)
                weld.Parent = root
                
                grabbedPart = part
                holding = true
                print("Objeto pego em Natural Disaster! Solte com outro toque.")
            else
                print("Objeto muito pesado pra carregar!")
            end
        end
    end
end

btn.MouseButton1Click:Connect(grabObject)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    root = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
    if weld then weld:Destroy() end
    holding = false
    grabbedPart = nil
end)

btn.MouseButton1Down:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 150, 0)}):Play()
end)
btn.MouseButton1Up:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 100, 0)}):Play()
end)

print("Carregar Objetos em Natural Disaster ativado! Toque PEGAR OBJETO pra segurar/soltar.")               

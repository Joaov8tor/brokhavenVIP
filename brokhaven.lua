local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Criando UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.25, -200)  -- Inicia centralizado
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui
Frame.Visible = false  -- Começa invisível

-- Adicionando bordas arredondadas e sombra ao painel
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.BackgroundTransparency = 0.2
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.Image = "rbxassetid://3570695787"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -20, 0, 30)
TextBox.Position = UDim2.new(0, 10, 0, 10)
TextBox.PlaceholderText = "Digite um valor"
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Parent = Frame

local function CreateButton(text, posY, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, posY)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.Parent = Frame
    Button.MouseButton1Click:Connect(callback)
end

-- Funções
CreateButton("Alterar Velocidade", 50, function()
    local value = tonumber(TextBox.Text)
    if value then
        Character.Humanoid.WalkSpeed = value
    else
        print("Valor inválido para velocidade")
    end
end)

CreateButton("Alterar Pulo", 100, function()
    local value = tonumber(TextBox.Text)
    if value then
        Character.Humanoid.JumpPower = value
    else
        print("Valor inválido para pulo")
    end
end)

CreateButton("Alterar Gravidade", 150, function()
    local value = tonumber(TextBox.Text)
    if value then
        game.Workspace.Gravity = value
    else
        print("Valor inválido para gravidade")
    end
end)

CreateButton("Alterar FOV", 200, function()
    local value = tonumber(TextBox.Text)
    if value then
        LocalPlayer.CameraMaxZoomDistance = value
    else
        print("Valor inválido para FOV")
    end
end)

CreateButton("Teleportar ao Jogador", 250, function()
    local targetName = TextBox.Text
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    else
        print("Jogador não encontrado ou sem HumanoidRootPart")
    end
end)

CreateButton("Teleportar à Casa", 300, function()
    local houseNumber = tonumber(TextBox.Text)
    if houseNumber then
        local HousePos = Vector3.new(-300 + (houseNumber * 10), 10, 400) -- Posição aproximada
        HumanoidRootPart.CFrame = CFrame.new(HousePos)
    else
        print("Valor inválido para casa")
    end
end)

CreateButton("Teleportar ao Banco", 350, function()
    local BankPos = Vector3.new(-400, 10, 500) -- Aproximado
    HumanoidRootPart.CFrame = CFrame.new(BankPos)
end)

-- Botão fora da UI para abrir/fechar o painel no canto superior direito
local OpenPanelButton = Instance.new("TextButton")
OpenPanelButton.Size = UDim2.new(0, 150, 0, 50)
OpenPanelButton.Position = UDim2.new(1, -160, 0, 20)  -- Canto superior direito
OpenPanelButton.Text = "Abrir Painel"
OpenPanelButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
OpenPanelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenPanelButton.Font = Enum.Font.Gotham
OpenPanelButton.TextSize = 16
OpenPanelButton.Parent = ScreenGui

local isPanelVisible = false

-- Animação para abrir/fechar o painel
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local openTween = TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.25, -200), Visible = true})
local closeTween = TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.25, -400), Visible = false})

OpenPanelButton.MouseButton1Click:Connect(function()
    isPanelVisible = not isPanelVisible
    if isPanelVisible then
        tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.25, -200)}):Play()
        Frame.Visible = true
    else
        tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.25, -400)}):Play()
        Frame.Visible = false
    end
end)

-- Função para ver a tela do jogador
CreateButton("Ver Tela do Jogador", 400, function()
    local targetName = TextBox.Text
    local target = Players:FindFirstChild(targetName)
    if target and target.Character then
        -- Move a câmera para a posição do jogador sem alterar o tipo de câmera
        local targetRoot = target.Character:WaitForChild("HumanoidRootPart")
        workspace.CurrentCamera.CFrame = targetRoot.CFrame * CFrame.new(0, 5, 10) -- Ajuste da posição da câmera
    else
        print("Jogador não encontrado para ver a tela")
    end
end)

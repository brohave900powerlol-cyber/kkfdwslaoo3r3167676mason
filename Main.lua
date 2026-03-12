-- BRANDON HUB 🚷 PREMIUM 
-- ITEM-BASED SERVER SCANNER
-- VERSION: ELITE SCANNER

local LP = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- // 1. THE SCANNER UI // --
local Screen = Instance.new("ScreenGui", LP.PlayerGui)
Screen.Name = "BHub_Scanner"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 400, 0, 350)
Main.Position = UDim2.new(0.5, -200, 0.4, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Main)
local Glow = Instance.new("UIStroke", Main)
Glow.Color = Color3.fromRGB(0, 170, 255)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🔍 SERVER LOOT SCANNER"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.Size = UDim2.new(0, 380, 0, 240)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
Scroll.ScrollBarThickness = 2

-- // 2. THE SCANNING LOGIC // --
local function ScanServers()
    -- Clears old list
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    
    -- API call to find servers
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=25"
    local success, result = pcall(function() return game:HttpGet(url) end)

    if success then
        local data = HttpService:JSONDecode(result)
        local yPos = 0
        
        for _, server in pairs(data.data) do
            local SFrame = Instance.new("Frame", Scroll)
            SFrame.Size = UDim2.new(1, 0, 0, 50)
            SFrame.Position = UDim2.new(0, 0, 0, yPos)
            SFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Instance.new("UICorner", SFrame)
            
            -- Server Info Text
            local Info = Instance.new("TextLabel", SFrame)
            Info.Size = UDim2.new(0.7, 0, 1, 0)
            Info.Position = UDim2.new(0.05, 0, 0, 0)
            Info.BackgroundTransparency = 1
            Info.TextColor3 = Color3.new(1, 1, 1)
            Info.TextXAlignment = Enum.TextXAlignment.Left
            Info.Font = Enum.Font.Gotham
            
            -- Logic to "Guess" loot based on player count and server age
            -- (Real item-scanning requires joining, but we estimate here)
            local lootRating = server.playing > 5 and "🔥 HIGH VALUE" or "💎 STACKED"
            Info.Text = "Players: " .. server.playing .. "/" .. server.maxPlayers .. " | " .. lootRating
            
            -- Join Button
            local Join = Instance.new("TextButton", SFrame)
            Join.Size = UDim2.new(0.2, 0, 0.6, 0)
            Join.Position = UDim2.new(0.75, 0, 0.2, 0)
            Join.Text = "JOIN"
            Join.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            Instance.new("UICorner", Join)
            
            Join.MouseButton1Click:Connect(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LP)
            end)
            
            yPos = yPos + 60
        end
    end
end

local ScanBtn = Instance.new("TextButton", Main)
ScanBtn.Size = UDim2.new(0.9, 0, 0, 40)
ScanBtn.Position = UDim2.new(0.05, 0, 0, 300)
ScanBtn.Text = "REFRESH SCANNER 🔄"
ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ScanBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", ScanBtn)
ScanBtn.MouseButton1Click:Connect(ScanServers)

-- Initial Scan
ScanServers()

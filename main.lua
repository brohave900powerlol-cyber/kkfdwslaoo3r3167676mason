-- #brandon-hub-server-finder💎
-- DISCORD: https://discord.gg/UbkuVHMKbR

local LP = game:GetService("Players").LocalPlayer
local HS = game:GetService("HttpService")
local TS = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")

-- // 1. THE MAIN INTERFACE // --
local Screen = Instance.new("ScreenGui", LP.PlayerGui)
Screen.Name = "BHub_ServerFinder"
Screen.ResetOnSpawn = false

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 380, 0, 320)
Main.Position = UDim2.new(0.5, -190, 0.4, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Instance.new("UICorner", Main)

-- Cyan/Diamond Glow
local Glow = Instance.new("UIStroke", Main)
Glow.Color = Color3.fromRGB(0, 220, 255)
Glow.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "#brandon-hub-server-finder💎"
Title.TextColor3 = Color3.fromRGB(0, 220, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.BackgroundTransparency = 1

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(0.9, 0, 0.65, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.15, 0)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 5, 0)
Scroll.ScrollBarThickness = 2

-- // 2. SERVER SCANNING LOGIC // --
local function GetServers()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=25"
    local s, res = pcall(function() return game:HttpGet(url) end)

    if s then
        local data = HS:JSONDecode(res)
        local y = 0
        for _, server in pairs(data.data) do
            if server.id ~= game.JobId then
                local F = Instance.new("Frame", Scroll)
                F.Size = UDim2.new(1, 0, 0, 45)
                F.Position = UDim2.new(0, 0, 0, y)
                F.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                Instance.new("UICorner", F)

                -- "Best Stuff" Logic: 5-8 players usually means active loot
                local rating = "⚪ NORMAL"
                local rColor = Color3.new(1, 1, 1)
                
                if server.playing >= 5 and server.playing <= 8 then
                    rating = "💎 STACKED"
                    rColor = Color3.fromRGB(0, 255, 150)
                elseif server.playing < 4 then
                    rating = "⚡ EASY STEAL"
                    rColor = Color3.fromRGB(0, 220, 255)
                end

                local Info = Instance.new("TextLabel", F)
                Info.Size = UDim2.new(0.7, 0, 1, 0)
                Info.Position = UDim2.new(0.05, 0, 0, 0)
                Info.Text = "Players: "..server.playing.." | "..rating
                Info.TextColor3 = rColor
                Info.Font = Enum.Font.Gotham
                Info.BackgroundTransparency = 1
                Info.TextXAlignment = Enum.TextXAlignment.Left

                local Join = Instance.new("TextButton", F)
                Join.Size = UDim2.new(0.2, 0, 0.7, 0)
                Join.Position = UDim2.new(0.75, 0, 0.15, 0)
                Join.Text = "JOIN"
                Join.BackgroundColor3 = Color3.fromRGB(0, 180, 220)
                Instance.new("UICorner", Join)
                Join.MouseButton1Click:Connect(function() TS:TeleportToPlaceInstance(game.PlaceId, server.id, LP) end)

                y = y + 50
            end
        end
    end
end

-- // 3. BUTTONS & DRAGGING // --
local Ref = Instance.new("TextButton", Main)
Ref.Size = UDim2.new(0.43, 0, 0, 35)
Ref.Position = UDim2.new(0.05, 0, 0.85, 0)
Ref.Text = "REFRESH 🔄"
Ref.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Ref.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Ref)
Ref.MouseButton1Click:Connect(GetServers)

local Disc = Instance.new("TextButton", Main)
Disc.Size = UDim2.new(0.43, 0, 0, 35)
Disc.Position = UDim2.new(0.52, 0, 0.85, 0)
Disc.Text = "DISCORD 💬"
Disc.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Disc.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Disc)
Disc.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/UbkuVHMKbR") end)

-- MOBILE DRAG
local drag, dStart, sPos
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then drag = true; dStart = i.Position; sPos = Main.Position end end)
UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.Touch then 
    local delta = i.Position - dStart
    Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then drag = false end end)

GetServers()

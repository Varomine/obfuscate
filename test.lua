--//load and save
local foldername = "Alchemy Hub - Kaitun"
local filename = foldername.."/Setting.json"
function saveSettings()
	local HttpService = game:GetService("HttpService")
	local json = HttpService:JSONEncode(_G)
	if true then
		if isfolder(foldername) then
			if isfile(filename) then
				writefile(filename, json)
			else
				writefile(filename, json)
			end
		else
			makefolder(foldername)
		end
	end
end
function loadSettings()
	local HttpService = game:GetService("HttpService")
	if isfolder(foldername) then
		if isfile(filename) then
			_G = HttpService:JSONDecode(readfile(filename))
		end
	end
end
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.BackgroundTransparency = 1.000
ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.0605285577, 0, 0.128846154, 0)
ImageButton.Size = UDim2.new(0, 78, 0, 74)
ImageButton.Image = "rbxassetid://14981376704"
ImageButton.MouseButton1Down:Connect(function()
	game:GetService("VirtualInputManager"):SendKeyEvent(true,127,false,game)
	game:GetService("VirtualInputManager"):SendKeyEvent(false,127,false,game)
end)
UICorner.Parent = ImageButton
loadSettings()
--//stop tween
function StopTween(target)
	if not target then
		_G.StopTween = true
		wait()
		TweenFarm(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
		wait()
		_G.StopTween = false
	end
end
function TweenFarm(gotoCFrame)
	pcall(function()
		game.Players.LocalPlayer.Character.Humanoid.Sit = false
		game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
	end)
	if (game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart.Position - gotoCFrame.Position).Magnitude <= 200 then
		pcall(function() 
			tweenz:Cancel()
		end)
		game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart.CFrame = gotoCFrame
	else
		local tween_s = game:service"TweenService"
		local info = TweenInfo.new((game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart.Position - gotoCFrame.Position).Magnitude/325, Enum.EasingStyle.Linear)
		tween, err = pcall(function()
			tweenz = tween_s:Create(game.Players.LocalPlayer.Character["HumanoidRootPart"], info, {CFrame = gotoCFrame})
			tweenz:Play()
		end)
		if not tween then return err end
	end
	function _TweenCanCle()
		tweenz:Cancel()
	end
end 
function equip(tooltip)
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	for _, item in pairs(player.Backpack:GetChildren()) do
		if item:IsA("Tool") and item.ToolTip == tooltip then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid and not humanoid:IsDescendantOf(item) then
				humanoid:UnequipTools()
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(item)
				return true
			end
		end
	end
	return false
end
function ByPass(Position)
	game.Players.LocalPlayer.Character.Head:Destroy()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Position
	wait(1)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Position
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
end
function unequip(Weapon)
	if game.Players.LocalPlayer.Character:FindFirstChild(Weapon) then
		_G.NotAutoEquip = true
		wait(.5)
		game.Players.LocalPlayer.Character:FindFirstChild(Weapon).Parent = game.Players.LocalPlayer.Backpack
		wait(.1)
		_G.NotAutoEquip = false
	end
end
function AutoHaki()
	if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
	end
end
--//function hop
function Hop()
	Notify("Wait to Hop Server", 3)
	local PlaceID = game.PlaceId
	local AllIDs = {}
	local foundAnything = ""
	local actualHour = os.date("!*t").hour
	local Deleted = false
	function TPReturner()
		local Site;
		if foundAnything == "" then
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
		else
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
		end
		local ID = ""
		if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
			foundAnything = Site.nextPageCursor
		end
		local num = 0;
		for i,v in pairs(Site.data) do
			local Possible = true
			ID = tostring(v.id)
			if tonumber(v.maxPlayers) > tonumber(v.playing) then
				for _,Existing in pairs(AllIDs) do
					if num ~= 0 then
						if ID == tostring(Existing) then
							Possible = false
						end
					else
						if tonumber(actualHour) ~= tonumber(Existing) then
							local delFile = pcall(function()
								AllIDs = {}
								table.insert(AllIDs, actualHour)
							end)
						end
					end
					num = num + 1
				end
				if Possible == true then
					table.insert(AllIDs, ID)
					wait()
					pcall(function()
						wait()
						game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
					end)
					wait(4)
				end
			end
		end
	end
	function Teleport() 
		while wait() do
			pcall(function()
				TPReturner()
				if foundAnything ~= "" then
					TPReturner()
				end
			end)
		end
	end
	Teleport()
end      
--//antiban
function AntiBan()
	for i,v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
		if v:IsA("LocalScript") then
			if v.Name == "General" or v.Name == "Shiftlock"  or v.Name == "FallDamage" or v.Name == "4444" or v.Name == "CamBob" or v.Name == "JumpCD" or v.Name == "Looking" or v.Name == "Run" then
				v:Destroy()
			end
		end
	end
	for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerScripts:GetDescendants()) do
		if v:IsA("LocalScript") then
			if v.Name == "RobloxMotor6DBugFix" or v.Name == "Clans"  or v.Name == "Codes" or v.Name == "CustomForceField" or v.Name == "MenuBloodSp"  or v.Name == "PlayerList" then
				v:Destroy()
			end
		end
	end
end
AntiBan()
--//join
----local player = game.Players.LocalPlayer
----repeat task.wait() until game:IsLoaded()
---repeat task.wait() until player and player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("Main")
----local chooseTeam = player.PlayerGui.Main.ChooseTeam
---local teamContainer = chooseTeam.Container
---local function activateTeamButton(team)
----for _, connection in pairs(getconnections(team.Frame.TextButton.Activated)) do
----connection.Function()
--- end
---end
---repeat
-- local v2 = "Pirates"
--local teamName = string.find(v2, "Marine") and ---"Marines" or "Pirates"
---- activateTeamButton(teamContainer[teamName])
---task.wait()
---until player.Team ~= nil and game:IsLoaded()
for i,v in pairs(game.Workspace.Map:GetDescendants()) do
	if v.Name == "Tavern" or v.Name == "SmileFactory" or v.Name == "Tree" or v.Name == "Rocks" or v.Name == "PartHouse" or v.Name == "Hotel" or v.Name == "WallPiece" or v.Name == "MiddlePillars" or v.Name == "Cloud" or v.Name == "PluginGrass" or v.Name == "BigHouse" or v.Name == "SmallHouse" or v.Name == "Detail" then
		v:Destroy()
	end
end 
for i,v in pairs(game.ReplicatedStorage.Unloaded:GetDescendants()) do
	if v.Name == "Tavern" or v.Name == "SmileFactory" or v.Name == "Tree" or v.Name == "Rocks" or v.Name == "PartHouse" or v.Name == "Hotel" or v.Name == "WallPiece" or v.Name == "MiddlePillars" or v.Name == "Cloud" or v.Name == "PluginGrass" or v.Name == "BigHouse" or v.Name == "SmallHouse" or v.Name == "Detail" then
		v:Destroy()
	end
end
for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
	if v:IsA("Accessory") or v.Name == "Pants" or v.Name == "Shirt" then
		v:Destroy()
	end
end
local decalsyeeted = true -- Leaving this on makes games look shitty but the fps goes up by at least 20.
local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0
l.GlobalShadows = false
l.FogEnd = 9e9
l.Brightness = 0
settings().Rendering.QualityLevel = "Level01"
for i, v in pairs(g:GetDescendants()) do
	if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
		v.Material = "Plastic"
		v.Reflectance = 0
	elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
		v.Transparency = 1
	elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
		v.Lifetime = NumberRange.new(0)
	elseif v:IsA("Explosion") then
		v.BlastPressure = 1
		v.BlastRadius = 1
	elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
		v.Enabled = false
	elseif v:IsA("MeshPart") then
		v.Material = "Plastic"
		v.Reflectance = 0
		v.TextureID = 10385902758728957
	end
end
for i, e in pairs(l:GetChildren()) do
	if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
		e.Enabled = false
	end
end
if game.PlaceId == 2753915549 then  OldWolrd=true elseif game.PlaceId == 4442272183 then SecondSea=true elseif game.PlaceId == 7449423635 then ThirdSea=true end
local SlayerzLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2-Neptune/SlayerzUI/main/Library.script"))()
local Name = "Alchemy Hub | Blox Fruits"
local Description = "Version : Kaitan [ Premium ] | User : "..game.Players.LocalPlayer.Name
local Image = "rbxassetid://14981376704"
local Color = Color3.fromRGB(0, 255, 145)
local Window = SlayerzLibrary:Window(Name,Description,Image,Color)
local Tab = Window:Tab("General","9158926514")
local Section = Tab:Section("- Main -","Left")
local Section2 = Tab:Section("- Melee Status -","Left")
local Section3 = Tab:Section("- Sword Status -","Right")
local Notify = function(Text_i,Duration_i)
	game.StarterGui:SetCore("SendNotification", {
		Title = "Alchemy Hub V2",
		Text = Text_i,
		Duration = Duration_i,
		Icon = "rbxassetid://14981376704"
	})
end
Section:Toggle("Start Farm",false,function(v)
	getgenv().StartFarm = v
end)
Section:Toggle("Enable Kill Player",false,function(v)
	_G.AutoKillPlayerAfterLv120 = v
end)
local SuperhumanM = Section2:Label("❌ : SuperHuman")
local DeathStepM = Section2:Label("❌ : Death Step")
local SharkmanKarateM = Section2:Label("❌ : Sharkman Karate")
local ElectricClawM = Section2:Label("❌ : Electric Claw")
local DragonTalonM = Section2:Label("❌ : Dragon Talon")
local GodHumanM = Section2:Label("❌ : God Human")
task.spawn(
	function()
		while task.wait() do
			if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman", true) == 1 then
				SuperhumanM:Change("✅ : Superhuman")
			end
			if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep", true) == 1 then
				DeathStepM:Change("✅ : Death Step")
			end
			if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate", true) == 1 then
				SharkmanKarateM:Change("✅ : Sharkman Karate")
			end
			if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw", true) == 1 then
				ElectricClawM:Change("✅ : Electric Claw")
			end
			if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon", true) == 1 then
				DragonTalonM:Change("✅ : Dragon Talon")
			end
			if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman", true) == 1 then
				GodHumanM:Change("✅ : God Human")
			end
		end
	end
)
local DarkBladeS = Section3:Label("❌ : Dark Blade")
local SaberS = Section3:Label("❌ : Saber")
local RengokuS = Section3:Label("❌ : Rengoku")
local MidnightBladeS = Section3:Label("❌ : Midnight Blade")
local DragonTridentS = Section3:Label("❌ : Dragon Trident")
local YamaS = Section3:Label("❌ : Yama")
local BuddySwordS = Section3:Label("❌ : Buddy Sword")
local CanvanderS = Section3:Label("❌ : Canvander")
local SpikeyTridentS = Section3:Label("❌ : Spikey Trident")
local HallowScytheS = Section3:Label("❌ : Hallow Scythe")
local DarkDaggerS = Section3:Label("❌ : Dark Dagger")
local TushitaS = Section3:Label("❌ : Tushita")
local CursedDualKatanaS = Section3:Label("❌ : CDK")
task.spawn(
	function()
		while task.wait() do
			pcall(
				function()
					for i, v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventoryWeapons")) do
						if v.Name == "Dark Blade" then
							DarkBladeS:Change("✅ : Dark Blade")
						end
						if v.Name == "Saber" then
							SaberS:Change("✅ : Saber")
						end
						if v.Name == "Rengoku" then
							RengokuS:Change("✅ : Rengoku")
						end
						if v.Name == "Midnight Blade" then
							MidnightBladeS:Change("✅ : Midnight Blade")
						end
						if v.Name == "Dragon Trident" then
							DragonTridentS:Change("✅ : Dragon Trident")
						end
						if v.Name == "Yama" then
							YamaS:Change("✅ : Yama")
						end
						if v.Name == "Buddy Sword" then
							BuddySwordS:Change("✅ : Buddy Sword")
						end
						if v.Name == "Canvander" then
							CanvanderS:Change("✅ : Canvander")
						end
						if v.Name == "Spikey Trident" then
							SpikeyTridentS:Change("✅ : Spikey Trident")
						end
						if v.Name == "Hallow Scythe" then
							HallowScytheS:Change("✅ : Hallow Scythe")
						end
						if v.Name == "Dark Dagger" then
							DarkDaggerS:Change("✅ : Dark Dagger")
						end
						if v.Name == "Tushita" then
							TushitaS:Change("✅ : Tushita")
						end
						if v.Name == "Cursed Dual Katana" then
							CursedDualKatanaS:Change("✅ : CDK")
						end
					end
				end
			)
		end
	end
)
task.spawn(
	function()
		while task.wait() do
			pcall(
				function()
					for i, v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventoryWeapons")) do
						if v.Name == "Dark Blade" then
							DarkBladeS:Change("✅ : Dark Blade")
						end
						if v.Name == "Saber" then
							SaberS:Change("✅ : Saber")
						end
						if v.Name == "Rengoku" then
							RengokuS:Change("✅ : Rengoku")
						end
						if v.Name == "Midnight Blade" then
							MidnightBladeS:Change("✅ : Midnight Blade")
						end
						if v.Name == "Dragon Trident" then
							DragonTridentS:Change("✅ : Dragon Trident")
						end
						if v.Name == "Yama" then
							YamaS:Change("✅ : Yama")
						end
						if v.Name == "Buddy Sword" then
							BuddySwordS:Change("✅ : Buddy Sword")
						end
						if v.Name == "Canvander" then
							CanvanderS:Change("✅ : Canvander")
						end
						if v.Name == "Spikey Trident" then
							SpikeyTridentS:Change("✅ : Spikey Trident")
						end
						if v.Name == "Hallow Scythe" then
							HallowScytheS:Change("✅ : Hallow Scythe")
						end
						if v.Name == "Dark Dagger" then
							DarkDaggerS:Change("✅ : Dark Dagger")
						end
						if v.Name == "Tushita" then
							TushitaS:Change("✅ : Tushita")
						end
						if v.Name == "Cursed Dual Katana" then
							CursedDualKatanaS:Change("✅ : CDK")
						end
					end
				end
			)
		end
	end
)
task.spawn(
	function()
		while task.wait() do
			pcall(
				function()
					for i, v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventoryWeapons")) do
						if v.Name == "Dark Blade" then
							DarkBladeS:Change("✅ : Dark Blade")
						end
						if v.Name == "Saber" then
							SaberS:Change("✅ : Saber")
						end
						if v.Name == "Rengoku" then
							RengokuS:Change("✅ : Rengoku")
						end
						if v.Name == "Midnight Blade" then
							MidnightBladeS:Change("✅ : Midnight Blade")
						end
						if v.Name == "Dragon Trident" then
							DragonTridentS:Change("✅ : Dragon Trident")
						end
						if v.Name == "Yama" then
							YamaS:Change("✅ : Yama")
						end
						if v.Name == "Buddy Sword" then
							BuddySwordS:Change("✅ : Buddy Sword")
						end
						if v.Name == "Canvander" then
							CanvanderS:Change("✅ : Canvander")
						end
						if v.Name == "Spikey Trident" then
							SpikeyTridentS:Change("✅ : Spikey Trident")
						end
						if v.Name == "Hallow Scythe" then
							HallowScytheS:Change("✅ : Hallow Scythe")
						end
						if v.Name == "Dark Dagger" then
							DarkDaggerS:Change("✅ : Dark Dagger")
						end
						if v.Name == "Tushita" then
							TushitaS:Change("✅ : Tushita")
						end
						if v.Name == "Cursed Dual Katana" then
							CursedDualKatanaS:Change("✅ : CDK")
						end
					end
				end
			)
		end
	end
)
function Click()
	game:GetService'VirtualUser':CaptureController()
	game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
end
spawn(function()
	while task.wait() do
		if _G.AutoKillPlayerAfterLv120 then
			pcall(function()
				if game.Players.LocalPlayer.Data.Level.Value >= 120 and game.Players.LocalPlayer.Data.Level.Value < 300 or game.Players.LocalPlayer.Data.Level.Value > 315 and game.Players.LocalPlayer.Data.Level.Value < 350 then
					_G.AutoFarm = false
					if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.PvpDisabled.Visible == true then
						local args = {
							[1] = "EnablePvp"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					end
					if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
						local args = {
							[1] = "PlayerHunter"
						}
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
						for i,v in pairs(game.Players:GetPlayers()) do
							if not v.Data.SpawnPoint.Value == "Default" or v.Data.SpawnPoint.Value == "Town" or v.Data.SpawnPoint.Value == "Jungle" then
								if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,v.Name) then
									if v.Data.Level.Value >= 20  or v.Data.Level.Value <= 100 then
										repeat task.wait()
											if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
												local args = {
													[1] = "Buso"
												}
												game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args));
											end
											equip("Melee")
											TweenFarm(v.Character.HumanoidRootPart.CFrame * CFrame.new(0,5,5))
											if (game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude < 30 then
												Click()
												game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
												wait(.1)
												game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
												wait(2)
												game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
												wait(.1)
												game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
											end
										until v.Character.Humanoid.Health <= 0 or _G.AutoKillPlayerAfterLv120 == false
									else
										local args = {
											[1] = "PlayerHunter"
										}
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
									end
								else
									local args = {
										[1] = "PlayerHunter"
									}
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
								end
							else
								local args = {
									[1] = "PlayerHunter"
								}
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
							end
						end
					end
				else
					_G.AutoKillPlayerAfterLv120 = false
				end
			end)
		end
	end
end)
spawn(function()                     
	while wait(.1) do    
		if getgenv().StartFarm then                                            
			for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do                            
				if v.ToolTip == "Melee" then                           
					if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then                               
						local ToolSe = tostring(v.Name)                              
						local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)                              
						wait()                              
						game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)                                   
					end                               
				end    
			end                       
		end                                          
	end    
end)
spawn(function()
	while game:GetService("RunService").Stepped:wait() do
		if true then
			local character = lp.Character
			for _, v in pairs(character:GetChildren()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end
end)
_G.NoClip = true
spawn(function()
	pcall(function()
		while wait() do
			if getgenv().StartFarm or _G.AutoKillPlayerAfterLv120 or _G.NoClip then
				if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					local Noclip = Instance.new("BodyVelocity")
					Noclip.Name = "BodyClip"
					Noclip.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
					Noclip.MaxForce = Vector3.new(100000,100000,100000)
					Noclip.Velocity = Vector3.new(0,0,0)
				end
			end
		end
	end)
end)
task.spawn(
	function()
		while wait() do
			if getgenv().StartFarm then
				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1")
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2")
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3")
					if getgenv().StartFarm and SecondSea then
						wait(1)
						Hop()
					end
				end)
			end
		end
	end)
task.spawn(function()
	while wait()do 
		pcall(function()
			if getgenv().StartFarm then 
				for a,b in pairs(game:GetService("Workspace"):GetChildren())do 
					if b:IsA("Tool")then 
						if string.find(b.Name,"Fruit")then 
							repeat wait()
								wait(.1)
								b.Handle.CFrame=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,10,0)
								wait(.1)b.Handle.CFrame=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame*CFrame.new(0,2,0)
								wait(1)
								firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,b.Handle,0)
								wait(.1)
							until not getgenv().StartFarm or b.Parent==game.Players.LocalPlayer.Character 
						end
					end 
				end 
			end 
		end)
	end 
end)
spawn(function()
	while wait() do
		if getgenv().StartFarm then
			pcall(function()
				for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if v:IsA("Tool") and string.find(v.Name, "Fruit") then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit",v:GetAttribute("OriginalName"),v)
					end
				end
			end)
		end
	end
end)
--//yama
spawn(function()
	while wait() do
		if ThirdSea then
			if getgenv().StartFarm then
				if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress") >= 30 then
					repeat wait(.1)
						fireclickdetector(game:GetService("Workspace").Map.Waterfall.SealedKatana.Handle.ClickDetector)
					until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Yama") or not getgenv().StartFarm
				end
			end
		end
	end
end)
--//checkquest
if game.PlaceId == 2753915549 then  OldWolrd=true elseif game.PlaceId == 4442272183 then SecondSea=true elseif game.PlaceId == 7449423635 then ThirdSea=true end
function QuestCheck() 
	MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
	if OldWolrd then
		if MyLevel == 1 or MyLevel <= 9 then
			Mon = "Bandit"
			LevelQuest = 1
			NameQuest = "BanditQuest1"
			NameMon = "Bandit"
			CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, 0, 1, -0, 0.341998369, 0, 0.939700544)
			CFrameMon = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, 0, 1, -0, 0.341998369, 0, 0.939700544)
		elseif MyLevel == 10 or MyLevel <= 14 then
			Mon = "Monkey"
			LevelQuest = 1
			NameQuest = "JungleQuest"
			NameMon = "Monkey"
			CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			CFrameMon = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 15 or MyLevel < 20 then
			Mon = "Gorilla"
			LevelQuest = 2
			NameQuest = "JungleQuest"
			NameMon = "Gorilla"
			CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			CFrameMon = CFrame.new(-1301.87988, 18.6214523, -468.544769, 0.164645091, -1.12205412e-09, 0.986352861, -5.18567367e-09, 1, 2.00318762e-09, -0.986352861, -5.44471934e-09, 0.164645091)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel >= 20 and MyLevel < 90 then 
			usequest = false
			Mon = "Shanda"
			LevelQuest = 2
			NameQuest = "SkyExp1Quest"
			NameMon = "Shanda"
			CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998)
			CFrameMon = CFrame.new(-7685.12354, 5601.05127, -443.171509)       
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel > 90 and MyLevel < 120 then 
			Mon = "Royal Squad"
			LevelQuest = 1
			NameQuest = "SkyExp2Quest"
			NameMon = "Royal Squad"
			CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-7685.02051, 5606.87842, -1442.729)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 120 or MyLevel <= 149 then
			Mon = "Chief Petty Officer"
			LevelQuest = 1
			NameQuest = "MarineQuest2"
			NameMon = "Chief Petty Officer"
			CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-4882.8623, 22.6520386, 4255.53516)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 150 or MyLevel <= 174 then
			Mon = "Sky Bandit"
			LevelQuest = 1
			NameQuest = "SkyQuest"
			NameMon = "Sky Bandit"
			CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
			CFrameMon = CFrame.new(-4970.74219, 294.544342, -2890.11353)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 175 or MyLevel <= 189 then
			Mon = "Dark Master"
			LevelQuest = 2
			NameQuest = "SkyQuest"
			NameMon = "Dark Master"
			CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
			CFrameMon = CFrame.new(-5220.58594, 430.693298, -2278.17456)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 190 or MyLevel <= 209 then
			Mon = "Prisoner"
			LevelQuest = 1
			NameQuest = "PrisonerQuest"
			NameMon = "Prisoner"
			CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
			CFrameMon = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 210 or MyLevel <= 249 then
			Mon = "Dangerous Prisoner"
			LevelQuest = 2
			NameQuest = "PrisonerQuest"
			NameMon = "Dangerous Prisoner"
			CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
			CFrameMon = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 250 or MyLevel <= 299 then
			Mon = "Toga Warrior"
			LevelQuest = 1
			NameQuest = "ColosseumQuest"
			NameMon = "Toga Warrior"
			CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
			CFrameMon = CFrame.new(-1779.97583, 44.6077499, -2736.35474)
		elseif MyLevel == 300 or MyLevel <= 324 then
			usequest = true
			Mon = "Military Soldier"
			LevelQuest = 1
			NameQuest = "MagmaQuest"
			NameMon = "Military Soldier"
			CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
			CFrameMon = CFrame.new(-5363.01123, 41.5056877, 8548.47266)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 325 or MyLevel <= 374 then
			Mon = "Military Spy"
			LevelQuest = 2
			NameQuest = "MagmaQuest"
			NameMon = "Military Spy"
			CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
			CFrameMon = CFrame.new(-5926.0625, 57.0983391, 8898.3877, 0.820648372, -1.39857292e-09, -0.571433485, 5.01257647e-10, 1, -1.72761416e-09, 0.571433485, 1.13132836e-09, 0.820648372)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 375 or MyLevel <= 399 then
			Mon = "Fishman Warrior"
			LevelQuest = 1
			NameQuest = "FishmanQuest"
			NameMon = "Fishman Warrior"
			CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
			CFrameMon = CFrame.new(61163.8515625, 5.3073043823242, 1819.7841796875)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
			end
		elseif MyLevel == 400 or MyLevel <= 449 then
			Mon = "Fishman Commando"
			LevelQuest = 2
			NameQuest = "FishmanQuest"
			NameMon = "Fishman Commando"
			CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
			CFrameMon = CFrame.new(61909.7539, 108.484055, 1561.8739, -0.276268601, 7.58251204e-08, 0.961080492, 5.23033243e-08, 1, -6.38607887e-08, -0.961080492, 3.26249712e-08, -0.276268601)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 450 or MyLevel <= 474 then
			Mon = "God's Guard"
			LevelQuest = 1
			NameQuest = "SkyExp1Quest"
			NameMon = "God's Guard"
			CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, -0, -0.0871884301, 0, 1, -0, 0.0871884301, 0, 0.996191859)
			CFrameMon = CFrame.new(-4716.95703, 853.089722, -1933.925427)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 475 or MyLevel <= 524 then
			Mon = "Shanda"
			LevelQuest = 2
			NameQuest = "SkyExp1Quest"
			NameMon = "Shanda"
			CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998)
			CFrameMon = CFrame.new(-7685.12354, 5601.05127, -443.171509)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 525 or MyLevel <= 549 then
			Mon = "Royal Squad"
			LevelQuest = 1
			NameQuest = "SkyExp2Quest"
			NameMon = "Royal Squad"
			CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-7685.02051, 5606.87842, -1442.729)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 550 or MyLevel <= 624 then
			Mon = "Royal Soldier"
			LevelQuest = 2
			NameQuest = "SkyExp2Quest"
			NameMon = "Royal Soldier"
			CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-7864.44775, 5661.94092, -1708.22351)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 625 or MyLevel <= 649 then
			Mon = "Galley Pirate"
			LevelQuest = 1
			NameQuest = "FountainQuest"
			NameMon = "Galley Pirate"
			CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
			CFrameMon = CFrame.new(5595.06982, 41.5013695, 3961.47095)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel >= 650 then
			Mon = "Galley Captain"
			LevelQuest = 2
			NameQuest = "FountainQuest"
			NameMon = "Galley Captain"
			CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
			CFrameMon = CFrame.new(5658.5752, 38.5361786, 4928.93506)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		end
	elseif SecondSea then
		if MyLevel == 700 or MyLevel <= 724 then
			Mon = "Raider"
			LevelQuest = 1
			NameQuest = "Area1Quest"
			NameMon = "Raider"
			CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
			CFrameMon = CFrame.new(-737.026123, 39.1748352, 2392.57959)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 725 or MyLevel <= 774 then
			Mon = "Mercenary"
			LevelQuest = 2
			NameQuest = "Area1Quest"
			NameMon = "Mercenary"
			CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
			CFrameMon = CFrame.new(-960.12384, 80.2886276, 1691.82996, 0.920708776, 8.58963034e-09, -0.390250295, -3.26311032e-08, 1, -5.49752599e-08, 0.390250295, 6.33505053e-08, 0.920708776)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 775 or MyLevel <= 799 then
			Mon = "Swan Pirate"
			LevelQuest = 1
			NameQuest = "Area2Quest"
			NameMon = "Swan Pirate"
			CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906)
			CFrameMon = CFrame.new(970.369446, 142.653198, 1217.3667)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 800 or MyLevel <= 874 then
			Mon = "Factory Staff"
			NameQuest = "Area2Quest"
			LevelQuest = 2
			NameMon = "Factory Staff"
			CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
			CFrameMon = CFrame.new(506.323364, 72.9597626, 9.77466297, -0.339674324, -7.69937536e-09, -0.940543115, -3.40559581e-08, 1, 4.11311296e-09, 0.940543115, 3.34282184e-08, -0.339674324)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 875 or MyLevel <= 899 then
			Mon = "Marine Lieutenant"
			LevelQuest = 1
			NameQuest = "MarineQuest3"
			NameMon = "Marine Lieutenant"
			CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
			CFrameMon = CFrame.new(-2682.18726, 198.169113, -2991.05737, 0.600202382, 6.21085405e-09, 0.799848199, -5.2549618e-09, 1, -3.82174248e-09, -0.799848199, -1.9093529e-09, 0.600202382)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 900 or MyLevel <= 949 then
			Mon = "Marine Captain"
			LevelQuest = 2
			NameQuest = "MarineQuest3"
			NameMon = "Marine Captain"
			CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
			CFrameMon = CFrame.new(-1860.27209, 197.220596, -3219.6062, 0.816204965, 2.98379241e-08, -0.577762485, -9.47813916e-08, 1, -8.22537274e-08, 0.577762485, 1.21897031e-07, 0.816204965)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 950 or MyLevel <= 974 then
			Mon = "Zombie"
			LevelQuest = 1
			NameQuest = "ZombieQuest"
			NameMon = "Zombie"
			CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
			CFrameMon = CFrame.new(-5634.83838, 126.067039, -697.665039)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 975 or MyLevel <= 999 then
			Mon = "Vampire"
			LevelQuest = 2
			NameQuest = "ZombieQuest"
			NameMon = "Vampire"
			CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
			CFrameMon = CFrame.new(-6030.32031, 6.4377408, -1313.5564)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1000 or MyLevel <= 1049 then
			Mon = "Snow Trooper"
			LevelQuest = 1
			NameQuest = "SnowMountainQuest"
			NameMon = "Snow Trooper"
			CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
			CFrameMon = CFrame.new(535.893433, 401.457062, -5329.6958)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1050 or MyLevel <= 1099 then
			Mon = "Winter Warrior"
			LevelQuest = 2
			NameQuest = "SnowMountainQuest"
			NameMon = "Winter Warrior"
			CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
			CFrameMon = CFrame.new(1223.7417, 454.575226, -5170.02148)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1100 or MyLevel <= 1124 then
			Mon = "Lab Subordinate"
			LevelQuest = 1
			NameQuest = "IceSideQuest"
			NameMon = "Lab Subordinate"
			CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578)
			CFrameMon = CFrame.new(-5769.2041, 37.9288292, -4468.38721)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1125 or MyLevel <= 1174 then
			Mon = "Horned Warrior"
			LevelQuest = 2
			NameQuest = "IceSideQuest"
			NameMon = "Horned Warrior"
			CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578)
			CFrameMon = CFrame.new(-6400.85889, 24.7645149, -5818.63574)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1175 or MyLevel <= 1199 then
			Mon = "Magma Ninja"
			LevelQuest = 1
			NameQuest = "FireSideQuest"
			NameMon = "Magma Ninja"
			CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
			CFrameMon = CFrame.new(-5496.65576, 58.6890411, -5929.76855)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1200 or MyLevel <= 1249 then
			Mon = "Lava Pirate"
			LevelQuest = 2
			NameQuest = "FireSideQuest"
			NameMon = "Lava Pirate"
			CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
			CFrameMon = CFrame.new(-5169.71729, 34.1234779, -4669.73633)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1250 or MyLevel <= 1274 then
			Mon = "Ship Deckhand"
			LevelQuest = 1
			NameQuest = "ShipQuest1"
			NameMon = "Ship Deckhand"
			CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)         
			CFrameMon = CFrame.new(1181.84875, 130.485107, 33005.4961, -0.946877539, -7.47373434e-08, -0.321594298, -7.391602e-08, 1, -1.47637005e-08, 0.321594298, 9.79155601e-09, -0.946877539)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1275 or MyLevel <= 1299 then
			Mon = "Ship Engineer"
			LevelQuest = 2
			NameQuest = "ShipQuest1"
			NameMon = "Ship Engineer"
			CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)        
			CFrameMon = CFrame.new(919.250427, 43.544014, 32781.9922, 0.999619186, 4.03968698e-08, -0.0275939237, -3.75240887e-08, 1, 1.04626984e-07, 0.0275939237, -1.03551706e-07, 0.999619186)       
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1300 or MyLevel <= 1324 then
			Mon = "Ship Steward"
			LevelQuest = 1
			NameQuest = "ShipQuest2"
			NameMon = "Ship Steward"
			CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)         
			CFrameMon = CFrame.new(917.478882, 129.556, 33441.2227, -0.999965012, -1.84493896e-08, -0.00836863648, -1.84426696e-08, 1, -8.80260864e-10, 0.00836863648, -7.2589007e-10, -0.999965012)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1325 or MyLevel <= 1349 then
			Mon = "Ship Officer"
			LevelQuest = 2
			NameQuest = "ShipQuest2"
			NameMon = "Ship Officer"
			CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
			FrameMon = CFrame.new(1201.18286, 181.149124, 33308.0508, 0.0748318806, -7.14178512e-08, -0.997196138, 2.97970733e-08, 1, -6.93826223e-08, 0.997196138, -2.45214959e-08, 0.0748318806)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1350 or MyLevel <= 1374 then
			Mon = "Arctic Warrior"
			LevelQuest = 1
			NameQuest = "FrostQuest"
			NameMon = "Arctic Warrior"
			CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
			CFrameMon = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1375 or MyLevel <= 1424 then
			Mon = "Snow Lurker"
			LevelQuest = 2
			NameQuest = "FrostQuest"
			NameMon = "Snow Lurker"
			CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
			CFrameMon = CFrame.new(5518.00684, 60.5559731, -6828.80518)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1425 or MyLevel <= 1449 then
			Mon = "Sea Soldier"
			LevelQuest = 1
			NameQuest = "ForgottenQuest"
			NameMon = "Sea Soldier"
			CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376)
			CFrameMon = CFrame.new(-3366.32958984375, 47.21970748901367, -9704.3505859375)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel >= 1450 then
			Mon = "Water Fighter"
			LevelQuest = 2
			NameQuest = "ForgottenQuest"
			NameMon = "Water Fighter"
			CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376)
			CFrameMon = CFrame.new(-3436.7727050781, 290.52191162109, -10503.438476563)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		end
	elseif ThirdSea then
		if MyLevel == 1500 or MyLevel <= 1524 then
			Mon = "Pirate Millionaire"
			LevelQuest = 1
			NameQuest = "PiratePortQuest"
			NameMon = "Pirate Millionaire"
			CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
			CFrameMon = CFrame.new(-290.674988, 34.7821121, 5417.57666, -0.959131062, 7.87279077e-08, 0.282962203, 6.99472977e-08, 1, -4.11336849e-08, -0.282962203, -1.96601544e-08, -0.959131062)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1525 or MyLevel <= 1574 then
			Mon = "Pistol Billionaire"
			LevelQuest = 2
			NameQuest = "PiratePortQuest"
			NameMon = "Pistol Billionaire"
			CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
			CFrameMon = CFrame.new(-387.624237, 74.2720413, 5851.84473, -0.990750372, -6.79122536e-08, 0.135697171, -7.2516066e-08, 1, -2.89841076e-08, -0.135697171, -3.85562409e-08, -0.990750372)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1575 or MyLevel <= 1599 then
			Mon = "Dragon Crew Warrior"
			LevelQuest = 1
			NameQuest = "AmazonQuest"
			NameMon = "Dragon Crew Warrior"
			CFrameQuest = CFrame.new(5832.83594, 51.6806107, -1101.51563, 0.898790359, -0, -0.438378751, 0, 1, -0, 0.438378751, 0, 0.898790359)
			CFrameMon = CFrame.new(6241.9951171875, 51.522083282471, -1243.9771728516)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1600 or MyLevel <= 1624 then 
			Mon = "Dragon Crew Archer"
			NameQuest = "AmazonQuest"
			LevelQuest = 2
			NameMon = "Dragon Crew Archer"
			CFrameQuest = CFrame.new(5833.1147460938, 51.60498046875, -1103.0693359375)
			CFrameMon = CFrame.new(6788.97461, 462.341248, 164.233673, -0.711975694, 1.98202414e-08, 0.702204108, -1.45830699e-08, 1, -4.30117559e-08, -0.702204108, -4.08636183e-08, -0.711975694)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1625 or MyLevel <= 1649 then
			Mon = "Female Islander"
			NameQuest = "AmazonQuest2"
			LevelQuest = 1
			NameMon = "Female Islander"
			CFrameQuest = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
			CFrameMon = CFrame.new(5763.98682, 848.118103, 1082.43127, 0.986172736, 2.65753979e-08, 0.165720671, -2.36233451e-08, 1, -1.97844852e-08, -0.165720671, 1.55960436e-08, 0.986172736)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1650 or MyLevel <= 1699 then 
			Mon = "Giant Islander"
			NameQuest = "AmazonQuest2"
			LevelQuest = 2
			NameMon = "Giant Islander"
			CFrameQuest = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
			CFrameMon = CFrame.new(4784.24561, 708.376465, 466.297485, 0.99801594, 3.11927195e-09, 0.0629619658, -5.34848299e-09, 1, 3.52371394e-08, -0.0629619658, -3.55039766e-08, 0.99801594)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1700 or MyLevel <= 1724 then
			Mon = "Marine Commodore"
			LevelQuest = 1
			NameQuest = "MarineTreeIsland"
			NameMon = "Marine Commodore"
			CFrameQuest = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)
			PosMon = Vector3.new(2490.0844726563, 190.4232635498, -7160.0502929688)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1725 or MyLevel <= 1774 then
			Mon = "Marine Rear Admiral"
			NameMon = "Marine Rear Admiral"
			NameQuest = "MarineTreeIsland"
			LevelQuest = 2
			CFrameQuest = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
			CFrameMon = CFrame.new(3951.3903808594, 229.11549377441, -6912.81640625)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1775 or MyLevel <= 1799 then
			Mon = "Fishman Raider"
			LevelQuest = 1
			NameQuest = "DeepForestIsland3"
			NameMon = "Fishman Raider"
			CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)   
			CFrameMon = CFrame.new(-10322.400390625, 390.94473266602, -8580.0908203125)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1800 or MyLevel <= 1824 then
			Mon = "Fishman Captain"
			LevelQuest = 2
			NameQuest = "DeepForestIsland3"
			NameMon = "Fishman Captain"
			CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)   
			CFrameMon = CFrame.new(-11194.541992188, 442.02795410156, -8608.806640625)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1825 or MyLevel <= 1849 then
			Mon = "Forest Pirate"
			LevelQuest = 1
			NameQuest = "DeepForestIsland"
			NameMon = "Forest Pirate"
			CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)
			CFrameMon = CFrame.new(-13225.809570313, 428.19387817383, -7753.1245117188)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1850 or MyLevel <= 1899 then
			Mon = "Mythological Pirate"
			LevelQuest = 2
			NameQuest = "DeepForestIsland"
			NameMon = "Mythological Pirate"
			CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)   
			CFrameMon = CFrame.new(-13869.172851563, 564.95251464844, -7084.4135742188)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1900 or MyLevel <= 1924 then
			Mon = "Jungle Pirate"
			LevelQuest = 1
			NameQuest = "DeepForestIsland2"
			NameMon = "Jungle Pirate"
			CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
			FrameMon = CFrame.new(-11982.221679688, 376.32522583008, -10451.415039063)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1925 or MyLevel <= 1974 then
			Mon = "Musketeer Pirate"
			LevelQuest = 2
			NameQuest = "DeepForestIsland2"
			NameMon = "Musketeer Pirate"
			CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
			CFrameMon = CFrame.new(-13282.3046875, 496.23684692383, -9565.150390625)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 1975 or MyLevel <= 1999 then
			Mon = "Reborn Skeleton"
			LevelQuest = 1
			NameQuest = "HauntedQuest1"
			NameMon = "Reborn Skeleton"
			CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			CFrameMon = CFrame.new(-8817.880859375, 191.16761779785, 6298.6557617188)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2000 or MyLevel <= 2024 then
			Mon = "Living Zombie"
			LevelQuest = 2
			NameQuest = "HauntedQuest1"
			NameMon = "Living Zombie"
			CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
			CFrameMon = CFrame.new(-10125.234375, 183.94705200195, 6242.013671875)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2025 or MyLevel <= 2049 then
			Mon = "Demonic Soul"
			LevelQuest = 1
			NameQuest = "HauntedQuest2"
			NameMon = "Demonic Soul"
			CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0) 
			CFrameMon = CFrame.new(-9712.03125, 204.69589233398, 6193.322265625)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2050 or MyLevel <= 2074 then
			Mon = "Posessed Mummy"
			LevelQuest = 2
			NameQuest = "HauntedQuest2"
			NameMon = "Posessed Mummy"
			CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-9545.7763671875, 69.619895935059, 6339.5615234375)    
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2075 or MyLevel <= 2099 then
			Mon = "Peanut Scout"
			LevelQuest = 1
			NameQuest = "NutsIslandQuest"
			NameMon = "Peanut Scout"
			CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-2265.89014, 89.7506104, -10261.2197, -0.809553444, -9.26727282e-08, 0.587046146, -5.44419549e-08, 1, 8.27857534e-08, -0.587046146, 3.50595535e-08, -0.809553444)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2100 or MyLevel <= 2124 then
			Mon = "Peanut President"
			LevelQuest = 2
			NameQuest = "NutsIslandQuest"
			NameMon = "Peanut President"
			CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-2062.11792, 86.0444489, -10481.1445, 0.834163189, -9.79785408e-09, -0.551517665, -2.60617616e-09, 1, -2.17070646e-08, 0.551517665, 1.95445864e-08, 0.834163189)
			if getgenv().LevelStartFarmFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2125 or MyLevel <= 2149 then
			Mon = "Ice Cream Chef"
			LevelQuest = 1
			NameQuest = "IceCreamIslandQuest"
			NameMon = "Ice Cream Chef"
			CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-875.441345, 107.871437, -11253.3691, 0.630182087, 5.98710486e-08, 0.776447415, -6.03229751e-08, 1, -2.81494827e-08, -0.776447415, -2.90983202e-08, 0.63018208)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2150 or MyLevel <= 2199 then
			Mon = "Ice Cream Commander"
			LevelQuest = 2
			NameQuest = "IceCreamIslandQuest"
			NameMon = "Ice Cream Commander"
			CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
			CFrameMon = CFrame.new(-643.3078, 140.913528, -11334.7109, -0.996822715, -9.07818087e-09, 0.0796525627, -1.43212509e-08, 1, -6.52529906e-08, -0.0796525627, -6.61863808e-08, -0.996822715)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2200 or MyLevel <= 2224 then
			Mon = "Cookie Crafter"
			LevelQuest = 1
			NameQuest = "CakeQuest1"
			NameMon = "Cookie Crafter"
			CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
			CFrameMon = CFrame.new(-2437.66064, 133.07428, -12122.8721, 0.215197399, 2.05706883e-08, -0.976570547, -6.6551344e-08, 1, 6.39893472e-09, 0.976570547, 6.36150475e-08, 0.215197399)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2225 or MyLevel <= 2249 then
			Mon = "Cake Guard"
			LevelQuest = 2
			NameQuest = "CakeQuest1"
			NameMon = "Cake Guard"
			CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
			CFrameMon = CFrame.new(-1595.00916, 44.7149811, -12252.0547, -0.998557925, -6.0718726e-08, -0.0536852553, -5.64001539e-08, 1, -8.19574169e-08, 0.0536852553, -7.88113681e-08, -0.998557925)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2250 or MyLevel <= 2274 then
			Mon = "Baking Staff"
			LevelQuest = 1
			NameQuest = "CakeQuest2"
			NameMon = "Baking Staff"
			CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
			CFrameMon = CFrame.new(-1817.20581, 93.8077316, -12885.6309, -0.696141601, 7.12665269e-08, 0.717904449, 4.05417566e-08, 1, -5.99574506e-08, -0.717904449, -1.26337669e-08, -0.696141601)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2274 or MyLevel <= 2300 then
			Mon = "Head Baker"
			LevelQuest = 2
			NameQuest = "CakeQuest2"
			NameMon = "Head Baker"
			CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
			CFrameMon = CFrame.new(-2263.37744, 156.999985, -12776, 0.945995748, 2.16281637e-09, 0.324179053, -1.23387056e-09, 1, -3.0710805e-09, -0.324179053, 2.50523402e-09, 0.945995748)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2301 or MyLevel <= 2324 then
			Mon = "Cocoa Warrior"
			LevelQuest = 1
			NameQuest = "ChocQuest1"
			NameMon = "Cocoa Warrior"
			CFrameQuest = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
			CFrameMon = CFrame.new(-103.987442, 141.551514, -12260.2188, 0.589523733, -3.54913752e-08, -0.80775106, 4.28455316e-08, 1, -1.26684059e-08, 0.80775106, -2.71401959e-08, 0.589523733)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2325 or MyLevel <= 2349 then
			Mon = "Chocolate Bar Battler"
			LevelQuest = 2
			NameQuest = "ChocQuest1"
			NameMon = "Chocolate Bar Battler"
			CFrameQuest = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
			CFrameMon = CFrame.new(617.304688, 80.6076355, -12580.6494, -0.485228658, 3.42073503e-09, -0.874387324, -4.0368306e-08, 1, 2.63139608e-08, 0.874387324, 4.80658215e-08, -0.485228658)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2350 or MyLevel <= 2374 then
			Mon = "Sweet Thief"
			LevelQuest = 1
			NameQuest = "ChocQuest2"
			NameMon = "Sweet Thief"
			CFrameQuest = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, 0.422592998)         
			CFrameMon = CFrame.new(72.062767, 77.630722, -12640.4287, -0.62450999, -9.80953416e-08, 0.781016827, 1.42118917e-09, 1, 1.26735927e-07, -0.781016827, 8.02578199e-08, -0.62450999)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2375 or MyLevel <= 2400 then
			Mon = "Candy Rebel"
			LevelQuest = 2
			NameQuest = "ChocQuest2"
			NameMon = "Candy Rebel"
			CFrameQuest = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, 0.422592998)
			CFrameMon = CFrame.new(420.127747, 109.63044, -12989.6035, 0.0957952142, 3.10210027e-08, 0.995401084, -9.46955225e-09, 1, -3.02529948e-08, -0.995401084, -6.52791066e-09, 0.0957952142)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2400 or MyLevel <= 2449 then
			Mon = "Candy Pirate"
			LevelQuest = 1
			NameQuest = "CandyQuest1"
			NameMon = "Candy Pirate"
			CFrameQuest = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
			CFrameMon = CFrame.new(-1310.5003662109375, 26.016523361206055, -14562.404296875)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2450 or MyLevel <= 2474 then
			Mon = "Isle Outlaw"
			LevelQuest = 1
			NameQuest = "TikiQuest1"
			NameMon = "Isle Outlaw"
			CFrameQuest = CFrame.new(-16548.8164, 55.6059914, -172.8125, 0.213092566, -0, -0.977032006, 0, 1, -0, 0.977032006, 0, 0.213092566)
			CFrameMon = CFrame.new(-16479.900390625, 226.6117401123047, -300.3114318847656)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2475 or MyLevel <= 2499 then
			Mon = "Island Boy"
			LevelQuest = 2
			NameQuest = "TikiQuest1"
			NameMon = "Island Boy"
			CFrameQuest = CFrame.new(-16548.8164, 55.6059914, -172.8125, 0.213092566, -0, -0.977032006, 0, 1, -0, 0.977032006, 0, 0.213092566)
			CFrameMon = CFrame.new(-16849.396484375, 192.86505126953125, -150.7853240966797)
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		elseif MyLevel == 2500 or MyLevel <= 2524 then
			Mon = "Sun-kissed Warrior"
			LevelQuest = 1
			NameQuest = "TikiQuest2"
			NameMon = "kissed Warrior"
			CFrameMon = CFrame.new(-16347, 64, 984)
			CFrameQuest = CFrame.new(-16538, 55, 1049)
		elseif MyLevel >= 2525 then
			Mon = "Isle Champion"
			LevelQuest = 2
			NameQuest = "TikiQuest2"
			NameMon = "Isle Champion"
			CFrameQuest = CFrame.new(-16541.0215, 57.3082275, 1051.46118, 0.0410757065, -0, -0.999156058, 0, 1, -0, 0.999156058, 0, 0.0410757065) 
			CFrameMon = CFrame.new(-16602.1015625, 130.38734436035156, 1087.24560546875) 
			if getgenv().StartFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 1200 then
				ByPass(CFrameQuest)
			end
		end
	end
end
--//
getgenv().busy = false
spawn(function()
	while wait() do
		if getgenv().busy == false then
			local MyLevel = game.Players.LocalPlayer.Data.Level.Value
			if MyLevel ~= nil and MyLevel < 90 and MyLevel > 20 then
				getgenv().farmmode = "No Quest"
			elseif MyLevel >= 20 then
				getgenv().farmmode = "No Quest"
			elseif MyLevel >= 300 then
				getgenv().farmmode = "Level Farm"  
			elseif MyLevel > 90 and MyLevel < 120 then
				getgenv().farmmode = "No Quest"
			elseif MyLevel < 20 then
				getgenv().farmmode = "Level Farm"
			elseif MyLevel >= 850 then
				getgenv().farmmode = "Bartlio Quest"
			elseif MyLevel == 2550 then
				getgenv().farmmode = "Bone Farm"
			elseif MyLevel > 1500 then
				getgenv().farmmode = "Level Farm"
			end
		end
	end
end)
MethodFarm = CFrame.new(1,5,1)
_G.AutoFarm = true
spawn(function()
	wait(8)
	while wait() do
		if _G.AutoFarm then
			spawn(function()
				if getgenv().farmmode == "Level Farm" then
					if not string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) and arefarm then
						StartMagnet = false
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
					end
					if not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
						StartMagnet = false
						QuestCheck()
						repeat wait() TweenFarm(CFrameQuest) until (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 or not getgenv().StartFarm
						if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							wait(1.2)
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
							wait(0.5)
						end
					elseif game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
						QuestCheck()
						if game.Workspace.Enemies:FindFirstChild(Mon) then
							for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
								if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
									if v.Name == Mon then
										repeat wait()
											arefarm = true
											StartMagnet = true
											AutoHaki()
											PosMon = v.HumanoidRootPart.CFrame
											v.HumanoidRootPart.CanCollide = false
											v.Humanoid.WalkSpeed = 0
											v.Head.CanCollide = false
											v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
											StartMagnet = true
											TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(1, 25, 1))
											getgenv().atk = true
										until not getgenv().StartFarm or v.Humanoid.Health <= 0 or not v.Parent or not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible
										getgenv().atk = false
										arefarm = false
										StartMagnet = false
									end
								end
							end
						else
							StartMagnet = false
							if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
								TweenFarm(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
							else
								TweenFarm(CFrameMon)
							end
						end
					end
				elseif getgenv().farmmode == "No Quest" then
					spawn(function()
						QuestCheck()
						if game.Workspace.Enemies:FindFirstChild(Mon) then
							for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
								if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
									if v.Name == Mon then
										if v.Humanoid.Health > 0 then
											repeat wait()
												AutoHaki()
												PosMon = v.HumanoidRootPart.CFrame
												v.HumanoidRootPart.CanCollide = false
												v.Humanoid.WalkSpeed = 0
												v.Head.CanCollide = false
												v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
												StartMagnet = true
												TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
												getgenv().atk = true
											until not getgenv().StartFarm or v.Humanoid.Health <= 0 or not v.Parent or not checkquest2()
											getgenv().atk = false
										end
									end
								end
							end
						else
							StartMagnet = false
							if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
								TweenFarm(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
							else
								TweenFarm(CFrameMon)
							end
						end
					end)                        
				elseif getgenv().farmmode == "Bartlio Quest" then
					_G.AutoFarm = false
					if game:GetService("Players").LocalPlayer.Data.Level.Value >= 850 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 0 then
						if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then 
							if game:GetService("Workspace").Enemies:FindFirstChild("Swan Pirate]") then
								Ms = "Swan Pirate"
								for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
									if v.Name == Ms then
										pcall(function()
											repeat task.wait()
												sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
												EquipWeapon(_G.SelectWeapon)
												AutoHaki()
												v.HumanoidRootPart.Transparency = 1
												v.HumanoidRootPart.CanCollide = false
												v.HumanoidRootPart.Size = Vector3.new(50,50,50)
												TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))                                                   
												PosMonBarto =  v.HumanoidRootPart.CFrame
												game:GetService'VirtualUser':CaptureController()
												game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
												AutoBartiloBring = true
											until not v.Parent or v.Humanoid.Health <= 0 or getgenv().StartFarm == false or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
											AutoBartiloBring = false
										end)
									end
								end
							else
								repeat TweenFarm(CFrame.new(932.624451, 156.106079, 1180.27466, -0.973085582, 4.55137119e-08, -0.230443969, 2.67024713e-08, 1, 8.47491108e-08, 0.230443969, 7.63147128e-08, -0.973085582)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(932.624451, 156.106079, 1180.27466, -0.973085582, 4.55137119e-08, -0.230443969, 2.67024713e-08, 1, 8.47491108e-08, 0.230443969, 7.63147128e-08, -0.973085582)).Magnitude <= 10
							end
						else
							repeat TweenFarm(CFrame.new(-456.28952, 73.0200958, 299.895966)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-456.28952, 73.0200958, 299.895966)).Magnitude <= 10
							wait(1.1)
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest","BartiloQuest",1)
						end 
					elseif game:GetService("Players").LocalPlayer.Data.Level.Value >= 800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 1 then
						if game:GetService("Workspace").Enemies:FindFirstChild("Jeremy") then
							Ms = "Jeremy"
							for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if v.Name == Ms then
									OldCFrameBartlio = v.HumanoidRootPart.CFrame
									repeat task.wait()
										sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
										EquipWeapon("Melee")
										AutoHaki()
										v.HumanoidRootPart.Transparency = 1
										v.HumanoidRootPart.CanCollide = false
										v.HumanoidRootPart.Size = Vector3.new(50,50,50)
										v.HumanoidRootPart.CFrame = OldCFrameBartlio
										TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
										game:GetService'VirtualUser':CaptureController()
										game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
										sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
									until not v.Parent or v.Humanoid.Health <= 0 or getgenv().StartFarm == false
								end
							end
						elseif game:GetService("ReplicatedStorage"):FindFirstChild("Jeremy") then
							repeat TweenFarm(CFrame.new(-456.28952, 73.0200958, 299.895966)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-456.28952, 73.0200958, 299.895966)).Magnitude <= 10
							wait(1.1)
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo")
							wait(1)
							repeat TweenFarm(CFrame.new(2099.88159, 448.931, 648.997375)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(2099.88159, 448.931, 648.997375)).Magnitude <= 10
							wait(2)
						else
							repeat TweenFarm(CFrame.new(2099.88159, 448.931, 648.997375)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(2099.88159, 448.931, 648.997375)).Magnitude <= 10
						end
					elseif game:GetService("Players").LocalPlayer.Data.Level.Value >= 800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 2 then
						repeat TweenFarm(CFrame.new(-1850.49329, 13.1789551, 1750.89685)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1850.49329, 13.1789551, 1750.89685)).Magnitude <= 10
						wait(1)
						repeat TweenFarm(CFrame.new(-1858.87305, 19.3777466, 1712.01807)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1858.87305, 19.3777466, 1712.01807)).Magnitude <= 10
						wait(1)
						repeat TweenFarm(CFrame.new(-1803.94324, 16.5789185, 1750.89685)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1803.94324, 16.5789185, 1750.89685)).Magnitude <= 10
						wait(1)
						repeat TweenFarm(CFrame.new(-1858.55835, 16.8604317, 1724.79541)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1858.55835, 16.8604317, 1724.79541)).Magnitude <= 10
						wait(1)
						repeat TweenFarm(CFrame.new(-1869.54224, 15.987854, 1681.00659)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1869.54224, 15.987854, 1681.00659)).Magnitude <= 10
						wait(1)
						repeat TweenFarm(CFrame.new(-1800.0979, 16.4978027, 1684.52368)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1800.0979, 16.4978027, 1684.52368)).Magnitude <= 10
						wait(1)
						repeat TweenFarm(CFrame.new(-1819.26343, 14.795166, 1717.90625)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1819.26343, 14.795166, 1717.90625)).Magnitude <= 10
						wait(1)
						repeat TweenFarm(CFrame.new(-1813.51843, 14.8604736, 1724.79541)) wait() until not getgenv().StartFarm or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1813.51843, 14.8604736, 1724.79541)).Magnitude <= 10
					end 
				elseif getgenv().farmmode == "Bone Farm" then
					pcall(function()
						_G.AutoFarm = false
						if game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy") then
							for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name == "Demonic Soul" or v.Name == "Posessed Mummy" then
									if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
										repeat task.wait()
											EquipWeapon("Melee")
											AutoHaki()
											v.HumanoidRootPart.CanCollide = false
											v.Humanoid.WalkSpeed = 0
											v.Head.CanCollide = false 
											StartMagnetBoneMon = true
											PosMonBone = v.HumanoidRootPart.CFrame
											TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
											NoClip = true
											game:GetService("VirtualUser"):CaptureController()
											game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
										until not getgenv().StartFarm or not v.Parent or v.Humanoid.Health <= 0
										NoClip = false
									end
								end
							end
						else
							StartMagnetBoneMon = false
							TweenFarm(CFrame.new(-9506.234375, 172.130615234375, 6117.0771484375))
							for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
								if v.Name == "Reborn Skeleton" then
									TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
								elseif v.Name == "Living Zombie" then
									TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
								elseif v.Name == "Demonic Soul" then
									TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
								elseif v.Name == "Posessed Mummy" then
									TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
								end
							end
						end
					end)
				end
			end)
		end
	end
end)
spawn(function()
	while wait() do
		for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
			if getgenv().StartFarm and StartMagnetBoneMon then
				if (v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name == "Demonic Soul" or v.Name == "Posessed Mummy") and (v.HumanoidRootPart.Position - PosMonBone.Position).Magnitude <= 400 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
					v.HumanoidRootPart.Size = Vector3.new(50,50,50)
					v.Humanoid:ChangeState(14)
					v.HumanoidRootPart.CanCollide = false
					v.Head.CanCollide = false
					v.HumanoidRootPart.CFrame = PosMonBone
					if v.Humanoid:FindFirstChild("Animator") then
						v.Humanoid.Animator:Destroy()
					end
					sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
				end
			end
		end
	end
end)
task.spawn(function()
	while task.wait() do
		pcall(function()
			if StartMagnet then
				for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
					if not string.find(v.Name,"Boss") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
						if InMyNetWork(v.HumanoidRootPart) then
							v.HumanoidRootPart.CFrame = PosMon
							v.Humanoid.JumpPower = 0
							v.Humanoid.WalkSpeed = 0
							v.HumanoidRootPart.Size = Vector3.new(60,60,60)
							v.HumanoidRootPart.Transparency = 1
							v.HumanoidRootPart.CanCollide = false
							v.Head.CanCollide = false
							if v.Humanoid:FindFirstChild("Animator") then
								v.Humanoid.Animator:Destroy()
							end
							v.Humanoid:ChangeState(11)
							v.Humanoid:ChangeState(14)
						end
					end
				end
			end
		end)
	end
end)
--//remove
_G.Remove_Effect = true
spawn(function()
	game:GetService('RunService').Stepped:Connect(function()
		if _G.Remove_Effect then
			local effectContainer = game:GetService("ReplicatedStorage").Effect.Container
			for i, v in pairs(effectContainer:GetChildren()) do
				if v.Name == "Death" then
					v:Destroy()
				end
			end
			local soundStorage = game:GetService("ReplicatedStorage").Util.Sound.Storage.Other
			local levelUpProxy = soundStorage:FindFirstChild("LevelUp_Proxy")
			local levelUp = soundStorage:FindFirstChild("LevelUp")
			if levelUpProxy then
				levelUpProxy:Destroy()
			end
			if levelUp then
				levelUp:Destroy()
			end
		else
			_G.Remove_Effect = false
		end
	end)
end)
--//bringmob
task.spawn(function()
	while task.wait() do
		pcall(function()
			if getgenv().StartFarm then
				QuestCheck()
				for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
					if getgenv().StartFarm and StartMagnet and v.Name == Mon and (Mon == "Factory Staff" or Mon == "Monkey" or Mon == "Dragon Crew Warrior" or Mon == "Dragon Crew Archer" or Mon == "Head Baker" or Mon == "Baking Staff" or Mon == "Cake Guard") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 220 then
						v.HumanoidRootPart.CFrame = PosMon
						v.Humanoid:ChangeState(14)
						v.HumanoidRootPart.CanCollide = false
						v.Head.CanCollide = false
						if v.Humanoid:FindFirstChild("Animator") then
							v.Humanoid.Animator:Destroy()
						end
						sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
					elseif getgenv().StartFarm and StartMagnet and v.Name == Mon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 275 then
						v.HumanoidRootPart.CFrame = PosMon
						v.Humanoid:ChangeState(14)
						v.HumanoidRootPart.CanCollide = false
						v.Head.CanCollide = false
						if v.Humanoid:FindFirstChild("Animator") then
							v.Humanoid.Animator:Destroy()
						end
						sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
					end
				end
			end
		end)
	end
end)
spawn(function ()
	while wait() do
		if _G.AutoBartilo and AutoBartiloBring then
			pcall(function()
				if v.Name == "Swan Pirate" and (v.HumanoidRootPart.Position - PosMonBarto.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
					v.HumanoidRootPart.Size = Vector3.new(50,50,50)
					v.Humanoid:ChangeState(14)
					v.HumanoidRootPart.CanCollide = false
					v.Head.CanCollide = false
					v.HumanoidRootPart.CFrame = PosMonBarto
					if v.Humanoid:FindFirstChild("Animator") then
						v.Humanoid.Animator:Destroy()
					end
					sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
				end
			end)
		end
	end
end)
_G.FastAttack = true
NoAttackAnimation = true
local Char = game.Players.LocalPlayer.Character
local Root = Char.HumanoidRootPart
local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local CollectionService = game:GetService("CollectionService")
repeat 
	LocalPlayer = Players.LocalPlayer
	wait()
until LocalPlayer
local kkii = require(game.ReplicatedStorage.Util.CameraShaker)
kkii:Stop()
local ItsTrue = true or false
local CurrentAllMob,
recentlySpawn,
StoredSuccessFully,
canHits, RecentCollected,
FruitInServer,
RecentlyLocationSet,
lastequip = {}, 0, 0, {}, 0, {}, 0, tick()
local PC,
RL,
DMG, 
RigC,
Combat = require(LocalPlayer.PlayerScripts.CombatFramework.Particle), require(game:GetService("ReplicatedStorage").CombatFramework.RigLib), require(LocalPlayer.PlayerScripts.CombatFramework.Particle.Damage), getupvalue(require(LocalPlayer.PlayerScripts.CombatFramework.RigController),2), getupvalue(require(LocalPlayer.PlayerScripts.CombatFramework),2)
local UserInputService, RunService, vim, CollectionService, CoreGui = game:GetService("UserInputService")
,game:GetService("RunService")
,game:GetService('VirtualInputManager')
,game:GetService("CollectionService")
,game:GetService("CoreGui")
local dist = function(a,b,noHeight)
	if not b then
		b = Root.Position
	end
	return (Vector3.new(a.X,not noHeight and a.Y,a.Z) - Vector3.new(b.X,not noHeight and b.Y,b.Z)).magnitude
end
do -- Starter Thread
	task.spawn(function()
		local stacking = 0
		local printCooldown = 0
		while task.wait(.075) do
			pcall(function()
				local nearbymon = false
				table.clear(CurrentAllMob)
				table.clear(canHits)
				local mobs = CollectionService:GetTagged("ActiveRig")
				for i=1,#mobs do local v = mobs[i]
					local Human = v:FindFirstChildOfClass("Humanoid")
					if Human and Human.Health > 0 and Human.RootPart and v ~= Char then
						local IsPlayer = game.Players:GetPlayerFromCharacter(v)
						local IsAlly = IsPlayer and CollectionService:HasTag(IsPlayer,"Ally"..LocalPlayer.Name)
						if not IsAlly then
							CurrentAllMob[#CurrentAllMob + 1] = v
							if not nearbymon and dist(Human.RootPart.Position) < 65 then
								nearbymon = true
							end
						end
					end
				end
				if nearbymon then
					local Enemies = workspace.Enemies:GetChildren()
					local Players = Players:GetPlayers()
					for i=1,#Enemies do local v = Enemies[i]
						local Human = v:FindFirstChildOfClass("Humanoid")
						if Human and Human.RootPart and Human.Health > 0 and dist(Human.RootPart.Position) < 65 then
							canHits[#canHits+1] = Human.RootPart
						end
					end
					for i=1,#Players do local v = Players[i].Character
						if not Players[i]:GetAttribute("PvpDisabled") and v and v ~= LocalPlayer.Character then
							local Human = v:FindFirstChildOfClass("Humanoid")
							if Human and Human.RootPart and Human.Health > 0 and dist(Human.RootPart.Position) < 65 then
								canHits[#canHits+1] = Human.RootPart
							end
						end
					end
				end
			end)
		end
	end)
end
-- Initialize Fast Attack .
task.spawn(function()
	local Data = Combat
	local Blank = function() end
	local RigEvent = game:GetService("ReplicatedStorage").RigControllerEvent
	local Animation = Instance.new("Animation")
	local RecentlyFired = 0
	local AttackCD = 0
	local Controller
	local lastFireValid = 0
	local MaxLag = 350
	fucker = 0.0000007
	TryLag = 0
	local resetCD = function()
		local WeaponName = Controller.currentWeaponModel.Name
		local Cooldown = {
			combat = 0.07
		}
		AttackCD = tick() + (fucker and Cooldown[WeaponName:lower()] or fucker or 0.285) + ((TryLag/MaxLag)*0.3)
		RigEvent.FireServer(RigEvent,"weaponChange",WeaponName)
		TryLag += 1
		task.delay((fucker or 0.285) + (TryLag+0.5/MaxLag)*0.3,function()
			TryLag -= 1
		end)
	end
	if not shared.orl then shared.orl = RL.wrapAttackAnimationAsync end
	if not shared.cpc then shared.cpc = PC.play end
	if not shared.dnew then shared.dnew = DMG.new end
	if not shared.attack then shared.attack = RigC.attack end
	RL.wrapAttackAnimationAsync = function(a,b,c,d,func)
		if not NoAttackAnimation and not _G.FastAttack then
			PC.play = shared.cpc
			return shared.orl(a,b,c,65,func)
		end
		local Radius = _G.FastAttack or 65
		if _G.FastAttack and canHits and #canHits > 0 then
			PC.play = function() end
			a:Play(0.00075,0.01,0.01)
			func(canHits)
			wait(a.length * 0.5)
			a:Stop()
		end
	end
	while task.wait() do
		pcall(function()
			if #canHits > 0 then
				Controller = Data.activeController
				if NormalClick then
					pcall(task.spawn,Controller.attack,Controller)
				end
				if Controller and Controller.equipped and (not Char.Busy.Value or not LocalPlayer.PlayerGui.Main.Dialogue.Visible) and Char.Stun.Value == 0 and Controller.currentWeaponModel then
					if _G.FastAttack then
						if _G.FastAttack and tick() > AttackCD then
							resetCD()
						end 
						if tick() - lastFireValid > 0.5 then
							Controller.timeToNextAttack = 0
							Controller.increment = 1
							Controller.hitboxMagnitude = 65
							pcall(task.spawn,Controller.attack,Controller)
							lastFireValid = tick()
						end
						local AID3 = Controller.anims.basic[3]
						local AID2 = Controller.anims.basic[2]
						local ID = AID3 or AID2
						Animation.AnimationId = ID
						local Playing = Controller.humanoid:LoadAnimation(Animation)
						Playing:Play(0.00075,0.01,0.01)
						RigEvent.FireServer(RigEvent,"hit",canHits,AID3 and 1 or 2 or 3,"") -- 3 or 2
						pcall(Controller.attack)
						--AttackSignal:Fire()
						delay(.5,function()
							--Playing:Stop()
						end)
					end
				end
			end
		end)
	end
end)
redeemkey = function(code)
	game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
end
spawn(function()
	while wait() do
		for _, v in pairs({
			"EXP_5B",
			"CONTROL",
			"UPDATE11",
			"XMASEXP",
			"1BILLION",
			"ShutDownFix2",
			"UPD14",
			"STRAWHATMAINE",
			"TantaiGaming",
			"Colosseum",
			"Axiore",
			"Sub2Daigrock",
			"Sky Island 3",
			"Sub2OfficialNoobie",
			"SUB2NOOBMASTER123",
			"THEGREATACE",
			"Fountain City",
			"BIGNEWS",
			"FUDD10",
			"SUB2GAMERROBOT_EXP1",
			"UPD15",
			"2BILLION",
			"UPD16",
			"3BVISITS",
			"fudd10_v2",
			"Starcodeheo",
			"Magicbus",
			"JCWK",
			"Bluxxy",
			"Sub2Fer999",
			"Enyu_is_Pro"
			}) do
			redeemkey(v)
		end
	end
end)
task.spawn(function()
	while wait() do
		pcall(function()
			if getgenv().StartFarm then
				if game:GetService("Players").localPlayer.Data.Stats.Melee.Level.Value <= 2550 then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Melee",_G.PointStats)
				end
			end
		end)
	end
end)
spawn(function()
	while wait(.1) do
		if getgenv().StartFarm then
			local Lvv = game.Players.LocalPlayer.Data.Level.Value
			if Lvv >= 700 and game.PlaceId == 2753915549 then
				_G.AutoFarm = false
				if game.Workspace.Map.Ice.Door.CanCollide == true and game.Workspace.Map.Ice.Door.Transparency == 0 then
					TweenFarm(CFrame.new(4851.8720703125, 5.6514348983765, 718.47094726563))
					if (game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
						wait(.5)
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("DressrosaQuestProgress","Detective")
					end
					EquipWeapon("Key")
					TweenFarm(CFrame.new(1347.7124, 37.3751602, -1325.6488))
					wait(3)
				elseif game.Workspace.Map.Ice.Door.CanCollide == false and game.Workspace.Map.Ice.Door.Transparency == 1 then
					if game:GetService("Workspace").Enemies:FindFirstChild("Ice Admiral") then
						for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if v.Name == "Ice Admiral" and v.Humanoid.Health > 0 then
								repeat game:GetService("RunService").Heartbeat:wait()
									pcall(function()
										for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
											if v.ToolTip == _G.SelectWeapon then
												game.Players.LocalPlayer.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(v.Name))
											end
										end
										TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(0,40,0))				
									end)
								until getgenv().StartFarm == false or v.Humanoid.Health <= 0 or not v.Parent
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
							end
						end
					else
						TweenFarm(CFrame.new(1347.7124, 37.3751602, -1325.6488))
					end
				else
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
				end
			end
		end
	end
end)
spawn(function()
	while wait() do
		if getgenv().StartFarm then
			pcall(function()
				if game:GetService("Players").LocalPlayer.Data.Level.Value >= 1500 and SecondSea then
					_G.AutoFarm = false
					if game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("ZQuestProgress", "General") == 0 then
						TweenFarm(CFrame.new(-1926.3221435547, 12.819851875305, 1738.3092041016))
						if (CFrame.new(-1926.3221435547, 12.819851875305, 1738.3092041016).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							wait(1.5)
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ZQuestProgress","Begin")
						end
						wait(1.8)
						if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
							for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if v.Name == "rip_indra" then
									OldCFrameThird = v.HumanoidRootPart.CFrame
									repeat task.wait()
										AutoHaki()
										EquipWeapon("Melee")
										TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
										v.HumanoidRootPart.CFrame = OldCFrameThird
										v.HumanoidRootPart.Size = Vector3.new(50,50,50)
										v.HumanoidRootPart.CanCollide = false
										v.Humanoid.WalkSpeed = 0
										game:GetService'VirtualUser':CaptureController()
										game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
										sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
									until getgenv().StartFarm == false or v.Humanoid.Health <= 0 or not v.Parent
								end
							end
						elseif not game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") and (CFrame.new(-26880.93359375, 22.848554611206, 473.18951416016).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1000 then
							TweenFarm(CFrame.new(-26880.93359375, 22.848554611206, 473.18951416016))
						end
					end
				end
			end)
		end
	end
end)
--//auto saber
_G.Auto_Saber = true
spawn(function()
	while wait() do
		if _G.Auto_Saber then
			if game.Players.localPlayer.Data.Level.Value >= 200 then
			else
				if game.Workspace.Map.Jungle.Final.Part.CanCollide == false then
					if _G.Auto_Saber and game.ReplicatedStorage:FindFirstChild("Saber Expert") or game.Workspace.Enemies:FindFirstChild("Saber Expert") then
						if game.Workspace.Enemies:FindFirstChild("Saber Expert") then
							for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
								if v.Name == "Saber Expert" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
									repeat wait()
										if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 300 then
											TweenFarm(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
										elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
											EquipWeapon("Melee")
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,30,0)
											game:GetService'VirtualUser':CaptureController()
											game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
										end
									until not _G.Auto_Saber or not v.Parent or v.Humanoid.Health <= 0
								end
							end
						else
							TweenFarm(CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position,CFrame.new(-1405.41956, 29.8519993, 5.62435055))
							if (CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1405.41956, 29.8519993, 5.62435055, 0.885240912, 3.52892613e-08, 0.465132833, -6.60881128e-09, 1, -6.32913171e-08, -0.465132833, 5.29540891e-08, 0.885240912)
							end
						end
					end
				elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Relic") or game.Players.LocalPlayer.Character:FindFirstChild("Relic") and game.Players.localPlayer.Data.Level.Value >= 200 then
					EquipWeapon("Relic")
					wait(0.5)
					TweenFarm(CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position,CFrame.new(-1405.41956, 29.8519993, 5.62435055))
					if (CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1405.41956, 29.8519993, 5.62435055, 0.885240912, 3.52892613e-08, 0.465132833, -6.60881128e-09, 1, -6.32913171e-08, -0.465132833, 5.29540891e-08, 0.885240912)
					end
				else
					if Workspace.Map.Jungle.QuestPlates.Door.CanCollide == false then
						if game.Workspace.Map.Desert.Burn.Part.CanCollide == false then
							if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan") == 0 then
								if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 0 then
									if game.Workspace.Enemies:FindFirstChild("Mob Leader") then
										for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
											if _G.Auto_Saber and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and v.Name == "Mob Leader" then
												repeat
													pcall(function() wait() 
														if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 300 then
															TweenFarm(v.HumanoidRootPart.Position,v.HumanoidRootPart.CFrame)
														elseif (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
															EquipWeapon("Melee")
															game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,25, 0)
															game:GetService'VirtualUser':CaptureController()
															game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
														end
													end)
												until not _G.Auto_Saber or not v.Parent or v.Humanoid.Health <= 0
											end
										end
									else
										TweenFarm(CFrame.new(-2848.59399, 7.4272871, 5342.44043).Position,CFrame.new(-2848.59399, 7.4272871, 5342.44043))
										if (CFrame.new(-2848.59399, 7.4272871, 5342.44043).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2848.59399, 7.4272871, 5342.44043, -0.928248107, -8.7248246e-08, 0.371961564, -7.61816636e-08, 1, 4.44474857e-08, -0.371961564, 1.29216433e-08, -0.928248107)
										end
									end
								elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 1 then
									if game.Players.LocalPlayer.Backpack:FindFirstChild("Relic") or game.Players.LocalPlayer.Character:FindFirstChild("Relic") then
										EquipWeapon("Relic")
										wait(0.5)
										TweenFarm(CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position,CFrame.new(-1405.41956, 29.8519993, 5.62435055))
										if (CFrame.new(-1405.41956, 29.8519993, 5.62435055).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1405.41956, 29.8519993, 5.62435055)
										end
									else
										TweenFarm(CFrame.new(-910.979736, 13.7520342, 4078.14624).Position,CFrame.new(-910.979736, 13.7520342, 4078.14624))
										if (CFrame.new(-910.979736, 13.7520342, 4078.14624).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-910.979736, 13.7520342, 4078.14624, 0.00685182028, -1.53155766e-09, -0.999976516, 9.15205245e-09, 1, -1.46888401e-09, 0.999976516, -9.14177267e-09, 0.00685182028)
											wait(.5)
											local args = {
												[1] = "ProQuestProgress",
												[2] = "RichSon"
											}
											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
										end
									end
								else
									TweenFarm(CFrame.new(-910.979736, 13.7520342, 4078.14624).Position,CFrame.new(-910.979736, 13.7520342, 4078.14624))
									if (CFrame.new(-910.979736, 13.7520342, 4078.14624).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-910.979736, 13.7520342, 4078.14624)
										local args = {
											[1] = "ProQuestProgress",
											[2] = "RichSon"
										}
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
									end
								end
							else
								if game.Players.LocalPlayer.Backpack:FindFirstChild("Cup") or game.Players.LocalPlayer.Character:FindFirstChild("Cup") then
									EquipWeapon("Cup")
									if game.Players.LocalPlayer.Character.Cup.Handle:FindFirstChild("TouchInterest") then
										TweenFarm(CFrame.new(1397.229, 37.3480148, -1320.85217).Position,CFrame.new(1397.229, 37.3480148, -1320.85217))
										if (CFrame.new(1397.229, 37.3480148, -1320.85217).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1397.229, 37.3480148, -1320.85217, -0.11285457, 2.01368788e-08, 0.993611455, 1.91641178e-07, 1, 1.50028845e-09, -0.993611455, 1.90586206e-07, -0.11285457)
										end
									else
										wait(0.5)
										if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan") ~= 0 then
											local args = {
												[1] = "ProQuestProgress",
												[2] = "SickMan"
											}
											game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
										end
									end
								else
									TweenFarm(game.Workspace.Map.Desert.Cup.Position,game.Workspace.Map.Desert.Cup.CFrame)
									if (game.Workspace.Map.Desert.Cup.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
										game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Map.Desert.Cup.CFrame
									end
								end
							end
						else
							if game.Players.LocalPlayer.Backpack:FindFirstChild("Torch") or game.Players.LocalPlayer.Character:FindFirstChild("Torch") then
								EquipWeapon("Torch")
								TweenFarm(CFrame.new(1114.87708, 4.9214654, 4349.8501).Position,CFrame.new(1114.87708, 4.9214654, 4349.8501))
								if (CFrame.new(1114.87708, 4.9214654, 4349.8501).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1114.87708, 4.9214654, 4349.8501, -0.612586915, -9.68697833e-08, 0.790403247, -1.2634203e-07, 1, 2.4638446e-08, -0.790403247, -8.47679615e-08, -0.612586915)
								end
							else
								TweenFarm(CFrame.new(-1610.00757, 11.5049858, 164.001587).Position,CFrame.new(-1610.00757, 11.5049858, 164.001587))
								if (CFrame.new(-1610.00757, 11.5049858, 164.001587).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551, -0.167722285, -0.0449818149, 0.17364943, 0.951244235, 0.254912198, 3.42372805e-05, -0.258850515, 0.965917408)
								end
							end
						end
					else
						for i,v in pairs(Workspace.Map.Jungle.QuestPlates:GetChildren()) do
							if v:IsA("Model") then wait()
								if v.Button.BrickColor ~= BrickColor.new("Camo") then
									repeat wait()
										TweenFarm(v.Button.Position,v.Button.CFrame)
										if (v.Button.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 150 then
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Button.CFrame
										end
									until not _G.Auto_Saber or v.Button.BrickColor == BrickColor.new("Camo")
								end
							end
						end    
					end
				end
			end 
		end
	end
end)
--//race v2
_G.Auto_EvoRace = true
spawn(function()
	pcall(function()
		while wait(.1) do
			if _G.Auto_EvoRace then
				if game:GetService("Players").LocalPlayer.Data.Level.Value >= 900 and SecondSea then
					if not game:GetService("Players").LocalPlayer.Data.Race:FindFirstChild("Evolved") then
						if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then
							TweenFarm(CFrame.new(-2779.83521, 72.9661407, -3574.02002, -0.730484903, 6.39014104e-08, -0.68292886, 3.59963224e-08, 1, 5.50667032e-08, 0.68292886, 1.56424669e-08, -0.730484903))
							if (Vector3.new(-2779.83521, 72.9661407, -3574.02002) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 then
								wait(1.3)
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist","2")
							end
						elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then
							pcall(function()
								if not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 1") and not game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flower 1") then
									TweenFarm(game:GetService("Workspace").Flower1.CFrame)
								elseif not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 2") and not game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flower 2") then
									TweenFarm(game:GetService("Workspace").Flower2.CFrame)
								elseif not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 3") and not game:GetService("Players").LocalPlayer.Character:FindFirstChild("Flower 3") then
									if game:GetService("Workspace").Enemies:FindFirstChild("Zombie") then
										for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
											if v.Name == "Zombie" then
												repeat task.wait()
													AutoHaki()
													EquipWeapon(_G.SelectWeapon)
													TweenFarm(v.HumanoidRootPart.CFrame * Pos)
													v.HumanoidRootPart.CanCollide = false
													v.HumanoidRootPart.Size = Vector3.new(50,50,50)
													game:GetService("VirtualUser"):CaptureController()
													game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
													PosMonEvo = v.HumanoidRootPart.CFrame
													StartEvoMagnet = true
												until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_EvoRace == false
												StartEvoMagnet = false
											end
										end
									else
										StartEvoMagnet = false
										TweenFarm(CFrame.new(-5685.9233398438, 48.480125427246, -853.23724365234))
									end
								end
							end)
						elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist","3")
						end
					end
				end
			end
		end
	end)
end)
--//auto cdk
if game.Players.LocalPlayer.Data.Level.Value >= 2300 then 
	if game.Players.LocalPlayer.Backpack:FindFirstChild("Tushita") and game.Players.LocalPlayer.Backpack:FindFirstChild("Yama") or game.Players.LocalPlayer.Character:FindFirstChild("Tushita") and game.Players.LocalPlayer.Character:FindFirstChild("Yama") then
		spawn(function()
			while wait() do
				pcall(function()
					if Auto_Cursed_Dual_Katana then
						_G.AutoFarm = false
						if GetMaterial("Alucard Fragment") == 0 then
							Auto_Quest_Yama_1 = true
							Auto_Quest_Yama_2 = false
							Auto_Quest_Yama_3 = false
							Auto_Quest_Tushita_1 = false
							Auto_Quest_Tushita_2 = false
							Auto_Quest_Tushita_3 = false
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
						elseif GetMaterial("Alucard Fragment") == 1 then
							Auto_Quest_Yama_1 = false
							Auto_Quest_Yama_2 = true
							Auto_Quest_Yama_3 = false
							Auto_Quest_Tushita_1 = false
							Auto_Quest_Tushita_2 = false
							Auto_Quest_Tushita_3 = false
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
						elseif GetMaterial("Alucard Fragment") == 2 then
							Auto_Quest_Yama_1 = false
							Auto_Quest_Yama_2 = false
							Auto_Quest_Yama_3 = true
							Auto_Quest_Tushita_1 = false
							Auto_Quest_Tushita_2 = false
							Auto_Quest_Tushita_3 = false
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
						elseif GetMaterial("Alucard Fragment") == 3 then
							Auto_Quest_Yama_1 = false
							Auto_Quest_Yama_2 = false
							Auto_Quest_Yama_3 = false
							Auto_Quest_Tushita_1 = true
							Auto_Quest_Tushita_2 = false
							Auto_Quest_Tushita_3 = false
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
						elseif GetMaterial("Alucard Fragment") == 4 then
							Auto_Quest_Yama_1 = false
							Auto_Quest_Yama_2 = false
							Auto_Quest_Yama_3 = false
							Auto_Quest_Tushita_1 = false
							Auto_Quest_Tushita_2 = true
							Auto_Quest_Tushita_3 = false
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
						elseif GetMaterial("Alucard Fragment") == 5 then
							Auto_Quest_Yama_1 = false
							Auto_Quest_Yama_2 = false
							Auto_Quest_Yama_3 = false
							Auto_Quest_Tushita_1 = false
							Auto_Quest_Tushita_2 = false
							Auto_Quest_Tushita_3 = true
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Good")
						elseif GetMaterial("Alucard Fragment") == 6 then
							if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton Boss") or game:GetService("Workspace").ReplicatedStorage:FindFirstChild("Cursed Skeleton Boss") then
								Auto_Quest_Yama_1 = false
								Auto_Quest_Yama_2 = false
								Auto_Quest_Yama_3 = false
								Auto_Quest_Tushita_1 = false
								Auto_Quest_Tushita_2 = false
								Auto_Quest_Tushita_3 = false
								if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton Boss") or game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Cursed Skeleton Boss" or v.Name == "Cursed Skeleton" then
											if v.Humanoid.Health > 0 then
												v.HumanoidRootPart.CanCollide = false
												v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
												TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(0,50,0))
												game:GetService'VirtualUser':CaptureController()
												game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
											end
										end
									end
								end
							else
								if (CFrame.new(-12361.7060546875, 603.3547973632812, -6550.5341796875).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Good")
									wait(1)
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","Progress","Evil")
									wait(1)
									TweenFarm(CFrame.new(-12361.7060546875, 603.3547973632812, -6550.5341796875))
									wait(1.5)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
									wait(1.5)
									TweenFarm(CFrame.new(-12253.5419921875, 598.8999633789062, -6546.8388671875))
								else
									TweenFarm(CFrame.new(-12361.7060546875, 603.3547973632812, -6550.5341796875))
								end   
							end
						end
					end
				end)
			end
		end)
		spawn(function()
			while wait() do
				if Auto_Quest_Yama_1 then
					pcall(function()
						if game:GetService("Workspace").Enemies:FindFirstChild("Mythological Pirate") then
							for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if v.Name == "Mythological Pirate" then
									repeat wait()
										TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(0,0,-2))
									until Auto_Cursed_Dual_Katana == false or Auto_Cursed_Dual_Katana == false or Auto_Quest_Yama_1 == false
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","StartTrial","Evil")
								end
							end
						else
							TweenFarm(CFrame.new(-13451.46484375, 543.712890625, -6961.0029296875))
						end
					end)
				end
			end
		end)
		spawn(function()
			while wait() do
				pcall(function()
					if Auto_Quest_Yama_2 then
						for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if v:FindFirstChild("HazeESP") then
								v.HazeESP.Size = UDim2.new(50,50,50,50)
								v.HazeESP.MaxDistance = "inf"
							end
						end
						for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
							if v:FindFirstChild("HazeESP") then
								v.HazeESP.Size = UDim2.new(50,50,50,50)
								v.HazeESP.MaxDistance = "inf"
							end
						end
					end
				end)
			end
		end)
		spawn(function()
			while wait() do
				pcall(function()
					for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if Auto_Quest_Yama_2 and v:FindFirstChild("HazeESP") and (v.HumanoidRootPart.Position - PosMonsEsp.Position).magnitude <= 300 then
							v.HumanoidRootPart.CFrame = PosMonsEsp
							v.HumanoidRootPart.CanCollide = false
							v.HumanoidRootPart.Size = Vector3.new(50,50,50)
							if not v.HumanoidRootPart:FindFirstChild("BodyVelocity") then
								local vc = Instance.new("BodyVelocity", v.HumanoidRootPart)
								vc.MaxForce = Vector3.new(1, 1, 1) * math.huge
								vc.Velocity = Vector3.new(0, 0, 0)
							end
						end
					end
				end)
			end
		end)
		spawn(function()
			while wait() do
				if Auto_Quest_Yama_2 then 
					pcall(function() 
						for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if v:FindFirstChild("HazeESP") then
								repeat wait()
									if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 2000 then
										TweenFarm(y.HumanoidRootPart.CFrameMon * CFrame.new(0,20,0))
									else
										StartMagnet = true
										if not game.Players.LocalPlayer.Character:FindFirstChild(_G.SelectWeapon) then
											wait()
											EquipWeapon("Melee")
										end
										PosMonsEsp = v.HumanoidRootPart.CFrame
										v.HumanoidRootPart.Size = Vector3.new(60,60,60)
										if _G.Configs["Show Hitbox"] then
											v.HumanoidRootPart.Transparency = _G.Hitbox_LocalTransparency
										else
											v.HumanoidRootPart.Transparency = 1
										end
										v.Humanoid.JumpPower = 0
										v.Humanoid.WalkSpeed = 0
										v.HumanoidRootPart.CanCollide = false
										v.Humanoid:ChangeState(11)
										TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(0,20,0))								
									end      
								until Auto_Cursed_Dual_Katana == false or Auto_Quest_Yama_2 == false or not v.Parent or v.Humanoid.Health <= 0 or not v:FindFirstChild("HazeESP")
							else
								for x,y in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
									if y:FindFirstChild("HazeESP") then
										if (y.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 2000 then
											TweenFarm(y.HumanoidRootPart.CFrameMon* CFrame.new(0,20,0))
										else
											TweenFarm(y.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
										end
									end
								end
							end
						end
					end)
				end
			end
		end)
		spawn(function()
			while wait() do
				if Auto_Quest_Yama_3 then
					pcall(function()
						if game.Players.LocalPlayer.Backpack:FindFirstChild("Hallow Essence") then         
							TweenFarm(game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.CFrame)
						elseif game:GetService("Workspace").Map:FindFirstChild("HellDimension") then
							repeat wait()
								if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton") or game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton") or game:GetService("Workspace").Enemies:FindFirstChild("Hell's Messenger") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Cursed Skeleton" or v.Name == "Cursed Skeleton" or v.Name == "Hell's Messenger" then
											if v.Humanoid.Health > 0 then
												repeat wait()
													StartMagnet = true
													FastAttack = true
													if Auto_Buso then
														if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
															game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
														end
													end
													if not game.Players.LocalPlayer.Character:FindFirstChild("Melee") then
														wait()
														EquipWeapon("Melee")
													end
													PosMonsEsp = v.HumanoidRootPart.CFrame
													if not FastAttack then
														game:GetService'VirtualUser':CaptureController()
														game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
													end
													v.HumanoidRootPart.Size = Vector3.new(60,60,60)
													if _G.Configs["Show Hitbox"] then
														v.HumanoidRootPart.Transparency = _G.Hitbox_LocalTransparency
													else
														v.HumanoidRootPart.Transparency = 1
													end
													v.Humanoid.JumpPower = 0
													v.Humanoid.WalkSpeed = 0
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid:ChangeState(11)
													TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(0,50,0))
												until v.Humanoid.Health <= 0 or not v.Parent or Auto_Quest_Yama_3 == false
											end
										end
									end
								else
									wait(5)
									TweenFarm(game:GetService("Workspace").Map.HellDimension.Torch1.CFrame)
									wait(1.5)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
									wait(1.5)        
									TweenFarm(game:GetService("Workspace").Map.HellDimension.Torch2.CFrame)
									wait(1.5)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
									wait(1.5)     
									TweenFarm(game:GetService("Workspace").Map.HellDimension.Torch3.CFrame)
									wait(1.5)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
									wait(1.5)     
									TweenFarm(game:GetService("Workspace").Map.HellDimension.Exit.CFrame)
								end
							until Auto_Cursed_Dual_Katana == false or Auto_Quest_Yama_3 == false or GetMaterial("Alucard Fragment") == 3
						else
							if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") or game.ReplicatedStorage:FindFirstChild("Soul Reaper") then
								if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Soul Reaper" then
											if v.Humanoid.Health > 0 then
												repeat wait()
													TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(0,0,-2))
												until Auto_Cursed_Dual_Katana == false or Auto_Quest_Yama_3 == false or game:GetService("Workspace").Map:FindFirstChild("HellDimension")
											end
										end
									end
								else
									TweenFarm(CFrame.new(-9570.033203125, 315.9346923828125, 6726.89306640625))
								end
							end
						end
					end)
				end
			end
		end)
		spawn(function() 
			while wait() do
				if Auto_Quest_Tushita_1 then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest","BoatQuest",workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
				end
			end
		end)
		spawn(function()
			while wait() do
				if Auto_Quest_Tushita_1 then
					TweenFarm(CFrame.new(-9546.990234375, 21.139892578125, 4686.1142578125))
					wait(5)
					TweenFarm(CFrame.new(-6120.0576171875, 16.455780029296875, -2250.697265625))
					wait(5)
					TweenFarm(CFrame.new(-9533.2392578125, 7.254445552825928, -8372.69921875))    
				end
			end
		end)
		spawn(function()
			while wait() do
				if Auto_Quest_Tushita_2 then
					pcall(function()
						if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
							for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
								if Auto_Quest_Tushita_2 and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
									if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000 then
										repeat wait()
											v.HumanoidRootPart.CanCollide = false
											v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
											TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(0,50,0))
											game:GetService'VirtualUser':CaptureController()
											game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
										until v.Humanoid.Health <= 0 or not v.Parent or Auto_Quest_Tushita_2 == false
									end
								end
							end
						else
							TweenFarm(CFrame.new(-5545.1240234375, 313.800537109375, -2976.616455078125))
						end
					end)
				end
			end
		end)
		spawn(function()
			while wait() do
				if Auto_Quest_Tushita_3 then
					pcall(function()
						if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen") or game.ReplicatedStorage:FindFirstChild("Cake Queen") then
							if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen") then
								for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
									if v.Name == "Cake Queen" then
										if v.Humanoid.Health > 0 then
											repeat wait()
												if Auto_Buso then
													if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
														game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
													end
												end
												if not game.Players.LocalPlayer.Character:FindFirstChild("Melee") then
													wait()
													EquipWeapon("Melee")
												end
												v.HumanoidRootPart.Size = Vector3.new(60,60,60)
												if _G.Configs["Show Hitbox"] then
													v.HumanoidRootPart.Transparency = _G.Hitbox_LocalTransparency
												else
													v.HumanoidRootPart.Transparency = 1
												end
												v.Humanoid.JumpPower = 0
												v.Humanoid.WalkSpeed = 0
												v.HumanoidRootPart.CanCollide = false
												v.Humanoid:ChangeState(11)
												TweenFarm(v.HumanoidRootPart.CFrame * CFrame.new(0,50,0))
											until Auto_Cursed_Dual_Katana == false or Auto_Quest_Tushita_3 == false or game:GetService("Workspace").Map:FindFirstChild("HeavenlyDimension")
										end
									end
								end
							else
								TweenFarm(CFrame.new(-709.3132934570312, 381.6005859375, -11011.396484375))
							end
						elseif game:GetService("Workspace").Map:FindFirstChild("HeavenlyDimension") then
							repeat wait()
								if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton") or game:GetService("Workspace").Enemies:FindFirstChild("Cursed Skeleton") or game:GetService("Workspace").Enemies:FindFirstChild("Heaven's Guardian") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Cursed Skeleton" or v.Name == "Cursed Skeleton" or v.Name == "Heaven's Guardian" then
											if v.Humanoid.Health > 0 then
												repeat wait()
													if Auto_Buso then
														if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
															game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
														end
													end
													if not game.Players.LocalPlayer.Character:FindFirstChild("Melee") then
														wait()
														EquipWeapon("Melee")
													end
													if not FastAttack then
														game:GetService'VirtualUser':CaptureController()
														game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
													end
													v.HumanoidRootPart.Size = Vector3.new(60,60,60)
													if _G.Configs["Show Hitbox"] then
														v.HumanoidRootPart.Transparency = _G.Hitbox_LocalTransparency
													else
														v.HumanoidRootPart.Transparency = 1
													end
													v.Humanoid.JumpPower = 0
													v.Humanoid.WalkSpeed = 0
													v.HumanoidRootPart.CanCollide = false
													v.Humanoid:ChangeState(11)
												until v.Humanoid.Health <= 0 or not v.Parent or Auto_Quest_Tushita_3 == false
											end
										end
									end
								else
									wait(5)
									TweenFarm(game:GetService("Workspace").Map.HeavenlyDimension.Torch1.CFrame)
									wait(1.5)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
									wait(1.5)        
									TweenFarm(game:GetService("Workspace").Map.HeavenlyDimension.Torch2.CFrame)
									wait(1.5)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
									wait(1.5)     
									TweenFarm(game:GetService("Workspace").Map.HeavenlyDimension.Torch3.CFrame)
									wait(1.5)
									game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
									wait(1.5)     
									TweenFarm(game:GetService("Workspace").Map.HeavenlyDimension.Exit.CFrame)
								end
							until Auto_Cursed_Dual_Katana == false or Auto_Quest_Tushita_3 == false or GetMaterial("Alucard Fragment") == 6
						else
							Hop()
						end
					end)
				end
			end
		end)
	end
end
-- buy all ability
_G.BuyAllAib = true
while wait() do
	if _G.BuyAllAib then
		pcall(function()
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk","Buy")
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Buso")
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Soru")
		end)
	end 
end 
--//auto hop
while wait() do
	wait(2500)
	Hop()
end

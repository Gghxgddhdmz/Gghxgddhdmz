local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "RobartoxVoiidxLith",
   Icon = 89329261427843, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "ALSHABA7 Voiid",
   LoadingSubtitle = "Made By Voiid!",
   Theme = "Light", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Alshaba7 HUB"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

Rayfield:Notify({
   Title = "Welcome To My Script!",
   Content = "This Script Made Specially For You And ALSHABA7 Clan",
   Duration = 5,
   Image = 110139412486838,
})

local Tab = Window:CreateTab("AntiAFK Scripts", 89329261427843) -- Title, Image

local Section = Tab:CreateSection("سكربتات صمله")

local Button = Tab:CreateButton({
   Name = "LordVoiid AntiAFK OP",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/XxAbood/Anti-Afk-Script-By-LordVoiid/refs/heads/main/AntiafkByLordVoiid"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "AntiAFK V2",
   Callback = function()
   loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Anti-Afk-Remastered-Script-or-Diffrent-Cool-UI-2097"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "AntiAFK By hassanxzayn",
   Callback = function()
   loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AntiAFK-script-18076"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "AntiAFK By getmepink",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/brosula123/Anti-afk/main/Bl%C3%B8xzScript"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "AntiAFK KongerHub",
   Callback = function()
   loadstring(game:HttpGet("https://zxfolix.github.io/antiafk.lua"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "AntiAFK Advanced With Spam",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/2dgeneralspam1/scripts-and-stuff/master/scripts/LoadstringypVvhJBq4QNz", true))()
   end,
})

local Tab = Window:CreateTab("BrookHaven Scripts", 132680152916449) -- Title, Image

local Section = Tab:CreateSection("سكربتات ماب البيوت")

local Button = Tab:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Nameless Admin Script",
   Callback = function()
   --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
loadstring(game:HttpGet('https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Atomic Hub",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/n0kc/AtomicHub/main/Map-Al-Biout.lua"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "R4D Hub",
   Callback = function()
   --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
loadstring(game:HttpGet('https://raw.githubusercontent.com/M1ZZ001/BrookhavenR4D/main/Brookhaven%20R4D%20Script'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Ghost Hub",
   Callback = function()
   --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Rochips Universal",
   Callback = function()
   loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-rochips-universal-18294"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "F0rtuit0us Hub (OP)",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/TrollGuiMaker/f0rtuit0us-hub/refs/heads/main/old"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Sander X NEW UPDATE",
   Callback = function()
   loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-Sander-x-22769"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "YIN Hub",
   Callback = function()
   loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-Yin-Hub-21835"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Vex Hub",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/V31nc/discord.com/invite/3NN5zTW7h2"))()
   end,
})

local Tab = Window:CreateTab("Random Scripts", 80203996981387) -- Title, Image

local Section = Tab:CreateSection("سكربتات منوعه *ممكن تشتغل فماب البيوت*")

local Button = Tab:CreateButton({
   Name = "VR7 سكربت تاج معرب",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/VR7ss/OMK/main/VR7%20RAGDOLL"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Invisible 1 اختفاء",
   Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Invisible%20Gui'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Invisible 2 اختفاء",
   Callback = function()
   loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Fling Script 1",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/0Ben1/fe./main/Fling%20GUI"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Fling Script 2",
   Callback = function()
   loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fling-gui-script-13229"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Notify If Someone Leave - Joins",
   Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/leg1337/legadmv2/main/legadminv2.lua'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "FPS Booster",
   Callback = function()
   --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
_G.Ignore = {}
_G.Settings = {
	Players = {
		["Ignore Me"] = true,
		["Ignore Others"] = true,
		["Ignore Tools"] = true
	},
	Meshes = {
		NoMesh = false,
		NoTexture = false,
		Destroy = false
	},
	Images = {
		Invisible = true,
		Destroy = false
	},
	Explosions = {
		Smaller = true,
		Invisible = false, -- Not for PVP games
		Destroy = false -- Not for PVP games
	},
	Particles = {
		Invisible = true,
		Destroy = false
	},
	TextLabels = {
		LowerQuality = true,
		Invisible = false,
		Destroy = false
	},
	MeshParts = {
		LowerQuality = true,
		Invisible = false,
		NoTexture = false,
		NoMesh = false,
		Destroy = false
	},
	Other = {
		["FPS Cap"] = 360, -- true to uncap
		["No Camera Effects"] = true,
		["No Clothes"] = true,
		["Low Water Graphics"] = true,
		["No Shadows"] = true,
		["Low Rendering"] = true,
		["Low Quality Parts"] = true,
		["Low Quality Models"] = true,
		["Reset Materials"] = true,
	}
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua"))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Voiid Fly GUI V3",
   Callback = function()
   loadstring(game:HttpGet('https://pastebin.com/raw/VgGGWeNH'))()
   end,
})

local Button = Tab:CreateButton({
   Name = "Fly Gui V3 Modded",
   Callback = function()
   loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Fly-Gui-Modded-10763"))()
   end,
})

local Tab = Window:CreateTab("BONUS", 96509056170213) -- Title, Image

local Section = Tab:CreateSection("سكربتات مفيدة")

local Button = Tab:CreateButton({
   Name = "Chat Protection حماية من باند السبام",
   Callback = function()
   --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
loadstring(game:HttpGet("https://raw.githubusercontent.com/AnthonyIsntHere/anthonysrepository/main/scripts/AntiChatLogger.lua", true))()
   end,
})

local Button = Tab:CreateButton({
   Name = "FE Illusion سكربت تفادي بانق",
   Callback = function()
   loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-Illusion-Script-12744"))()
   end,
})

local Tab = Window:CreateTab("Read Me Lol", 96509056170213) -- Title, Image

local Section = Tab:CreateSection("Thank You For using My Script! :D")

local Section = Tab:CreateSection("سكربتي افضل من داني ههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههههه")

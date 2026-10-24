-- Copies the serialized environment from Outpost_Extracted.rbxlx.
-- Run once in Studio Edit mode. Creates no gameplay scripts.
local lighting = game:GetService("Lighting")
local history = game:GetService("ChangeHistoryService")
history:SetWaypoint("Before Outpost Environment Match")
local storage = game:GetService("ServerStorage")
local backupRoot = storage:FindFirstChild("SpaceWorldSetupBackup")
if not backupRoot then backupRoot = Instance.new("Folder"); backupRoot.Name = "SpaceWorldSetupBackup"; backupRoot.Parent = storage end
local backup = Instance.new("Folder")
backup.Name = "BeforeOutpostEnvironment_" .. game:GetService("HttpService"):GenerateGUID(false)
backup.Parent = backupRoot
backup:SetAttribute("Ambient", lighting["Ambient"])
backup:SetAttribute("OutdoorAmbient", lighting["OutdoorAmbient"])
backup:SetAttribute("ColorShift_Top", lighting["ColorShift_Top"])
backup:SetAttribute("ColorShift_Bottom", lighting["ColorShift_Bottom"])
backup:SetAttribute("Brightness", lighting["Brightness"])
backup:SetAttribute("ClockTime", lighting["ClockTime"])
backup:SetAttribute("GeographicLatitude", lighting["GeographicLatitude"])
backup:SetAttribute("GlobalShadows", lighting["GlobalShadows"])
backup:SetAttribute("FogColor", lighting["FogColor"])
backup:SetAttribute("FogStart", lighting["FogStart"])
backup:SetAttribute("FogEnd", lighting["FogEnd"])
for _, child in lighting:GetChildren() do
 if child:IsA("Sky") or child:IsA("Atmosphere") or child:IsA("PostEffect") then child.Parent = backup end
end
lighting["Ambient"] = Color3.new(0.52, 0.56, 0.64)
lighting["OutdoorAmbient"] = Color3.new(0.56, 0.62, 0.72)
lighting["ColorShift_Top"] = Color3.new(0.98, 0.96, 0.92)
lighting["ColorShift_Bottom"] = Color3.new(0.48, 0.54, 0.65)
lighting["Brightness"] = 2.2
lighting["ClockTime"] = 14.5
lighting["GeographicLatitude"] = 41.73
lighting["GlobalShadows"] = true
lighting["FogColor"] = Color3.new(0.7, 0.78, 0.9)
lighting["FogStart"] = 1500
lighting["FogEnd"] = 5000
local effect0 = Instance.new("Sky")
effect0["Name"] = "CosmicSky"
effect0["SkyboxBk"] = "rbxassetid://159454299"
effect0["SkyboxDn"] = "rbxassetid://159454296"
effect0["SkyboxFt"] = "rbxassetid://159454293"
effect0["SkyboxLf"] = "rbxassetid://159454286"
effect0["SkyboxRt"] = "rbxassetid://159454300"
effect0["SkyboxUp"] = "rbxassetid://159454288"
effect0["CelestialBodiesShown"] = true
effect0["StarCount"] = 5000
effect0["SunAngularSize"] = 11
effect0.Parent = lighting
local effect1 = Instance.new("Atmosphere")
effect1["Name"] = "Atmosphere"
effect1["Density"] = 0.1
effect1["Offset"] = 0.25
effect1["Color"] = Color3.new(0.65, 0.78, 0.95)
effect1["Decay"] = Color3.new(0.75, 0.65, 0.9)
effect1["Glare"] = 0.1
effect1["Haze"] = 0.2
effect1.Parent = lighting
local effect2 = Instance.new("ColorCorrectionEffect")
effect2["Name"] = "ColorCorrection"
effect2["Brightness"] = 0.02
effect2["Contrast"] = 0.12
effect2["Saturation"] = 0.28
effect2["TintColor"] = Color3.new(1, 1, 1)
effect2.Parent = lighting
local effect3 = Instance.new("SunRaysEffect")
effect3["Name"] = "SunRays"
effect3["Intensity"] = 0.08
effect3["Spread"] = 0.6
effect3.Parent = lighting
local effect4 = Instance.new("BloomEffect")
effect4["Name"] = "Bloom"
effect4["Intensity"] = 0.18
effect4["Size"] = 10
effect4["Threshold"] = 0.94
effect4.Parent = lighting
history:SetWaypoint("Outpost Environment Matched")
return "Outpost environment applied. Previous environment backed up at " .. backup:GetFullName()

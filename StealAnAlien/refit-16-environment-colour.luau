-- Editor-only colour pass. Preserves geometry, floor materials and collision.
local root = workspace.SpaceWorld
local C = Color3.fromRGB
local backup = game.ServerStorage:FindFirstChild("OrbitalEnvironmentBackup")
if not backup then backup = Instance.new("Folder"); backup.Name = "OrbitalEnvironmentBackup"; backup.Parent = game.ServerStorage end
local count = 0
local function tint(p, color)
 if not p:GetAttribute("OrbitalOriginalColor") then p:SetAttribute("OrbitalOriginalColor", p.Color) end
 p.Color = color
 for _,a in p:GetChildren() do if a:IsA("SurfaceAppearance") then
  pcall(function()
   if not a:GetAttribute("OrbitalOriginalColor") then a:SetAttribute("OrbitalOriginalColor", a.Color) end
   a.Color = color; p.Color = C(255,255,255)
  end)
 end end
 count += 1
end
local function assembly(m,color)
 for _,p in m:GetDescendants() do if p:IsA("BasePart") and p.Transparency < .95 then tint(p,color) end end
end
local function ship(m, accent)
 for _,p in m:GetDescendants() do if p:IsA("BasePart") then
  if p.Name == "PressureHull" or p.Name:match("^BeveledFlank") or p.Name:match("^TaperedEnd") or p.Name:match("^Nacelle_") then tint(p, C(40,59,80))
  elseif p.Name:match("^NacelleBand") or p.Name:match("^NacelleTop") or p.Name:match("^ProwAccent") or p.Name:match("^ExhaustCore") or p.Name:match("^Header_") or p.Name:match("^SideCap") or p.Name=="SensorBar" then tint(p,accent)
  elseif p.Name:match("^ArmorRib") or p.Name:match("^SplitProw") or p.Name:match("^EngineBell") then tint(p,C(105,132,151))
  elseif p.Name:match("^SideWall") or p.Name:match("^DockingShoulder") then tint(p,C(35,55,73)) end
 end end
end
local hub=root.SpawnHub
ship(hub.Spacecraft,C(66,176,187))
for _,m in hub.StationArchitecture:GetChildren() do assembly(m,C(92,140,159)) end
for _,p in hub.ConcourseCanopy:GetDescendants() do
 if p:IsA("BasePart") and (p.Name:find("Rail") or p.Name:find("Crossmember")) then tint(p,C(37,67,88))
 elseif p:IsA("Light") then p.Color=C(208,231,237) end
end
for _,p in hub.HubStructure.EngineeredWalkingDeck:GetChildren() do
 if p.Name=="PortDeck" or p.Name=="StarboardDeck" then tint(p,C(159,182,190)) end
end
local palettes={
 {"LunarOutpost",C(91,177,218),C(218,226,232),C(79,117,145)},
 {"RustMoon",C(225,148,72),C(237,184,139),C(137,95,71)},
 {"Xenoforest",C(105,196,139),C(144,190,137),C(69,119,96)},
 {"CryoMoon",C(111,216,231),C(178,218,236),C(88,142,170)},
 {"BasaltRift",C(234,114,66),C(158,140,133),C(128,80,72)},
 {"VoidArchive",C(170,136,228),C(176,158,218),C(104,84,147)},
}
for i,v in palettes do
 local w=root.Worlds[string.format("World_%02d_%s",i,v[1])]
 w:SetAttribute("EnvironmentAccent",v[2]); ship(w.Spacecraft,v[2])
 for _,p in w.EngineeredWalkingDeck:GetChildren() do if p.Name=="PortDeck" or p.Name=="StarboardDeck" then tint(p,v[3]) end end
 for _,p in w.EntryGate:GetDescendants() do if p:IsA("BasePart") and p.Name~="Header" then tint(p,v[2]) end end
 for _,m in w.RefinedEnvironment:GetDescendants() do
  if m:IsA("Model") and (m.Name:match("^RearPanel") or m.Name:match("^FrontShoulder") or m.Name:match("^SidePanel")) then assembly(m,v[4]) end
 end
 for _,p in w.Spacecraft:GetDescendants() do if p:IsA("TextLabel") then p.TextColor3=v[2]:Lerp(C(255,255,255),.5) end end
 task.wait()
end
for _,plot in root.PlayerBases:GetChildren() do
 for _,p in plot:GetDescendants() do
  if p:IsA("BasePart") and (p.Name=="EntryBoundary_1" or p.Name=="EntryBoundary_-1" or p.Name=="ReturnPad") then tint(p,C(74,175,180)) end
 end
end
local light=game.Lighting
if not backup:GetAttribute("LightingBackedUp") then
 for _,k in {"Ambient","OutdoorAmbient","Brightness","ExposureCompensation","EnvironmentDiffuseScale","EnvironmentSpecularScale"} do backup:SetAttribute(k,light[k]) end
 for _,p in light:GetChildren() do local c=p:Clone();c.Parent=backup end
 backup:SetAttribute("LightingBackedUp",true)
end
light.Ambient=C(104,103,112);light.OutdoorAmbient=C(134,130,137)
light.Brightness=2;light.ExposureCompensation=.65
light.EnvironmentDiffuseScale=.65;light.EnvironmentSpecularScale=.75
local grade=light:FindFirstChild("NeutralSpaceGrade")
if grade and grade:IsA("ColorCorrectionEffect") then grade.TintColor=C(255,249,241);grade.Saturation=.08;grade.Contrast=.08;grade.Brightness=0 end
root:SetAttribute("OrbitalColourPass",true)
game:GetService("ChangeHistoryService"):SetWaypoint("Space environment colour palette")
return {recolouredParts=count,worldPalettes=#palettes}

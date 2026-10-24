local lighting=game:GetService("Lighting")
local backup=game:GetService("ServerStorage").StealAnAlien_TemplateBackup
local saved=Instance.new("Folder"); saved.Name="OriginalLighting"; saved.Parent=backup
for _,name in {"ClockTime","Brightness","Ambient","OutdoorAmbient","GlobalShadows","FogColor","FogStart","FogEnd","ExposureCompensation"} do saved:SetAttribute(name,lighting[name]) end
for _,child in lighting:GetChildren() do child.Parent=saved end
lighting.ClockTime=0; lighting.Brightness=2
lighting.Ambient=Color3.fromRGB(80,86,100); lighting.OutdoorAmbient=Color3.fromRGB(110,116,130)
lighting.GlobalShadows=true; lighting.ExposureCompensation=1
lighting.EnvironmentDiffuseScale=0.35; lighting.EnvironmentSpecularScale=0.35
lighting.FogColor=Color3.fromRGB(8,12,20); lighting.FogStart=2800; lighting.FogEnd=6000
workspace.Gravity=196.2
local sky=Instance.new("Sky"); sky.Name="DeepSpaceBackdrop"
for _,name in {"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp"} do sky[name]="" end
sky.CelestialBodiesShown=false; sky.StarCount=0; sky.Parent=lighting
local bloom=Instance.new("BloomEffect"); bloom.Name="RestrainedBloom"; bloom.Enabled=false; bloom.Intensity=0; bloom.Parent=lighting
local correction=Instance.new("ColorCorrectionEffect"); correction.Name="NeutralSpaceGrade"
correction.Brightness=0; correction.Contrast=0.04; correction.Saturation=-0.08; correction.TintColor=Color3.fromRGB(255,255,255); correction.Parent=lighting
assert(lighting.ClockTime==0 and lighting.Brightness==2,"Lighting mismatch")
assert(math.abs(workspace.Gravity-196.2)<0.001,"Gravity mismatch")
assert(#lighting:GetChildren()==3 and bloom.Enabled==false,"Effects mismatch")
game:GetService("ChangeHistoryService"):SetWaypoint("Steal an Alien Lighting Complete")
return game:GetService("HttpService"):JSONEncode({phase="B",passed=true,clock=lighting.ClockTime,brightness=lighting.Brightness,ambient=tostring(lighting.Ambient),outdoorAmbient=tostring(lighting.OutdoorAmbient),gravity=workspace.Gravity,bloom=false,sky="Empty-face dark backdrop; no external assets"})

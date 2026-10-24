-- Phase 5: static, responsive HUD. Run in Studio Edit mode.
-- No LocalScripts, event handlers, counters, or stealing logic are installed.
local starterGui=game:GetService("StarterGui")
assert(not starterGui:FindFirstChild("SpaceStealHUD"),"SpaceStealHUD already exists")
game:GetService("ChangeHistoryService"):SetWaypoint("Before Space HUD")
local cyan=Color3.fromRGB(65,225,255)
local white=Color3.fromRGB(232,244,255)
local muted=Color3.fromRGB(148,175,199)
local gui=Instance.new("ScreenGui")
gui.Name="SpaceStealHUD"
gui.ResetOnSpawn=false
gui.Enabled=true
gui.DisplayOrder=10
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.ScreenInsets=Enum.ScreenInsets.CoreUISafeInsets
gui.ClipToDeviceSafeArea=true
local function frame(parent,name,size,position,color,transparency)
 local f=Instance.new("Frame")
 f.Name=name; f.Size=size; f.Position=position
 f.BackgroundColor3=color; f.BackgroundTransparency=transparency or 0
 f.BorderSizePixel=0; f.Active=false; f.Parent=parent
 return f
end
local function stylePanel(panel)
 local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,8); corner.Parent=panel
 local stroke=Instance.new("UIStroke"); stroke.Name="CyanBorder"; stroke.Color=cyan; stroke.Thickness=1.25; stroke.Transparency=0.35; stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; stroke.Parent=panel
 local gradient=Instance.new("UIGradient"); gradient.Rotation=90; gradient.Color=ColorSequence.new(Color3.fromRGB(24,35,57),Color3.fromRGB(7,13,25)); gradient.Parent=panel
end
local function label(parent,name,text,size,position,color,maxSize,minSize,alignment)
 local t=Instance.new("TextLabel")
 t.Name=name; t.Text=text; t.Size=size; t.Position=position
 t.BackgroundTransparency=1; t.BorderSizePixel=0
 t.TextColor3=color; t.Font=Enum.Font.GothamBold
 t.TextSize=maxSize; t.TextScaled=true; t.TextWrapped=false
 t.TextXAlignment=alignment or Enum.TextXAlignment.Left
 t.TextYAlignment=Enum.TextYAlignment.Center
 t.Parent=parent
 local constraint=Instance.new("UITextSizeConstraint"); constraint.MaxTextSize=maxSize; constraint.MinTextSize=minSize; constraint.Parent=t
 return t
end
local banner=frame(gui,"StatusBanner",UDim2.new(1,-32,0,64),UDim2.new(0.5,0,0,12),Color3.new(1,1,1),0.14)
banner.AnchorPoint=Vector2.new(0.5,0)
stylePanel(banner)
local bannerSize=Instance.new("UISizeConstraint"); bannerSize.MaxSize=Vector2.new(720,64); bannerSize.Parent=banner
local topAccent=frame(banner,"TopAccent",UDim2.fromOffset(72,2),UDim2.new(0.5,0,0,0),cyan)
topAccent.AnchorPoint=Vector2.new(0.5,0)
local missionTitle=label(banner,"MissionTitle","SECTOR 01 // STEAL THE COSMIC EGG",UDim2.new(1,-32,0,26),UDim2.fromOffset(16,10),white,21,10,Enum.TextXAlignment.Center)
missionTitle.TextWrapped=true
label(banner,"SectorDetail","CENTRAL NEST  //  FOUR OUTPOSTS",UDim2.new(1,-32,0,16),UDim2.fromOffset(16,38),muted,11,9,Enum.TextXAlignment.Center)
local telemetry=frame(gui,"EggStatusPanel",UDim2.new(0.65,0,0,112),UDim2.new(1,-16,0,96),Color3.new(1,1,1),0.12)
telemetry.AnchorPoint=Vector2.new(1,0)
stylePanel(telemetry)
local panelSize=Instance.new("UISizeConstraint"); panelSize.MinSize=Vector2.new(190,112); panelSize.MaxSize=Vector2.new(260,112); panelSize.Parent=telemetry
frame(telemetry,"LeftAccent",UDim2.new(0,3,1,-24),UDim2.fromOffset(0,12),cyan)
label(telemetry,"PanelHeading","FIELD TELEMETRY",UDim2.new(1,-36,0,16),UDim2.fromOffset(18,10),muted,11,10)
frame(telemetry,"HeadingDivider",UDim2.new(1,-36,0,1),UDim2.fromOffset(18,34),cyan,0.75)
label(telemetry,"StolenEggs","STOLEN EGGS: 0",UDim2.new(1,-36,0,28),UDim2.fromOffset(18,42),white,20,14)
label(telemetry,"Carrying","CARRYING: NONE",UDim2.new(1,-36,0,22),UDim2.fromOffset(18,77),cyan,16,12)
gui.Parent=starterGui
game:GetService("ChangeHistoryService"):SetWaypoint("Space HUD Created")
return "StarterGui.SpaceStealHUD created with responsive mission banner and static egg status panel."

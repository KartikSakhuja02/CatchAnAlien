local root=workspace.SpaceWorld
local sources=game.ServerStorage.SpaceArtSourceAssets
local arch=sources.BeyondTheDark_Architecture
local props=sources.BeyondTheDark_Props
local V,C=Vector3.new,Color3.fromRGB
local backup=game.ServerStorage:FindFirstChild("SpaceVisualRefitBackup")
if not backup then backup=Instance.new("Folder");backup.Name="SpaceVisualRefitBackup";backup.Parent=game.ServerStorage end
local function model(parent,name) local m=Instance.new("Model");m.Name=name;m.Parent=parent;return m end
local function box(parent,name,pos,size,color,material)
 local p=Instance.new("Part");p.Name=name;p.Position=pos;p.Size=size;p.Color=color or C(82,91,102);p.Material=material or Enum.Material.Metal;p.Anchored=true;p.CanCollide=true;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=parent;return p
end
local function archive(p,name)
 if p then if name then p.Name=name end;p.Parent=backup end
end
local function install(source,parent,name,x,bottom,z,scale,yaw)
 assert(source,"Missing source: "..name)
 local m=Instance.new("Model");m.Name=name;m:SetAttribute("ArtSource",source:GetFullName());m:SetAttribute("StaticImportedArt",true)
 local clone=source:Clone();clone.Parent=m
 for _,p in m:GetDescendants() do
  if p:IsA("LuaSourceContainer") or p:IsA("Humanoid") or p:IsA("AnimationController") or p.Name=="HumanoidRootPart" or p:IsA("ProximityPrompt") or p:IsA("ClickDetector") or p:IsA("Sound") or p:IsA("ParticleEmitter") or p:IsA("Trail") or p:IsA("Beam") then p:Destroy()
  elseif p:IsA("BasePart") then
   p.Anchored=true;p.CanCollide=true
   if p:IsA("Seat") or p:IsA("VehicleSeat") then p.Disabled=true end
   if p:IsA("MeshPart") then p.CollisionFidelity=Enum.CollisionFidelity.PreciseConvexDecomposition end
   if p.Material==Enum.Material.Neon then p.Material=Enum.Material.SmoothPlastic end
  elseif p:IsA("Light") then p.Brightness=math.min(p.Brightness,1.5);p.Range=math.min(p.Range,35)
  elseif p:IsA("SurfaceGui") or p:IsA("BillboardGui") then p:Destroy() end
 end
 if scale and scale~=1 then m:ScaleTo(scale) end
 local bcf,size=m:GetBoundingBox()
 local target=CFrame.new(x,bottom+size.Y/2,z)*CFrame.Angles(0,math.rad(yaw or 0),0)
 m:PivotTo(target*bcf:Inverse()*m:GetPivot())
 m.Parent=parent;return m,size
end
local function sign(parent,name,text,cf,size,accent)
 local panel=box(parent,name,cf.Position,size,C(21,29,37));panel.CFrame=cf
 local gui=Instance.new("SurfaceGui");gui.Name="StationSign";gui.Face=Enum.NormalId.Front;gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;gui.PixelsPerStud=45;gui.LightInfluence=.15;gui.Parent=panel
 local label=Instance.new("TextLabel");label.Name="Text";label.Size=UDim2.new(1,-18,1,-12);label.Position=UDim2.fromOffset(9,6);label.BackgroundTransparency=1;label.Font=Enum.Font.GothamMedium;label.Text=text;label.TextColor3=accent or C(198,215,216);label.TextSize=36;label.TextScaled=true;label.Parent=gui
 return panel
end

local function cabin(parent,name,x,z)
 local m=model(parent,name);m:SetAttribute("ArtAssembly",true)
 local w,h,d=16.00325,16.003235,3.48664
 local sideX=w+d/2
 for _,side in {-1,1} do
  install(arch.Walls.Wall_Panel_A_Dark,m,"RearPanel_"..side,x+side*w/2,2,z+8+d/2,1,180)
  install(arch.Walls.Wall_Panel_A_Half_Dark,m,"FrontShoulder_"..side,x+side*w*.75,2,z-8-d/2,1,0)
  for _,dz in {-4,4} do install(arch.Walls.Wall_Panel_A_Half,m,"SidePanel_"..side.."_"..dz,x+side*sideX,2,z+dz,1,side*90) end
 end
 install(arch.Walls.Locked_Door,m,"SealedResearchAirlock",x,2,z-9.84,1,0)
 install(arch.Walls.Arbor_Ceiling_Panel,m,"Roof",x,2+h,z,1.25,0)
 sign(m,"FacilityIdentity",name:gsub("_"," "):upper(),CFrame.new(x,14.8,z-11.8),V(16,1.6,.2))
 install(props.Kiosks.StandaloneKiosk_A,m,"ExteriorTerminal",x+23,2,z-4,1.2,0)
 return m
end

local hub=root.SpawnHub
local m=model(root.HubFacilities,"ConcourseServices")
for _,name in {"SupplyKiosk","AlienIndex","Speed_Lab"} do archive(root.HubFacilities:FindFirstChild(name),"OldHub_"..name) end
-- Compact service bays use the same wall kit as the personal labs.
cabin(m,"SUPPLY_DEPOT",-48,-85)
cabin(m,"RESEARCH_INDEX",48,-85)
cabin(m,"MOVEMENT_LAB",-48,90)
for i,p in {{-64,-65},{64,-65},{-64,72}} do install(props["Crates and Boxes"].CargoCrate4x4,m,"ServiceCargo_"..i,p[1],2,p[2],1.1,i*15) end
-- Replace the tallest generic lamp posts with shorter station light fittings.
for _,a in hub:GetChildren() do
 if a:IsA("Model") and a.Name:match("^AreaLight") then
  for _,p in a:GetDescendants() do if p:IsA("BasePart") then p.Color=C(74,87,99) end end
 end
end
for _,data in {{"SUPPLY_DEPOT",-48,-85,.8,-90},{"RESEARCH_INDEX",48,-85,.8,90},{"MOVEMENT_LAB",-48,90,.65,0}} do
 local bay=m[data[1]];local anchor=V(data[2],2,data[3]);local old=bay:GetPivot();local offset=old.Position-anchor
 bay:ScaleTo(data[4]);bay:PivotTo(CFrame.new(anchor)*CFrame.Angles(0,math.rad(data[5]),0)*CFrame.new(offset*data[4])*old.Rotation)
 if data[1]~="MOVEMENT_LAB" then local terminal=bay:FindFirstChild("ExteriorTerminal");if terminal then
  local cf,size=terminal:GetBoundingBox();local target=CFrame.new(data[2]>0 and 25 or -25,2+size.Y/2,-83)*CFrame.Angles(0,math.rad(data[5]),0)
  terminal:PivotTo(target*cf:Inverse()*terminal:GetPivot())
 end end
end
for _,bridge in root.ProgressionRoute:GetChildren() do
 local deck=bridge.WalkingDeck
 for _,p in bridge:GetChildren() do if p.Name:match("^GuardRail") or p.Name:match("^RailPost") then archive(p,"Old"..bridge.Name.."_"..p.Name) end end
 local rails=model(bridge,"StationRailings")
 for _,side in {-1,1} do for i=1,3 do
  local z=deck.Position.Z-deck.Size.Z/2+(i-.5)*deck.Size.Z/3
  install(arch.Catwalk.FloorPanelA_Railing_Long,rails,"Rail_"..side.."_"..i,side*7.65,2,z,1,90)
 end end
end
for _,world in root.Worlds:GetChildren() do
 for _,p in world.Environment:GetChildren() do
  if p.Name=="ExitMarker" or p.Name=="TerminusMarker" then
   p.Size=V(8,4,1);p.Position=V(p.Position.X,4,p.Position.Z);p.Color=C(28,39,49)
   local label=p:FindFirstChildWhichIsA("SurfaceGui").Label;label.TextScaled=true
  end
 end
end
game.Lighting.MilkyWaySpace.StarCount=1000
return {hubServices=3,bridgesRefitted=6}

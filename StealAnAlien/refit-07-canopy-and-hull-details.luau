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


local hub=root.SpawnHub
assert(not hub:FindFirstChild("ConcourseCanopy"),"Canopy already exists")
local canopy=model(hub,"ConcourseCanopy")
for _,m in hub.StationArchitecture:GetChildren() do
 for _,p in m:GetDescendants() do
  if p:IsA("BasePart") then p.Color=C(144,158,166) end
  if p:IsA("SurfaceAppearance") then pcall(function()p.Color=C(185,200,208)end) end
 end
end
local zs={-33,5,43,83}
for i=1,#zs-1 do
 local front=zs[i]+5.933502/2;local back=zs[i+1]-5.933502/2
 local depth=back-front;local z=(front+back)/2
 box(canopy,"CeilingCrossmember_"..i,V(0,36.9,z),V(61.5,.8,1),C(59,74,87))
 for _,side in {-1,1} do
  box(canopy,"RoofRail_"..i.."_"..side,V(side*32,36.9,z),V(2.5,.8,depth),C(59,74,87))
  local lens=box(canopy,"RecessedLuminaire_"..i.."_"..side,V(side*18,36.25,z),V(2,.5,18),C(190,201,199),Enum.Material.SmoothPlastic)
  local light=Instance.new("SurfaceLight");light.Name="ConcourseCeilingLight";light.Face=Enum.NormalId.Bottom
  light.Color=C(233,237,224);light.Brightness=1;light.Range=60;light.Angle=100;light.Shadows=false;light.Parent=lens
 end
 local pane=box(canopy,"ObservationGlass_"..i,V(0,37.4,z),V(62,.2,depth),C(104,137,146),Enum.Material.Glass)
 pane.Transparency=.88;pane.Reflectance=.03
end
for _,m in hub:GetChildren() do
 if m:IsA("Model") and m.Name:match("^AreaLight") then
  local cf=m:GetBoundingBox();if cf.Position.Z>-50 then archive(m,"FormerStreetFixture_"..m.Name) end
 end
end
local parents={hub}
for _,m in root.Worlds:GetChildren() do table.insert(parents,m) end
local total=0
for index,parent in parents do
 local ship=parent.Spacecraft
 assert(not ship:FindFirstChild("EngineArmorCladding"),"Engine armor already exists")
 local cladding=model(ship,"EngineArmorCladding")
 local isHub=parent==hub
 local width,length,z=isHub and 150 or 160,isHub and 200 or 180,isHub and 0 or parent.PrimaryPart.Position.Z
 local offsets=parent.Name=="World_04_CryoMoon" and {-.36,.36} or {-.36,-.12,.12,.36}
 local panel=arch.Walls.Wall_Panel_A_Dark
 local _,s=panel:GetBoundingBox();local thickness=s.Z*.75
 for _,side in {-1,1} do
  for i,offset in offsets do
   install(panel,cladding,"PressurePlate_"..side.."_"..i,side*(width/2+33+thickness/2),-26,z+length*offset,.75,side*90)
   total+=1
  end
 end
 task.wait()
end
game:GetService("ChangeHistoryService"):SetWaypoint("Glazed concourse and engine armor detail")
return {canopySections=3,ceilingLights=6,engineArmorPanels=total}

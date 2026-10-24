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

local floorSource=arch.Catwalk.FloorPanelA_Dark
local function floorRoute(parent,old,width,length,z,name)
 archive(old,name.."_OriginalFloor")
 local m=model(parent,"EngineeredWalkingDeck")
 local _,tileSize=floorSource:GetBoundingBox()
 local half=(width-16)/2
 local color=old.Color;local material=old.Material
 box(m,"PortDeck",V(-(width+16)/4,0,z),V(half,4,length),color,material)
 box(m,"StarboardDeck",V((width+16)/4,0,z),V(half,4,length),color,material)
 local thickness=4-tileSize.Y
 local base=box(m,"AisleFoundation",V(0,-tileSize.Y/2,z),V(16,thickness,length),C(43,51,61))
 local n=math.floor(length/8)
 for i=1,n do install(floorSource,m,"DeckPanel_"..i,0,2-tileSize.Y,z-length/2+4+(i-1)*8,1,0) end
 local remainder=length-n*8
 if remainder>.01 then box(m,"DockEdgeCap",V(0,2-tileSize.Y/2,z+length/2-remainder/2),V(16,tileSize.Y,remainder),C(61,72,82)) end
 return m,base
end
local hub=root.SpawnHub
local deck,base=floorRoute(hub.HubStructure,hub.HubStructure.HubPlatform,150,200,0,"Hub")
hub.HubStructure.PrimaryPart=base
for i,name in {"LunarOutpost","RustMoon","Xenoforest","CryoMoon","BasaltRift","VoidArchive"} do
 local world=root.Worlds[string.format("World_%02d_%s",i,name)]
 local z=245+(i-1)*230
 local m,p=floorRoute(world,world.WorldPlatform,160,180,z,name);world.PrimaryPart=p
 task.wait()
end
local decor=model(root.Landmarks,"OrbitalBackdrop")
local _,moonSize=sources.LunarPlanetSource:GetBoundingBox()
install(sources.LunarPlanetSource,decor,"DistantCrateredMoon",-400,80,900,500/moonSize.Y,130)
local a=install(sources.AsteroidSource,decor,"OrbitalRock_01",210,-45,310,7,22)
local b=install(sources.AsteroidSource,decor,"OrbitalRock_02",-190,-65,730,10,70)
local c=install(sources.AsteroidSource,decor,"OrbitalRock_03",250,15,1100,5,120)
local site=root.CollectionProps.LunarSpecimens.AlienNest_Lunar_01
for _,m in site:GetChildren() do if m:IsA("Model") and m.Name:match("^StaticAlien_") then archive(m,"OldLunarAlien") end end
install(sources.ClassicAlienSource,site,"LunarSpecimenFigure",-30,3.4,215,.8,0)
return {walkingDecks=7,moonHeight=500,sourceFloorHeight=select(2,floorSource:GetBoundingBox()).Y}

local root=workspace.SpaceWorld
local V=Vector3.new
local C=Color3.fromRGB
local palette={steel=C(111,119,124),dark=C(44,51,60),light=C(172,177,176),teal=C(96,143,144),copper=C(140,111,85),ink=C(24,31,39)}
local function model(parent,name)
 local m=Instance.new("Model"); m.Name=name; m.Parent=parent; return m
end
local function part(parent,name,size,cf,material,color,class)
 local p=Instance.new(class or "Part"); p.Name=name; p.Size=size; p.CFrame=cf
 p.Material=material or Enum.Material.Metal; p.Color=color or palette.steel
 p.Anchored=true; p.CanCollide=true; p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent; return p
end
local function box(parent,name,x,y,z,sx,sy,sz,material,color)
 return part(parent,name,V(sx,sy,sz),CFrame.new(x,y,z),material,color)
end
local function cylinder(parent,name,x,y,z,diameter,height,material,color)
 local p=part(parent,name,V(height,diameter,diameter),CFrame.new(x,y,z)*CFrame.Angles(0,0,math.pi/2),material,color)
 p.Shape=Enum.PartType.Cylinder; return p
end
local function ball(parent,name,x,y,z,sx,sy,sz,material,color)
 local p=box(parent,name,x,y,z,sx,sy,sz,material,color); p.Shape=Enum.PartType.Ball; return p
end
local function signOn(p,text,size,color,face)
 local gui=Instance.new("SurfaceGui"); gui.Name="Identification"; gui.Face=face or Enum.NormalId.Front
 gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud; gui.PixelsPerStud=40; gui.LightInfluence=0; gui.AlwaysOnTop=false; gui.Parent=p
 local label=Instance.new("TextLabel"); label.Name="Label"; label.Size=UDim2.new(1,-12,1,-8); label.Position=UDim2.fromOffset(6,4)
 label.BackgroundTransparency=1; label.Text=text; label.TextColor3=color or C(220,225,224); label.Font=Enum.Font.GothamMedium
 label.TextSize=size or 30; label.TextScaled=true; label.TextWrapped=true; label.Parent=gui
 return gui
end
local function verify(container)
 local count=0
 for _,p in container:GetDescendants() do
  assert(not p:IsA("LuaSourceContainer"),"Runtime script unexpectedly added")
  if p:IsA("BasePart") then assert(p.Anchored and p.CanCollide,"Physics mismatch: "..p.Name); count+=1 end
 end
 return count
end

local function lamp(parent,x,z,height)
 height=height or 18
 local m=model(parent,"AreaLight_"..x.."_"..z)
 box(m,"Foot",x,2.25,z,1.4,0.5,1.4,Enum.Material.Metal,palette.dark)
 box(m,"Mast",x,(2.5+height-0.5)/2,z,0.5,height-3,0.5,Enum.Material.Metal,palette.steel)
 box(m,"Fixture",x+1.5,height-0.25,z,4,0.5,1.4,Enum.Material.Metal,palette.dark)
 local lens=box(m,"Lens",x+2,height-0.6,z,2.5,0.2,1.1,Enum.Material.SmoothPlastic,C(195,209,205))
 local light=Instance.new("SurfaceLight"); light.Name="PracticalAreaLight"; light.Face=Enum.NormalId.Bottom
 light.Color=C(221,232,227); light.Brightness=1.5; light.Range=55; light.Angle=140; light.Shadows=false; light.Parent=lens
 return m
end
local function module(parent,name,x,z,w,d,h,accent)
 local m=model(parent,name)
 box(m,"ModuleBody",x,2+h/2,z,w,h,d,Enum.Material.Metal,C(124,133,137))
 box(m,"OverhangingRoof",x,2+h+0.5,z,w+2,1,d+2,Enum.Material.Metal,palette.dark)
 local front=z-d/2-0.12
 local doorHeight=math.min(6.2,h-1.6)
 box(m,"SealedDoor",x-0.23*w,2+doorHeight/2,front,3.2,doorHeight,0.24,Enum.Material.Metal,accent)
 box(m,"ObservationWindow",x+0.17*w,2+h*0.6,front,w*0.33,2.2,0.24,Enum.Material.Glass,C(60,89,101))
 local nameplate=box(m,"ModuleSign",x,2+h-0.8,z-d/2-0.18,w*0.7,1.2,0.36,Enum.Material.Metal,palette.ink)
 signOn(nameplate,string.upper(name:gsub("_"," ")),24,C(208,216,214))
 -- Roof-mounted ventilation boxes are kept separate from the sign and each other.
 box(m,"VentA",x-w*0.23,2+h+2,z+1,3,2,d*0.4,Enum.Material.Metal,palette.steel)
 box(m,"VentB",x+w*0.23,2+h+1.6,z+1,3,1.2,d*0.4,Enum.Material.Metal,palette.steel)
 return m
end
local function rock(parent,name,x,z,sx,h,sz,color,mat,angle)
 local m=model(parent,name)
 local cf=CFrame.new(x,2+h/2,z)*CFrame.Angles(0,math.rad(angle or 0),0)
 local p=part(m,"RockCore",V(sx,h,sz),cf,mat or Enum.Material.Rock,color)
 local facet=part(m,"SlopingFace",V(sx,h,sz*0.4),cf*CFrame.new(0,0,-sz*0.7),mat or Enum.Material.Rock,color:Lerp(palette.light,0.08),"WedgePart")
 return m
end
local function alien(parent,x,y,z,color,kind)
 local m=model(parent,"StaticAlien_"..kind)
 for _,side in {-1,1} do
  box(m,"Foot_"..side,x+side*0.48,y+0.125,z,0.65,0.25,1.1,Enum.Material.SmoothPlastic,color)
  box(m,"Leg_"..side,x+side*0.48,y+0.75,z,0.4,1,0.4,Enum.Material.SmoothPlastic,color)
  box(m,"Arm_"..side,x+side*0.95,y+2.1,z,0.4,1.3,0.45,Enum.Material.SmoothPlastic,color)
 end
 box(m,"Torso",x,y+2.125,z,1.5,1.75,1.2,Enum.Material.SmoothPlastic,color)
 box(m,"Head",x,y+4.1,z,2.6,2.2,2.2,Enum.Material.SmoothPlastic,color:Lerp(palette.light,0.12))
 for _,side in {-1,1} do
  ball(m,"Eye_"..side,x+side*0.63,y+4.25,z-1.35,0.5,0.65,0.5,Enum.Material.SmoothPlastic,C(20,27,33))
  box(m,"Antenna_"..side,x+side*0.8,y+5.55,z,0.18,0.7,0.18,Enum.Material.Metal,palette.steel)
  ball(m,"SensorTip_"..side,x+side*0.8,y+6.05,z,0.3,0.3,0.3,Enum.Material.SmoothPlastic,color)
 end
 m:SetAttribute("StaticPlaceholder",true)
 return m
end
local function specimen(parent,name,x,z,accent,kind)
 local site=model(parent,name)
 box(site,"SiteFoundation",x,2.3,z,12,0.6,10,Enum.Material.Concrete,C(121,128,128))
 box(site,"ContainmentPedestal",x,3,z,6,0.8,6,Enum.Material.Metal,palette.dark)
 alien(site,x,3.4,z,accent,kind)
 for _,side in {-1,1} do
  box(site,"BackSupport_"..side,x+side*4.4,5,z+4.3,0.5,4.8,0.5,Enum.Material.Metal,palette.steel)
 end
 local label=box(site,"SpecimenSign",x,8.05,z+4.3,10,1.3,0.6,Enum.Material.Metal,palette.ink)
 signOn(label,kind.." // SPECIMEN",20,C(209,219,216))
 local marker=box(site,"InstrumentIndicator",x+2.5,3.5,z-2.5,0.3,0.2,0.3,Enum.Material.Neon,accent)
 local light=Instance.new("PointLight"); light.Color=C(220,231,224); light.Brightness=0.7; light.Range=17; light.Parent=label
 site:SetAttribute("StaticPlaceholder",true)
 return site
end

local world=root.Worlds.World_06_VoidArchive; local z=1395
assert(not world:FindFirstChild("Environment"),"Void environment already built")
world.WorldPlatform.Material=Enum.Material.Slate; world.WorldPlatform.Color=C(92,96,108)
local env=model(world,"Environment")
local landmark=model(root.Landmarks,"Void_ArchiveThreshold")
for _,side in {-1,1} do box(landmark,"PaleArchiveTower_"..side,side*12,18,z+74,3,32,3,Enum.Material.Metal,C(168,173,171)) end
local lintel=box(landmark,"ArchiveLintel",0,35.5,z+74,28,3,3,Enum.Material.Metal,palette.dark)
signOn(lintel,"VOID ARCHIVE",32,C(202,206,215))
box(landmark,"EmblemSuspension",0,32,z+74,0.5,4,0.5,Enum.Material.Metal,palette.steel)
local emblem=part(landmark,"ArchiveSeal",V(8,8,3),CFrame.new(0,30-8/math.sqrt(2),z+74)*CFrame.Angles(0,0,math.pi/4),Enum.Material.Metal,C(116,111,132))
signOn(emblem,"VI",40,C(194,198,206))
local vault=module(env,"Memory_Vault",-50,z+15,24,20,10,C(116,130,140))
vault.ModuleBody.Color=C(162,168,167)
local monoliths=model(env,"GeometricArchiveStones")
for i,data in {{35,12,-52},{48,23,-48},{62,17,-54}} do
 local x,h,dz=data[1],data[2],data[3]
 local cf=CFrame.new(x,2+h/2,z+dz)*CFrame.Angles(0,math.rad(i*9),0)
 part(monoliths,"Monolith_"..i,V(7,h,7),cf,Enum.Material.Slate,C(89+i*8,94+i*7,106+i*8))
 part(monoliths,"PaleCap_"..i,V(8,1,8),cf*CFrame.new(0,h/2+0.5,0),Enum.Material.Metal,C(169,175,173))
end
rock(env,"ArchiveFragment",-62,z-58,7,18,6,C(110,112,123),Enum.Material.Slate,16)
rock(env,"BrokenArchivePiece",-47,z-65,6,9,8,C(126,129,135),Enum.Material.Concrete,-12)
box(env,"DataSpine",65,8,z+24,4,12,3,Enum.Material.Metal,C(135,145,145))
local sites=model(root.CollectionProps,"VoidSpecimens")
specimen(sites,"AlienNest_Void_01",-30,z-30,C(137,131,155),"ARCHIVE WITNESS")
specimen(sites,"AlienNest_Void_02",30,z+2,C(127,147,151),"ECHO KEEPER")
specimen(sites,"AlienNest_Void_03",-25,z+53,C(160,159,169),"VOID SCRIBE")
signOn(world.EntryGate.Header,"06  //  VOID ARCHIVE",30,C(211,209,224))
lamp(env,-19,z-38,18); lamp(env,18,z+42,22)
local endplate=box(env,"TerminusMarker",20,5,z+82,8,6,1,Enum.Material.Metal,palette.dark); signOn(endplate,"ARCHIVE\nTERMINUS",24)
world:SetAttribute("IdentityComplete",true)
return game:GetService("HttpService"):JSONEncode({world=world.Name,parts=verify(world)+verify(landmark)+verify(sites),specimens=#sites:GetChildren(),identityComplete=true})

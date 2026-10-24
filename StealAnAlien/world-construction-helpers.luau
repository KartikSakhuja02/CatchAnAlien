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

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

local FIRST_PLOT=1; local LAST_PLOT=8
for index=FIRST_PLOT,LAST_PLOT do
 local plot=root.PlayerBases[string.format("Plot_%02d",index)]
 assert(not plot:FindFirstChild("PlotInterior"),"Plot already finished")
 local base=plot.PlotPlatform.Position
 local cf=CFrame.lookAt(V(base.X,3,base.Z),V(0,3,base.Z))
 local interior=model(plot,"PlotInterior")
 local accent=C(110+index%3*5,139+index%2*4,137+index%3*3)
 local function localPart(parent,name,x,y,z,sx,sy,sz,mat,color)
  return part(parent,name,V(sx,sy,sz),cf*CFrame.new(x,y,z),mat,color)
 end
 for _,side in {-1,1} do
  localPart(interior,"SideBoundary_"..side,side*14.75,0.2,0,0.25,0.4,32,Enum.Material.Metal,C(83,94,99))
  localPart(interior,"EntryBoundary_"..side,side*9.75,0.1,-16.75,9.5,0.2,0.25,Enum.Material.Metal,accent)
  localPart(interior,"NameplateFoot_"..side,side*11,0.2,-14,1,0.4,1,Enum.Material.Metal,palette.dark)
  localPart(interior,"NameplatePost_"..side,side*11,4.2,-14,0.35,7.6,0.35,Enum.Material.Metal,palette.steel)
 end
 localPart(interior,"BackBoundary",0,0.2,16.75,29.5,0.4,0.25,Enum.Material.Metal,C(83,94,99))
 local nameplate=localPart(interior,"PlotNameplate",0,8.75,-14,24,1.5,0.5,Enum.Material.Metal,palette.dark)
 signOn(nameplate,string.format("PLOT %02d  //  PERSONAL OUTPOST",index),24,C(219,226,222))
 local deposit=localPart(interior,"ReturnPad",0,0.15,-9,5,0.3,4,Enum.Material.Metal,accent)
 deposit:SetAttribute("StaticPlaceholder",true)
 signOn(deposit,"RETURN",24,C(228,231,225),Enum.NormalId.Top)
 local bays=model(interior,"HabitatBays")
 for bayIndex=1,4 do
  local side=bayIndex%2==1 and -1 or 1
  local x=side*8; local z=bayIndex<=2 and -2 or 9
  local bay=model(bays,string.format("Habitat_%02d",bayIndex))
  localPart(bay,"HabitatFloor",x,0.15,z,8,0.3,7,Enum.Material.Metal,C(104,113,118))
  localPart(bay,"DisplayPlinth",x,0.55,z,5,0.5,4,Enum.Material.Concrete,C(153,160,158))
  for _,postSide in {-1,1} do localPart(bay,"FramePost_"..postSide,x+postSide*3.5,1.8,z+2.8,0.4,3,0.4,Enum.Material.Metal,palette.steel) end
  local header=localPart(bay,"HabitatLabel",x,3.7,z+2.8,8,0.8,0.3,Enum.Material.Metal,palette.dark)
  signOn(header,string.format("HABITAT %02d",bayIndex),20,C(208,220,215))
  local glass=localPart(bay,"BackObservationGlass",x,1.3,z+3.3,6,2,0.2,Enum.Material.Glass,C(129,151,155)); glass.Transparency=0.55
  bay:SetAttribute("StaticPlaceholder",true)
 end
 local lab=model(interior,"PersonalLaboratory")
 localPart(lab,"StorageModule",0,3,13,6,6,6,Enum.Material.Metal,C(128,138,142))
 localPart(lab,"Roof",0,6.3,13,7,0.6,7,Enum.Material.Metal,palette.dark)
 local door=localPart(lab,"SealedLabDoor",0,2,9.9,2.6,4,0.2,Enum.Material.Metal,accent)
 signOn(door,"LAB",24,C(224,230,225))
 localPart(lab,"SmallWindow",2,4.8,9.9,1,1.2,0.2,Enum.Material.Glass,C(72,99,109))
 localPart(lab,"RoofVent",1.5,7,14,1.5,0.8,2,Enum.Material.Metal,palette.steel)
 local lamp=Instance.new("PointLight"); lamp.Color=C(223,232,226); lamp.Brightness=0.35; lamp.Range=22; lamp.Parent=nameplate
 plot:SetAttribute("HabitatCount",4); plot:SetAttribute("LayoutComplete",true)
 assert(#bays:GetChildren()==4,"Habitat count mismatch")
 verify(plot)
 task.wait()
end
return "Personal plot interiors verified: plots "..FIRST_PLOT.." through "..LAST_PLOT..", four habitat bays each, inward entrances, return pads and laboratory modules."

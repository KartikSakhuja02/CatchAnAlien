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

local names={"LunarOutpost","RustMoon","Xenoforest","CryoMoon","BasaltRift","VoidArchive"}
for i,name in names do
 local world=root.Worlds[string.format("World_%02d_%s",i,name)]
 assert(#world:GetChildren()==0,"World already contains geometry")
 local z=245+(i-1)*230
 local p=box(world,"WorldPlatform",0,0,z,160,4,180,Enum.Material.Concrete,C(128,131,133)); world.PrimaryPart=p
 local underside=model(world,"DesignedUnderside")
 box(underside,"LowerHull",0,-4.5,z,140,5,160,Enum.Material.Metal,palette.dark)
 box(underside,"Keel",0,-9,z,94,4,120,Enum.Material.Metal,C(38,44,52))
 local gate=model(world,"EntryGate")
 box(gate,"LeftPylon",-12,6.5,z-77,2,9,2,Enum.Material.Metal,palette.steel)
 box(gate,"RightPylon",12,6.5,z-77,2,9,2,Enum.Material.Metal,palette.steel)
 box(gate,"Header",0,12,z-77,26,2,2,Enum.Material.Metal,palette.dark)
 task.wait()
end
assert(#root.ProgressionRoute:GetChildren()==0,"Route already exists")
for i=1,6 do
 local startZ=i==1 and 100 or (245+(i-2)*230+90)
 local endZ=245+(i-1)*230-90
 local length=endZ-startZ; local z=(startZ+endZ)/2
 local bridge=model(root.ProgressionRoute,string.format("Bridge_%02d",i))
 bridge:SetAttribute("StartZ",startZ); bridge:SetAttribute("EndZ",endZ); bridge:SetAttribute("ClearWidth",14.5)
 box(bridge,"WalkingDeck",0,1,z,16,2,length,Enum.Material.Metal,C(104,113,120))
 box(bridge,"StructuralSpine",0,-1,z,10,2,length,Enum.Material.Metal,palette.dark)
 for _,side in {-1,1} do
  box(bridge,"GuardRail_"..side,side*7.5,4.7,z,0.5,0.6,length,Enum.Material.Metal,palette.light)
  for post=1,4 do
   local postZ=startZ+2+(post-1)*(length-4)/3
   box(bridge,string.format("RailPost_%d_%d",side,post),side*7.5,3.2,postZ,0.5,2.4,0.5,Enum.Material.Metal,palette.steel)
  end
 end
 task.wait()
end
for _,world in root.Worlds:GetChildren() do assert(world.WorldPlatform.Position.Y+world.WorldPlatform.Size.Y/2==2,"World floor height mismatch") end
for i=1,6 do
 local bridge=root.ProgressionRoute[string.format("Bridge_%02d",i)]
 local deck=bridge.WalkingDeck
 assert(deck.Position.Y+deck.Size.Y/2==2,"Bridge height mismatch")
 assert(math.abs(deck.Position.Z-deck.Size.Z/2-bridge:GetAttribute("StartZ"))<0.001,"Bridge start mismatch")
 assert(math.abs(deck.Position.Z+deck.Size.Z/2-bridge:GetAttribute("EndZ"))<0.001,"Bridge end mismatch")
end
game:GetService("ChangeHistoryService"):SetWaypoint("Steal an Alien Greybox Complete")
return game:GetService("HttpService"):JSONEncode({phase="C",verified=true,worlds=6,plots=8,bridges=6,walkingTopY=2,worldParts=verify(root.Worlds),routeParts=verify(root.ProgressionRoute)})

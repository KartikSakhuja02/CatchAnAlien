-- Static spacecraft conversion. Run separately with INDEX=0 (hub) or 1..6.
local INDEX=0
local root=workspace.SpaceWorld
local V,C=Vector3.new,Color3.fromRGB
local names={"LunarOutpost","RustMoon","Xenoforest","CryoMoon","BasaltRift","VoidArchive"}
local shipNames={"SELENE // RESEARCH","FERRUM // MINING","VERDANT // BIO-ARK","BOREAL // CRYOGENICS","CINDER // REFINERY","VESPER // ARCHIVE"}
local accents={C(105,140,142),C(135,106,82),C(117,133,100),C(137,164,175),C(135,113,91),C(130,126,150)}
local parent=INDEX==0 and root.SpawnHub or root.Worlds[string.format("World_%02d_%s",INDEX,names[INDEX])]
local width,length,z=INDEX==0 and 150 or 160,INDEX==0 and 200 or 180,INDEX==0 and 0 or 245+(INDEX-1)*230
local accent=INDEX==0 and C(103,141,146) or accents[INDEX]
local metal=C(79,91,101);local dark=C(39,48,60);local pale=C(145,155,160)
assert(not parent:FindFirstChild("Spacecraft"),"Spacecraft already exists")
local backup=game.ServerStorage:FindFirstChild("SpacecraftConversionBackup")
if not backup then backup=Instance.new("Folder");backup.Name="SpacecraftConversionBackup";backup.Parent=game.ServerStorage end
local old=Instance.new("Folder");old.Name=INDEX==0 and "Hub" or names[INDEX];old.Parent=backup
if INDEX==0 then
 for _,name in {"UndersideHull","CentralKeel"} do local p=parent.HubStructure:FindFirstChild(name);if p then p.Parent=old end end
else
 local p=parent:FindFirstChild("DesignedUnderside");if p then p.Parent=old end
end
local ship=Instance.new("Model");ship.Name="Spacecraft";ship:SetAttribute("VesselType",INDEX==0 and "Carrier Hub" or shipNames[INDEX])
local function group(name)
 local m=Instance.new("Model");m.Name=name;m.Parent=ship;return m
end
local function p(parent,name,x,y,d,sx,sy,sz,color,mat,class,rotation)
 local a=Instance.new(class or "Part");a.Name=name;a.Size=V(sx,sy,sz)
 a.CFrame=CFrame.new(x,y,z+d)*(rotation or CFrame.identity)
 a.Color=color or metal;a.Material=mat or Enum.Material.Metal
 a.Anchored=true;a.CanCollide=true;a.TopSurface=Enum.SurfaceType.Smooth;a.BottomSurface=Enum.SurfaceType.Smooth
 a.Parent=parent;return a
end
local function label(a,text,face)
 local gui=Instance.new("SurfaceGui");gui.Name="HullMarking";gui.Face=face or Enum.NormalId.Front;gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;gui.PixelsPerStud=20;gui.LightInfluence=0.25;gui.Parent=a
 local t=Instance.new("TextLabel");t.Name="Text";t.BackgroundTransparency=1;t.Size=UDim2.fromScale(.9,.8);t.Position=UDim2.fromScale(.05,.1)
 t.Font=Enum.Font.GothamMedium;t.TextColor3=C(207,216,215);t.Text=text;t.TextSize=30;t.TextScaled=true;t.Parent=gui
end
local hull=group("ArmoredHull")
p(hull,"PressureHull",0,-12,0,width-40,20,length-40)
for _,side in {-1,1} do
 p(hull,"BeveledFlank_"..side,side*(width/2-10),-12,0,length-40,20,20,metal,Enum.Material.Metal,"WedgePart",CFrame.Angles(0,-side*math.pi/2,0)*CFrame.Angles(0,0,math.pi))
 p(hull,"TaperedEnd_"..side,0,-12,side*(length/2-10),width,20,20,metal,Enum.Material.Metal,"WedgePart",CFrame.Angles(0,side==1 and math.pi or 0,0)*CFrame.Angles(0,0,math.pi))
 -- Split prow preserves the docking corridor through the ship's centre.
 p(hull,"SplitProw_"..side,side*43,-5,length/2+9,52,14,18,pale,Enum.Material.Metal,"WedgePart",CFrame.Angles(0,math.pi,math.pi))
 p(hull,"ProwAccent_"..side,side*43,2.15,length/2+7,4,.3,12,accent)
end
p(hull,"ReactorKeel",0,-27,0,62,10,length*.28,dark)
for _,dz in {-length*.22,length*.22} do p(hull,"EngineCrossmember_"..dz,0,-26,dz,width+26,8,14,dark) end
local sides=group("DeckBulwarks")
for _,side in {-1,1} do
 p(sides,"SideWall_"..side,side*(width/2-.6),3.2,0,1.2,2.4,length-2,dark)
 p(sides,"SideCap_"..side,side*(width/2-.6),4.5,0,1.2,.2,length-2,pale)
 for _,endSide in {-1,1} do
  p(sides,"DockingShoulder_"..side.."_"..endSide,side*(width/4+4.4),3.2,endSide*(length/2-.6),width/2-11.2,2.4,1.2,dark)
 end
 for i=1,5 do
  local dz=-length*.38+(i-1)*length*.19
  -- Vertical armor ribs sit entirely outside the sloping hull.
  p(hull,"ArmorRib_"..side.."_"..i,side*(width/2+1),-6,dz,2,8,2,pale)
 end
end
local engines=group("Propulsion")
for _,side in {-1,1} do
 local x=side*(width/2+23);local bodyLength=length*.9
 p(engines,"Nacelle_"..side,x,-20,-8,20,20,bodyLength,dark)
 p(engines,"NacelleTop_"..side,x,-9.75,-8,20,.5,bodyLength,accent)
 p(engines,"NacelleNose_"..side,x,-20,-8+bodyLength/2+7,20,20,14,metal,Enum.Material.Metal,"WedgePart",CFrame.Angles(0,math.pi,math.pi))
 local e=p(engines,"EngineBell_"..side,x,-20,-8-bodyLength/2-4,8,20,20,pale,Enum.Material.Metal,nil,CFrame.Angles(0,math.pi/2,0));e.Shape=Enum.PartType.Cylinder
 local recess=p(engines,"ExhaustRecess_"..side,x,-20,-8-bodyLength/2-8.2,.4,16,16,C(17,23,29),Enum.Material.Metal,nil,CFrame.Angles(0,math.pi/2,0));recess.Shape=Enum.PartType.Cylinder
 local core=p(engines,"ExhaustCore_"..side,x,-20,-8-bodyLength/2-8.5,.2,9,9,accent,Enum.Material.SmoothPlastic,nil,CFrame.Angles(0,math.pi/2,0));core.Shape=Enum.PartType.Cylinder
 for _,dz in {-length*.3,0,length*.3} do
  p(engines,"NacelleBand_"..side.."_"..dz,side*(width/2+33.4),-20,dz,.8,18,3,pale)
 end
end
local tower=group("CommandIsland")
local tx=width/2+23;local tz=-length*.26;local mastHeight=INDEX==0 and 22 or 15
p(tower,"IslandFooting",tx,-8.25,tz,24,2.5,32,metal)
p(tower,"LiftShaft",tx,-7+mastHeight/2,tz,12,mastHeight,18,metal)
local cabinY=-7+mastHeight+4
p(tower,"BridgeCabin",tx,cabinY,tz,24,8,28,pale)
p(tower,"BridgeRoof",tx,cabinY+4.5,tz,26,1,30,dark)
p(tower,"ForwardWindows",tx,cabinY+1,tz+14.15,20,3,.3,C(52,84,98),Enum.Material.Glass)
p(tower,"InboardWindows",tx-12.15,cabinY+1,tz,.3,3,20,C(52,84,98),Enum.Material.Glass)
p(tower,"SignalMast",tx,cabinY+10,tz,1,10,1,pale)
p(tower,"SensorBar",tx,cabinY+15.3,tz,12,.6,1,accent)
local plate=p(tower,"VesselName",tx,cabinY-1.5,tz-14.2,22,2.5,.4,dark)
label(plate,INDEX==0 and "ARK // COLONY CARRIER" or shipNames[INDEX])
-- Docking collars sit on the flat deck, clear of the main route.
local docks=group("DockingCollars")
for _,endSide in {-1,1} do
 for _,side in {-1,1} do p(docks,"Post_"..endSide.."_"..side,side*9.5,6,endSide*(length/2-3),1,8,2,pale) end
 p(docks,"Header_"..endSide,0,10.5,endSide*(length/2-3),20,1,2,accent)
end
local details=group("VesselEquipment")
if INDEX==0 then
 p(details,"AftArrivalDeck",0,0,-length/2-11,60,4,22,metal)
 p(details,"AftHull",0,-9,-length/2-11,60,14,22,metal,Enum.Material.Metal,"WedgePart",CFrame.Angles(0,0,math.pi))
 local wall=p(details,"ArrivalBulkhead",0,8,-length/2-21,60,12,2,metal)
 local panel=p(details,"ArrivalIdentity",0,10,-length/2-19.8,32,4,.4,dark)
 label(panel,"ARK / ARRIVAL DECK",Enum.NormalId.Back)
 for _,side in {-1,1} do p(details,"AftCargoLocker_"..side,side*24,5,-length/2-10,8,6,12,accent) end
elseif INDEX==1 then
 -- A compact externally mounted scanner gives the research ship its silhouette.
 p(details,"ScannerPlinth",-width/2-23,-7,28,14,5,14,metal)
 p(details,"ScannerStem",-width/2-23,1.5,28,2,12,2,pale)
 local disc=p(details,"ScannerDish",-width/2-23,8.5,28,2,20,20,accent,Enum.Material.Metal,nil,CFrame.Angles(0,0,math.pi/2));disc.Shape=Enum.PartType.Cylinder
elseif INDEX==2 then
 for _,side in {-1,1} do for i=1,2 do
  p(details,"ExternalOreContainer_"..side.."_"..i,side*(width/2+23),-4.5,5+(i-1)*36,16,10,24,accent,Enum.Material.CorrodedMetal)
 end end
elseif INDEX==3 then
 for _,dz in {-48,45} do
  for _,side in {-1,1} do p(details,"BioFrameUpright_"..side.."_"..dz,side*(width/2-3),23,dz,3,42,3,pale) end
  p(details,"BioFrameSpan_"..dz,0,45.5,dz,width-3,3,3,accent)
 end
elseif INDEX==4 then
 for _,side in {-1,1} do for _,dz in {-25,25} do
  p(details,"RadiatorRoot_"..side.."_"..dz,side*(width/2+34.5),-20,dz,3,4,22,dark)
  p(details,"RadiatorPanel_"..side.."_"..dz,side*(width/2+48),-20,dz,24,.8,22,accent,Enum.Material.DiamondPlate)
  for i=1,5 do p(details,"CoolingFin_"..side.."_"..dz.."_"..i,side*(width/2+48),-19.4,dz-9+(i-1)*4.5,24,.4,.6,pale) end
 end end
elseif INDEX==5 then
 for _,side in {-1,1} do
  p(details,"ThermalStackBase_"..side,side*(width/2+23),-5.5,28,14,8,20,accent)
  p(details,"ThermalStack_"..side,side*(width/2+23),9.5,28,8,22,12,dark)
  p(details,"ThermalStackCap_"..side,side*(width/2+23),21,28,12,1,16,pale)
 end
else
 for _,side in {-1,1} do
  p(details,"ArchiveBlade_"..side,side*(width/2+23),5.5,28,12,30,26,accent,Enum.Material.Metal,"WedgePart")
 end
end
ship.Parent=parent
task.wait()
local count=0
for _,a in ship:GetDescendants() do if a:IsA("BasePart") then assert(a.Anchored and a.CanCollide);count+=1 end end
local params=OverlapParams.new();params.FilterType=Enum.RaycastFilterType.Include;params.FilterDescendantsInstances={root};params.MaxParts=0
local overlaps,seen={},{}
for _,a in ship:GetDescendants() do if a:IsA("BasePart") then
 for _,b in workspace:GetPartsInPart(a,params) do
  local x,y=a:GetFullName(),b:GetFullName();if x>y then x,y=y,x end;local key=x.." <> "..y
  if not seen[key] then seen[key]=true;table.insert(overlaps,key) end
 end
end end
game:GetService("ChangeHistoryService"):SetWaypoint("Spacecraft Conversion "..INDEX)
return game.HttpService:JSONEncode({index=INDEX,parts=count,overlaps=overlaps})

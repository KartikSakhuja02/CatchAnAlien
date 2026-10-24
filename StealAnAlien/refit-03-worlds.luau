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

local INDEX=1
local worldNames={"LunarOutpost","RustMoon","Xenoforest","CryoMoon","BasaltRift","VoidArchive"}
local kinds={"Lunar","Rust","Xeno","Cryo","Basalt","Void"}
local world=root.Worlds[string.format("World_%02d_%s",INDEX,worldNames[INDEX])]
local env=world.Environment;local z=245+(INDEX-1)*230
assert(not world:FindFirstChild("RefinedEnvironment"),"World refit already applied")
local m=model(world,"RefinedEnvironment")
-- Replace closed blockout modules with detailed static architecture.
local cabins={}
for _,a in env:GetChildren() do
 if a:IsA("Model") and a:FindFirstChild("ModuleBody") then
  local p=a.ModuleBody.Position;table.insert(cabins,{name=a.Name,x=p.X,z=p.Z});archive(a,"Old_"..worldNames[INDEX].."_"..a.Name)
 end
end
for _,v in cabins do cabin(m,v.name,v.x,v.z) end
-- Natural mesh rocks replace rectangular rock cores.
for _,a in env:GetChildren() do
 if a:IsA("Model") and a:FindFirstChild("RockCore") then
  local p=a.RockCore;local height=p.Size.Y;local pos=p.Position;local name=a.Name
  archive(a,"Old_"..worldNames[INDEX].."_"..name)
  local rock=install(sources.AsteroidSource,m,name,pos.X,2,pos.Z,math.max(1,height/5),INDEX*19)
  for _,p in rock:GetDescendants() do if p:IsA("BasePart") then p.Color=INDEX==2 and C(112,88,71) or INDEX==4 and C(149,163,169) or C(100,104,108);p.Material=INDEX==5 and Enum.Material.Basalt or Enum.Material.Rock end end
 end
end
local sites=root.CollectionProps[kinds[INDEX].."Specimens"]
for _,site in sites:GetChildren() do
 local center=site.SiteFoundation.Position
 for _,a in site:GetChildren() do
  if a:IsA("Model") and (a.Name:match("^StaticAlien_") or a.Name=="LunarSpecimenFigure") then archive(a,"OldSpecimen_"..site.Name) end
 end
 local source=INDEX==3 and sources.AlienCreatureSource or sources.RobloxAlienSource
 local cf,size
 if source:IsA("Model") then cf,size=source:GetBoundingBox() end
 local scale=INDEX==3 and math.min(6/size.X,5/size.Y) or .8+(tonumber(site.Name:sub(-2))%3)*.04
 local figure=install(source,site,"SpecimenFigure",center.X,3.4,center.Z,scale,0)
 local tint=({C(140,155,150),C(151,127,105),C(120,144,115),C(160,182,188),C(127,119,112),C(146,140,163)})[INDEX]
 for _,p in figure:GetDescendants() do if p:IsA("BasePart") and p.Transparency<1 then p.Color=tint;p.Material=Enum.Material.SmoothPlastic end end
 local label=site.SpecimenSign
 label.Size=V(6,.9,.6);label.Position=V(center.X,7.85,center.Z+4.3)
 for _,a in site:GetChildren() do if a.Name:match("^BackSupport") then a.Position=V(center.X+(a.Name:sub(-2)=="-1" and -2.5 or 2.5),a.Position.Y,a.Position.Z) end end
 local text=label.Identification.Label;text.Text=text.Text:gsub(" // SPECIMEN","");text.TextScaled=true
 install(props.Floor_Signs.Interact_Console_SM,site,"SpecimenTerminal",center.X+4.5,2.6,center.Z-3,1,0)
end
if INDEX==1 then
 local mark=root.Landmarks.Lunar_ResearchObservatory
 archive(mark.Survey_Station,"OldSurveyStation")
 cabin(mark,"Survey_Station",45,z+55)
 for _,p in mark:GetChildren() do if p:IsA("BasePart") then p.Position+=V(0,7.74,0) end end
 install(props["Crates and Boxes"].CargoCrate4x2x4,m,"SurveyEquipment",-51,2,z-15,1.4,12)
elseif INDEX==2 then
 local conveyor=env.IdleMiningConveyor
 for _,p in conveyor:GetChildren() do if p.Name:match("Ore") then archive(p,"OldOre_"..p.Name) end end
 for i=1,3 do install(props["Crates and Boxes"].CargoCrate4x2x4,m,"MineralContainer_"..i,39+(i-1)*9,8,z-48,1.1,0) end
 install(props.Energy_Condenser,m,"MiningPowerUnit",-65,2,z+45,1.8,0)
elseif INDEX==3 then
 archive(root.Landmarks.Xeno_BifurcatedCanopy.ElderForkTree,"OldElderTree")
 install(props["Alien Plants Pack"].LargeAlienTree,root.Landmarks.Xeno_BifurcatedCanopy,"ElderCanopy",44,2,z+55,1,20)
 for _,a in env:GetChildren() do if a:IsA("Model") and (a.Name:match("Tree") or a:FindFirstChild("Trunk")) then archive(a,"OldXeno_"..a.Name) end end
 install(props["Alien Plants Pack"].AlienTreeStumpGroup,m,"RootColony",-52,2,z+17,.8,-12)
 install(props["Alien Plants Pack"].AlienFungus_Standalone01,m,"CanopyCompanion",49,2,z-49,.65,55)
 for i,p in {{-55,-51},{-39,-56},{52,-20},{-55,53}} do install(props["Alien Plants Pack"].FernTallVar01,m,"FernCluster_"..i,p[1],2,z+p[2],.65,i*31) end
elseif INDEX==4 then
 archive(env:FindFirstChild("FrostedRoofCap"),"OldCryoRoofCap")
 install(arch.Walls["Wall_add-ons"].EmergencySuitLocker02,m,"CryogenicCabinet",61,2,z-32,.9,0)
 install(props["Crates and Boxes"].CargoCrate4x4,m,"CryoSupplies",-67,2,z+51,1.1,10)
elseif INDEX==5 then
 install(props.Energy_Condenser,m,"ThermalTurbine",-56,2,z+50,2.1,0)
 for i=1,3 do install(props.Pipes.Pipe_Insulated_B,m,"ThermalPipe_"..i,65,2,z+25+i*5,1.4,0) end
elseif INDEX==6 then
 for _,side in {-1,1} do install(arch.Walls.Rotunda_Panel_A,m,"ArchiveWing_"..side,side*56,2,z+48,.7,side*25) end
 install(props.Terrarium,m,"PreservedBiosphere",-55,2,z-42,.85,20)
end
world:SetAttribute("VisualRefitComplete",true)
return {world=worldNames[INDEX],refitObjects=#m:GetChildren(),sites=#sites:GetChildren()}

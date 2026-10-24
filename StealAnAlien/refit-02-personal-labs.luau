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

local FIRST_PLOT,LAST_PLOT=1,4
for i=FIRST_PLOT,LAST_PLOT do
 local plot=root.PlayerBases[string.format("Plot_%02d",i)]
 local interior=plot.PlotInterior
 local base=plot.PlotPlatform.Position
 local cf=CFrame.lookAt(V(base.X,3,base.Z),V(0,3,base.Z))
 local _,rot,_=cf:ToOrientation();local yaw=math.deg(rot)
 local m=model(plot,"StationLabArchitecture")
 local function place(source,name,x,z,scale,angle)
  local p=(cf*CFrame.new(x,0,z)).Position
  return install(source,m,name,p.X,3,p.Z,scale,yaw+(angle or 0))
 end
 archive(interior:FindFirstChild("PersonalLaboratory"),"OldPlotLab_"..i)
 for _,p in interior:GetChildren() do
  if p.Name:match("^Nameplate") or p.Name=="PlotNameplate" or p.Name=="BackBoundary" then archive(p,"OldPlot"..i.."_"..p.Name) end
 end
 place(arch.Walls.Wall_Panel_A_Dark,"RearLabWall",-7.5,15.2,.9373)
 place(arch.Walls.Wall_Panel_A_Window_Split,"RearObservationWindow",7.5,15.2,.9373)
 place(arch.Walls["Wall_add-ons"].EmergencySuitLocker01,"ResearchCabinet",0,11.8,.55)
 place(props.Floor_Signs.Interact_Console_SM,"LaboratoryConsole",0,6.3,1.4)
 for _,bay in interior.HabitatBays:GetChildren() do
  local label=bay:FindFirstChild("HabitatLabel")
  if label then local gui=label:FindFirstChildWhichIsA("SurfaceGui");if gui then gui:Destroy() end end
  local plinth=bay.DisplayPlinth
  local tag=sign(bay,"BayIdentifier",bay.Name:sub(-2),plinth.CFrame*CFrame.new(0,0,-2.1),V(2,.5,.2),C(160,195,194))
 end
 local foot=box(m,"PlotMarkerFoot",(cf*CFrame.new(-11,.3,-14)).Position,V(3.6,.6,2),C(58,71,82));foot.CFrame=cf*CFrame.new(-11,.3,-14)
 sign(m,"PlotMarker",string.format("%02d\nPERSONAL\nOUTPOST",i),cf*CFrame.new(-11,2.7,-14),V(3.6,4.2,.45),C(202,218,218))
 sign(m,"ResearchHeader",string.format("OUTPOST %02d   /   FIELD LAB",i),cf*CFrame.new(0,12,13.47),V(18,1.6,.18),C(198,215,216))
 task.wait()
end
return {plotsRefitted=LAST_PLOT-FIRST_PLOT+1}

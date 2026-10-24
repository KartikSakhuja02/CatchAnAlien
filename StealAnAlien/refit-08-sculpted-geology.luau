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


local ice=sources.IceSpikeSource
local crown=root.Landmarks.Cryo_FracturedIceCrown
assert(not crown:FindFirstChild("SculptedIceCrown"),"Ice crown already updated")
local iceArt=model(crown,"SculptedIceCrown")
for _,p in crown:GetChildren() do if p:IsA("BasePart") and p.Name:match("^IceSpire") then archive(p,"Former_"..p.Name) end end
local layouts={{32,986,19,15},{42,989,34,-16},{56,993,24,24},{36,998,14,60},{52,981,13,-35}}
for i,v in layouts do
 local item=install(ice,iceArt,"GlacierSpire_"..i,v[1],4,v[2],v[3]/20,v[4])
 local center=item:GetBoundingBox();item:PivotTo(CFrame.new(center.Position)*CFrame.Angles(math.pi,0,0)*CFrame.new(-center.Position)*item:GetPivot())
 for _,p in item:GetDescendants() do if p:IsA("BasePart") then p.Material=Enum.Material.Ice;p.Color=C(155,177,187);p.Transparency=.08;p.Reflectance=.03 end end
end
local field=root.Worlds.World_04_CryoMoon.Environment.BrokenIceField
for _,p in field:GetChildren() do
 if p:IsA("WedgePart") then
  local pos,height,name=p.Position,p.Size.Y,p.Name;archive(p,"Former_"..name)
  local item=install(ice,field,name,pos.X,2,pos.Z,height/20,25)
  local center=item:GetBoundingBox();item:PivotTo(CFrame.new(center.Position)*CFrame.Angles(math.pi,0,0)*CFrame.new(-center.Position)*item:GetPivot())
  for _,q in item:GetDescendants() do if q:IsA("BasePart") then q.Material=Enum.Material.Ice;q.Color=C(164,184,193);q.Transparency=.08 end end
 end
end
local pack=sources.SculptedRockPack
local chosen={pack:FindFirstChild("Boulder"),pack.LargeBoulder01,pack:FindFirstChild("Meshes/Medium Boulder 01"),pack["Nordic Cliff"],pack.Rock,pack:FindFirstChild("Nordic Cliff2")}
local names={"LunarOutpost","RustMoon","Xenoforest","CryoMoon","BasaltRift","VoidArchive"}
local colors={C(163,166,162),C(145,112,87),C(110,129,102),C(181,197,202),C(93,98,105),C(130,131,149)}
local count=0
for index,name in names do
 local m=root.Worlds[string.format("World_%02d_%s",index,name)].RefinedEnvironment
 local replace={}
 for _,a in m:GetChildren() do
  if a:IsA("Model") and tostring(a:GetAttribute("ArtSource")):find("AsteroidSource",1,true) then table.insert(replace,a) end
 end
 for i,old in replace do
  local cf,size=old:GetBoundingBox();local source=chosen[((index+i-2)%#chosen)+1]
  local probe=Instance.new("Model");source:Clone().Parent=probe;local _,dimensions=probe:GetBoundingBox();probe:Destroy()
  local scale=math.min(size.Y/dimensions.Y,math.max(10,size.X*1.5)/dimensions.X,math.max(9,size.Z*1.5)/dimensions.Z)
  local oldName=old.Name;archive(old,"FormerGroundRock_"..name.."_"..oldName)
  local item=install(source,m,oldName,cf.Position.X,2,cf.Position.Z,scale,index*23+i*17)
  for _,p in item:GetDescendants() do
   if p:IsA("BasePart") then p.Color=colors[index];p.Material=index==5 and Enum.Material.Basalt or Enum.Material.Rock
   elseif p:IsA("SurfaceAppearance") then pcall(function()p.Color=colors[index]end) end
  end
  count+=1
 end
 task.wait()
end
game:GetService("ChangeHistoryService"):SetWaypoint("Sculpted world geology")
return {groundRocksReplaced=count,iceSpires=8}

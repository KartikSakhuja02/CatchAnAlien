local history=game:GetService("ChangeHistoryService")
history:SetWaypoint("Before Steal an Alien Phase A")
assert(not workspace:FindFirstChild("SpaceWorld"),"Existing SpaceWorld requires inspection")
local backup=Instance.new("Folder"); backup.Name="StealAnAlien_TemplateBackup"; backup.Parent=game:GetService("ServerStorage")
for _,name in {"Baseplate","SpawnLocation"} do local obj=workspace:FindFirstChild(name); if obj then obj.Parent=backup end end
local root=Instance.new("Folder"); root.Name="SpaceWorld"; root:SetAttribute("Project","Steal an Alien")
root:SetAttribute("InitialPlotCount",8); root:SetAttribute("ProgressionAxis","+Z")
for _,name in {"SpawnHub","PlayerBases","ProgressionRoute","Worlds","CollectionProps","HubFacilities","Landmarks"} do local f=Instance.new("Folder"); f.Name=name; f.Parent=root end
local names={"LunarOutpost","RustMoon","Xenoforest","CryoMoon","BasaltRift","VoidArchive"}
for i,name in names do local f=Instance.new("Model"); f.Name=string.format("World_%02d_%s",i,name); f:SetAttribute("WorldNumber",i); f:SetAttribute("CenterZ",245+(i-1)*230); f.Parent=root.Worlds end
for i=1,8 do local m=Instance.new("Model"); m.Name=string.format("Plot_%02d",i); m:SetAttribute("PlotNumber",i); m.Parent=root.PlayerBases end
root.Parent=workspace
assert(#root:GetChildren()==7 and #root.Worlds:GetChildren()==6 and #root.PlayerBases:GetChildren()==8,"Hierarchy mismatch")
assert(not workspace:FindFirstChild("Baseplate"),"Baseplate remains")
history:SetWaypoint("Steal an Alien Structure Complete")
return "Phase A verified: seven root folders, six world models, eight plot models, template Baseplate and spawn preserved in ServerStorage."

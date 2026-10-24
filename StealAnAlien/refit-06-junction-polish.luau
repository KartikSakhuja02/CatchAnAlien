local root=workspace.SpaceWorld
local services=root.HubFacilities.ConcourseServices
for _,name in {"SUPPLY_DEPOT","RESEARCH_INDEX"} do local m=services[name];m:PivotTo(m:GetPivot()+Vector3.new(0,0,2)) end
services.MOVEMENT_LAB:PivotTo(services.MOVEMENT_LAB:GetPivot()+Vector3.new(-6,0,0))
for _,plot in root.PlayerBases:GetChildren() do
 for _,side in {-1,1} do local p=plot.PlotInterior["SideBoundary_"..side];p.Size=Vector3.new(p.Size.X,p.Size.Y,29.3);p.CFrame*=CFrame.new(0,0,-1.35) end
end
local fern=root.Worlds.World_03_Xenoforest.RefinedEnvironment.FernCluster_1
fern:PivotTo(fern:GetPivot()+Vector3.new(0,0,12))
for _,m in root:GetDescendants() do if m:IsA("Model") and m:GetAttribute("StaticImportedArt") then
 for _,p in m:GetDescendants() do if p:IsA("Light") then p.Enabled=false end end
end end
game:GetService("ChangeHistoryService"):SetWaypoint("Visual refit junction polish")
for _,m in {root.Landmarks.Xeno_BifurcatedCanopy,root.Worlds.World_03_Xenoforest.RefinedEnvironment} do
 for _,p in m:GetDescendants() do if p:IsA("SurfaceAppearance") then pcall(function()p.Color=Color3.fromRGB(110,145,86)end) end end
end
for _,p in game.ServerStorage.SpaceArtSourceAssets:GetDescendants() do if p:IsA("LuaSourceContainer") then p:Destroy() end end
for _,p in root:GetDescendants() do if p:IsA("BasePart") and p.Parent.Name=="DockingCollars" and p.Name:match("^Header") then p.Position+=Vector3.new(0,1,0) end end
return "Cross-assembly clipping fixes applied"

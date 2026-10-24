local root=workspace.SpaceWorld
local layouts={
 {"Rust",475,{{-50,-4},{29,-48},{-27,48}}},
 {"Xeno",705,{{-32,-22},{31,16},{-26,56}}},
 {"Cryo",935,{{-28,-45},{34,2},{-24,58}}},
 {"Basalt",1165,{{-32,-25},{27,23},{-24,61}}},
 {"Void",1395,{{-27,-30},{28,10},{-28,51}}}
}
for _,layout in layouts do
 local group=root.CollectionProps[layout[1].."Specimens"]
 for i,offset in layout[3] do
  local site=group[string.format("AlienNest_%s_%02d",layout[1],i)]
  local foundation=site.SiteFoundation
  local delta=Vector3.new(offset[1],foundation.Position.Y,layout[2]+offset[2])-foundation.Position
  site:PivotTo(site:GetPivot()+delta)
 end
 task.wait()
end
for _,plot in root.PlayerBases:GetChildren() do
 local label=plot.PlotInterior.ReturnPad.Identification.Label
 -- A quarter turn aligns top-face lettering to the plot entrance.
 label.Rotation=90
 label.Size=UDim2.new(0.7,0,0.7,0); label.AnchorPoint=Vector2.new(0.5,0.5); label.Position=UDim2.fromScale(0.5,0.5)
end
local label=root.SpawnHub.CentralAisle.DirectionTile.Identification.Label
label.Rotation=90; label.AnchorPoint=Vector2.new(0.5,0.5); label.Position=UDim2.fromScale(0.5,0.5); label.Size=UDim2.fromScale(0.75,0.75)
local params=OverlapParams.new();params.FilterType=Enum.RaycastFilterType.Include;params.FilterDescendantsInstances={root}
local overlaps,seen={},{}
for _,p in root:GetDescendants() do
 if p:IsA("BasePart") then
  for _,q in workspace:GetPartsInPart(p,params) do
   local a,b=p:GetFullName(),q:GetFullName();if a>b then a,b=b,a end
   local key=a.." <> "..b
   if not seen[key] then seen[key]=true;table.insert(overlaps,key) end
  end
 end
end
game:GetService("ChangeHistoryService"):SetWaypoint("Final Composition and Label Polish")
return {phase="G",specimenSitesRepositioned=15,overlaps=overlaps}

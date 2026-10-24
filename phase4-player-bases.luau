-- Phase 4A: four static perimeter bases; no gameplay scripts.
local root=workspace.SpaceWorld
local bases=root.PlayerBases
assert(#bases:GetChildren()==0,"PlayerBases already contains work")
game:GetService("ChangeHistoryService"):SetWaypoint("Before Phase 4 Bases")
local definitions={
 {name="NorthBase",label="NORTH // BLUE",position=Vector3.new(0,4,-160),color=Color3.fromRGB(35,135,255),team="Bright blue"},
 {name="SouthBase",label="SOUTH // RED",position=Vector3.new(0,4,160),color=Color3.fromRGB(255,65,80),team="Bright red"},
 {name="EastBase",label="EAST // GREEN",position=Vector3.new(160,4,0),color=Color3.fromRGB(50,255,140),team="Bright green"},
 {name="WestBase",label="WEST // GOLD",position=Vector3.new(-160,4,0),color=Color3.fromRGB(255,195,45),team="New Yeller"}
}
local function part(parent,name,size,cf,mat,color,class)
 local p=Instance.new(class or "Part")
 p.Name=name; p.Size=size; p.CFrame=cf; p.Material=mat; p.Color=color
 p.Anchored=true; p.CanCollide=true; p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent; return p
end
for _,d in definitions do
 local m=Instance.new("Model"); m.Name=d.name
 m:SetAttribute("TeamLabel",d.label); m:SetAttribute("BaseCenter",d.position)
 local cf=CFrame.lookAt(d.position,Vector3.new(0,4,0))
 local platform=part(m,"LandingPlatform",Vector3.new(44,4,44),cf,Enum.Material.Metal,Color3.fromRGB(42,47,60))
 m.PrimaryPart=platform
 local trim=Instance.new("Folder"); trim.Name="TeamNeonTrim"; trim.Parent=m
 for _,side in {-1,1} do
  part(trim,"SideTrim_"..side,Vector3.new(0.6,0.4,44),cf*CFrame.new(side*22.3,2.2,0),Enum.Material.Neon,d.color)
  part(trim,"EndTrim_"..side,Vector3.new(44,0.4,0.6),cf*CFrame.new(0,2.2,side*22.3),Enum.Material.Neon,d.color)
 end
 local spawn=part(m,"SpawnLocation",Vector3.new(8,1,8),cf*CFrame.new(0,2.5,14),Enum.Material.Metal,d.color,"SpawnLocation")
 spawn.Neutral=true; spawn.TeamColor=BrickColor.new(d.team); spawn.AllowTeamChangeOnTouch=false; spawn.Duration=0
 spawn:SetAttribute("IntendedTeam",d.label)
 local billboard=Instance.new("BillboardGui"); billboard.Name="BaseIdentification"; billboard.Size=UDim2.fromOffset(260,36); billboard.StudsOffset=Vector3.new(0,7,0); billboard.MaxDistance=180; billboard.AlwaysOnTop=false; billboard.Parent=spawn
 local label=Instance.new("TextLabel"); label.Size=UDim2.fromScale(1,1); label.BackgroundTransparency=1; label.Text=d.label; label.TextColor3=d.color; label.TextStrokeTransparency=0.3; label.Font=Enum.Font.GothamBold; label.TextSize=21; label.Parent=billboard
 local deposit=Instance.new("Model"); deposit.Name="EggDepositZone"; deposit.Parent=m
 local depositCF=cf*CFrame.new(0,2.4,-2)
 local pad=part(deposit,"DepositPad",Vector3.new(0.8,9,9),depositCF*CFrame.Angles(0,0,math.pi/2),Enum.Material.Metal,Color3.fromRGB(26,31,43))
 pad.Shape=Enum.PartType.Cylinder
 deposit.PrimaryPart=pad
 local count=32; local radius=5.5; local width=0.6
 local length=2*(radius-width/2)*math.tan(math.pi/count)-0.04
 for i=1,count do
  local a=(i-1)*2*math.pi/count
  local pos=depositCF:PointToWorldSpace(Vector3.new(radius*math.cos(a),0,radius*math.sin(a)))
  local target=depositCF.Position
  part(deposit,string.format("BaseRing_%02d",i),Vector3.new(length,0.8,width),CFrame.lookAt(pos,target),Enum.Material.Neon,d.color)
 end
 local beam=part(deposit,"DepositBeam",Vector3.new(9,8,8),cf*CFrame.new(0,7.3,-2)*CFrame.Angles(0,0,math.pi/2),Enum.Material.Neon,d.color)
 beam.Shape=Enum.PartType.Cylinder; beam.Transparency=0.86; beam.CanCollide=false; beam.CanTouch=false; beam.CanQuery=false; beam.CastShadow=false; beam:SetAttribute("VisualAura",true)
 local glow=Instance.new("PointLight"); glow.Color=d.color; glow.Brightness=0.5; glow.Range=18; glow.Parent=pad
 for _,side in {-1,1} do
  part(m,"ExitFoot_"..side,Vector3.new(2.8,1,2.8),cf*CFrame.new(side*8,2.5,-18),Enum.Material.Metal,Color3.fromRGB(35,40,52))
  local columnCF=cf*CFrame.new(side*8,8,-18)
  part(m,"LaserGatePillar_"..side,Vector3.new(1.4,10,1.4),columnCF,Enum.Material.Metal,Color3.fromRGB(53,61,77))
  part(m,"GateEnergyStrip_"..side,Vector3.new(0.5,8,0.2),columnCF*CFrame.new(0,0,-0.8),Enum.Material.Neon,d.color)
  part(m,"GateCap_"..side,Vector3.new(2,0.4,2),cf*CFrame.new(side*8,13.2,-18),Enum.Material.Neon,d.color)
  part(m,"ApproachGuide_"..side,Vector3.new(0.3,0.2,8),cf*CFrame.new(side*5,2.1,-11),Enum.Material.Neon,d.color)
 end
 m.Parent=bases
 task.wait()
end
game:GetService("ChangeHistoryService"):SetWaypoint("Four Space Bases Built")
return "Four 44x4x44 bases built at radius 160, each with spawn, deposit zone, team trim, and two gate pillars."

-- Phase 4C: four asteroid arcs connect adjacent bases around the outer perimeter.
local paths=workspace.SpaceWorld.Pathways
assert(not paths:FindFirstChild("OuterAsteroidRing"),"Outer ring already exists")
local folder=Instance.new("Folder"); folder.Name="OuterAsteroidRing"; folder.Parent=paths
local names={"NorthToEast","EastToSouth","SouthToWest","WestToNorth"}
local colors={Color3.fromRGB(35,135,255),Color3.fromRGB(50,255,140),Color3.fromRGB(255,65,80),Color3.fromRGB(255,195,45)}
local function part(parent,name,size,cf,mat,color,class)
 local p=Instance.new(class or "Part"); p.Name=name; p.Size=size; p.CFrame=cf; p.Material=mat; p.Color=color
 p.Anchored=true; p.CanCollide=true; p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent; return p
end
for quadrant=0,3 do
 local arc=Instance.new("Model"); arc.Name=names[quadrant+1]
 for i=1,17 do
  local t=(i-1)/16
  local angle=-math.pi/2+quadrant*math.pi/2+math.rad(11+68*t)
  local endpoint=i==1 or i==17
  local top=endpoint and 6 or (5.8+0.6*math.sin(i*math.pi/4))
  local height=3.6+(i%4)*0.3
  local width=endpoint and 8.8 or (9.4+(i%3)*0.4)
  local depth=endpoint and 8.8 or (9.2+(i%3)*0.5)
  local pos=Vector3.new(160*math.cos(angle),top-height/2,160*math.sin(angle))
  local cf=CFrame.lookAt(pos,Vector3.new(0,pos.Y,0))*CFrame.Angles(0,math.rad(endpoint and 0 or ((i%3)-1)*4),0)
  local color=Color3.fromRGB(62+(i%4)*5,65+(i%3)*4,82+(i%5)*3)
  local stone=part(arc,string.format("Asteroid_%02d",i),Vector3.new(width,height,depth),cf,Enum.Material.Slate,color)
  stone:SetAttribute("RouteOrder",i); stone:SetAttribute("LandingTopY",top); stone:SetAttribute("RouteSurface",true)
  -- Separate wedges touch the core's radial faces and give each rock a tapered silhouette.
  for _,side in {-1,1} do
   local wedgeCF=cf*CFrame.new(0,0,side*(depth/2+0.75))
   if side==1 then wedgeCF=wedgeCF*CFrame.Angles(0,math.pi,0) end
   part(arc,string.format("RockFacet_%02d_%d",i,side),Vector3.new(width,height,1.5),wedgeCF,Enum.Material.Slate,color:Lerp(Color3.fromRGB(95,90,115),0.2),"WedgePart")
  end
  if i%4==1 then
   local beaconColor=colors[quadrant+1]:Lerp(colors[(quadrant+1)%4+1],t)
   part(arc,string.format("RouteMarker_%02d",i),Vector3.new(1.8,0.2,0.45),cf*CFrame.new(0,height/2+0.1,0),Enum.Material.Neon,beaconColor)
  end
 end
 arc.Parent=folder
 task.wait()
end
game:GetService("ChangeHistoryService"):SetWaypoint("Outer Asteroid Flanking Routes Built")
return "Outer flanking ring built: 68 landable asteroids in four arcs, with roughly 12-stud center spacing."

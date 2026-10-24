-- Phase 4B: four mixed bridge / asteroid routes, from radius 42 to radius 135.
local paths=workspace.SpaceWorld.Pathways
assert(not paths:FindFirstChild("RadialRoutes"),"RadialRoutes already exists")
local folder=Instance.new("Folder"); folder.Name="RadialRoutes"; folder.Parent=paths
local defs={
 {name="NorthRoute",direction=Vector3.new(0,0,-1),color=Color3.fromRGB(35,135,255)},
 {name="SouthRoute",direction=Vector3.new(0,0,1),color=Color3.fromRGB(255,65,80)},
 {name="EastRoute",direction=Vector3.new(1,0,0),color=Color3.fromRGB(50,255,140)},
 {name="WestRoute",direction=Vector3.new(-1,0,0),color=Color3.fromRGB(255,195,45)}
}
local segments={
 {r=48,top=2.5,h=1,w=10,length=12,kind="Bridge"},
 {r=60,top=3.4,h=4,w=10.2,length=9.4,yaw=6,kind="Asteroid"},
 {r=72,top=4.2,h=4.6,w=9.6,length=10.2,yaw=-5,kind="Asteroid"},
 {r=84,top=3.8,h=1,w=10,length=12,kind="Bridge"},
 {r=96,top=4.8,h=3.8,w=10.4,length=9.4,yaw=-6,kind="Asteroid"},
 {r=108,top=4.4,h=4.4,w=9.4,length=10.2,yaw=5,kind="Asteroid"},
 {r=120,top=5.2,h=1,w=10,length=12,kind="Bridge"},
 {r=132,top=5.7,h=1,w=10,length=6,kind="Bridge"}
}
local function part(parent,name,size,cf,mat,color)
 local p=Instance.new("Part"); p.Name=name; p.Size=size; p.CFrame=cf; p.Material=mat; p.Color=color
 p.Anchored=true; p.CanCollide=true; p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent; return p
end
for _,d in defs do
 local route=Instance.new("Model"); route.Name=d.name
 for i,s in segments do
  local pos=d.direction*s.r+Vector3.new(0,s.top-s.h/2,0)
  local cf=CFrame.lookAt(pos,Vector3.new(0,pos.Y,0))*CFrame.Angles(0,math.rad(s.yaw or 0),0)
  local p=part(route,string.format("%02d_%s",i,s.kind),Vector3.new(s.w,s.h,s.length),cf,s.kind=="Bridge" and Enum.Material.Glass or Enum.Material.Slate,s.kind=="Bridge" and d.color:Lerp(Color3.fromRGB(175,220,245),0.45) or Color3.fromRGB(68+i*2,65+i,83+i))
  p:SetAttribute("RouteOrder",i); p:SetAttribute("LandingTopY",s.top); p:SetAttribute("RouteSurface",true)
  if s.kind=="Bridge" then
   p.Transparency=0.3
   for _,side in {-1,1} do
    local rail=part(route,string.format("%02d_EnergyEdge_%d",i,side),Vector3.new(0.4,0.35,s.length),cf*CFrame.new(side*(s.w/2+0.2),s.h/2-0.175,0),Enum.Material.Neon,d.color)
    rail.Transparency=0.3
   end
  end
 end
 route.Parent=folder
 task.wait()
end
game:GetService("ChangeHistoryService"):SetWaypoint("Four Radial Routes Built")
return "Four radial routes built: 16 glass bridge sections and 16 slate asteroids, with 12-stud center spacing."

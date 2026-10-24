-- Phase 3C: diagonal tactical cover keeps the four cardinal approaches open.
local nest=workspace.SpaceWorld.CentralNest
assert(nest:FindFirstChild("CosmicPedestal"),"Build pedestal first")
assert(not nest:FindFirstChild("TacticalCover"),"Cover already exists")
local cover=Instance.new("Model"); cover.Name="TacticalCover"
local function part(name,size,cf,material,color)
 local p=Instance.new("Part"); p.Name=name; p.Size=size; p.CFrame=cf; p.Material=material; p.Color=color
 p.Anchored=true; p.CanCollide=true; p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=cover; return p
end
for i=0,3 do
 local theta=math.pi/4+i*math.pi/2
 local pos=Vector3.new(28*math.cos(theta),5,28*math.sin(theta))
 local cf=CFrame.lookAt(pos,Vector3.new(0,5,0))
 local wall=part("Barricade_"..(i+1),Vector3.new(14,6,2),cf,Enum.Material.DiamondPlate,Color3.fromRGB(53,61,76))
 wall:SetAttribute("Radius",28)
 part("CoverTopTrim_"..(i+1),Vector3.new(14,0.22,2),cf*CFrame.new(0,3.11,0),Enum.Material.Neon,Color3.fromRGB(0,205,240))
 part("CoverFrontStripe_"..(i+1),Vector3.new(11,0.25,0.1),cf*CFrame.new(0,1.7,-1.05),Enum.Material.Neon,Color3.fromRGB(0,150,190))
end
cover.Parent=nest
game:GetService("ChangeHistoryService"):SetWaypoint("Central Cosmic Nest Phase 3 Complete")
game:GetService("Selection"):Set({nest})
workspace.CurrentCamera.CFrame=CFrame.lookAt(Vector3.new(76,65,88),Vector3.new(0,4,0))
return "Four 14x6x2 DiamondPlate barricades placed at radius 28, with cardinal approaches clear."

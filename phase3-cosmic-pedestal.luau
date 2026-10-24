-- Phase 3B: two-tier pedestal, egg, and angled containment pillars.
local nest=workspace.SpaceWorld.CentralNest
assert(nest:FindFirstChild("CorePlatform"),"Build platform first")
assert(not nest:FindFirstChild("CosmicPedestal"),"Pedestal already exists")
local model=Instance.new("Model"); model.Name="CosmicPedestal"
local function part(name,size,cf,material,color,parent)
 local p=Instance.new("Part"); p.Name=name; p.Size=size; p.CFrame=cf; p.Material=material; p.Color=color
 p.Anchored=true; p.CanCollide=true; p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent; return p
end
local rotation=CFrame.Angles(0,0,math.pi/2)
local base=part("MetalPedestalBase",Vector3.new(3,14,14),CFrame.new(0,3.5,0)*rotation,Enum.Material.Metal,Color3.fromRGB(38,42,54),model)
base.Shape=Enum.PartType.Cylinder
local pad=part("MagentaEnergyPad",Vector3.new(0.5,10,10),CFrame.new(0,5.25,0)*rotation,Enum.Material.Neon,Color3.fromRGB(255,35,190),model)
pad.Shape=Enum.PartType.Cylinder
local egg=part("CosmicEggPlaceholder",Vector3.new(5,7,5),CFrame.new(0,9,0),Enum.Material.Neon,Color3.fromRGB(255,60,200),model)
egg.Shape=Enum.PartType.Ball
local light=Instance.new("PointLight"); light.Name="CosmicGlow"; light.Color=egg.Color; light.Brightness=1.2; light.Range=22; light.Shadows=false; light.Parent=egg
model.Parent=nest
local pillars=Instance.new("Model"); pillars.Name="ContainmentPillars"
local lean=math.rad(12)
local h=11
for i=0,3 do
 local theta=math.pi/4+i*math.pi/2
 local radial=Vector3.new(math.cos(theta),0,math.sin(theta))
 local footPos=radial*12+Vector3.new(0,2.75,0)
 local footCF=CFrame.lookAt(footPos,Vector3.new(0,footPos.Y,0))
 part("PillarFoot_"..(i+1),Vector3.new(3.8,1.5,3.8),footCF,Enum.Material.Metal,Color3.fromRGB(35,39,49),pillars)
 -- The lowest rotated corner touches the top of the foot at Y=3.5.
 local centerY=3.5+h*math.cos(lean)/2+1.4*math.sin(lean)/2
 local center=radial*(12-h*math.sin(lean)/2)+Vector3.new(0,centerY,0)
 local cf=CFrame.lookAt(center,Vector3.new(0,center.Y,0))*CFrame.Angles(-lean,0,0)
 part("AngledContainmentPillar_"..(i+1),Vector3.new(1.8,h,1.4),cf,Enum.Material.Metal,Color3.fromRGB(50,57,72),pillars)
 part("PillarEnergyStrip_"..(i+1),Vector3.new(0.65,9,0.14),cf*CFrame.new(0,0,-0.77),Enum.Material.Neon,Color3.fromRGB(0,225,255),pillars)
 local cap=part("PillarCap_"..(i+1),Vector3.new(2.2,0.4,1.8),cf*CFrame.new(0,h/2+0.2,0),Enum.Material.Neon,Color3.fromRGB(255,55,190),pillars)
 local capLight=Instance.new("PointLight"); capLight.Color=cap.Color; capLight.Brightness=0.35; capLight.Range=10; capLight.Parent=cap
end
pillars.Parent=nest
game:GetService("ChangeHistoryService"):SetWaypoint("Cosmic Pedestal Complete")
return "Pedestal and egg complete; four inward-angled pillars built with clean surface offsets."

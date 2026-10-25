local ark = workspace.SpaceWorld.SpawnHub.ARKShip
assert(not ark:FindFirstChild("PressureShell"), "Pressure shell already installed")
local V,C=Vector3.new,Color3.fromRGB
local shell=Instance.new("Model");shell.Name="PressureShell";shell:SetAttribute("ArtAssembly",true)
local function p(name,pos,size,color,rotation,material)
	local x=Instance.new("Part");x.Name=name;x.Size=size;x.CFrame=CFrame.new(pos)*(rotation or CFrame.identity)
	x.Color=color or C(103,121,136);x.Material=material or Enum.Material.Metal;x.Anchored=true;x.CanCollide=true
	x.TopSurface=Enum.SurfaceType.Smooth;x.BottomSurface=Enum.SurfaceType.Smooth
	if x.Material==Enum.Material.Metal then x.MaterialVariant="SA_StationDeck_BrushedSteel"end
	x.Parent=shell;return x
end
for _,side in {-1,1}do
	for i=0,3 do
		p("CabinArmor_"..side.."_"..i,V(side*10.2,11.6,-184.5+i*9),V(.25,8.1,8.94),C(100+i*4,117+i*4,130+i*4),CFrame.Angles(0,0,math.rad(side*15)))
	end
	p("CockpitLowerArmor_"..side,V(side*10.2,9.05,-195),V(.3,2.9,12),C(84,102,118))
	p("CockpitRoofEdge_"..side,V(side*10.2,15.25,-195),V(.3,1.3,12),C(128,144,155))
	local glass=p("CockpitSideWindow_"..side,V(side*10.2,12.6,-195),V(.2,4.0,12),C(69,107,124),nil,Enum.Material.Glass)
	glass.Transparency=.3;glass.Reflectance=.04
	p("CockpitSideFloor_"..side,V(side*8,9.45,-195),V(4,.1,10),C(118,136,148))
	p("DorsalArmor_"..side,V(side*6.8,15.9,-177),V(7.6,.22,48),C(119,138,151),CFrame.Angles(0,0,math.rad(-side*5)))
end
p("DorsalSpine",V(0,16.25,-177),V(6,.25,48),C(106,124,137))
p("VentralArmor",V(0,7.05,-177),V(21,.25,48),C(51,67,82))
-- The cockpit closes with a framed observation window rather than a sealed wall.
p("ForwardSill",V(0,9.5,-200.65),V(20.7,.8,.3),C(82,101,116))
p("ForwardHeader",V(0,15.45,-200.65),V(20.7,.6,.3),C(131,149,160))
for _,x in {-10.2,0,10.2}do p("WindshieldMullion_"..x,V(x,12.45,-200.65),V(.3,5.3,.3),C(89,110,127))end
for _,side in {-1,1}do local g=p("ForwardObservationWindow_"..side,V(side*5.1,12.45,-200.65),V(9.9,5.3,.2),C(70,108,129),nil,Enum.Material.Glass);g.Transparency=.28;g.Reflectance=.02 end
shell.Parent=ark

local hull=ark.Hull
local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Include;rp.FilterDescendantsInstances={shell,hull}
for _,m in ark.ExteriorSystems:GetChildren()do if m:IsA("Model")then
	local plate=m:FindFirstChild("EquipmentMount")
	if plate then
		local hits={};local high=-math.huge
		for _,dx in {-plate.Size.X/2,0,plate.Size.X/2}do for _,dz in {-plate.Size.Z/2,0,plate.Size.Z/2}do
			local h=workspace:Raycast(V(plate.Position.X+dx,45,plate.Position.Z+dz),V(0,-60,0),rp)
			if h then high=math.max(high,h.Position.Y)end
		end end
		if high>-math.huge then
			local targetBottom=high+.22;local delta=targetBottom-(plate.Position.Y-plate.Size.Y/2)
			m:PivotTo(CFrame.new(0,delta,0)*m:GetPivot())
			for _,foot in m:GetChildren()do if foot:IsA("BasePart")and foot.Name=="HullMountFoot"then
				local h=workspace:Raycast(V(foot.Position.X,45,foot.Position.Z),V(0,-60,0),rp)
				if h then local low=h.Position.Y+.08;local top=plate.Position.Y-plate.Size.Y/2;foot.Size=V(foot.Size.X,math.max(.05,top-low),foot.Size.Z);foot.Position=V(foot.Position.X,(top+low)/2,foot.Position.Z)end
			end end
		end
	end
end end
return {pressureShellParts=#shell:GetChildren(),exteriorEquipmentRefitted=true}

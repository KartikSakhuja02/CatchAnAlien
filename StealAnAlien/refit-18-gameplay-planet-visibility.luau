-- Editor-only: move the orbital backdrop into the outdoor gameplay horizon.
local system=workspace.SpaceWorld.Landmarks.SolarSystem
assert(not system:GetAttribute("GameplayVisibilityRefit"),"Visibility refit already applied")
system:SetAttribute("OriginalOrbitCenter",system:GetAttribute("OrbitCenter"))
system:SetAttribute("OriginalOrbitInclination",system:GetAttribute("OrbitInclination"))
system:SetAttribute("OrbitCenter",Vector3.new(-2400,1500,10000))
system:SetAttribute("OrbitInclination",.5)
local centre=system:GetAttribute("OrbitCenter")
local plane=CFrame.Angles(math.rad(.5),0,0)
local positions={}
for _,m in system:GetChildren()do if m:IsA("Model")and m:GetAttribute("CelestialBody")then
 m:SetAttribute("OriginalDisplayScale",m:GetScale())
 m:SetAttribute("OriginalOrbitRadius",m:GetAttribute("OrbitRadius"))
 m:ScaleTo(m:GetScale()*2)
 m:SetAttribute("OrbitRadius",m:GetAttribute("OrbitRadius")*(m.Name=="Moon"and 2 or 1.6))
 local diameter=m:GetAttribute("Diameter");if diameter then m:SetAttribute("Diameter",diameter*2)end
end end
local function position(m)
 if positions[m.Name]then return positions[m.Name]end
 local parent=system:FindFirstChild(m:GetAttribute("OrbitParent")or "")
 local origin=parent and position(parent)or centre
 local angle=math.rad(m:GetAttribute("PhaseDegrees")or 0)
 local radius=m:GetAttribute("OrbitRadius")or 0
 local p=origin+plane:VectorToWorldSpace(Vector3.new(math.cos(angle)*radius,0,math.sin(angle)*radius))
 positions[m.Name]=p;return p
end
for _,m in system:GetChildren()do if m:IsA("Model")and m:GetAttribute("CelestialBody")then
 m:PivotTo(CFrame.new(position(m))*CFrame.Angles(0,0,math.rad(m:GetAttribute("AxialTilt")or 0)))
end end
system:SetAttribute("AnimationEpoch",DateTime.now().UnixTimestampMillis/1000)
system:SetAttribute("GameplayVisibilityRefit",true)
system:SetAttribute("SkyRenderDistance",300)
system:SetAttribute("SkyAngularScale",1.35)
system:SetAttribute("GameplayRenderer","CameraRelativeSky")
system:SetAttribute("DisplayScale","Horizon composition; enlarged bodies and compressed circular orbits")
game:GetService("ChangeHistoryService"):SetWaypoint("Make planets visible from outdoor gameplay camera")
return {centre=tostring(centre),inclination=system:GetAttribute("OrbitInclination"),bodies=#system:GetChildren()}

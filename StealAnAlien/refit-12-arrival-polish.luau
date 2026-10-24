local bay = workspace.SpaceWorld.SpawnHub.ArrivalDock
local V, C = Vector3.new, Color3.fromRGB
local equipment = bay.FlightDeckEquipment
for _, p in bay.DockedShuttle:GetDescendants() do
	if p:IsA("BasePart") and p.Material ~= Enum.Material.Glass then
		local s = p.Size
		local area = math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z)
		if area > 24 and p.Color.R < .48 and p.Color.B < .6 then
			p.Color = C(127, 142, 155)
		end
	end
end
for _, p in equipment:GetDescendants() do
	if p:IsA("SurfaceLight") then p.Angle = 150 end
end
for _, p in equipment:GetChildren() do
	if p:IsA("BasePart") then
		if p.Name:match("^LandingGuide_") or p.Name:match("^LandingCorner_") or p.Name == "WelcomeFloorMark" then
			-- Roblox clamps extremely thin parts to 0.05 stud.
			p.Size = V(p.Size.X, .05, p.Size.Z)
			p.Position = V(p.Position.X, 2.03, p.Position.Z)
		elseif p.Name:match("^LightMast_") then
			p.Size = V(.7, 21.4, .7); p.Position = V(p.Position.X, 13.3, p.Position.Z)
		end
	end
end
local keyLight = equipment:FindFirstChild("Floodlight_1_-144")
if keyLight then keyLight.SurfaceLight.Shadows = true end
local access = bay.BoardingAccess
if not access:GetAttribute("RaisedRampFoot") then
	local angle = math.atan2(4.8, 13.2)
	local lift = .35 * math.cos(angle)
	for _, p in access:GetChildren() do if p:IsA("BasePart") then p.Position += V(0, lift, 0) end end
	access.BoardingRamp.Size = V(9, .35, access.BoardingRamp.Size.Z)
	access.BoardingThreshold.Size = V(9, .35, 1.8)
	access.BoardingThreshold.Position = V(0, 6.625 + lift, -136.6)
	access:SetAttribute("RaisedRampFoot", true)
end
local function part(name, pos, size, color)
	local p = equipment:FindFirstChild(name)
	if p then return p end
	p = Instance.new("Part"); p.Name = name; p.Position = pos; p.Size = size
	p.Color = color; p.Material = Enum.Material.Metal; p.Anchored = true; p.CanCollide = true
	p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth; p.Parent = equipment
	return p
end
part("GroundCrewSignFoot", V(-27, 2.1, -124.2), V(2.5, .2, 1), C(47, 60, 73))
part("GroundCrewSignStanchion", V(-27, 2.75, -124.2), V(.4, 1.1, .4), C(120, 135, 148))

-- Replace the plain access closure with the station kit's authored airlock.
if not access:FindFirstChild("ShuttleAirlock") then
	local source = game.ServerStorage.SpaceArtSourceAssets.BeyondTheDark_Architecture.Walls.Locked_Door
	local m = Instance.new("Model"); m.Name = "ShuttleAirlock"
	m:SetAttribute("ArtAssembly", true); m:SetAttribute("StaticImportedArt", true)
	local clone = source:Clone(); clone.Parent = m
	for _, p in m:GetDescendants() do
		if p:IsA("LuaSourceContainer") or p:IsA("ProximityPrompt") or p:IsA("ClickDetector") then p:Destroy()
		elseif p:IsA("BasePart") then p.Anchored = true; p.CanCollide = true
		elseif p:IsA("Light") then p.Enabled = false end
	end
	m:ScaleTo(.46)
	local cf, size = m:GetBoundingBox()
	local bottom = access.BoardingThreshold.Position.Y + access.BoardingThreshold.Size.Y / 2
	m:PivotTo(CFrame.new(0, bottom + size.Y / 2, -137.65) * CFrame.Angles(0, math.pi, 0) * cf:Inverse() * m:GetPivot())
	local old = access:FindFirstChild("ShuttleAccessDoor"); if old then old:Destroy() end
	m.Parent = access
	access.ShuttleIdentity.Position = V(0, bottom + size.Y + .6, -136.55)
end
return {paintAboveFloor = true, rampFootRaised = true, authoredAirlock = true}

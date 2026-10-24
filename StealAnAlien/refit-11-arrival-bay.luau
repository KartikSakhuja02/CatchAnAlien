-- Editor-only construction. Run with local ARRIVAL_PHASE = 1, then 2, then 3.
local phase = ARRIVAL_PHASE or 1
local root = workspace.SpaceWorld
local hub = root.SpawnHub
local V, C = Vector3.new, Color3.fromRGB
local steel, dark, trim = C(103, 116, 129), C(38, 48, 60), C(159, 174, 181)
local teal, ochre = C(99, 139, 144), C(172, 144, 90)
local backup = game.ServerStorage:FindFirstChild("ArrivalBayBackup")
if not backup then backup = Instance.new("Folder"); backup.Name = "ArrivalBayBackup"; backup.Parent = game.ServerStorage end
local bay = hub:FindFirstChild("ArrivalDock")
local function model(parent, name)
	local m = Instance.new("Model"); m.Name = name; m:SetAttribute("ArtAssembly", true); m.Parent = parent; return m
end
local function box(parent, name, pos, size, color, material, class, rotation)
	local p = Instance.new(class or "Part"); p.Name = name; p.Size = size
	p.CFrame = CFrame.new(pos) * (rotation or CFrame.identity)
	p.Color = color or steel; p.Material = material or Enum.Material.Metal
	p.Anchored = true; p.CanCollide = true
	p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent; return p
end
local function text(part, words, face, size)
	local g = Instance.new("SurfaceGui"); g.Name = "PaintedMarking"; g.Face = face or Enum.NormalId.Front
	g.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; g.PixelsPerStud = 45
	g.LightInfluence = .7; g.AlwaysOnTop = false; g.Parent = part
	local t = Instance.new("TextLabel"); t.Name = "Label"; t.BackgroundTransparency = 1
	t.Size = UDim2.fromScale(.94, .84); t.Position = UDim2.fromScale(.03, .08)
	t.Font = Enum.Font.GothamMedium; t.Text = words; t.TextColor3 = C(210, 219, 217)
	t.TextSize = size or 36; t.TextScaled = true; t.Parent = g
	return g
end
local function install(source, parent, name, x, bottom, z, scale, yaw)
	local m = Instance.new("Model"); m.Name = name; m:SetAttribute("ArtAssembly", true)
	m:SetAttribute("StaticImportedArt", true); m:SetAttribute("ArtSource", source:GetFullName())
	local clone = source:Clone(); clone.Parent = m
	for _, p in m:GetDescendants() do
		if p:IsA("LuaSourceContainer") or p:IsA("Humanoid") or p:IsA("AnimationController")
			or p:IsA("ProximityPrompt") or p:IsA("ClickDetector") or p:IsA("Sound")
			or p:IsA("ParticleEmitter") or p:IsA("Trail") or p:IsA("Beam") then p:Destroy()
		elseif p:IsA("BasePart") then
			p.Anchored = true; p.CanCollide = true
			if p:IsA("Seat") or p:IsA("VehicleSeat") then p.Disabled = true end
			if p:IsA("MeshPart") then p.CollisionFidelity = Enum.CollisionFidelity.PreciseConvexDecomposition end
			if p.Material == Enum.Material.Neon then p.Material = Enum.Material.SmoothPlastic end
		elseif p:IsA("Light") then p.Enabled = false
		end
	end
	if scale and scale ~= 1 then m:ScaleTo(m:GetScale() * scale) end
	local cf, size = m:GetBoundingBox()
	m:PivotTo(CFrame.new(x, bottom + size.Y / 2, z) * CFrame.Angles(0, math.rad(yaw or 0), 0) * cf:Inverse() * m:GetPivot())
	m.Parent = parent; return m
end

if phase == 1 then
	assert(not bay, "Arrival dock already exists")
	bay = model(hub, "ArrivalDock")
	local equipment = hub.Spacecraft.VesselEquipment
	for _, name in {"ArrivalBulkhead", "ArrivalIdentity", "AftCargoLocker_-1", "AftCargoLocker_1"} do
		local original = equipment:FindFirstChild(name)
		if original then original:SetAttribute("OriginalParent", equipment:GetFullName()); original.Parent = backup end
	end
	local deck = model(bay, "DockStructure")
	local floor = box(deck, "ApronDeck", V(0, 0, -159), V(82, 4, 74), C(154, 165, 174))
	floor.MaterialVariant = "SA_StationDeck_BrushedSteel"
	bay.PrimaryPart = floor
	box(deck, "UndersidePressureHull", V(0, -7, -159), V(64, 10, 60), dark)
	for _, side in {-1, 1} do
		box(deck, "DeckSideArmor_" .. side, V(side * 40.5, -4.5, -159), V(1, 5, 74), steel)
		box(deck, "HullStringer_" .. side, V(side * 25, -13, -159), V(4, 2, 66), dark)
	end
	box(deck, "OuterEndArmor", V(0, -4.5, -195.5), V(80, 5, 1), steel)
	local portal = model(bay, "ArrivalPortal")
	for _, side in {-1, 1} do
		box(portal, "BulkheadShoulder_" .. side, V(side * 21, 8, -121), V(18, 12, 2), steel)
		box(portal, "PortalJamb_" .. side, V(side * 11.5, 8, -119.7), V(1, 12, .6), trim)
		box(portal, "IdentificationAccent_" .. side, V(side * 23, 8, -119.8), V(2, 8, .4), teal)
	end
	box(portal, "PortalHeader", V(0, 14.75, -121), V(60, 1.5, 2), dark)
	local plate = box(portal, "ArrivalIdentity", V(0, 16.5, -120.9), V(31, 2, .5), dark)
	text(plate, "ARK  /  ARRIVAL BAY 01", Enum.NormalId.Back)
	text(plate, "ARK  /  ARRIVAL BAY 01", Enum.NormalId.Front)
	bay:SetAttribute("DeckPhaseComplete", true)
elseif phase == 2 then
	assert(bay and bay:GetAttribute("DeckPhaseComplete"), "Build the docking deck first")
	assert(not bay:FindFirstChild("DockedShuttle"), "Shuttle already installed")
	local source = game.ServerStorage.SpaceArtSourceAssets.ArrivalShuttleSource
	local _, size = source:GetBoundingBox()
	local shuttle = install(source, bay, "DockedShuttle", 0, 2.04, -161, 48 / size.Z, 0)
	shuttle:SetAttribute("CreatorStoreAsset", "125245019220487")
	shuttle:SetAttribute("VesselName", "ARK-01 / EXCURSION SHUTTLE")
	local n = 0
	for _, p in shuttle:GetDescendants() do
		if p:IsA("BasePart") then
			local c = p.Color; local high = math.max(c.R, c.G, c.B)
			if p.Material == Enum.Material.Glass then
				p.Color = C(48, 77, 94); p.Transparency = math.min(p.Transparency, .32)
			elseif high < .12 then p.Color = C(55, 65, 79)
			elseif high < .26 then p.Color = C(99, 112, 128)
			elseif c.R > .5 and c.G > .3 and c.B < .35 then p.Color = ochre
			elseif c.R > .5 and c.G < .25 then p.Color = teal
			end
			n += 1
			if n % 400 == 0 then task.wait() end
		end
	end
	local access = model(bay, "BoardingAccess")
	-- Walkable ramp: low endpoint touches deck at Y=2; high endpoint is Y=6.8.
	local run, rise, thickness = 13.2, 4.8, .35
	local angle = math.atan2(rise, run)
	local length = math.sqrt(run * run + rise * rise)
	local centerY = 4.4 - thickness * math.cos(angle) / 2
	local ramp = box(access, "BoardingRamp", V(0, centerY, -129.6), V(8, thickness, length), C(155, 167, 176), Enum.Material.Metal, nil, CFrame.Angles(angle, 0, 0))
	ramp.MaterialVariant = "SA_StationDeck_TractionSteel"
	for _, side in {-1, 1} do
		local rail = box(access, "RampHandrail_" .. side, V(side * 4.35, 6.5, -129.6), V(.25, .25, length), trim, nil, nil, CFrame.Angles(angle, 0, 0))
		for i = 0, 2 do
			local z = -123 - i * 6.6; local floorY = 2 + i * 2.4
			box(access, "RampPost_" .. side .. "_" .. i, V(side * 4.35, floorY + 1.05, z), V(.25, 2.1, .25), trim)
		end
	end
	local dock = box(access, "BoardingThreshold", V(0, 6.625, -136.7), V(8, .35, 1), trim)
	dock.MaterialVariant = "SA_StationDeck_TractionSteel"
	local door = box(access, "ShuttleAccessDoor", V(0, 9.9, -137.35), V(7, 6.2, .3), dark)
	local identity = box(access, "ShuttleIdentity", V(0, 13.35, -137.35), V(11, .8, .35), dark)
	text(identity, "ARK-01  /  EXCURSION SHUTTLE", Enum.NormalId.Back)
	bay:SetAttribute("ShuttlePhaseComplete", true)
elseif phase == 3 then
	assert(bay and bay:GetAttribute("ShuttlePhaseComplete"), "Install shuttle first")
	assert(not bay:FindFirstChild("FlightDeckEquipment"), "Details already installed")
	local equipment = model(bay, "FlightDeckEquipment")
	for _, side in {-1, 1} do
		for _, z in {-144, -181} do
			box(equipment, "LightMast_" .. side .. "_" .. z, V(side * 36, 13, z), V(.7, 22, .7), steel)
			box(equipment, "LightFoot_" .. side .. "_" .. z, V(side * 36, 2.3, z), V(2, .6, 2), dark)
			box(equipment, "LightArm_" .. side .. "_" .. z, V(side * 33.2, 24.3, z), V(6.3, .6, .8), steel)
			local lamp = box(equipment, "Floodlight_" .. side .. "_" .. z, V(side * 30.8, 23.8, z), V(3.2, .4, 2.4), C(220, 230, 225), Enum.Material.SmoothPlastic)
			local light = Instance.new("SurfaceLight"); light.Face = Enum.NormalId.Bottom
			light.Color = C(221, 231, 239); light.Brightness = .55; light.Range = 50
			light.Angle = 120; light.Shadows = false; light.Parent = lamp
		end
		-- Perimeter protection; gaps remain at the carrier connection.
		for i = 0, 5 do
			box(equipment, "EdgePost_" .. side .. "_" .. i, V(side * 40, 3.65, -125 - i * 13.4), V(.35, 3.3, .35), steel)
		end
		for _, y in {3.1, 4.5} do box(equipment, "SideGuardrail_" .. side .. "_" .. y, V(side * 40, y, -158.5), V(.25, .25, 67), trim) end
		-- Guide marks sit cleanly above the deck; no embedded geometry.
		for i = 0, 7 do box(equipment, "LandingGuide_" .. side .. "_" .. i, V(side * 22, 2.012, -141 - i * 6), V(.3, .024, 3), ochre) end
		for _, z in {-139, -190} do box(equipment, "LandingCorner_" .. side .. "_" .. z, V(side * 18, 2.012, z), V(8, .024, .3), ochre) end
	end
	local aftRail = box(equipment, "OuterGuardrail", V(0, 4.5, -195), V(79.6, .25, .25), trim)
	for _, x in {-39.8, -20, 0, 20, 39.8} do box(equipment, "OuterEdgePost_" .. x, V(x, 3.65, -195), V(.35, 3.3, .35), steel) end
	local props = game.ServerStorage.SpaceArtSourceAssets.BeyondTheDark_Props
	install(props["Crates and Boxes"].CargoCrate4x2x4, equipment, "CargoPallet_Port", -29, 2, -129, 1.15, 0)
	install(props["Crates and Boxes"].CargoCrate4x4, equipment, "CargoPallet_Starboard", 28, 2, -130, .9, 15)
	install(props.Kiosks.StandaloneKiosk_A, equipment, "ArrivalControlTerminal", 27, 2, -118, 1, 0)
	local sign = box(equipment, "GroundCrewSign", V(-27, 4.3, -124.2), V(8, 2, .25), dark)
	text(sign, "01  /  GROUND SERVICES", Enum.NormalId.Back)
	local welcome = box(equipment, "WelcomeFloorMark", V(13, 2.012, -126), V(12, .024, 4), dark)
	text(welcome, "ARK / 01", Enum.NormalId.Top)
	bay:SetAttribute("DetailsPhaseComplete", true)
	game:GetService("ChangeHistoryService"):SetWaypoint("ARK arrival bay and docked shuttle")
end
return {phase = phase, model = bay:GetFullName()}

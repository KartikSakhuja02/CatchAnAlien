-- Editor-only. The ARK conversion/reparenting runs before this file.
-- Run local INTERIOR_PHASE=1, then 2.
local phase = INTERIOR_PHASE or 1
local hub = workspace.SpaceWorld.SpawnHub
local ark = assert(hub:FindFirstChild("ARKShip"), "Convert the docked craft first")
local sources = game.ServerStorage.SpaceArtSourceAssets
local props, arch = sources.BeyondTheDark_Props, sources.BeyondTheDark_Architecture
local backup = game.ServerStorage.ARKSpawnConversionBackup
local V, C = Vector3.new, Color3.fromRGB
local dark, steel, pale = C(34, 46, 57), C(105, 122, 135), C(171, 187, 192)
local interior = ark:FindFirstChild("Interior")
local function group(parent, name)
	local m = Instance.new("Model"); m.Name = name; m:SetAttribute("ArtAssembly", true); m.Parent = parent; return m
end
local function box(parent, name, pos, size, color, material, rotation)
	local p = Instance.new("Part"); p.Name = name; p.Size = size
	p.CFrame = CFrame.new(pos) * (rotation or CFrame.identity)
	p.Color = color or steel; p.Material = material or Enum.Material.Metal
	p.Anchored = true; p.CanCollide = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent; return p
end
local function install(source, parent, name, x, bottom, z, scale, yaw)
	local m = Instance.new("Model"); m.Name = name; m:SetAttribute("ArtAssembly", true)
	m:SetAttribute("StaticImportedArt", true)
	local copy = source:Clone(); copy.Parent = m
	for _, p in m:GetDescendants() do
		if p:IsA("LuaSourceContainer") or p:IsA("Humanoid") or p:IsA("AnimationController")
			or p:IsA("ProximityPrompt") or p:IsA("ClickDetector") or p:IsA("Sound")
			or p:IsA("ParticleEmitter") or p:IsA("Trail") or p:IsA("Beam") then p:Destroy()
		elseif p:IsA("BasePart") then
			p.Anchored = true; p.CanCollide = true
			if p:IsA("Seat") or p:IsA("VehicleSeat") then p.Disabled = true end
			if p.Material == Enum.Material.Neon then p.Material = Enum.Material.SmoothPlastic end
		elseif p:IsA("Light") then p.Enabled = false end
	end
	if scale ~= 1 then m:ScaleTo(m:GetScale() * scale) end
	local cf, size = m:GetBoundingBox()
	m:PivotTo(CFrame.new(x, bottom + size.Y / 2, z) * CFrame.Angles(0, math.rad(yaw or 0), 0) * cf:Inverse() * m:GetPivot())
	m.Parent = parent; return m
end
local function label(part, words, face)
	local g = Instance.new("SurfaceGui"); g.Name = "ShipMarking"; g.Face = face or Enum.NormalId.Front
	g.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; g.PixelsPerStud = 45; g.LightInfluence = .35; g.Parent = part
	local t = Instance.new("TextLabel"); t.Size = UDim2.fromScale(.92, .8); t.Position = UDim2.fromScale(.04, .1)
	t.BackgroundTransparency = 1; t.Font = Enum.Font.GothamMedium; t.TextScaled = true; t.TextColor3 = C(200, 222, 220)
	t.Text = words; t.Parent = g
end
local function floor(name, x, z, sx, sz, top)
	local p = box(interior, name, V(x, top - .05, z), V(sx, .1, sz), C(131, 146, 156))
	p.MaterialVariant = "SA_StationDeck_TractionSteel"; return p
end

if phase == 1 then
	assert(not interior, "Interior already exists")
	interior = group(ark, "Interior")
	-- Recess the spawn pad into four surrounding floor sections.
	floor("CabinFloor_Port", -5.95, -179, 5.9, 18, 7.4)
	floor("CabinFloor_Starboard", 5.95, -179, 5.9, 18, 7.4)
	floor("CabinFloor_Forward", 0, -185, 6, 6, 7.4)
	floor("CabinFloor_Aft", 0, -173, 6, 6, 7.4)
	local spawn = hub.SharedSpawn
	spawn.Size = V(6, .1, 6); spawn.CFrame = CFrame.lookAt(V(0, 7.35, -179), V(0, 7.35, -178))
	spawn.Anchored = true; spawn.CanCollide = true; spawn.Enabled = true; spawn.Neutral = true
	spawn.Duration = 0; spawn.AllowTeamChangeOnTouch = false; spawn.Transparency = 0
	spawn.Color = C(137, 157, 164); spawn.Material = Enum.Material.Metal; spawn.MaterialVariant = "SA_StationDeck_TractionSteel"
	for _, p in spawn:GetChildren() do if p:IsA("Decal") or p:IsA("SurfaceGui") then p.Parent = backup end end
	spawn:SetAttribute("SpawnVessel", "ARKShip")
	for _, side in {-1, 1} do
		for _, z in {-183.8, -175.8} do
			install(arch.Walls.Wall_Panel_A_Dark, interior, "CabinLiner_" .. side .. "_" .. z, side * 8.9, 7.4, z, .45, side * 90)
		end
		box(interior, "CabinEdgeCeiling_" .. side, V(side * 5.5, 15.2, -179), V(5.3, .2, 18), dark, nil, CFrame.Angles(0, 0, math.rad(-side * 17)))
	end
	box(interior, "CabinCentralCeiling", V(0, 15.95, -179), V(6, .2, 18), dark)
	floor("AftCompanionwayFloor", 0, -156.5, 6.4, 27, 7.4)
	for _, side in {-1, 1} do
		box(interior, "CompanionwayWall_" .. side, V(side * 3.35, 11, -156), V(.3, 7.2, 26), steel)
	end
	box(interior, "CompanionwayCeiling", V(0, 14.7, -156), V(7, .2, 26), dark)
	floor("CockpitFloor", 0, -195, 12, 10, 9.5)
	for i = 1, 3 do
		local top = 7.4 + i * .7
		local z = -188 - (i - .5) * .8
		box(interior, "CockpitStep_" .. i, V(0, (7.1 + top) / 2, z), V(6, top - 7.1, .8), steel)
	end
	local oldEquipment = hub.Spacecraft.VesselEquipment
	for _, n in {"AftArrivalDeck", "AftHull"} do local p = oldEquipment:FindFirstChild(n); if p then p.Parent = backup end end
	local gangway = group(ark, "HubGangway")
	local run, thickness = 43.1, .3
	local angle = math.atan2(5.4 - thickness, run)
	for _ = 1, 3 do angle = math.atan2(5.4 - thickness * math.cos(angle), run) end
	local rise = 5.4 - thickness * math.cos(angle)
	local length = math.sqrt(run * run + rise * rise)
	local z = -121.55 - thickness * math.sin(angle) / 2
	local p = box(gangway, "SlopedDockingBridge", V(0, 4.7, z), V(7, thickness, length), steel, nil, CFrame.Angles(angle, 0, 0))
	p.MaterialVariant = "SA_StationDeck_TractionSteel"
	for _, side in {-1, 1} do
		box(gangway, "GangwayRail_" .. side, V(side * 3.3, 6.8, z), V(.2, .2, length), pale, nil, CFrame.Angles(angle, 0, 0))
		for i = 0, 5 do
			local f = i / 5; local yy = 7.4 - rise * f; local zz = -143.1 + run * f
			box(gangway, "GangwayPost_" .. side .. "_" .. i, V(side * 3.3, yy + 1.05, zz), V(.2, 2.1, .2), pale)
		end
	end
	local header = box(interior, "ExitIdentity", V(0, 14, -143.05), V(6.4, .8, .2), dark)
	label(header, "HUB ACCESS  →", Enum.NormalId.Front)
	interior:SetAttribute("StructureComplete", true)
elseif phase == 2 then
	assert(interior and interior:GetAttribute("StructureComplete"), "Build interior first")
	assert(not interior:GetAttribute("Furnished"), "Already furnished")
	for _, side in {-1, 1} do
		for _, z in {-183.5, -174} do
			install(props.Seating.ArmChair, interior, "CrewSeat_" .. side .. "_" .. z, side * 5.6, 7.4, z, 1, side * 90)
		end
		install(props.Seating.ArmChair, interior, "PilotSeat_" .. side, side * 2.6, 9.5, -192.2, .9, 0)
		local x = side * 2.8
		box(interior, "ConsolePedestal_" .. side, V(x, 10.3, -197), V(2, 1.6, 1.25), dark)
		box(interior, "ConsoleDesktop_" .. side, V(x, 11.2, -197), V(3.6, .2, 2), steel)
		install(props.Kiosks.DeskTop_Kiosk, interior, "NavigationConsole_" .. side, x, 11.3, -197, 1, 0)
	end
	install(props["Crates and Boxes"].CargoCrate2x1x4, interior, "CrewSupplyCase", -6.9, 7.4, -178.5, .8, 0)
	install(arch.Walls["Wall_add-ons"].EmergencySuitLocker01, interior, "CrewEquipmentLocker", 6.8, 7.4, -178.5, .3, 90)
	install(arch.Walls["Wall_add-ons"].EmergencyKit, interior, "MedicalSupplyCabinet", -7.6, 8.5, -172, .28, -90)
	for _, z in {-184, -178, -172} do for _, side in {-1, 1} do
		local lamp = box(interior, "CabinLuminaire_" .. side .. "_" .. z, V(side * 3.5, 15.65, z), V(.55, .12, 2.6), C(221, 235, 228), Enum.Material.Neon)
		local light = Instance.new("SurfaceLight"); light.Face = Enum.NormalId.Bottom; light.Brightness = .35
		light.Range = 17; light.Angle = 130; light.Color = C(218, 231, 227); light.Shadows = false; light.Parent = lamp
	end end
	for _, z in {-165, -153} do
		local lamp = box(interior, "CompanionwayLuminaire_" .. z, V(0, 14.5, z), V(2.5, .12, .7), C(216, 231, 227), Enum.Material.Neon)
		local light = Instance.new("SurfaceLight"); light.Face = Enum.NormalId.Bottom; light.Brightness = .45
		light.Range = 16; light.Angle = 130; light.Shadows = false; light.Parent = lamp
	end
	local plate = box(interior, "ARKCabinIdentity", V(0, 14.8, -188), V(7, .8, .2), dark)
	label(plate, "ARK  /  CREW TRANSPORT", Enum.NormalId.Back)
	interior:SetAttribute("Furnished", true)
	game:GetService("ChangeHistoryService"):SetWaypoint("ARK interior and native player spawn")
end
return {phase = phase, interior = interior:GetFullName(), spawn = tostring(hub.SharedSpawn.Position)}

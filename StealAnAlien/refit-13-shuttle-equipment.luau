-- Editor-only authoring. Run local DETAIL_PHASE=1, then 2.
local phase = DETAIL_PHASE or 1
local bay = workspace.SpaceWorld.SpawnHub.ArrivalDock
local ship = bay.DockedShuttle
local sources = game.ServerStorage.SpaceArtSourceAssets
local props, arch = sources.BeyondTheDark_Props, sources.BeyondTheDark_Architecture
local V, C = Vector3.new, Color3.fromRGB
local dark, pale, steel = C(41, 52, 65), C(161, 177, 184), C(107, 125, 139)
local ray = RaycastParams.new(); ray.FilterType = Enum.RaycastFilterType.Include; ray.FilterDescendantsInstances = {ship}
local exterior = bay:FindFirstChild("ShuttleExterior")
local function group(parent, name)
	local m = Instance.new("Model"); m.Name = name; m:SetAttribute("ArtAssembly", true); m.Parent = parent; return m
end
local function box(parent, name, pos, size, color, material, rotation, shape)
	local p = Instance.new("Part"); p.Name = name; p.Size = size
	p.CFrame = CFrame.new(pos) * (rotation or CFrame.identity)
	p.Color = color or steel; p.Material = material or Enum.Material.Metal
	p.Anchored = true; p.CanCollide = true; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent; return p
end
local function dimensions(m)
	local low, high = V(math.huge, math.huge, math.huge), V(-math.huge, -math.huge, -math.huge)
	for _, p in m:GetDescendants() do if p:IsA("BasePart") then
		for _, x in {-1, 1} do for _, y in {-1, 1} do for _, z in {-1, 1} do
			local q = p.CFrame:PointToWorldSpace(p.Size * V(x, y, z) / 2)
			low = V(math.min(low.X, q.X), math.min(low.Y, q.Y), math.min(low.Z, q.Z))
			high = V(math.max(high.X, q.X), math.max(high.Y, q.Y), math.max(high.Z, q.Z))
		end end end
	end end
	return low, high
end
local function asset(source, name, scale, rotation)
	local m = Instance.new("Model"); m.Name = name; m:SetAttribute("ArtAssembly", true)
	m:SetAttribute("StaticImportedArt", true); m:SetAttribute("ArtSource", source:GetFullName())
	local copy = source:Clone(); copy.Parent = m
	for _, p in m:GetDescendants() do
		if p:IsA("LuaSourceContainer") or p:IsA("Humanoid") or p:IsA("AnimationController")
			or p:IsA("ProximityPrompt") or p:IsA("ClickDetector") or p:IsA("Sound")
			or p:IsA("ParticleEmitter") or p:IsA("Beam") or p:IsA("Trail") then p:Destroy()
		elseif p:IsA("BasePart") then
			p.Anchored = true; p.CanCollide = true
			if p:IsA("Seat") or p:IsA("VehicleSeat") then p.Disabled = true end
			if p:IsA("MeshPart") then p.CollisionFidelity = Enum.CollisionFidelity.PreciseConvexDecomposition end
			if p.Material == Enum.Material.Neon then p.Material = Enum.Material.SmoothPlastic end
		elseif p:IsA("Light") then p.Enabled = false end
	end
	if scale ~= 1 then m:ScaleTo(m:GetScale() * scale) end
	local cf = m:GetBoundingBox()
	m:PivotTo((rotation or CFrame.identity) * cf:Inverse() * m:GetPivot())
	return m
end
local function ground(source, name, x, bottom, z, scale, yaw, parent)
	local m = asset(source, name, scale, CFrame.Angles(0, math.rad(yaw or 0), 0))
	local low, high = dimensions(m); local center = (low + high) / 2
	m:PivotTo(CFrame.new(x - center.X, bottom - low.Y, z - center.Z) * m:GetPivot())
	m.Parent = parent
	return m, high - low
end
local function hit(x, z)
	return workspace:Raycast(V(x, 45, z), V(0, -60, 0), ray)
end
local function mounts(parent, x, z, width, depth)
	local samples = {}; local highest = -math.huge
	local wx, dz = math.max(.15, width / 2 - .16), math.max(.15, depth / 2 - .16)
	for _, dx in {-wx, -wx / 2, 0, wx / 2, wx} do for _, offset in {-dz, -dz / 2, 0, dz / 2, dz} do
		local h = hit(x + dx, z + offset)
		if h then highest = math.max(highest, h.Position.Y); table.insert(samples, {dx, offset, h.Position.Y}) end
	end end
	assert(#samples >= 5, "Not enough hull surface beneath " .. parent.Name)
	local bottom = highest + .2
	for _, dx in {-wx, wx} do for _, offset in {-dz, dz} do
		local h = hit(x + dx, z + offset)
		if h then
			local localHigh = h.Position.Y
			for _, ex in {-.085, .085} do for _, ez in {-.085, .085} do
				local edge = hit(x + dx + ex, z + offset + ez)
				if edge then localHigh = math.max(localHigh, edge.Position.Y) end
			end end
			local y = localHigh + .06; local height = bottom - y
			if height >= .05 then box(parent, "HullMountFoot", V(x + dx, y + height / 2, z + offset), V(.17, height, .17), dark) end
		end
	end end
	local plate = box(parent, "EquipmentMount", V(x, bottom + .09, z), V(width, .18, depth), dark)
	plate.MaterialVariant = "SA_StationDeck_BrushedSteel"
	parent:SetAttribute("HullMounted", true)
	return bottom + .18
end
local function roof(source, name, x, z, scale, rotation)
	local m = asset(source, name, scale, rotation)
	local low, high = dimensions(m); local size = high - low
	local top = mounts(m, x, z, size.X + .25, size.Z + .25)
	-- Mount geometry was created at world coordinates, so place the asset clone alone.
	local imported = m:GetChildren()[1]
	local carrier = Instance.new("Model"); imported.Parent = carrier
	local ilow, ihigh = dimensions(carrier); local center = (ilow + ihigh) / 2
	carrier:PivotTo(CFrame.new(x - center.X, top - ilow.Y, z - center.Z) * carrier:GetPivot())
	imported.Parent = m; carrier:Destroy()
	m.Parent = exterior; return m
end

if phase == 1 then
	assert(not exterior, "Shuttle exterior pass already exists")
	exterior = group(bay, "ShuttleExterior")
	for _, side in {-1, 1} do
		roof(props.AC_Unit, "LifeSupportUnit_" .. side, side * 3, -163, .75)
		roof(arch.Walls["Wall_add-ons"].Lobby_Vent, "EngineCoolingGrille_" .. side, side * 6, -176, .65, CFrame.Angles(math.pi / 2, 0, 0))
		roof(props.Pipes.Pipe_Insulated_B, "ExternalCoolantLine_" .. side, side * 3, -158.2, .35, CFrame.Angles(math.pi / 2, 0, 0))
		roof(props["Crates and Boxes"].CargoCrate2x1x4, "ExternalSupplyCase_" .. side, side * 6, -153, .75)
	end
	roof(arch.Catwalk.FloorPanelC_Dark, "DorsalServiceHatch", 0, -158, .32)
	for _, p in ship:GetDescendants() do if p:IsA("BasePart") and not p:IsA("MeshPart") and p.Material == Enum.Material.Metal then
		local s = p.Size
		if math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 24 then p.MaterialVariant = "SA_StationDeck_BrushedSteel" end
	end end
	exterior:SetAttribute("SystemsComplete", true)
elseif phase == 2 then
	assert(exterior and exterior:GetAttribute("SystemsComplete"), "Fit hull systems first")
	assert(not exterior:GetAttribute("DetailsComplete"), "Details already installed")
	local antenna = group(exterior, "CommunicationsArray")
	local top = mounts(antenna, 0, -151.5, 1.9, 1.9)
	box(antenna, "MastPlinth", V(0, top + .25, -151.5), V(1.4, .5, 1.4), pale)
	box(antenna, "AntennaMast", V(0, top + 2.3, -151.5), V(.18, 3.6, .18), pale)
	box(antenna, "ArrayCrossbar", V(0, top + 4.2, -151.5), V(3.5, .2, .35), dark)
	for _, side in {-1, 1} do
		box(antenna, "Receiver_" .. side, V(side * 1.5, top + 4.8, -151.5), V(.35, 1, .6), pale)
	end
	local sensor = group(exterior, "ForwardSensorRadome")
	local sensorTop = mounts(sensor, 0, -170.5, 2.4, 2.4)
	box(sensor, "RadomeBase", V(0, sensorTop + .15, -170.5), V(2.15, .3, 2.15), steel)
	box(sensor, "SensorDome", V(0, sensorTop + 1.1, -170.5), V(1.9, 1.6, 1.9), pale, Enum.Material.SmoothPlastic, nil, Enum.PartType.Ball)
	for _, side in {-1, 1} do
		local nav = group(exterior, "NavigationLamp_" .. side)
		local y = mounts(nav, side * 13, -154, .8, .8)
		box(nav, "LampHousing", V(side * 13, y + .12, -154), V(.65, .24, .65), dark)
		box(nav, "NavigationLens", V(side * 13, y + .29, -154), V(.43, .1, .43), side == -1 and C(188, 94, 86) or C(104, 174, 180), Enum.Material.Neon)
	end
	local service = group(bay, "ShuttleGroundServices")
	for _, side in {-1, 1} do
		local x, z = side * 28, side == -1 and -169 or -157
		local pallet, size = ground(props["Crates and Boxes"].CargoCrate_Pallete_4x4, "CargoPallet_" .. side, x, 2, z, 1.4, 0, service)
		ground(props["Crates and Boxes"].CargoCrate4x2x4, "SpareSystemsCrate_" .. side, x, 2 + size.Y, z, 1.25, 0, service)
		ground(props["Crates and Boxes"].CargoCrate1x1x4, "ToolCase_" .. side, x + side * 5, 2, z + 3, 1, 90, service)
	end
	ground(arch.Walls["Wall_add-ons"].Canister_Recharge, "ServiceCanisterRack", -29, 2, -151, .85, 0, service)
	ground(props.AC_Unit, "GroundPowerCabinet", 27, 2, -180, 1.2, 0, service)
	ground(arch.Walls["Wall_add-ons"].EmergencyKit, "DocksideFirstAid", 34, 2, -131, .65, 0, service)
	exterior:SetAttribute("DetailsComplete", true)
	game:GetService("ChangeHistoryService"):SetWaypoint("ARK shuttle exterior systems and service equipment")
end
return {phase = phase, hullModules = #exterior:GetChildren()}

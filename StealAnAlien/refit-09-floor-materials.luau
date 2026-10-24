-- Editor-only surface authoring. Supply local FLOOR_BATCH before this file.
-- Existing dimensions, transforms and collision behavior are preserved.
local root = workspace.SpaceWorld
local service = game:GetService("MaterialService")
local batch = FLOOR_BATCH or "Hub"
local C = Color3.fromRGB

local function generated(name, tile, candidate)
	candidate = candidate or 0
	local candidates = service.AssistantMaterials:FindFirstChild("Material: " .. name)
	assert(candidates, "Missing generated material family: " .. name)
	local original = candidates:FindFirstChild(name .. (candidate > 0 and tostring(candidate) or ""))
	assert(original and original:IsA("MaterialVariant"), "Missing material candidate: " .. name)
	local activeName = "SA_" .. name
	local active = service:FindFirstChild(activeName)
	if not active then
		active = original:Clone()
		active.Name = activeName
		active.Parent = service
	end
	if active:GetAttribute("GeneratedCandidate") ~= candidate then
		for _, property in {"ColorMap", "NormalMap", "RoughnessMap", "MetalnessMap"} do
			active[property] = original[property]
		end
		active:SetAttribute("GeneratedCandidate", candidate)
	end
	active.StudsPerTile = tile
	active:SetAttribute("FloorSurfacePass", true)
	return active
end

local count = 0
local function surface(part, variant, tint)
	assert(part:IsA("BasePart") and part.Anchored and part.CanCollide)
	if not part:GetAttribute("FloorSurfacePass") then
		part:SetAttribute("FloorOriginalMaterial", part.Material.Name)
		part:SetAttribute("FloorOriginalVariant", part.MaterialVariant)
		part:SetAttribute("FloorOriginalColor", part.Color)
		-- The surface pass must not silently make snow/ice decks slippery.
		part.CustomPhysicalProperties = part.CurrentPhysicalProperties
	end
	part.Material = variant.BaseMaterial
	part.MaterialVariant = variant.Name
	part.Color = tint
	part.Reflectance = 0
	part:SetAttribute("FloorSurfacePass", true)
	count += 1
end

local function referenceSteel(name, tile, color, normal, roughness, metalness)
	local v = service:FindFirstChild(name)
	if not v then
		v = Instance.new("MaterialVariant")
		v.Name = name
		v.BaseMaterial = Enum.Material.Metal
		v.MaterialPattern = Enum.MaterialPattern.Regular
		v.ColorMap = "rbxassetid://" .. color
		v.NormalMap = "rbxassetid://" .. normal
		v.RoughnessMap = "rbxassetid://" .. roughness
		v.MetalnessMap = "rbxassetid://" .. metalness
		v.Parent = service
	end
	v.StudsPerTile = tile
	v:SetAttribute("FloorSurfacePass", true)
	return v
end
-- Published Roblox PBR reference maps; subtler than the generated steel.
local steel = referenceSteel("SA_StationDeck_BrushedSteel", 4,
	"9920574687", "9873295432", "9873318890", "9873318201")
local traction = referenceSteel("SA_StationDeck_TractionSteel", 3,
	"10237720195", "9438583222", "9438583558", "9438583347")
if batch == "Hub" then
	local deck = root.SpawnHub.HubStructure.EngineeredWalkingDeck
	for _, name in {"PortDeck", "StarboardDeck"} do
		surface(deck[name], steel, C(188, 196, 201))
	end
	surface(root.SpawnHub.SharedSpawn, traction, C(190, 201, 207))
	for _, plot in root.PlayerBases:GetChildren() do
		surface(plot.PlotPlatform, traction, C(180, 190, 196))
		for _, part in plot:GetDescendants() do
			if part:IsA("BasePart") and part.Name == "HabitatFloor" then
				surface(part, steel, C(180, 190, 196))
			end
		end
	end
elseif batch == "Connections" then
	for _, bridge in root.ProgressionRoute:GetChildren() do
		local floor = bridge:FindFirstChild("WalkingDeck")
		if floor then surface(floor, traction, C(188, 198, 204)) end
	end
	for _, world in root.Worlds:GetChildren() do
		local cap = world.EngineeredWalkingDeck:FindFirstChild("DockEdgeCap")
		if cap then surface(cap, steel, C(208, 216, 222)) end
	end
else
	local configs = {
		Lunar = {"World_01_LunarOutpost", "LunarRegolith_Fine", 9, C(244, 244, 240)},
		Rust = {"World_02_RustMoon", "RustMoon_IronDust", 10, C(232, 221, 208)},
		Xeno = {"World_03_Xenoforest", "Xenoforest_MossSoil", 5, C(160, 178, 151)},
		Cryo = {"World_04_CryoMoon", "CryoMoon_FrostedGround", 5, C(225, 230, 235), 2},
		Basalt = {"World_05_BasaltRift", "BasaltRift_WeatheredLava", 6, C(238, 239, 240)},
		Void = {"World_06_VoidArchive", "VoidArchive_WeatheredStone", 12, C(222, 224, 240)},
	}
	local spec = assert(configs[batch], "Unknown floor batch: " .. batch)
	local variant = generated(spec[2], spec[3], spec[5])
	local deck = root.Worlds[spec[1]].EngineeredWalkingDeck
	for _, name in {"PortDeck", "StarboardDeck"} do
		surface(deck[name], variant, spec[4])
	end
end

return {batch = batch, changedSurfaces = count, geometryChanged = false}

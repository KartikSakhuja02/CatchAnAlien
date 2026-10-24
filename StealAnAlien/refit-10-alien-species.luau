-- Editor-only authoring. Supply local ALIEN_FAMILY before this file.
local family = assert(ALIEN_FAMILY, "Select a world species")
local sources = game.ServerStorage.SpaceArtSourceAssets.AlienSpecies
local root = workspace.SpaceWorld.CollectionProps
local C, V = Color3.fromRGB, Vector3.new
local configs = {
	Lunar = {height = 4.2, variants = {
		{"LUNAR SCOUT", C(242, 246, 255), 1.00},
		{"DUST DRIFTER", C(244, 223, 195), 1.08},
		{"MOONLING", C(223, 241, 218), 0.82},
	}},
	Rust = {height = 3.7, variants = {
		{"RUST BURROWER", C(237, 205, 183), 1.04},
		{"ORE SIFTER", C(189, 207, 224), 0.91},
		{"COPPER CRAWLER", C(255, 224, 169), 1.00},
	}},
	Xeno = {height = 4.3, variants = {
		{"CANOPY WANDERER", C(200, 235, 188), 1.00},
		{"MOSS STRIDER", C(167, 226, 208), 0.90},
		{"SEED KEEPER", C(255, 207, 157), 1.05},
	}},
	Cryo = {height = 3.8, variants = {
		{"FROSTLING", C(241, 248, 255), 0.88},
		{"ICE GRAZER", C(181, 220, 249), 1.07},
		{"SNOW SENTINEL", C(220, 224, 238), 1.00},
	}},
	Basalt = {height = 4.1, variants = {
		{"ASH WALKER", C(115, 126, 143), 0.90},
		{"BASALT KEEPER", C(143, 117, 94), 1.07},
		{"RIFT GRAZER", C(109, 134, 114), 1.00},
	}},
	Void = {height = 4.2, variants = {
		{"ARCHIVE WITNESS", C(136, 112, 180), 1.00},
		{"ECHO KEEPER", C(91, 151, 191), 0.89},
		{"VOID SCRIBE", C(182, 123, 161), 1.06},
	}},
}
local config = assert(configs[family], "Unknown family")
local source = assert(sources:FindFirstChild(family .. "Source"), "Missing species source")
local result = {}
for index, spec in config.variants do
	local site = root[family .. "Specimens"][string.format("AlienNest_%s_%02d", family, index)]
	local sourceModel = Instance.new("Model")
	sourceModel.Name = "SpecimenFigure"
	sourceModel:SetAttribute("SpeciesFamily", family)
	sourceModel:SetAttribute("SpecimenType", spec[1])
	sourceModel:SetAttribute("FinishVariant", index)
	sourceModel:SetAttribute("StaticImportedArt", true)
	sourceModel:SetAttribute("ArtAssembly", true)
	local clone = source:Clone()
	clone.Parent = sourceModel
	for _, item in sourceModel:GetDescendants() do
		if item:IsA("LuaSourceContainer") or item:IsA("Humanoid") or item:IsA("AnimationController")
			or item:IsA("ProximityPrompt") or item:IsA("ClickDetector") then
			item:Destroy()
		elseif item:IsA("BasePart") then
			item.Anchored = true
			item.CanCollide = true
			item.Material = Enum.Material.SmoothPlastic
			item.Color = spec[2]
			if item:IsA("MeshPart") then
				item.CollisionFidelity = Enum.CollisionFidelity.PreciseConvexDecomposition
				item.RenderFidelity = Enum.RenderFidelity.Automatic
			end
		elseif item:IsA("SurfaceAppearance") then
			item.Color = spec[2]
		elseif item:IsA("Light") then
			item.Enabled = false
		end
	end
	local _, size = sourceModel:GetBoundingBox()
	local scale = math.min(config.height * spec[3] / size.Y, 4.8 * spec[3] / size.X, 4.8 * spec[3] / size.Z)
	sourceModel:ScaleTo(sourceModel:GetScale() * scale)
	local cf, finalSize = sourceModel:GetBoundingBox()
	local pedestal = site.ContainmentPedestal
	local top = pedestal.Position.Y + pedestal.Size.Y / 2
	local destination = CFrame.new(pedestal.Position.X, top + finalSize.Y / 2, pedestal.Position.Z)
	sourceModel:PivotTo(destination * cf:Inverse() * sourceModel:GetPivot())
	local old = site:FindFirstChild("SpecimenFigure")
	if old then old:Destroy() end -- originals are preserved in ServerStorage.AlienSpeciesBackup
	sourceModel.Parent = site
	site.SpecimenSign.Identification.Label.Text = spec[1]
	site:SetAttribute("SpeciesFamily", family)
	table.insert(result, {specimen = spec[1], size = {finalSize.X, finalSize.Y, finalSize.Z}, feetY = top})
	task.wait()
end
return {family = family, installed = result}

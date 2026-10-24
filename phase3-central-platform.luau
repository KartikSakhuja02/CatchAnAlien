-- Phase 3A: core platform and perimeter ring. Studio Edit mode only.
local history = game:GetService("ChangeHistoryService")
local nest = workspace.SpaceWorld.CentralNest
assert(#nest:GetChildren() == 0, "CentralNest must be empty before initial build")
history:SetWaypoint("Before Central Cosmic Nest")
local backup = game:GetService("ServerStorage"):FindFirstChild("SpaceWorldSetupBackup")
assert(backup, "Setup backup folder missing")
local spawn = workspace:FindFirstChild("SpawnLocation")
if spawn and spawn:IsA("SpawnLocation") then spawn.Parent = backup end
local model = Instance.new("Model")
model.Name = "CorePlatform"
local function part(name, size, cf, material, color, parent)
 local p=Instance.new("Part")
 p.Name=name; p.Size=size; p.CFrame=cf; p.Material=material; p.Color=color
 p.Anchored=true; p.CanCollide=true
 p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent
 return p
end
-- Roblox cylinders use local X as their axis: rotation yields an 80 x 4 x 80 world footprint.
local core=part("MainCorePlatform", Vector3.new(4,80,80), CFrame.new(0,0,0)*CFrame.Angles(0,0,math.pi/2), Enum.Material.Metal, BrickColor.new("Dark stone grey").Color, model)
core.Shape=Enum.PartType.Cylinder
core:SetAttribute("WorldFootprint",Vector3.new(80,4,80))
local ring=Instance.new("Folder"); ring.Name="CyanOuterRing"; ring.Parent=model
local radius=40.65
local segmentCount=96
-- Narrow expansion joints keep neighbouring ring blocks from intersecting.
local length=2*(radius-0.3)*math.tan(math.pi/segmentCount)-0.04
for i=1,segmentCount do
 local theta=(i-1)*2*math.pi/segmentCount
 local position=Vector3.new(radius*math.cos(theta),1.75,radius*math.sin(theta))
 part(string.format("RingSegment_%02d",i),Vector3.new(length,0.5,0.6),CFrame.lookAt(position,Vector3.new(0,position.Y,0)),Enum.Material.Neon,Color3.fromRGB(0,225,255),ring)
end
local accents=Instance.new("Folder"); accents.Name="DeckGuideLights"; accents.Parent=model
for i=0,7 do
 local theta=i*math.pi/4
 local position=Vector3.new(20*math.cos(theta),2.1,20*math.sin(theta))
 part(string.format("RadialGuide_%02d",i+1),Vector3.new(0.22,0.2,6),CFrame.lookAt(position,Vector3.new(0,position.Y,0)),Enum.Material.Neon,Color3.fromRGB(0,170,205),accents)
end
model.Parent=nest
history:SetWaypoint("Central Nest Platform Complete")
return "Core platform complete: 80x4x80 world footprint, 96 cyan ring segments, 8 deck guide lights."

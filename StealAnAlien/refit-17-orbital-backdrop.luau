-- Editor-only construction. Run batches: 1 = Sun/Mercury/Venus,
-- 2 = Earth/Mars/Jupiter, 3 = Saturn/Uranus/Neptune/Moon.
local batch = ORBITAL_BATCH or 1
local root = workspace.SpaceWorld
local sources = game.ServerStorage.SpaceArtSourceAssets
local source = sources.PlanetArtReference["Solar System Models"].Planets
local system = root.Landmarks:FindFirstChild("SolarSystem")
local V = Vector3.new
local spec = {
 {"Sun", 540, 0, 0, 150, 0, 7.25},
 {"Mercury", 80, 550, 180, 80, 300, 2},
 {"Venus", 170, 820, 300, -110, 165, 177},
 {"Earth", 240, 1250, 480, 70, 40, 23.4},
 {"Mars", 130, 1680, 720, 85, 205, 25.2},
 {"Jupiter", 460, 2200, 1080, 40, 80, 3.1},
 {"Saturn", 380, 3000, 1500, 45, 130, 26.7},
 {"Uranus", 240, 3900, 2100, -65, 235, 97.8},
 {"Neptune", 230, 4700, 2700, 60, 5, 28.3},
}
if not system then
 assert(batch==1,"Build first batch first")
 system=Instance.new("Model");system.Name="SolarSystem"
 system:SetAttribute("OrbitCenter",V(0,1150,650));system:SetAttribute("OrbitInclination",8)
 system:SetAttribute("AnimationEpoch",DateTime.now().UnixTimestampMillis/1000)
 system:SetAttribute("TimeScale",1);system:SetAttribute("AnimationEnabled",true)
 system:SetAttribute("DisplayScale","Compressed distances and enlarged terrestrial planets")
 system.Parent=root.Landmarks
 local old=root.Landmarks.OrbitalBackdrop:FindFirstChild("DistantCrateredMoon")
 if old then old.Parent=game.ServerStorage.OrbitalEnvironmentBackup end
 local sky=game.Lighting:FindFirstChildOfClass("Sky")
 if sky then sky.StarCount=3000;sky.SunAngularSize=0;sky.MoonAngularSize=0 end
end
local function sanitize(m)
 for _,p in m:GetDescendants() do
  if p:IsA("LuaSourceContainer") or p:IsA("Constraint") or p:IsA("JointInstance") or p:IsA("Light") or p:IsA("Sound") or p:IsA("ParticleEmitter") or p:IsA("GuiBase2d") then p:Destroy()
  elseif p:IsA("BasePart") then
   p.Anchored=true;p.CanCollide=true;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
   p.Color=Color3.new(1,1,1);p.Reflectance=0
   if p.Name=="Water" then p.Color=Color3.fromRGB(20,91,156);p.Transparency=0 end
   if p.Name=="Clouds" then p.Transparency=.18 end
   if p.Name~="Clouds" and p.Name~="Water" then p.Transparency=0 end
   p.Material=Enum.Material.SmoothPlastic
   if p:IsA("MeshPart") then p.RenderFidelity=Enum.RenderFidelity.Precise end
  end
 end
end
local function frame(m)
 local centre=system:GetAttribute("OrbitCenter")
 local theta=math.rad(m:GetAttribute("PhaseDegrees") or 0)
 local radius=m:GetAttribute("OrbitRadius") or 0
 local plane=CFrame.Angles(math.rad(system:GetAttribute("OrbitInclination")),0,0)
 local pos=centre+plane:VectorToWorldSpace(V(math.cos(theta)*radius,0,math.sin(theta)*radius))
 return CFrame.new(pos)*CFrame.Angles(0,0,math.rad(m:GetAttribute("AxialTilt") or 0))
end
local function texturedSource(name)
 local m=Instance.new("Model");m.Name=name
 local original=source[name]
 if name=="Earth" then
  for _,n in {"Earth","Water","Clouds"} do original[n]:Clone().Parent=m end
 elseif name=="Saturn" then original.Surface:Clone().Parent=m
 elseif name=="Uranus" then
  local p=original.U:Clone()
  for _,c in p:GetChildren() do if c:IsA("BasePart") then c:Destroy() end end
  p.Parent=m
 else
  local candidate
  for _,p in original:GetDescendants() do if p:IsA("MeshPart") and p.TextureID~="" and p.Transparency<.95 then candidate=p;break end end
  assert(candidate,"No textured surface for "..name)
  local p=candidate:Clone();for _,c in p:GetChildren() do if c:IsA("BasePart") then c:Destroy() end end;p.Parent=m
 end
 sanitize(m)
 local cf,size=m:GetBoundingBox()
 -- Normalise orientation before scale and use a centred model pivot for spin.
 m:PivotTo(cf:Inverse()*m:GetPivot())
 m.WorldPivot=CFrame.identity
 return m,size
end
local created={}
local first,last=(batch-1)*3+1,math.min(batch*3,#spec)
for index=first,last do
 local v=spec[index];assert(not system:FindFirstChild(v[1]),"Already built "..v[1])
 local m,size=texturedSource(v[1]);m:ScaleTo(m:GetScale()*v[2]/math.max(size.X,size.Y,size.Z))
 m:SetAttribute("CelestialBody",true);m:SetAttribute("OrbitRadius",v[3]);m:SetAttribute("OrbitPeriod",v[4])
 m:SetAttribute("SpinPeriod",v[5]*2.5);m:SetAttribute("PhaseDegrees",v[6]);m:SetAttribute("AxialTilt",v[7])
 m:SetAttribute("SourceAssetId","16811836464");m:SetAttribute("Diameter",v[2])
 m.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
 if v[1]=="Sun" then for _,p in m:GetDescendants()do if p:IsA("BasePart")then p.Material=Enum.Material.Neon;p.Color=Color3.fromRGB(255,219,164)end end end
 if v[1]=="Saturn" then
  local p=Instance.new("Part");p.Name="IcyRings";p.Size=V(800,.1,800);p.CFrame=CFrame.identity
  p.Anchored=true;p.CanCollide=true;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
  p.Transparency=1;p.Parent=m
  for _,face in {Enum.NormalId.Top,Enum.NormalId.Bottom}do local d=Instance.new("Decal");d.Name="RingTexture";d.Face=face;d.Texture="rbxassetid://423084630";d.Color3=Color3.fromRGB(239,221,193);d.Parent=p end
 end
 m:PivotTo(frame(m));m.Parent=system;table.insert(created,v[1]);task.wait()
end
if batch==3 then
 local m=Instance.new("Model");m.Name="Moon"
 local original=sources.LunarPlanetSource:Clone();original.Parent=m;sanitize(m)
 local cf,size=m:GetBoundingBox();m:PivotTo(cf:Inverse()*m:GetPivot());m.WorldPivot=CFrame.identity
 m:ScaleTo(m:GetScale()*60/math.max(size.X,size.Y,size.Z))
 m:SetAttribute("CelestialBody",true);m:SetAttribute("OrbitParent","Earth");m:SetAttribute("OrbitRadius",215)
 m:SetAttribute("OrbitPeriod",100);m:SetAttribute("SpinPeriod",100);m:SetAttribute("PhaseDegrees",210);m:SetAttribute("AxialTilt",6.7)
 m.ModelStreamingMode=Enum.ModelStreamingMode.Persistent
 m:PivotTo(CFrame.new(system.Earth:GetPivot().Position+V(-186.2,0,-107.5)))
 m.Parent=system;table.insert(created,"Moon")
end
game:GetService("ChangeHistoryService"):SetWaypoint("Orbital backdrop batch "..batch)
return {batch=batch,created=created}

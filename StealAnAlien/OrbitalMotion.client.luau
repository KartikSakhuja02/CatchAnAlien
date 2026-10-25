-- Client-only sky copies stay inside low-quality render distance.
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local system=workspace:WaitForChild("SpaceWorld"):WaitForChild("Landmarks"):WaitForChild("SolarSystem")
local renderRoot=Instance.new("Folder")
renderRoot.Name="RenderedSolarSystem";renderRoot.Parent=workspace
local tau=2*math.pi
local bodies={}
local function register(m)
 if not m:IsA("Model")or not m:GetAttribute("CelestialBody")or bodies[m.Name]then return end
 local visual=m:Clone();visual.Name=m.Name
 visual.ModelStreamingMode=Enum.ModelStreamingMode.Default
 local parts,decals={},{}
 for _,p in visual:GetDescendants()do
  if p:IsA("BasePart")then
   p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
   p.CastShadow=false;p.LocalTransparencyModifier=0;table.insert(parts,p)
  elseif p:IsA("Decal")then table.insert(decals,{part=p,transparency=p.Transparency})end
 end
 visual.Parent=renderRoot
 bodies[m.Name]={source=m,visual=visual,baseScale=visual:GetScale(),parts=parts,decals=decals,occluded=false,lastScale=0}
 for _,p in m:GetDescendants()do
  if p:IsA("BasePart")then p.LocalTransparencyModifier=1
  elseif p:IsA("Decal")then p.Transparency=1 end
 end
end
for _,m in system:GetChildren()do register(m)end
system.ChildAdded:Connect(register)
system.ChildRemoved:Connect(function(m)
 local b=bodies[m.Name]
 if b and b.source==m then b.visual:Destroy();bodies[m.Name]=nil end
end)
local function rotation(seconds,period)
 if period==0 then return 0 end
 return (seconds/math.abs(period)%1)*tau*(period<0 and -1 or 1)
end
local rayParams=RaycastParams.new()
rayParams.FilterType=Enum.RaycastFilterType.Exclude
local accumulator,occlusionClock=0,0
RunService.RenderStepped:Connect(function(dt)
 accumulator+=dt;occlusionClock+=dt
 if accumulator<1/30 then return end
 accumulator%=1/30
 local camera=workspace.CurrentCamera;if not camera then return end
 local cameraPos=camera.CFrame.Position
 local time=0
 if system:GetAttribute("AnimationEnabled")then
  time=(workspace:GetServerTimeNow()-(system:GetAttribute("AnimationEpoch")or 0))*(system:GetAttribute("TimeScale")or 1)
 end
 local centre=system:GetAttribute("OrbitCenter")
 local plane=CFrame.Angles(math.rad(system:GetAttribute("OrbitInclination")or 0),0,0)
 local positions={}
 local function position(m)
  if positions[m.Name]then return positions[m.Name]end
  local parent=bodies[m:GetAttribute("OrbitParent")]
  local origin=parent and position(parent.source)or centre
  local angle=math.rad(m:GetAttribute("PhaseDegrees")or 0)+rotation(time,m:GetAttribute("OrbitPeriod")or 0)
  local radius=m:GetAttribute("OrbitRadius")or 0
  local p=origin+plane:VectorToWorldSpace(Vector3.new(math.cos(angle)*radius,0,math.sin(angle)*radius))
  positions[m.Name]=p;return p
 end
 local distance=math.clamp(system:GetAttribute("SkyRenderDistance")or 300,150,350)
 local angularScale=system:GetAttribute("SkyAngularScale")or 1.35
 local queryOcclusion=occlusionClock>=.2
 if queryOcclusion then
  occlusionClock=0
  local excluded={system,renderRoot}
  local character=Players.LocalPlayer.Character
  if character then table.insert(excluded,character)end
  rayParams.FilterDescendantsInstances=excluded
 end
 for _,b in bodies do
  local m=b.source
  if m.Parent==system then
   local virtualPos=position(m)
   local delta=virtualPos-cameraPos
   local factor=distance/math.max(delta.Magnitude,1)*angularScale
   if b.lastScale==0 or math.abs(factor-b.lastScale)/b.lastScale>.002 then
    b.visual:ScaleTo(b.baseScale*factor);b.lastScale=factor
   end
   local cf=CFrame.new(cameraPos+delta.Unit*distance)*CFrame.Angles(0,0,math.rad(m:GetAttribute("AxialTilt")or 0))*CFrame.Angles(0,rotation(time,m:GetAttribute("SpinPeriod")or 0),0)
   b.visual:PivotTo(cf)
   if queryOcclusion then
    -- Nearby structures occlude the actual 3D copies. Hide whole copies if a
    -- more distant building would otherwise appear behind the nearer sky.
    local hit=workspace:Raycast(cameraPos,delta,rayParams)
    local hidden=hit~=nil and hit.Distance>distance*.8
    if hidden~=b.occluded then
     b.occluded=hidden
     for _,p in b.parts do p.LocalTransparencyModifier=hidden and 1 or 0 end
     for _,d in b.decals do d.part.Transparency=hidden and 1 or d.transparency end
    end
   end
   b.visual:SetAttribute("VirtualPosition",virtualPos)
  end
 end
end)
script.Destroying:Connect(function()renderRoot:Destroy()end)
script:SetAttribute("MotionReady",true)
script:SetAttribute("RenderMode","CameraRelativeSky")

local root=workspace.SpaceWorld
local V=Vector3.new
local C=Color3.fromRGB
local palette={steel=C(111,119,124),dark=C(44,51,60),light=C(172,177,176),teal=C(96,143,144),copper=C(140,111,85),ink=C(24,31,39)}
local function model(parent,name)
 local m=Instance.new("Model"); m.Name=name; m.Parent=parent; return m
end
local function part(parent,name,size,cf,material,color,class)
 local p=Instance.new(class or "Part"); p.Name=name; p.Size=size; p.CFrame=cf
 p.Material=material or Enum.Material.Metal; p.Color=color or palette.steel
 p.Anchored=true; p.CanCollide=true; p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=parent; return p
end
local function box(parent,name,x,y,z,sx,sy,sz,material,color)
 return part(parent,name,V(sx,sy,sz),CFrame.new(x,y,z),material,color)
end
local function cylinder(parent,name,x,y,z,diameter,height,material,color)
 local p=part(parent,name,V(height,diameter,diameter),CFrame.new(x,y,z)*CFrame.Angles(0,0,math.pi/2),material,color)
 p.Shape=Enum.PartType.Cylinder; return p
end
local function ball(parent,name,x,y,z,sx,sy,sz,material,color)
 local p=box(parent,name,x,y,z,sx,sy,sz,material,color); p.Shape=Enum.PartType.Ball; return p
end
local function signOn(p,text,size,color,face)
 local gui=Instance.new("SurfaceGui"); gui.Name="Identification"; gui.Face=face or Enum.NormalId.Front
 gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud; gui.PixelsPerStud=40; gui.LightInfluence=0; gui.AlwaysOnTop=false; gui.Parent=p
 local label=Instance.new("TextLabel"); label.Name="Label"; label.Size=UDim2.new(1,-12,1,-8); label.Position=UDim2.fromOffset(6,4)
 label.BackgroundTransparency=1; label.Text=text; label.TextColor3=color or C(220,225,224); label.Font=Enum.Font.GothamMedium
 label.TextSize=size or 30; label.TextScaled=true; label.TextWrapped=true; label.Parent=gui
 return gui
end
local function verify(container)
 local count=0
 for _,p in container:GetDescendants() do
  assert(not p:IsA("LuaSourceContainer"),"Runtime script unexpectedly added")
  if p:IsA("BasePart") then assert(p.Anchored and p.CanCollide,"Physics mismatch: "..p.Name); count+=1 end
 end
 return count
end

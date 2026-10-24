local guiService=game:GetService("StarterGui")
assert(not guiService:FindFirstChild("SpaceStealHUD"),"HUD already exists")
local C=Color3.fromRGB
local hud=Instance.new("ScreenGui")
hud.Name="SpaceStealHUD"; hud.ResetOnSpawn=false; hud.IgnoreGuiInset=false
hud.DisplayOrder=10; hud.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
hud:SetAttribute("StaticPreview",true)
local function panel(name,pos,size,anchor,maxWidth)
 local f=Instance.new("Frame"); f.Name=name; f.Position=pos; f.Size=size; f.AnchorPoint=anchor
 f.BackgroundColor3=C(23,29,35); f.BackgroundTransparency=0.14; f.BorderSizePixel=0; f.Parent=hud
 local stroke=Instance.new("UIStroke"); stroke.Color=C(100,112,119); stroke.Transparency=0.35; stroke.Thickness=1; stroke.Parent=f
 local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,5); corner.Parent=f
 local limit=Instance.new("UISizeConstraint"); limit.MaxSize=Vector2.new(maxWidth,1000); limit.Parent=f
 return f
end
local function text(parent,name,value,pos,size,font,max,min,color)
 local t=Instance.new("TextLabel"); t.Name=name; t.Text=value; t.Position=pos; t.Size=size
 t.BackgroundTransparency=1; t.Font=font; t.TextColor3=color or C(224,231,231)
 t.TextSize=max; t.TextScaled=true; t.TextWrapped=false; t.TextXAlignment=Enum.TextXAlignment.Left
 t.Parent=parent
 local limit=Instance.new("UITextSizeConstraint"); limit.MaxTextSize=max; limit.MinTextSize=min; limit.Parent=t
 return t
end
local banner=panel("WorldBanner",UDim2.new(0.5,0,0,12),UDim2.new(0.9,0,0,54),Vector2.new(0.5,0),490)
local stripe=Instance.new("Frame"); stripe.Name="TealAccent"; stripe.Size=UDim2.new(0,3,1,-16); stripe.Position=UDim2.fromOffset(8,8)
stripe.BackgroundColor3=C(96,143,144); stripe.BorderSizePixel=0; stripe.Parent=banner
text(banner,"WorldTitle","WORLD 01 // LUNAR OUTPOST",UDim2.fromOffset(20,8),UDim2.new(1,-32,0,22),Enum.Font.GothamMedium,19,11)
text(banner,"RouteIndicator","01 / 06    •    NEXT: RUST MOON",UDim2.fromOffset(20,32),UDim2.new(1,-32,0,14),Enum.Font.Gotham,11,9,C(155,179,181))
local resources=panel("Resources",UDim2.new(1,-12,0,78),UDim2.new(0.43,0,0,62),Vector2.new(1,0),190)
text(resources,"Credits","CREDITS: 0",UDim2.fromOffset(12,9),UDim2.new(1,-24,0,20),Enum.Font.GothamMedium,15,11)
text(resources,"Aliens","ALIENS: 0",UDim2.fromOffset(12,33),UDim2.new(1,-24,0,20),Enum.Font.GothamMedium,15,11)
local carrying=panel("Carrying",UDim2.new(1,-12,0,148),UDim2.new(0.43,0,0,34),Vector2.new(1,0),190)
text(carrying,"Status","CARRYING: NONE",UDim2.fromOffset(12,8),UDim2.new(1,-24,0,18),Enum.Font.GothamMedium,13,9,C(193,177,153))
hud.Parent=guiService
for _,item in hud:GetDescendants() do assert(not item:IsA("LuaSourceContainer"),"No HUD scripts allowed") end
assert(hud.ResetOnSpawn==false)
game:GetService("ChangeHistoryService"):SetWaypoint("Static Steal an Alien HUD Complete")
return {phase="F",static=true,textLabels=5,scripts=0,resetOnSpawn=hud.ResetOnSpawn}

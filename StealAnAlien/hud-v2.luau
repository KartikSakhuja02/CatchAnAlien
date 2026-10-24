local C,U,V=Color3.fromRGB,UDim2,Vector2.new
local P={bg=C(17,24,31),edge=C(79,98,110),text=C(235,242,240),muted=C(144,163,172),teal=C(132,196,187),gold=C(208,175,116),deep=C(9,15,21)}
local hud=Instance.new("ScreenGui")
hud.Name="SpaceStealHUD";hud.ResetOnSpawn=false;hud.IgnoreGuiInset=false
hud.DisplayOrder=10;hud.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
hud:SetAttribute("StaticPreview",true);hud:SetAttribute("DesignVersion",2)
hud:SetAttribute("ForgeGUIJobId","06a647fb-9ef0-4518-8237-57a4d8f8cc07")
hud:SetAttribute("ArtworkStatus","Generated lunar art awaits a trusted Roblox publishing connection; native emblem displayed")
local function frame(parent,name,pos,size,color,transparency,radius)
 local f=Instance.new("Frame");f.Name=name;f.Position=pos;f.Size=size;f.BackgroundColor3=color or P.bg
 f.BackgroundTransparency=transparency or 0;f.BorderSizePixel=0;f.Parent=parent
 if radius then local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,radius);c.Parent=f end
 return f
end
local function stroke(f,color,thickness,transparency)
 local s=Instance.new("UIStroke");s.Color=color;s.Thickness=thickness or 1;s.Transparency=transparency or 0;s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;s.Parent=f;return s
end
local function gradient(f,a,b,angle)
 local g=Instance.new("UIGradient");g.Color=ColorSequence.new(a,b);g.Rotation=angle or 90;g.Parent=f;return g
end
local function text(parent,name,value,pos,size,max,min,color,font,align)
 local t=Instance.new("TextLabel");t.Name=name;t.Position=pos;t.Size=size;t.BackgroundTransparency=1
 t.Text=value;t.TextColor3=color or P.text;t.Font=font or Enum.Font.GothamMedium
 t.TextSize=max;t.TextScaled=true;t.TextWrapped=false;t.TextXAlignment=align or Enum.TextXAlignment.Left;t.Parent=parent
 local limit=Instance.new("UITextSizeConstraint");limit.MinTextSize=min or max;limit.MaxTextSize=max;limit.Parent=t
 t.TextScaled=true
 return t
end
local function panel(name,pos,size,anchor,maxWidth)
 local shell=frame(hud,name,pos,size,P.bg,1)
 shell.AnchorPoint=anchor
 local limit=Instance.new("UISizeConstraint");limit.MaxSize=V(maxWidth,1000);limit.Parent=shell
 local shadow=frame(shell,"Shadow",U.fromOffset(0,4),U.fromScale(1,1),C(0,0,0),.65,8);shadow.ZIndex=1
 local surface=frame(shell,"Surface",U.fromOffset(0,0),U.fromScale(1,1),C(255,255,255),.06,7);surface.ZIndex=2
 gradient(surface,C(32,44,54),C(13,21,29),110);stroke(surface,P.edge,1,.22)
 local glint=frame(surface,"TopEdge",U.new(0,10,0,0),U.new(1,-20,0,1),C(156,181,188),.6)
 return surface
end
local nav=panel("WorldNavigation",U.new(.5,0,0,12),U.new(.92,0,0,78),V(.5,0),500)
local emblem=frame(nav,"LunarEmblem",U.fromOffset(10,8),U.fromOffset(60,60),P.deep,.2,6)
local orbit=frame(emblem,"Orbit",U.fromOffset(3,23),U.fromOffset(54,18),P.bg,1,100);orbit.Rotation=-28;stroke(orbit,P.teal,1.4,.25)
local moon=frame(emblem,"Moon",U.fromOffset(12,10),U.fromOffset(38,38),C(255,255,255),0,100)
gradient(moon,C(221,230,222),C(75,93,106),40);stroke(moon,C(188,207,202),.8,.3)
for i,crater in {{8,8,9},{23,17,6},{10,25,5}} do
 local f=frame(moon,"Crater_"..i,U.fromOffset(crater[1],crater[2]),U.fromOffset(crater[3],crater[3]),C(88,108,119),.38,100)
 stroke(f,C(218,227,220),.7,.6)
end
frame(emblem,"OrbitMarker",U.fromOffset(51,15),U.fromOffset(4,4),P.teal,0,100)
local badge=frame(nav,"WorldNumber",U.new(1,-62,0,10),U.fromOffset(48,18),P.deep,.16,3)
text(badge,"Value","01 / 06",U.fromOffset(3,0),U.new(1,-6,1,0),10,9,P.teal,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
text(nav,"Eyebrow","CURRENT WORLD",U.fromOffset(82,10),U.new(1,-154,0,13),10,8,P.muted,Enum.Font.GothamMedium)
text(nav,"Title","LUNAR OUTPOST",U.fromOffset(81,25),U.new(1,-95,0,27),24,14,P.text,Enum.Font.GothamBold)
text(nav,"NextWorld","NEXT  /  RUST MOON",U.fromOffset(82,55),U.new(1,-96,0,13),11,9,P.teal,Enum.Font.GothamMedium)
local progress=frame(nav,"WorldRoute",U.new(0,10,1,-3),U.new(1,-20,0,2),P.bg,1)
for i=1,6 do frame(progress,"Stage_"..i,U.new((i-1)/6,0,0,0),U.new(1/6,-4,1,0),i==1 and P.teal or C(68,85,98),i==1 and 0 or .5,1) end

local resources=panel("Resources",U.fromOffset(16,104),U.new(.43,0,0,94),V(0,0),202)
local credit=frame(resources,"CreditIcon",U.fromOffset(13,10),U.fromOffset(30,30),P.gold,.91,5)
local coin=frame(credit,"CreditChip",U.fromOffset(7,7),U.fromOffset(16,16),P.gold,.9,3);coin.Rotation=45;stroke(coin,P.gold,1.6)
local inner=frame(credit,"InsetChip",U.fromOffset(11,11),U.fromOffset(8,8),P.gold,0,1);inner.Rotation=45
text(resources,"CreditsLabel","CREDITS",U.fromOffset(53,9),U.new(1,-65,0,12),10,9,P.muted)
text(resources,"CreditsValue","0",U.fromOffset(52,22),U.new(1,-64,0,23),22,14,P.text,Enum.Font.GothamBold)
frame(resources,"Divider",U.fromOffset(13,47),U.new(1,-26,0,1),P.edge,.6)
local alien=frame(resources,"AlienIcon",U.fromOffset(13,55),U.fromOffset(30,30),P.teal,.92,5)
local head=frame(alien,"Head",U.fromOffset(5,4),U.fromOffset(20,19),P.teal,.08,10)
local jaw=frame(alien,"Chin",U.fromOffset(10,15),U.fromOffset(10,11),P.teal,.08,6)
local le=frame(alien,"LeftEye",U.fromOffset(8,10),U.fromOffset(5,9),P.deep,0,4);le.Rotation=-28
local re=frame(alien,"RightEye",U.fromOffset(18,10),U.fromOffset(5,9),P.deep,0,4);re.Rotation=28
text(resources,"AliensLabel","ALIENS",U.fromOffset(53,54),U.new(1,-65,0,12),10,9,P.muted)
text(resources,"AliensValue","0",U.fromOffset(52,67),U.new(1,-64,0,23),22,14,P.text,Enum.Font.GothamBold)

local carry=panel("CarryStatus",U.new(1,-16,0,104),U.new(.43,0,0,94),V(1,0),216)
text(carry,"Label","CARRYING",U.fromOffset(13,10),U.new(1,-26,0,12),10,9,P.muted)
local slot=frame(carry,"SpecimenSlot",U.fromOffset(13,33),U.fromOffset(40,43),P.deep,.25,5)
for _,x in {5,28} do for _,y in {5,31} do
 frame(slot,"BracketH_"..x.."_"..y,U.fromOffset(x,y),U.fromOffset(7,1),P.muted,.2)
 frame(slot,"BracketV_"..x.."_"..y,U.fromOffset(x==5 and x or x+6,y==5 and y or y-6),U.fromOffset(1,7),P.muted,.2)
end end
frame(slot,"EmptyDash",U.fromOffset(14,21),U.fromOffset(12,2),P.muted,.1,1)
text(carry,"Value","NONE",U.fromOffset(64,31),U.new(1,-77,0,27),22,16,P.text,Enum.Font.GothamBold)
text(carry,"Hint","NO SPECIMEN",U.fromOffset(65,62),U.new(1,-78,0,12),9,8,P.muted)
frame(carry,"StatusDot",U.fromOffset(14,84),U.fromOffset(3,3),P.muted,.25,100)
frame(carry,"FooterLine",U.fromOffset(22,85),U.new(1,-36,0,1),P.edge,.6)
local backup=game.ServerStorage:FindFirstChild("StealAnAlien_HUDBackups")
if not backup then backup=Instance.new("Folder");backup.Name="StealAnAlien_HUDBackups";backup.Parent=game.ServerStorage end
local old=game.StarterGui:FindFirstChild("SpaceStealHUD")
if old then old.Name="SpaceStealHUD_v1_"..os.time();old.Parent=backup end
hud.Parent=game.StarterGui
local labels=0
for _,a in hud:GetDescendants() do
 assert(not a:IsA("LuaSourceContainer"),"Runtime scripts are outside this task")
 assert(not a:IsA("GuiButton"),"Static HUD must not imply functional buttons")
 if a:IsA("TextLabel") then labels+=1 end
end
game:GetService("ChangeHistoryService"):SetWaypoint("Steal an Alien HUD redesign")
return {version=2,labels=labels,resetOnSpawn=hud.ResetOnSpawn,oldHudPreserved=true}

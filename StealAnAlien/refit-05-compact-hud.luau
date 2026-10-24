local h=game.StarterGui.SpaceStealHUD
local previous=h:Clone();previous.Name="SpaceStealHUD_v2_before_visual_refit";previous.Parent=game.ServerStorage.StealAnAlien_HUDBackups
h:SetAttribute("DesignVersion",3)
local U,V=UDim2,Vector2.new
local nav=h.WorldNavigation;nav.Size=U.new(.92,0,0,64);nav.UISizeConstraint.MaxSize=V(400,1000)
local n=nav.Surface
local s=Instance.new("UIScale");s.Scale=.8;s.Parent=n.LunarEmblem;n.LunarEmblem.Position=U.fromOffset(8,8)
n.Eyebrow.Position=U.fromOffset(68,8);n.Eyebrow.Size=U.new(1,-132,0,11);n.Eyebrow.Text="SECTOR / 01"
n.Title.Position=U.fromOffset(67,21);n.Title.Size=U.new(1,-79,0,22);n.Title.UITextSizeConstraint.MaxTextSize=20;n.Title.UITextSizeConstraint.MinTextSize=13
n.NextWorld.Position=U.fromOffset(68,45);n.NextWorld.Size=U.new(1,-80,0,11);n.NextWorld.UITextSizeConstraint.MaxTextSize=10
n.WorldNumber.Position=U.new(1,-60,0,8)
local resources=h.Resources;resources.Position=U.fromOffset(16,88);resources.Size=U.new(.42,0,0,78);resources.UISizeConstraint.MaxSize=V(174,1000)
local r=resources.Surface
for _,name in {"CreditIcon","AlienIcon"} do local a=r[name];local scale=Instance.new("UIScale");scale.Scale=.8;scale.Parent=a end
r.CreditIcon.Position=U.fromOffset(11,9);r.AlienIcon.Position=U.fromOffset(11,45)
r.CreditsLabel.Position=U.fromOffset(44,7);r.CreditsLabel.Size=U.new(1,-56,0,11)
r.CreditsValue.Position=U.fromOffset(43,19);r.CreditsValue.Size=U.new(1,-55,0,20);r.CreditsValue.UITextSizeConstraint.MaxTextSize=20
r.Divider.Position=U.fromOffset(11,39);r.Divider.Size=U.new(1,-22,0,1)
r.AliensLabel.Position=U.fromOffset(44,43);r.AliensLabel.Size=U.new(1,-56,0,11)
r.AliensValue.Position=U.fromOffset(43,55);r.AliensValue.Size=U.new(1,-55,0,20);r.AliensValue.UITextSizeConstraint.MaxTextSize=20
local carry=h.CarryStatus;carry.AnchorPoint=V(.5,1);carry.Position=U.new(.5,0,1,-18);carry.Size=U.new(.64,0,0,46);carry.UISizeConstraint.MaxSize=V(260,1000)
local c=carry.Surface
local scale=Instance.new("UIScale");scale.Scale=.7;scale.Parent=c.SpecimenSlot;c.SpecimenSlot.Position=U.fromOffset(9,8)
c.Label.Position=U.fromOffset(49,6);c.Label.Size=U.new(1,-62,0,11);c.Label.UITextSizeConstraint.MaxTextSize=9
c.Value.Position=U.fromOffset(48,18);c.Value.Size=U.fromOffset(80,20);c.Value.UITextSizeConstraint.MaxTextSize=17;c.Value.UITextSizeConstraint.MinTextSize=13
c.Hint.Position=U.new(1,-104,0,19);c.Hint.Size=U.fromOffset(91,12);c.Hint.TextXAlignment=Enum.TextXAlignment.Right;c.Hint.Text="EMPTY SLOT"
c.StatusDot:Destroy();c.FooterLine:Destroy()
for _,t in h:GetDescendants() do if t:IsA("TextLabel") then t.TextScaled=true end end
game:GetService("ChangeHistoryService"):SetWaypoint("Compact exploration HUD")
return {hudVersion=3,worldCardHeight=64,carryingPanelHeight=46}

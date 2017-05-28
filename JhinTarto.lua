if myHero.charName ~= "Jhin" then return end

-- Load Spells
function Jhin:LoadSpells()
	Q = {Range = myHero:GetSpellData(0).range, Delay = myHero:GetSpellData(0).delay, speed = myHero:GetSpellData(0).speed, width = myHero:GetSpellData(0).width}
	W = {Range = myHero:GetSpellData(1).range, Delay = myHero:GetSpellData(1).delay, speed = myHero:GetSpellData(1).speed, width = myHero:GetSpellData(1).width}
	E = {Range = myHero:GetSpellData(2).range, Delay = myHero:GetSpellData(2).delay, speed = myHero:GetSpellData(2).speed, width = myHero:GetSpellData(2).width}
	R = {Range = myHero:GetSpellData(3).range, Delay = myHero:GetSpellData(3).delay, speed = myHero:GetSpellData(3).speed, width = myHero:GetSpellData(3).width}
	PrintChat("Jhin Spells Loaded.")
end

-- Menus
local JhinMenu = MenuElement({id = "JhinTarto", name = "Jhin", type = MENU})
JhinMenu:MenuElement({id = "Combo", name = "Jhin", type = MENU})
JhinMenu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
JhinMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
JhinMenu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
JhinMenu:MenuElement({id = "Misc", name = "Misc", type = MENU})
-- Combo Sub-Menu
JhinMenu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true})
JhinMenu.Combo:MenuElement({id = "UseW", name = "Use W", value = true})
JhinMenu.Combo:MenuElement({id = "UseWKillsteal", name = "Use W Killsteal", value = true})
JhinMenu.Combo:MenuElement({id = "UseE", name = "Use E", value = true})
-- LaneClear Sub-Menu
-- Harass Sub-Menu
-- LastHit Sub-Menu

OnDraw(function()
	local qRange = myHero:GetSpellData(3).range
	local qColor = Draw.Color(150,255,0,0)
	Draw.Circle(myHero.pos, qRange, 1, qColor)
	end)
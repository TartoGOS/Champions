if myHero.charName ~= "Gnar" then return end

class "TartoGnar"

local Version = "1.0a"

require = 'DamageLib'
--getdmg("SKILL",target,source,stagedmg,spelllvl)
require = 'MapPositionGOS'
require = 'Collision'
--[[local name_as_you_wish = Collision:SetSpell(range, speed, delay, width, hitBox)
__GetCollision(from, to, mode, exclude)
__GetHeroCollision(from, to, mode, exclude)
__GetMinionCollision(from, to, mode, exclude)
from: the starting point
to: the ending point
mode: number 1 - 6 or "ALL", "ALLY", "ENEMY", "JUNGLE", "ENEMYANDJUNGLE", "ALLYANDJUNGLE"
exclude: a list of units or a unit

]]

function TartoGnar:__init()
	PrintChat("TartoGnar Loaded !")
	self:LoadSpells()
	self:LoadMenu()
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
end

function TartoGnar.LoadSpells()
	Q = { range = 1100, delay = 0.25, speed = 1200, width = 60 }
	QM = { range = 1100, delay = 0.25, speed = 1200, width = 80 }
	WM = { range = 550, delay = 0.5, speed = math.huge, width = 80 }
	R = { range = 400, delay = 0.5, speed = math.huge, width = 400 }
end

function TartoGnar:LoadMenu()
	TartoGnar.Menu = MenuElement({id = "TartoGnar", name = "Gnar", type = MENU, leftIcon ="https://puu.sh/w7a7c/7a388ab008.png"})
	TartoGnar.Menu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	TartoGnar.Menu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	TartoGnar.Menu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	TartoGnar.Menu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
	TartoGnar.Menu:MenuElement({id = "Killsteal", name = "Killsteal", type = MENU})
	TartoGnar.Menu:MenuElement({id = "Draw", name = "Drawings", type = MENU})
-- Combo Sub-Menu
	TartoGnar.Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = "https://puu.sh/w7aOp/f57d73b4c0.png"})
	TartoGnar.Menu.Combo:MenuElement({id = "UseQM", name = "Use Q MEGA", value = true, leftIcon = "https://puu.sh/w7aQP/c2ab4c230c.png"})
	TartoGnar.Menu.Combo:MenuElement({id = "UseWM", name = "Use W", value = true, leftIcon = "https://puu.sh/w7aTE/524fd39032.png"})
	TartoGnar.Menu.Combo:MenuElement({id = "UseR", name = "[SOON]Use R", value = true, leftIcon = "https://puu.sh/w7aYn/a4ac942f9c.png"})
	TartoGnar.Menu.Combo:MenuElement({id = "UseRTarget", name = "[SOON]Minimum targets R", value = 2, min = 1, max = 5, step = 1, leftIcon = "https://puu.sh/w7aYn/a4ac942f9c.png"})
-- LaneClear Sub-Menu
	TartoGnar.Menu.LaneClear:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = "https://puu.sh/w7aOp/f57d73b4c0.png"})
	TartoGnar.Menu.LaneClear:MenuElement({id = "UseQM", name = "Use Q MEGA", value = true, leftIcon = "https://puu.sh/w7aQP/c2ab4c230c.png"})
	TartoGnar.Menu.LaneClear:MenuElement({id = "UseWM", name = "Use W", value = true, leftIcon = "https://puu.sh/w7aTE/524fd39032.png"})
-- Harass Sub-Menu
	TartoGnar.Menu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = "https://puu.sh/w7aOp/f57d73b4c0.png"})
	TartoGnar.Menu.Harass:MenuElement({id = "UseQM", name = "Use Q MEGA", value = true, leftIcon = "https://puu.sh/w7aQP/c2ab4c230c.png"})
	TartoGnar.Menu.Harass:MenuElement({id = "UseWM", name = "Use W", value = true, leftIcon = "https://puu.sh/w7aTE/524fd39032.png"})
-- LastHit Sub-Menu
	TartoGnar.Menu.LastHit:MenuElement({id = "UseQ", name = "[SOON]Use Q", value = true, leftIcon = "https://puu.sh/w7aOp/f57d73b4c0.png"})
	TartoGnar.Menu.LastHit:MenuElement({id = "UseQM", name = "[SOON]Use Q MEGA", value = false, leftIcon = "https://puu.sh/w7aQP/c2ab4c230c.png"})
	TartoGnar.Menu.LastHit:MenuElement({id = "UseWM", name = "[SOON]Use W", value = false, leftIcon = "https://puu.sh/w7aTE/524fd39032.png"})
-- Draw Sub-Menu
	TartoGnar.Menu.Draw:MenuElement({id = "DrawReady", name = "[SOON] Draw Only Ready Spells [?]", value = false})
	TartoGnar.Menu.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true, leftIcon = "https://puu.sh/w7aOp/f57d73b4c0.png"})
	TartoGnar.Menu.Draw:MenuElement({id = "DrawW", name = "Draw W Range", value = false, leftIcon = "https://puu.sh/w7aTE/524fd39032.png"})
	TartoGnar.Menu.Draw:MenuElement({id = "DrawR", name = "Draw R Range", value = false, leftIcon = "https://puu.sh/w7aYn/a4ac942f9c.png"})

	PrintChat("GnarTarto Menu Loaded.")
end

function TartoGnar:Tick()
	if not myHero.alive then return end

	if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
		TartoGnar:Combo()
	elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then
		TartoGnar:Harass()
	elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] then
		TartoGnar:LaneClear()
	elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT] then
		TartoGnar:LastHit()
	end
end

function TartoGnar:Draw()
	if not myHero.alive then return end

	if TartoGnar.Menu.Draw.DrawQ:Value() then
		Draw.Circle(myHero.pos, 1100, 3, Draw.Color(255, 255, 255, 100))
	end
	if TartoGnar.Menu.Draw.DrawW:Value() then
		Draw.Circle(myHero.pos, 550, 3, Draw.Color(255, 255, 255, 100))
	end
	if TartoGnar.Menu.Draw.DrawR:Value() then
		Draw.Circle(myHero.pos, 475, 3, Draw.Color(255, 255, 255, 100))
	end
end

-- Début Vrai Script

function TartoGnar:Combo()
	if _G.SDK.TargetSelector:GetTarget(1100, _G.SDK.DAMAGE_TYPE_PHYSICAL) == nil then return end

	if not TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Combo.UseQ:Value() and TartoGnar:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(1100, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		local prediction = target:GetPrediction(1200, 0.25)
		Control.CastSpell(HK_Q, prediction)
	end
	if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Combo.UseQM:Value() and TartoGnar:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(1100, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		local prediction = target:GetPrediction(1200, 0.25)
		Control.CastSpell(HK_Q, prediction)
	end
	if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Combo.UseWM:Value() and TartoGnar:IsReady(_W) then
		local target = _G.SDK.TargetSelector:GetTarget(550, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		local prediction = target:GetPrediction(math.huge, 0.5)
		Control.CastSpell(HK_W, prediction)
	end
	--[[A FAIRE :
	-Ajouter le AutoR
	]]
end

function TartoGnar:Harass()
	if _G.SDK.TargetSelector:GetTarget(1100, _G.SDK.DAMAGE_TYPE_PHYSICAL) == nil then return end
	if not TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Harass.UseQ:Value() and TartoGnar:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(1100, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		local prediction = target:GetPrediction(1200, 0.25)
		Control.CastSpell(HK_Q, prediction)
	end
	if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Harass.UseWM:Value() and TartoGnar:IsReady(_W) then
		local target = _G.SDK.TargetSelector:GetTarget(550, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		local prediction = target:GetPrediction(1200, 0.25)
		Control.CastSpell(HK_W, prediction)
	end
	if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Harass.UseQM:Value() and TartoGnar:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(1100, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		local prediction = target:GetPrediction(1200, 0.25)
		Control.CastSpell(HK_Q, prediction)
	end
	--[[A FAIRE :
	-Harass Q en prenant compte de la collision des creeps
	-Harass QM en prenant compte de la collision des creeps
	-Harass WM en prenant compte de la collision des creeps
	]]
end

function TartoGnar:LaneClear()
	--[[A FAIRE :
	-Laneclear Q le plus de creeps possibles
	-Laneclear QM le plus de creeps possibles
	-Laneclear WM le plus de creeps possibles
	]]
end

function TartoGnar:LastHit()
	--[[A FAIRE :
	-Lasthit un creep en prenant compte de la collision des autres creeps
	-Lasthit un creep sans push la lane
	]]
end

function TartoGnar:CheckR()
	--[[A FAIRE :
	-Auto R pendant le combo le nombre de targets minimum choisis
	]]
end


function TartoGnar:StealableTarget()
	--[[A FAIRE :
	-Killsteal Q
	-Killsteal QM
	-Killsteal R
	]]
end

-- Fonctions nécessaires

function TartoGnar:GetValidMinion(range)
    	for i = 1,Game.MinionCount() do
        local minion = Game.Minion(i)
        if  minion.team ~= myHero.team and minion.valid and minion.pos:DistanceTo(myHero.pos) < 650 then
        return true
        end
    	end
    	return false
end

function TartoGnar:AARange()
	if myHero.levelData.lvl == 1 then return 400 end
	if myHero.levelData.lvl == 2 then return 406 end
	if myHero.levelData.lvl == 3 then return 412 end
	if myHero.levelData.lvl == 4 then return 418 end
	if myHero.levelData.lvl == 5 then return 424 end
	if myHero.levelData.lvl == 6 then return 430 end
	if myHero.levelData.lvl == 7 then return 435 end
	if myHero.levelData.lvl == 8 then return 441 end
	if myHero.levelData.lvl == 9 then return 447 end
	if myHero.levelData.lvl == 10 then return 453 end
	if myHero.levelData.lvl == 11 then return 459 end
	if myHero.levelData.lvl == 12 then return 465 end
	if myHero.levelData.lvl == 13 then return 471 end
	if myHero.levelData.lvl == 14 then return 477 end
	if myHero.levelData.lvl == 15 then return 483 end
	if myHero.levelData.lvl == 16 then return 489 end
	if myHero.levelData.lvl == 17 then return 494 end
	if myHero.levelData.lvl == 18 then return 500 end
end

function TartoGnar:IsReady(spellSlot)
	if myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0 then
		return spellSlot
	end
end

function TartoGnar:HasBuff(unit, buffname)
	for i, buff in pairs(TartoGnar:GetBuffs(unit)) do
		if buff.name == buffname then
			return true
		end
	end
	return false
end

function TartoGnar:GetBuffs(unit)
  local t = {}
  for i = 0, unit.buffCount do
    local buff = unit:GetBuff(i)
    if buff.count > 0 then
      table.insert(t, buff)
    end
  end
  return t
end


function OnLoad()
	TartoGnar()
end

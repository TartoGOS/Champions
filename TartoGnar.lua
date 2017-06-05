if myHero.charName ~= "Gnar" then return end

class "TartoGnar"

require 'DamageLib'
require '2DGeometry'
require 'Collision'

local QSpell = Collision:SetSpell(1100, 1200, 0.25, 60, true)
local QMSpell = Collision:SetSpell(1100, 1200, 0.25, 80, true)

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
	R = { range = 475, delay = 0.5, speed = math.huge, width = 400 }
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
	TartoGnar.Menu.Combo:MenuElement({id = "UseR", name = "[SOON]Use R", value = false, leftIcon = "https://puu.sh/w7aYn/a4ac942f9c.png"})
	TartoGnar.Menu.Combo:MenuElement({id = "UseRTarget", name = "[SOON]Minimum targets R", value = 2, min = 1, max = 5, step = 1, leftIcon = "https://puu.sh/w7aYn/a4ac942f9c.png"})
-- LaneClear Sub-Menu
	TartoGnar.Menu.LaneClear:MenuElement({id = "UseQ", name = "[SOON]Use Q", value = true, leftIcon = "https://puu.sh/w7aOp/f57d73b4c0.png"})
	TartoGnar.Menu.LaneClear:MenuElement({id = "UseQM", name = "[SOON]Use Q MEGA", value = true, leftIcon = "https://puu.sh/w7aQP/c2ab4c230c.png"})
	TartoGnar.Menu.LaneClear:MenuElement({id = "UseWM", name = "[SOON]Use W", value = true, leftIcon = "https://puu.sh/w7aTE/524fd39032.png"})
-- Harass Sub-Menu
	TartoGnar.Menu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = "https://puu.sh/w7aOp/f57d73b4c0.png"})
	TartoGnar.Menu.Harass:MenuElement({id = "UseQM", name = "Use Q MEGA", value = true, leftIcon = "https://puu.sh/w7aQP/c2ab4c230c.png"})
	TartoGnar.Menu.Harass:MenuElement({id = "UseWM", name = "Use W", value = true, leftIcon = "https://puu.sh/w7aTE/524fd39032.png"})
-- LastHit Sub-Menu
	TartoGnar.Menu.LastHit:MenuElement({id = "UseQ", name = "[SOON]Use Q", value = true, leftIcon = "https://puu.sh/w7aOp/f57d73b4c0.png"})
	TartoGnar.Menu.LastHit:MenuElement({id = "UseQM", name = "[SOON]Use Q MEGA", value = false, leftIcon = "https://puu.sh/w7aQP/c2ab4c230c.png"})
	TartoGnar.Menu.LastHit:MenuElement({id = "UseWM", name = "[SOON]Use W", value = false, leftIcon = "https://puu.sh/w7aTE/524fd39032.png"})
-- Draw Sub-Menu
	TartoGnar.Menu.Draw:MenuElement({id = "DrawReady", name = "Draw Only Ready Spells [?]", value = false})
	TartoGnar.Menu.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true, leftIcon = "https://puu.sh/w7aOp/f57d73b4c0.png"})
	TartoGnar.Menu.Draw:MenuElement({id = "DrawW", name = "Draw W Range", value = false, leftIcon = "https://puu.sh/w7aTE/524fd39032.png"})
	TartoGnar.Menu.Draw:MenuElement({id = "DrawR", name = "Draw R Range", value = false, leftIcon = "https://puu.sh/w7aYn/a4ac942f9c.png"})
-- Killsteal Sub-Menu
	TartoGnar.Menu.Killsteal:MenuElement({id = "StealQ", name = "Killsteal Q", value = true, leftIcon = "https://puu.sh/w7aOp/f57d73b4c0.png"})
	TartoGnar.Menu.Killsteal:MenuElement({id = "StealQM", name = "Killsteal Q MEGA", value = false, leftIcon = "https://puu.sh/w7aQP/c2ab4c230c.png"})
	TartoGnar.Menu.Killsteal:MenuElement({id = "StealR", name = "Killsteal R", value = false, leftIcon = "https://puu.sh/w7aYn/a4ac942f9c.png"})
-- Infos
	TartoGnar.Menu:MenuElement({name = "Version : 1.0", type = SPACE})
	TartoGnar.Menu:MenuElement({name = "Patch   : 7.11", type = SPACE})
	TartoGnar.Menu:MenuElement({name = "by Tarto", type = SPACE})

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

	TartoGnar:StealableTarget()
end

function TartoGnar:Draw()
	if not myHero.alive then return end

	if TartoGnar.Menu.Draw.DrawReady:Value() then
		if TartoGnar:IsReady(_Q) and TartoGnar.Menu.Draw.DrawQ:Value() then
			Draw.Circle(myHero.pos, 1100, 3, Draw.Color(255, 255, 255, 100))
		end
		if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar:IsReady(_W) and TartoGnar.Menu.Draw.DrawW:Value() then
			Draw.Circle(myHero.pos, 550, 3, Draw.Color(255, 255, 255, 100))
		end
		if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar:IsReady(_R) and TartoGnar.Menu.Draw.DrawR:Value() then
			Draw.Circle(myHero.pos, 475, 3, Draw.Color(255, 255, 255, 100))
		end
	else
		if TartoGnar.Menu.Draw.DrawQ:Value() then
			Draw.Circle(myHero.pos, 1100, 3, Draw.Color(255, 255, 255, 100))
		end
		if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Draw.DrawW:Value() then
			Draw.Circle(myHero.pos, 550, 3, Draw.Color(255, 255, 255, 100))
		end
		if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Draw.DrawR:Value() then
			Draw.Circle(myHero.pos, 475, 3, Draw.Color(255, 255, 255, 100))
		end
	end
end

-- Début Vrai Script

function TartoGnar:Combo()
	if _G.SDK.TargetSelector:GetTarget(Q.range, _G.SDK.DAMAGE_TYPE_PHYSICAL) == nil then return end

	if (not TartoGnar:HasBuff(myHero, "gnartransform") or TartoGnar:HasBuff(myHero, "gnartransformsoon")) and TartoGnar.Menu.Combo.UseQ:Value() and TartoGnar:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(Q.range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		local prediction = target:GetPrediction(Q.speed, Q.delay)
		if QSpell:__GetMinionCollision(myHero, target, 5) then return end
		if target.alive then
			Control.CastSpell(HK_Q, prediction)
		end
	end
	if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Combo.UseQM:Value() and TartoGnar:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(QM.range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		local prediction = target:GetPrediction(QM.speed, QM.delay)
		if QMSpell:__GetMinionCollision(myHero, target, 5) then return end
		if target.alive then
			Control.CastSpell(HK_Q, prediction)
		end
	end
	if (TartoGnar:HasBuff(myHero, "gnartransform") or TartoGnar:HasBuff(myHero, "gnartransformsoon")) and TartoGnar.Menu.Combo.UseWM:Value() and TartoGnar:IsReady(_W) then
		local target = _G.SDK.TargetSelector:GetTarget(WM.range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		local prediction = target:GetPrediction(WM.speed, WM.delay)
		if target.alive then
			Control.CastSpell(HK_W, prediction)
		end
	end

	--[[A FAIRE :
	-Ajouter le AutoR
	]]
end

function TartoGnar:Harass()
	if _G.SDK.TargetSelector:GetTarget(Q.range, _G.SDK.DAMAGE_TYPE_PHYSICAL) == nil then return end
	if (not TartoGnar:HasBuff(myHero, "gnartransform") or TartoGnar:HasBuff(myHero, "gnartransformsoon")) and TartoGnar.Menu.Combo.UseQ:Value() and TartoGnar:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(1100, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		local prediction = target:GetPrediction(Q.speed, Q.delay)
		if QSpell:__GetMinionCollision(myHero, target, 5) then return end
		if target.alive then
			Control.CastSpell(HK_Q, prediction)
		end
	end
	if (TartoGnar:HasBuff(myHero, "gnartransform") or TartoGnar:HasBuff(myHero, "gnartransformsoon")) and TartoGnar.Menu.Combo.UseWM:Value() and TartoGnar:IsReady(_W) then
		local target = _G.SDK.TargetSelector:GetTarget(WM.range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		local prediction = target:GetPrediction(WM.speed, WM.delay)
		if target.alive then
			Control.CastSpell(HK_W, prediction)
		end
	end
	if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Combo.UseQM:Value() and TartoGnar:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(QM.range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		local prediction = target:GetPrediction(QM.speed, QM.delay)
		if QMSpell:__GetMinionCollision(myHero, target, 5) then return end
		if target.alive then
			Control.CastSpell(HK_Q, prediction)
		end
	end
end

function TartoGnar:LaneClear()
	--[[local GetValidMinion = GetValidMinion(Q.range)

	for i = 1, #GetValidMinion do
		local minion = GetValidMinion[i]
		if TartoGnar.Menu.Laneclear.UseQ:Value() and TartoGnar:IsReady(_Q) then
			local prediction = minion:GetPrediction(Q.speed, Q.delay)
			Control.CastSpell(HK_Q, prediction)
		end
	end]]

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
	if _G.SDK.TargetSelector:GetTarget(Q.range, _G.SDK.DAMAGE_TYPE_PHYSICAL) == nil then return end

	if (not TartoGnar:HasBuff(myHero, "gnartransform") or TartoGnar:HasBuff(myHero, "gnartransformsoon")) and TartoGnar.Menu.Killsteal.StealQ:Value() and TartoGnar:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(Q.range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target.alive and (target.health + target.shieldAD + target.shieldAP) < getdmg("Q", target, myHero) then
			if target == nil then return end
			local prediction = target:GetPrediction(Q.speed, Q.delay)
			if QSpell:__GetMinionCollision(myHero, target, 5) then return end
			Control.CastSpell(HK_Q, prediction)
		end
	end
	if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Killsteal.StealQM:Value() and TartoGnar:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(QM.range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		local DamageQM = ({5, 45, 85, 125, 165})[myHero:GetSpellData(_Q).level] + 1.2 * myHero.totalDamage
		if target.alive and (target.health + target.shieldAD + target.shieldAP) < DamageQM then
			if target == nil then return end
			local prediction = target:GetPrediction(QM.speed, QM.delay)
			if QMSpell:__GetMinionCollision(myHero, target, 5) then return end
			Control.CastSpell(HK_Q, prediction)
		end
	end

	if _G.SDK.TargetSelector:GetTarget(R.range, _G.SDK.DAMAGE_TYPE_PHYSICAL) == nil then return end

	if TartoGnar:HasBuff(myHero, "gnartransform") and TartoGnar.Menu.Killsteal.StealR:Value() and TartoGnar:IsReady(_R) and not TartoGnar:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(R.range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target.alive and (target.health + target.shieldAD + target.shieldAP) < getdmg("R", target, myHero) then
			if target == nil then return end
			local prediction = target:GetPrediction(R.speed, R.delay)
			Control.CastSpell(HK_R, prediction)
		end
	end
end

-- Fonctions nécessaires

function TartoGnar:QCollision(target, width, speed, delay)
	--QCOLLISION
end

function TartoGnar:CCed(unit)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if unit.buffCount > 0 then
			if buff and (buff.type == 5 or buff.type == 7 or buff.type == 8 or buff.type == 11 or buff.type == 21 or buff.type == 22 or buff.type == 24 or buff.type == 29 or buff.type == 30) then
				return true
			end
		end
	end
	return false
end

function TartoGnar:ValidTarget(target)
	if not target.dead and not target.IsImmortal and target.IsTargetable and target.IsEnemy then
		return true
		else return false
	end
end

function TartoGnar:GetValidMinion(range)
	EnemyMinions = {}
    for i = 1, Game.MinionCount() do
        local Minion = Game.Minion(i)
       	if  Minion.IsEnemy and (Minion:DistanceTo(myHero) < range) then
       		table.insert(EnemyMinions, Minion)
       		return EnemyMinions
       	end
    end
end

function TartoGnar:AARange()
	local level = myHero.levelData.lvl
	local range = ({400,406,412,418,424,430,435,441,447,453,459,465,471,477,483,489,494,500})[level]
	return range
end


function TartoGnar:IsReady(name)
	if myHero:GetSpellData(name).currentCd == 0 and myHero:GetSpellData(name).level > 0 then
		return name
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
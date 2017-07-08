if myHero.charName ~= "Jinx" then return end

require 'Eternal Prediction'
require 'DamageLib'

class "Jinx"

-- API : 
--[[
-EnemyOk(target)
-TargetDistance(range)
-Target(range, type1)
-OrbState(state, bool)
-CastX(spell, target, hitchance, minion, hero)
-CastOnly(spell)
-QRange()
-TrinketRange()
-BuffedStatikSoon(who)
-BuffedStatikSoon1(who)
-EnemyComing(target)
-DistTo(firstpos, secondpos)
-AbleCC(who)
-EnemiesCloseCanAttack(range)
-EnemiesAround(CustomRange)
-HealthPred(target, time)
-NeedLifesteal(target, range)
-RPress()
-ToggleECC()
-Botrk()
-StealableTarget()
-Force(target)
-EnemiesForQ()
-TurretAround(range)
-MinionNumber(range, Type)
]]

--Datas
local Q = {delay = myHero:GetSpellData(0).delay}
local W = {range = 1500, speed = 3300, delay = 0.6, width = 60}
local E = {range = 900, speed = 1750, delay = 0.7, width = 310}
local R = {range = 2800, speed = 1700, delay = 0.6, width = 140}
local HeroIcon = "https://puu.sh/wjmUo/6fcac89c6e.png"
local QIcon = "https://puu.sh/wjmN5/aafda0c781.png"
local WIcon = "https://puu.sh/wjmPk/900b665295.png"
local EIcon = "https://puu.sh/wjmRL/c494c6280d.png"
local RIcon = "https://puu.sh/wjmSz/9170a27129.png"
local BIcon = "https://i58.servimg.com/u/f58/16/33/77/19/botrk10.png"
local TKIcon = "https://i58.servimg.com/u/f58/16/33/77/19/trk10.png"
local Tarto = "https://i58.servimg.com/u/f58/16/33/77/19/baguli10.jpg"
local H = myHero
local ColorY = Draw.Color(255, 255, 255, 100)
local ColorZ = Draw.Color(255, 255, 200, 100)
local ping = Game.Latency()
local castXstate = 1
local castXtick = 0
local castOnlytick = 0
local customWvalid = 0
local customEvalid = 0
local customRvalid = 0
print("Competitive Jinx Loaded.")
--Menus
local Menu = MenuElement({id = "Menu", name = "Jinx", type = MENU, leftIcon = HeroIcon})
Menu:MenuElement({id = "Combo", name = "Combo", type = MENU})
Menu:MenuElement({id = "Harass", name = "Harass", type = MENU})
Menu:MenuElement({id = "Laneclear", name = "Laneclear", type = MENU})
Menu:MenuElement({id = "Lasthit", name = "Lasthit", type = MENU})
--Menu:MenuElement({id = "Flee", name = "Flee", type = MENU})
Menu:MenuElement({id = "Killsteal", name = "Killsteal", type = MENU})
Menu:MenuElement({id = "ESet", name = "E Settings", type = MENU})
--Menu:MenuElement({id = "Baseult", name = "Toggle", type = MENU})
Menu:MenuElement({id = "Items", name = "Items usage", type = MENU})
Menu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
Menu:MenuElement({name = "Version : 1.30", type = SPACE})
Menu:MenuElement({name = "By Tarto", type = SPACE, rightIcon = Tarto})
--Combo
Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
Menu.Combo:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = WIcon})
Menu.Combo:MenuElement({id = "UseE", name = "Use E", value = true	, leftIcon = EIcon})
Menu.Combo:MenuElement({id = "UseEOnly", name = "Use E on CC ONLY", value = true	, leftIcon = EIcon})
Menu.Combo:MenuElement({id = "UseEMana", name = "E mana min", value = 40, min = 0, max = 100, step = 5, leftIcon = EIcon})
--Menu.Combo:MenuElement({id = "UseR", name = "Use R", value = true, leftIcon = RIcon})
--Menu.Combo:MenuElement({id = "MinR", name = "Minimum targets to ultimate", value = 3, min = 1, max = 5, step = 1, leftIcon = RIcon})
Menu.Combo:MenuElement({id = "RPress", name = "Semi-Auto R (only if OnScreen)", key = string.byte("T"), leftIcon = RIcon})
--Menu.Combo:MenuElement({id = "Usetrkt", name = "Use trinket in bush", value = true, leftIcon = TKIcon})

--Harass
Menu.Harass:MenuElement({id = "UseQ", name = "Use Q (beta)", value = true, leftIcon = QIcon})
Menu.Harass:MenuElement({id = "UseW", name = "Use W (beta)", value = true, leftIcon = WIcon})
--Laneclear
Menu.Laneclear:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
Menu.Laneclear:MenuElement({id = "UseQMana", name = "Q Mana min", value = 60, min = 0, max = 100, step = 5, leftIcon = QIcon})

--Lasthit
Menu.Lasthit:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
--Flee
--Menu.Flee:MenuElement({id = "UseE", name = "Use E", value = true, leftIcon = EIcon})
--Killsteal
Menu.Killsteal:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = WIcon})
Menu.Killsteal:MenuElement({id = "UseR", name = "Use R", value = true, leftIcon = RIcon})
--E Settings
Menu.ESet:MenuElement({id = "ECC", name = "Auto-use E on CC", value = false, leftIcon = EIcon})
--Menu.ESet:MenuElement({id = "ETelep", name = "Auto-use E on teleport", value = false, leftIcon = EIcon})
--Baseult
--Menu.Baseult:MenuElement({id = "UseR", name = "Use Baseult", toggle = true, key = string.byte("U"), leftIcon = RIcon})
--Items
--Menu.Items:MenuElement({id = "UseBotrk", name = "Use Botrk", value = true, leftIcon = BIcon})
--Drawings
Menu.Drawings:MenuElement({id = "DrawAuto", name = "Draw AA Range", value = true, leftIcon = HeroIcon})
Menu.Drawings:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true, leftIcon = QIcon})
Menu.Drawings:MenuElement({id = "DrawW", name = "Draw W Range", value = true, leftIcon = WIcon})
Menu.Drawings:MenuElement({id = "DrawR", name = "Draw R Range", value = true, leftIcon = RIcon})
Menu.Drawings:MenuElement({id = "WriteTR", name = "Write Toggle Q", value = true, leftIcon = QIcon})

function Tick()
	if H.dead then return end
	ToggleECC()
	RPress()
	StealableTarget()
	if SDK then
		if SDK.Orbwalker.Modes[SDK.ORBWALKER_MODE_COMBO] then
			Combo()
		elseif SDK.Orbwalker.Modes[SDK.ORBWALKER_MODE_HARASS] then
			Harass()
		elseif SDK.Orbwalker.Modes[SDK.ORBWALKER_MODE_LANECLEAR] then
			Laneclear()
		elseif SDK.Orbwalker.Modes[SDK.ORBWALKER_MODE_JUNGLECLEAR] then
			Jungleclear()
		elseif SDK.Orbwalker.Modes[SDK.ORBWALKER_MODE_LASTHIT] then
			Lasthit()
		elseif SDK.Orbwalker.Modes[SDK.ORBWALKER_MODE_Flee] then
			Flee()
		end
	elseif EOWLoaded then
		if EOW:Mode() == 1 then
			Combo()
		elseif EOW:Mode() == 2 then
			Harass()
		elseif EOW:Mode() == 3 then
			Lasthit()
		elseif EOW:Mode() == 4 then
			Laneclear()
		end
	else
		GOS:GetMode()
	end
end

function Draws()
	if H.dead then return end
	if Menu.Drawings.DrawAuto:Value() then
		Draw.Circle(H.pos, H.range+130, 2, ColorZ)
	end
	if Menu.Drawings.DrawQ:Value() then
		Draw.Circle(H.pos, QRange(), 2, ColorY)
	end
	if Menu.Drawings.DrawW:Value() then
		Draw.Circle(H.pos, W.range, 2, ColorY)
	end
	if Menu.Drawings.DrawR:Value() then
		Draw.Circle(H.pos, R.range, 2, ColorY)
	end
end

function EnemyOk(target)
	if target == nil then return end
	if target.isEnemy and not target.isImmortal and not target.dead then
		return true
	else return false
	end
end

function TargetDistance(range)
	local target = nil
	for i = 0, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if math.sqrt(DistTo(Hero.pos, H.pos)) <= range and Hero.isEnemy then
			if target == nil then target = Hero break end
			if math.sqrt(DistTo(Hero.pos, H.pos)) < math.sqrt(DistTo(target.pos, H.pos)) then
				target = Hero
			end
		end
	end
	return target
end

function Target(range, type1)
	if SDK then
		if type1 == "damage" then
			if H.totalDamage > H.ap then
				local target = SDK.TargetSelector:GetTarget(range, SDK.DAMAGE_TYPE_PHYSICAL)
				return target
			elseif H.totalDamage <= H.ap then
				local target = SDK.TargetSelector:GetTarget(range, SDK.DAMAGE_TYPE_MAGICAL)
				return target
			end
		elseif type1 == "easy" then
			local target = SDK.TargetSelector:GetTarget(range, SDK.DAMAGE_TYPE_PHYSICAL)
			return target
		elseif type1 == "distance" then
			local target = TargetDistance(range)
			return target
		end
	elseif EOWLoaded then
		if type1 == "damage" then
			if H.totalDamage > H.ap then
				local target = EOW:GetTarget(range, ad_dec, H.pos)
				return target
			elseif H.totalDamage <= H.ap then
				local target = EOW:GetTarget(range, ap_dec, H.pos)
				return target
			end
		elseif type1 == "easy" then
			local target = EOW:GetTarget(range, easykill_acd, H.pos)
			return target
		elseif type1 == "distance" then
			local target = EOW:GetTarget(range, distance_acd, H.pos)
			return target
		end
	else 
		if type1 == "damage" then
			if H.totalDamage > H.ap then
				local target = GOS:GetTarget(range, "AD")
				return target
			elseif H.totalDamage <= H.ap then
				local target = GOS:GetTarget(range, "AP")
				return target
			end
		elseif type1 == "easy" then
			local target = GOS:GetTarget(range, "AD")
			return target
		elseif type1 == "distance" then
			local target = TargetDistance(range)
			return target
		end
	end
end

function OrbState(state, bool)
	if state == "Global" then
		if SDK then 
			SDK.Orbwalker:SetMovement(bool)
			SDK.Orbwalker:SetAttack(bool)
		elseif EOWLoaded then
			EOW:SetAttacks(bool)
			EOW:SetMovements(bool)
		else
			GOS:BlockAttack(not bool)
			GOS:BlockMovement(not bool)
		end
	elseif state == "Attack" then
		if SDK then 
			SDK.Orbwalker:SetAttack(bool)
		elseif EOWLoaded then
			EOW:SetAttacks(bool)
		else
			GOS:BlockAttack(not bool)
		end
	elseif state == "Movement" then
		if SDK then 
			SDK.Orbwalker:SetMovement(bool)
		elseif EOWLoaded then
			EOW:SetMovements(bool)
		else
			GOS:BlockMovement(not bool)
		end
	end
end

function CastX(spell, target, hitchance, minion, hero)
	if H.activeSpell.valid then return end
	local Custom = {delay = (ping/1000), spell = spell, minion = minion, hero = hero, hitchance = hitchance, hotkey = nil, pred = nil, Delay = nil}
	if Custom.minion == nil then Custom.minion = 0 end
	if Custom.hero == nil then Custom.hero = 0 end
	if Custom.hitchance == nil then Custom.hitchance = 0.20 end
	if Custom.spell == 1 then
		Custom.pred = Prediction:SetSpell(W, TYPE_LINE, true)
		Custom.hotkey = HK_W
		Custom.Delay = W.delay
	elseif Custom.spell == 2 then
		Custom.pred = Prediction:SetSpell(E, TYPE_GENERIC, true)
		Custom.hotkey = HK_E
		Custom.Delay = E.delay
	elseif Custom.spell == 3 then
		Custom.pred = Prediction:SetSpell(R, TYPE_LINE, true)
		Custom.hotkey = HK_R
		Custom.Delay = R.delay
	end
	DelayAction(function() OrbState("Attack", false) end, Custom.delay)
	if target ~= nil and Custom.pred ~= nil and Custom.hotkey ~= nil and not target.dead then
		if castXstate == 1 then
			if H.attackData.state == 2 then return end
			castXstate = 2
			local mLocation = nil
			local prediction = Custom.pred:GetPrediction(target, H.pos)
			if Custom.spell == 1 then
				if HealthPred(target, Custom.Delay + 0.1) < 1 then return end
				if not target.toScreen.onScreen then
					return
				end
				if prediction and prediction.hitChance >= Custom.hitchance and prediction:mCollision() == Custom.minion and prediction:hCollision() == Custom.hero and not target.dead and (GetTickCount() - castXtick) > 25 then
					mLocation = mousePos
					if mLocation == nil then return end
					DelayAction(function() OrbState("Movement", false) end, Custom.delay*2)
					DelayAction(function() Control.SetCursorPos(prediction.castPos) end, Custom.delay)
					DelayAction(function() Control.KeyDown(Custom.hotkey) end, Custom.delay)
					customWvalid = Game.Timer()
					DelayAction(function() Control.KeyUp(Custom.hotkey) end, Custom.delay)
					DelayAction(function() Control.SetCursorPos(mLocation) end, (Custom.Delay/2 + Custom.delay))
					DelayAction(function() OrbState("Global", true) end, Custom.delay)
					castXstate = 1
					castXtick = GetTickCount()
				end
			elseif Custom.spell == 2 then
				if HealthPred(target, Custom.Delay + 0.1) < 1 then return end
				if not target.toScreen.onScreen then
					return
				end
				if prediction and prediction.hitChance >= Custom.hitchance and not target.dead and (GetTickCount() - castXtick) > 25 then
					mLocation = mousePos
					if mLocation == nil then return end
					DelayAction(function() OrbState("Movement", false) end, Custom.delay*2)
					DelayAction(function() Control.SetCursorPos(prediction.castPos) end, Custom.delay)
					DelayAction(function() Control.KeyDown(Custom.hotkey) end, Custom.delay)
					customEvalid = Game.Timer()
					DelayAction(function() Control.KeyUp(Custom.hotkey) end, Custom.delay)
					DelayAction(function() Control.SetCursorPos(mLocation) end, (Custom.Delay/2 + Custom.delay))
					DelayAction(function() OrbState("Global", true) end, Custom.delay)
					castXstate = 1
					castXtick = GetTickCount()
				end
			elseif Custom.spell == 3 then
				if HealthPred(target, Custom.Delay + 0.1) < 1 then return end
				if prediction and prediction.hitChance >= Custom.hitchance and prediction:hCollision() == Custom.hero and not target.dead and (GetTickCount() - castXtick) > 25 then
					mLocation = mousePos
					local MM = prediction.castPos:ToMM()
					if mLocation == nil then return end
					DelayAction(function() OrbState("Movement", false) end, Custom.delay*2)
					DelayAction(function() Control.SetCursorPos(MM.x, MM.y) end, Custom.delay)
					DelayAction(function() Control.KeyDown(Custom.hotkey) end, Custom.delay)
					customRvalid = Game.Timer()
					DelayAction(function() Control.KeyUp(Custom.hotkey) end, Custom.delay)
					DelayAction(function() Control.SetCursorPos(mLocation) end, (Custom.Delay/2 + Custom.delay))
					DelayAction(function() OrbState("Global", true) end, Custom.delay)
					castXstate = 1
					castXtick = GetTickCount()
				end
			end
		elseif castXstate == 2 then return end
	end
end

function CastOnly(spell)
	if H.activeSpell.valid then return end
	local CustomDelay = ping/1000
	if SDK then
		if ((Game.Timer() - H.attackData.endTime) < (0.45*H.attackData.windDownTime) and (GetTickCount() - castXtick) > 25) then
			if H:GetSpellData(0).toggleState == 1 then
				DelayAction(function() OrbState("Attack", false) end, CustomDelay*2)
				DelayAction(function() Control.KeyDown(spell) end, CustomDelay)
				DelayAction(function() Control.KeyUp(spell) end, CustomDelay)
				DelayAction(function() OrbState("Attack", true) end, H.attackData.windDownTime)
				castOnlytick = GetTickCount()
			elseif H:GetSpellData(0).toggleState == 2 then
				DelayAction(function() Control.KeyDown(spell) end, CustomDelay*2)
				DelayAction(function() Control.KeyUp(spell) end, CustomDelay)
				castOnlytick = GetTickCount()
			end
		end
	elseif EOWLoaded then
		if ((Game.Timer() - H.attackData.endTime) < (0.45*H.attackData.windDownTime) and (GetTickCount() - castXtick) > 25) then
			DelayAction(function() Control.KeyDown(spell) end, CustomDelay)
			DelayAction(function() Control.KeyUp(spell) end, CustomDelay)
			castOnlytick = GetTickCount()
		end
	end
end

function QRange()
	if H:GetSpellData(0).level == 0 then return 655 end
	local range = {600+130, 625+130, 650+130, 675+130, 700+130}
	return range[H:GetSpellData(0).level]
end

function TrinketRange()
	local level = H:GetSpellData(0).level + H:GetSpellData(1).level + H:GetSpellData(2).level + H:GetSpellData(3).level
	return (60+3.5*(level-1))
end

function BuffedStatikSoon(who)
	for i, buff in pairs(GetBuffs(who)) do
		local buff = who:GetBuff(i)
		if buff.name == "itemstatikshankcharge" and buff.count >= 50 then
			return true
		end
	end
	return false
end

function BuffedStatikSoon1(who)
 	local buffs = {}
 	for i = 0, who.buffCount do
    	local buff = who:GetBuff(i)
    	if buff.duration > 0 then
      		table.insert(buffs, buff)
    	end
	end
  return buffs
end

function EnemyComing(target, time)
	if target == nil then return end
	local first, second, delay = target.pos, nil, GetTickCount()
	if GetTickCount() - delay > time then
		second = target.pos
		if math.sqrt(DistTo(first, H.pos)) > math.sqrt(DistTo(second, H.pos)) then
			return true
		elseif math.sqrt(DistTo(first, H.pos)) == math.sqrt(DistTo(second, H.pos)) then
			return false
		end
	end
	return false
end

function DistTo(firstpos, secondpos)
	local secondpos = secondpos or H.pos
	local distx = firstpos.x - secondpos.x
	local distyz = (firstpos.z or firstpos.y) - (secondpos.z or secondpos.y)
	local distf = (distx*distx) + (distyz*distyz)
	return distf
end

function AbleCC(who)
	if who == nil then return end
	if who.buffCount == 0 then return end
	for i = 0, who.buffCount do
		local buffs = who:GetBuff(i)
		if buffs.type == (5 or 8 or 11 or 22 or 24 or 29 or 30) and buffs.expireTime > 1.2 then
			return true
		end
	end
	return false
end

--[[
function AbleCC(who)
	if who == nil then return end
	if who.buffCount == 0 then return end
	for i = 0, who.buffCount do
		local buffs = who:GetBuff(i)
		for i = 1, CClist() do
			local number = CClist(i)
		if buffs.name == number and buffs.expireTime > 1 then
			return true
		end
	end
	return false
end


function CClist(number)
	local list = {"AhriSeduce", "Stun", "powerfistslow"}
	return list[number]
end



]]

function EnemiesCloseCanAttack(range)
	local Count = 0
	for i = 0, Game.HeroCount() do
		local HHero = Game.Hero(i)
		if math.sqrt(DistTo(HHero.pos, H.pos)) <= range and HHero.isEnemy then
			if math.sqrt(DistTo(HHero.pos, H.pos)) < HHero.range then
				Count = Count + 1
			end
		end
	end
	return Count
end

function EnemiesAround(CustomRange)
	local Count = 0
	for i = 0, Game.HeroCount() do
		if Game.HeroCount() == 0 then return Count end
		local Enemy = Game.Hero(i)
		if math.sqrt(DistTo(Enemy.pos, H.pos)) <= CustomRange and Enemy.isEnemy then
			Count = Count + 1
		end
	end
	return Count
end

function HealthPred(target, time)
	if SDK then
		return SDK.HealthPrediction:GetPrediction(target, time)
	elseif EOWLoaded then
		return EOW:GetHealthPrediction(target, time)
	else
		return GOS:HP_Pred(target,time)
	end
end

function NeedLifesteal(target, range)
	if target == nil then return end
	if target.lifeSteal > 0 and (target.health*100)/target.maxHealth < 5 and EnemiesCloseCanAttack(range) >= 1 then
		return true
	else return false
	end
end

function RPress()
	if Menu.Combo.RPress:Value() and Game.CanUseSpell(3) == 0 then
	local target = Target(2500, "easy")
		if target == nil then return end
		if H.attackData.state ~= 2 then
			CastX(3, target, 0.15)
		end
	end
end

function ToggleECC()
	if Menu.ESet.ECC:Value() and Game.CanUseSpell(2) == 0 then
		local target = Target(E.range-50, "distance")
		if target ~= nil then
			if AbleCC(target) then
				if H.attackData.state ~= 2 then
					CastX(2, target, 0.2)
				end
			end
		end
	end
end

function Botrk()
	--
end

function StealableTarget()
	castXstate = 1
	OrbState("Global", true)
	if Menu.Killsteal.UseR:Value() and Game.CanUseSpell(1) == 0 then
		if H.activeSpell.valid then return end
		local target = Target(W.range, "easy")
		if Target(W.range, "easy") == nil then return end
		if math.sqrt(DistTo(target.pos, H.pos)) < W.range and math.sqrt(DistTo(target.pos, H.pos)) > QRange() and EnemiesAround(QRange()) == 0 then
			if (target.health + target.shieldAD + target.shieldAP) < getdmg("W", target, myHero) then
				CastX(1, target, 0.15)
			end
		end
	end
	if Menu.Killsteal.UseR:Value() and Game.CanUseSpell(3) == 0 then
		if H.activeSpell.valid then return end
		local target = Target(R.range, "easy")
		if Target(R.range, "easy") == nil then return end
		if math.sqrt(DistTo(target.pos, H.pos)) < R.range and math.sqrt(DistTo(target.pos, H.pos)) > QRange() and EnemiesAround(QRange()) == 0 then
			if (target.health + target.shieldAD + target.shieldAP) < getdmg("R", target, myHero) then
				CastX(3, target, 0.15)
			end
		end
	end
end

function Force(target)
	if target ~= nil then
		if SDK then
			SDK.Orbwalker.ForceTarget = target
		elseif EOWLoaded then
			EOW:ForceTarget(target)
		elseif GOS then
			GOS:ForceTarget(target)
		end
	else
		if SDK then
			SDK.Orbwalker.ForceTarget = nil
		elseif EOWLoaded then
			EOW:ForceTarget(nil)
		elseif GOS then
			GOS:ForceTarget(nil)
		end
	end
end

function EnemiesForQ()
	local count = 0
	for i = 0, Game.HeroCount() do
		local target = Game.Hero(i)
		if target.isEnemy and math.sqrt(DistTo(target.pos, H.pos)) > 655 and math.sqrt(DistTo(target.pos, H.pos)) < 2000 then
			local count = count + 1
		end
	end
	return count
end

function TurretAround(range)
	local count = 0
	for i = 0, Game.TurretCount() do
		local turret = Game.Turret(i)
		if turret.isEnemy and math.sqrt(DistTo(turret.pos, H.pos)) <= range then
			count = count + 1
		end
	end
	return count
end

--SRU_OrderMinionSiege
--SRU_OrderMinionRanged
--SRU_OrderMinionMelee
--SRU_OrderMinionSuper
--SRU_ChaosMinionRanged
--SRU_ChaosMinionMelee
--SRU_ChaosMinionSiege
--SRU_ChaosMinionSuper

function MinionNumber(range, Type, who)
	if range == nil or Game.Timer() < 91 then return end
	if who == nil then who = H end
	local count = 0
	if Type == nil then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if math.sqrt(DistTo(minion.pos, who.pos)) < range then
				count = count + 1
			end
		end
	elseif Type == "ranged" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if who.team == 100 then
				if math.sqrt(DistTo(minion.pos, who.pos)) < range and minion.charName == "SRU_ChaosMinionRanged" then
					count = count + 1
				end
			elseif who.team == 200 then
				if math.sqrt(DistTo(minion.pos, who.pos)) < range and minion.charName == "SRU_OrderMinionRanged" then
					count = count + 1
				end
			end
		end
	elseif Type == "melee" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if who.team == 100 then
				if math.sqrt(DistTo(minion.pos, who.pos)) < range and minion.charName == "SRU_ChaosMinionMelee" then
					count = count + 1
				end
			elseif who.team == 200 then
				if math.sqrt(DistTo(minion.pos, who.pos)) < range and minion.charName == "SRU_OrderMinionRMelee" then
					count = count + 1
				end
			end
		end
	elseif Type == "siege" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if who.team == 100 then
				if math.sqrt(DistTo(minion.pos, who.pos)) < range and minion.charName == "SRU_ChaosMinionSiege" then
					count = count + 1
				end
			elseif who.team == 200 then
				if math.sqrt(DistTo(minion.pos, who.pos)) < range and minion.charName == "SRU_OrderMinionSiege" then
					count = count + 1
				end
			end
		end
	elseif Type == "super" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if who.team == 100 then
				if math.sqrt(DistTo(minion.pos, who.pos)) < range and minion.charName == "SRU_ChaosMinionSuper" then
					count = count + 1
				end
			elseif who.team == 200 then
				if math.sqrt(DistTo(minion.pos, who.pos)) < range and minion.charName == "SRU_OrderMinionSuper" then
					count = count + 1
				end
			end
		end
	end
	return count
end

function Combo()
	if H.activeSpell.valid then return end
	if customWvalid ~= 0 then
		if Game.Timer() - customWvalid <= 0.6 then return end
	end
	if customEvalid ~= 0 then
		if Game.Timer() - customEvalid <= 0.7 then return end
	end
	if customRvalid ~= 0 then
		if Game.Timer() - customEvalid <= 0.6 then return end
	end

	Force(nil)
	castXstate = 1
	OrbState("Global", true)
	if EnemiesAround(655) == 0 and Menu.Combo.UseQ:Value() then
		if H:GetSpellData(0).toggleState == 1 and Game.CanUseSpell(0) == 0  then 
			if H.attackData.state == 1 then
				OrbState("Global", true)
				Control.CastSpell(HK_Q)
			end
		end
	end

	if Menu.Combo.UseQ:Value() and Game.CanUseSpell(0) == 0 then
		local target = Target(W.range, "damage")
		if target ~= nil then
			if not EnemyOk(target) then return end
			if H:GetSpellData(0).toggleState == 1 and math.sqrt(DistTo(target.pos, H.pos)) > 655 and math.sqrt(DistTo(target.pos, H.pos)) <= (QRange()+150) then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			elseif H:GetSpellData(0).toggleState == 2 and math.sqrt(DistTo(target.pos, H.pos)) <= 655 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			end
		end
	end
	if Menu.Combo.UseW:Value() and Game.CanUseSpell(1) == 0 then
		local target = Target(Q.range, "easy")
		if target == nil then target = Target(W.range, "easy") end
		if target ~= nil then
			if math.sqrt(DistTo(target.pos, H.pos)) <= W.range and math.sqrt(DistTo(target.pos, H.pos)) > (QRange()+160) and not EnemyComing(target, 30) and EnemiesAround(1700) < 3 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastX(1, target, 0.15)
				end
			elseif math.sqrt(DistTo(target.pos, H.pos)) <= W.range and math.sqrt(DistTo(target.pos, H.pos)) > (QRange()+160) and target.ms > H.ms and not EnemyComing(target, 30) and EnemiesAround(1700) < 3 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastX(1, target, 0.15)
				end
			elseif math.sqrt(DistTo(target.pos, H.pos)) <= W.range and math.sqrt(DistTo(target.pos, H.pos)) > 1100 and EnemiesAround(2000) == 1 and not EnemyComing(target, 30) and EnemiesAround(1700) < 3 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastX(1, target, 0.15)
				end
			elseif math.sqrt(DistTo(target.pos, H.pos)) <= W.range and math.sqrt(DistTo(target.pos, H.pos)) > (QRange()+160) and EnemiesAround(W.range-200) == 1 and AbleCC(target) and EnemiesAround(1700) < 3 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastX(1, target, 0.15)
				end
			end
		else return end
	end

	if Menu.Combo.UseE:Value() and Game.CanUseSpell(2) == 0 and (H.mana*100)/H.maxMana >= Menu.Combo.UseEMana:Value() then
		local target = Target(E.range, "distance")
		if target ~= nil then
			if AbleCC(target) then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastX(2, target, 0.2)
				end
			elseif math.sqrt(DistTo(target.pos, H.pos)) < (655 * 0.2) and EnemyComing(target, 30) and Menu.Combo.UseEOnly:Value() == false and target.attackData.state == 2 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
						CastX(2, target, 0.2)
				end
			--[[elseif EnemyComing(target) and EnemiesCloseCanAttack >= 3 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastX(2, target, 0.2)
				end]]
			end
		end
	end
	--[[if Menu.Combo.Usetrkt:Value() and Target(QRange(), "distance") ~= nil then
		local target = Target(QRange(), "distance")
		BushVision(target)
	end]]
end

function Harass()
	if Game.Timer() < 91 then return end
	Force(nil)
	if H.activeSpell.valid then return end
	castXstate = 1
	OrbState("Global", true)
	if Menu.Harass.UseQ:Value() and Game.CanUseSpell(0) == 0 then
		local target = Target(QRange(), "damage")
		Force(nil)
		if target == nil then
			if H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then 
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					Control.CastSpell(HK_Q)
				end
			end
		elseif target ~= nil then
			if TurretAround(655) ~= nil then return end
			for i = 0, Game.MinionCount() do
				local minion = Game.Minion(i)
				if math.sqrt(DistTo(minion.pos, H.pos)) <= QRange() and HealthPred(minion, (ping/1000)*2 + H.attackData.windDownTime*2 + H.attackData.windUpTime*2) <= 0 then
					if H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then
						if H.attackData.state ~= 2 then
							OrbState("Global", true)
							Control.CastSpell(HK_Q)
							DelayAction(function() Force(minion) end, ping/1000 + H.attackData.windDownTime)
							return
						end
					elseif H:GetSpellData(0).toggleState == 1 then
						OrbState("Global", true)
						Force(minion)
						return
					end
				elseif math.sqrt(DistTo(target.pos, H.pos)) < QRange() then
					if H:GetSpellData(0).toggleState == 1 and Game.CanUseSpell(0) == 0 and math.sqrt(DistTo(target.pos, H.pos)) >= 655 then
						if H.attackData.state ~= 2 then
							Control.CastSpell(HK_Q)
							DelayAction(function() Force(target) end, ping/1000 + H.attackData.windDownTime)
							return
						end
					elseif H:GetSpellData(0).toggleState == 2 and math.sqrt(DistTo(target.pos, H.pos)) < 655 then
						if H.attackData ~= 2 then
							Force(target)
							return
						end
					end
				elseif Menu.Combo.UseW:Value() and Game.CanUseSpell(1) == 0 then
					local target = Target(W.range, "easy")
					if target ~= nil then
						if math.sqrt(DistTo(target.pos, H.pos)) <= W.range and math.sqrt(DistTo(target.pos, H.pos)) > 1100 and EnemiesAround(W.range) == 1 then
							if H.attackData.state ~= 2 then
								OrbState("Global", true)
								CastX(1, target, 0.15, 0)
							end
						end
					end
				end
			end
		end
	end
end

function Laneclear()
	if Game.Timer() < 91 then return end
	if H.activeSpell.valid then return end
	castXstate = 1
	OrbState("Global", true)
	Force(nil)
	if Menu.Laneclear.UseQ:Value() then
		if TurretAround(655) >= 1 then
			if H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			end
			return
		end
		if EnemiesAround(1000) > 0 then
		if H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			end
		end
		if (H.mana*100)/H.maxMana < Menu.Laneclear.UseQMana:Value() then
			if H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			end
			return
		end
		if MinionNumber(QRange(), "siege") > 1 or MinionNumber(QRange(), "ranged") >= 5 or MinionNumber(QRange(), "melee") >= 5 then	
			if H:GetSpellData(0).toggleState == 1 and Game.CanUseSpell(0) == 0 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			elseif H:GetSpellData(0).toggleState == 2 then
				for i = 0, Game.MinionCount() do
					local target = Game.Minion(i)
					if HealthPred(target, (H.attackData.windDownTime + (ping/1000))) <= 0 then 
						Force(nil)
						return
					end
					if MinionNumber(50, "melee", target) > 1 or MinionNumber(50, "ranged", target) > 1 or MinionNumber(50, "siege", target) > 1 then--changed
						if H.team == 100 and target.charName == "SRU_ChaosMinionSiege" then
							Force(target)
							break
						elseif H.team == 200 and target.charName == "SRU_OrderMinionSiege" then
							Force(target)
							break
						end
					end
				end
			end
		elseif MinionNumber(QRange(), "siege") == 1 then	
			if H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			elseif H:GetSpellData(0).toggleState == 1 then
				for i = 0, Game.MinionCount() do
					local target = Game.Minion(i)
					if target.health < (H.totalDamage*2.5) or H.attackSpeed > 1 or H.critChance >= 40 then
						if HealthPred(target, (H.attackData.windDownTime + (ping/1000))) <= 0 then 
							Force(nil)
							return
						end
						if H.team == 100 and target.charName == "SRU_ChaosMinionSiege" then
							Force(target)
							break
						elseif H.team == 200 and target.charName == "SRU_OrderMinionSiege" then
							Force(target)
							break
						end
					end
				end
			end
		elseif MinionNumber(QRange(), "super") > 1 then	
			if H:GetSpellData(0).toggleState == 1 and Game.CanUseSpell(0) == 0 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			elseif H:GetSpellData(0).toggleState == 2 then
				for i = 0, Game.MinionCount() do
					local target = Game.Minion(i)
					if target.health < (H.totalDamage*2.5) or H.attackSpeed > 1 or H.critChance >= 40 then
						if HealthPred(target, (H.attackData.windDownTime + (ping/1000))) <= 0 then 
							Force(nil)
							return
						end
						if H.team == 100 and target.charName == "SRU_ChaosMinionSuper" then
							Force(target)
							break
						elseif H.team == 200 and target.charName == "SRU_OrderMinionSuper" then
							Force(target)
							break
						end
					end
				end
			end
		elseif MinionNumber(QRange(), "ranged") > 3 then	
			if H:GetSpellData(0).toggleState == 1 and Game.CanUseSpell(0) == 0 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			elseif H:GetSpellData(0).toggleState == 2 then
				for i = 0, Game.MinionCount() do
					local target = Game.Minion(i)
					if target.health < (H.totalDamage*2.5) or H.attackSpeed > 1 or H.critChance >= 40 then
						if HealthPred(target, (H.attackData.windDownTime + (ping/1000))) <= 0 then 
							Force(nil)
							return
						end
						if MinionNumber(50, "ranged", target) > 1 or MinionNumber(50, "melee", target) > 1 then
							if H.team == 100 and target.charName == "SRU_ChaosMinionRanged" then
								Force(target)
								break
							elseif H.team == 200 and target.charName == "SRU_OrderMinionRanged" then
								Force(target)
								break
							end
						end
					end
				end
			end
		elseif MinionNumber(QRange(), "melee") > 3 then	
			if H:GetSpellData(0).toggleState == 1 and Game.CanUseSpell(0) == 0 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			elseif H:GetSpellData(0).toggleState == 2 then
				for i = 0, Game.MinionCount() do
					local target = Game.Minion(i)
					if target.health < (H.totalDamage*2.5) or H.attackSpeed > 1 or H.critChance >= 40 then
						if HealthPred(target, (H.attackData.windDownTime + (ping/1000))) <= 0 then 
							Force(nil)
							return
						end
						if MinionNumber(50, "melee", target) > 1 or MinionNumber(50, "ranged", target) > 1 then
							if H.team == 100 and target.charName == "SRU_ChaosMinionMelee" then
								Force(target)
								break
							elseif H.team == 200 and target.charName == "SRU_OrderMinionMelee" then
								Force(target)
								break
							end
						end
					end
				end
			end
		elseif (MinionNumber(QRange(), "melee") + MinionNumber(QRange(), "ranged")) > 6 then	
			if H:GetSpellData(0).toggleState == 1 and Game.CanUseSpell(0) == 0 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			elseif H:GetSpellData(0).toggleState == 2 then
				for i = 0, Game.MinionCount() do
					local target = Game.Minion(i)
					if target.health < (H.totalDamage*2.5) or H.attackSpeed > 1 or H.critChance >= 40 then
						if HealthPred(target, (H.attackData.windDownTime + (ping/1000))) <= 0 then 
							Force(nil)
							return
						end
						if MinionNumber(50, "melee", target) > 1 or MinionNumber(500, "ranged", target) > 1 then
							if H.team == 100 and target.charName == "SRU_ChaosMinionMelee" then
								Force(target)
								break
							elseif H.team == 200 and target.charName == "SRU_OrderMinionMelee" then
								Force(target)
								break
							end
						end
					end
				end
			end
		elseif H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then
			if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
		end
	end
end

function Jungleclear()
	if Game.Timer() < 91 then return end
	if H.activeSpell.valid then return end
	Force(nil)
	castXstate = 1
	OrbState("Global", true)
	if Menu.Laneclear.UseQ:Value() then
		if H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then
			OrbState("Global", true)
			CastOnly(HK_Q)
		end
	end
	--done
end

function Lasthit()
	if Game.Timer() < 91 then return end
	if H.activeSpell.valid then return end
	Force(nil)
	castXstate = 1
	OrbState("Global", true)
	if Menu.Lasthit.UseQ:Value() then
		if H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then
			OrbState("Global", true)
			CastOnly(HK_Q)
		end
	end
	--done
end

function Flee()
	Force(nil)
	if H.activeSpell.valid then return end
	OrbState("Movement", true)
	OrbState("Attack", false)
	--Ajouter buff maitrise de move speed
end

--Callbacks
Callback.Add("Tick", function() Tick() end)
Callback.Add("Draw", function() Draws() end)
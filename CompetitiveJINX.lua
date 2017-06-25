if myHero.charName ~= "Jinx" then return end

require 'Eternal Prediction'
require 'DamageLib'

class "Jinx"

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
local SpellTick = 0 --soon
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
Menu:MenuElement({name = "Version : 1.05", type = SPACE})
Menu:MenuElement({name = "By Tarto", type = SPACE, rightIcon = Tarto})
--Combo
Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
Menu.Combo:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = WIcon})
Menu.Combo:MenuElement({id = "UseE", name = "Use E", value = false	, leftIcon = EIcon})
--Menu.Combo:MenuElement({id = "UseR", name = "Use R", value = true, leftIcon = RIcon})
--Menu.Combo:MenuElement({id = "MinR", name = "Minimum targets to ultimate", value = 3, min = 1, max = 5, step = 1, leftIcon = RIcon})
Menu.Combo:MenuElement({id = "RPress", name = "Semi-Auto R (only if OnScreen tho", key = string.byte("T"), leftIcon = RIcon})
--Menu.Combo:MenuElement({id = "Usetrkt", name = "Use trinket in bush", value = true, leftIcon = TKIcon})

--Harass
Menu.Harass:MenuElement({id = "UseQ", name = "Use Q (bêta)", value = true, leftIcon = QIcon})
Menu.Harass:MenuElement({id = "UseW", name = "Use W (bêta)", value = true, leftIcon = WIcon})
--Laneclear
Menu.Laneclear:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
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
--Menu.Baseult:MenuElement({id = "UseQ", name = "Use Baseult", toggle = true, key = string.byte("U"), leftIcon = RIcon})
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
	if _G.SDK then
		if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
			Combo()
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then
			Harass()
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] then
			Laneclear()
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR] then
			Jungleclear()
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT] then
			Lasthit()
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_Flee] then
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
	ToggleECC()
	RPress()
	StealableTarget()
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
	if target.isEnemy and not target.isImmortal and target.isTargetable and not target.dead then
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
	if _G.SDK then
		if type1 == "damage" then
			if H.totalDamage > H.ap then
				local target = _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
				return target
			elseif H.totalDamage <= H.ap then
				local target = _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_MAGICAL)
				return target
			end
		elseif type1 == "easy" then
			local target = _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
			return target
		elseif type1 == "distance" then
			local target = TargetDistance(range)
			return target
		end
	elseif _G.EOWLoaded then
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
		if _G.SDK then 
			_G.SDK.Orbwalker:SetMovement(bool)
			_G.SDK.Orbwalker:SetAttack(bool)
		elseif _G.EOWLoaded then
			EOW:SetAttacks(bool)
			EOW:SetMovements(bool)
		else
			GOS:BlockAttack(not bool)
			GOS:BlockMovement(not bool)
		end
	elseif state == "Attack" then
		if _G.SDK then 
			_G.SDK.Orbwalker:SetAttack(bool)
		elseif _G.EOWLoaded then
			EOW:SetAttacks(bool)
		else
			GOS:BlockAttack(not bool)
		end
	elseif state == "Movement" then
		if _G.SDK then 
			_G.SDK.Orbwalker:SetMovement(bool)
		elseif _G.EOWLoaded then
			EOW:SetMovements(bool)
		else
			GOS:BlockMovement(not bool)
		end
	end
end

local castXstate = 1
local castXtick = 0
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
	OrbState("Attack", false)
	if target ~= nil and Custom.pred ~= nil and Custom.hotkey ~= nil and not target.dead then
		if castXstate == 1 and (GetTickCount() - castXtick) > 25 then
			if H.attackData == 2 then return end
			castXstate = 2
			local mLocation = nil
			local prediction = Custom.pred:GetPrediction(target, H.pos)
			if Custom.spell == 1 then
				if HealthPred(target, Custom.Delay + 0.1) < 1 then return end
				if not target.toScreen.onScreen then
					return
				end
				if prediction and prediction.hitChance >= Custom.hitchance and prediction:mCollision() == Custom.minion and prediction:hCollision() == Custom.hero and not target.dead then
					mLocation = mousePos
					if mLocation == nil then return end
					DelayAction(function() OrbState("Movement", false) end, Custom.delay)
					DelayAction(function() Control.SetCursorPos(prediction.castPos) end, Custom.delay)
					DelayAction(function() Control.KeyDown(Custom.hotkey) end, Custom.delay)
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
				if prediction and prediction.hitChance >= Custom.hitchance and not target.dead then
					mLocation = mousePos
					if mLocation == nil then return end
					DelayAction(function() OrbState("Movement", false) end, Custom.delay)
					DelayAction(function() Control.SetCursorPos(prediction.castPos) end, Custom.delay)
					DelayAction(function() Control.KeyDown(Custom.hotkey) end, Custom.delay)
					DelayAction(function() Control.KeyUp(Custom.hotkey) end, Custom.delay)
					DelayAction(function() Control.SetCursorPos(mLocation) end, (Custom.Delay/2 + Custom.delay))
					DelayAction(function() OrbState("Global", true) end, Custom.delay)
					castXstate = 1
					castXtick = GetTickCount()
				end
			elseif Custom.spell == 3 then
				if HealthPred(target, Custom.Delay + 0.1) < 1 then return end
				if not target.toScreen.onScreen then
					return
				end
				if prediction and prediction.hitChance >= Custom.hitchance and prediction:hCollision() == Custom.hero and not target.dead then
					mLocation = mousePos
					if mLocation == nil then return end
					DelayAction(function() OrbState("Movement", false) end, Custom.delay)
					DelayAction(function() Control.SetCursorPos(prediction.castPos) end, Custom.delay)
					DelayAction(function() Control.KeyDown(Custom.hotkey) end, Custom.delay)
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
	if _G.SDK then
		if ((Game.Timer() - H.attackData.endTime) < (0.45*H.attackData.windDownTime) and (GetTickCount() - castXtick) > 25) then
			if H:GetSpellData(0).toggleState == 1 then
				DelayAction(function() OrbState("Attack", false) end, CustomDelay)
				DelayAction(function() Control.KeyDown(spell) end, CustomDelay)
				DelayAction(function() Control.KeyUp(spell) end, CustomDelay)
				DelayAction(function() OrbState("Attack", true) end, H.attackData.windDownTime)
				castXtick = GetTickCount()
			elseif H:GetSpellData(0).toggleState == 2 then
				DelayAction(function() Control.KeyDown(spell) end, CustomDelay)
				DelayAction(function() Control.KeyUp(spell) end, CustomDelay)
				castXtick = GetTickCount()
			end
		end
	elseif _G.EOWLoaded then
		if ((Game.Timer() - H.attackData.endTime) < (0.45*H.attackData.windDownTime) and (GetTickCount() - castXtick) > 25) then
			DelayAction(function() Control.KeyDown(spell) end, CustomDelay)
			DelayAction(function() Control.KeyUp(spell) end, CustomDelay)
			castXtick = GetTickCount()
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

function GetBuffs(who)
 	local buffs = {}
 	for i = 0, who.buffCount do
    	local buff = who:GetBuff(i)
    	if buff.duration > 0 then
      		table.insert(buffs, buff)
    	end
	end
  return buffs
end

function EnemyComing(target)
	if target == nil then return end
	local first = { dist = math.sqrt(DistTo(target.pos, H.pos)), Time = Game.Timer()}
	if Game.Timer() - first.Time > 0.1 then 
		local seconde = { dist = math.sqrt(DistTo(target.pos, H.pos))}
		if first.dist - seconde.dist > 0 then return true 
		else end
	end
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
		if buffs.type == (5 or 8 or 11 or 22 or 24 or 29 or 30) and buffs.expireTime > 0.9 then
			return true
		end
	end
	return false
end

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

function EnemiesAround(CustomRange, number)
	local Count = 0
	for i = 0, Game.HeroCount() do
		local Enemy = Game.Hero(i)
		if math.sqrt(DistTo(Enemy.pos, H.pos)) <= CustomRange and Enemy.isEnemy then
			Count = Count + 1
		end
	end
	return Count
end

function HealthPred(target, time)
	if _G.SDK then
		return _G.SDK.HealthPrediction:GetPrediction(target, time)
	elseif _G.EOWLoaded then
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
		if math.sqrt(DistTo(target.pos, H.pos)) < W.range then
			if (target.health + target.shieldAD + target.shieldAP) < getdmg("W", target, myHero) then
				CastX(1, target, 0.15)
			end
		end
	end
	if Menu.Killsteal.UseR:Value() and Game.CanUseSpell(3) == 0 then
		if H.activeSpell.valid then return end
		local target = Target(R.range, "easy")
		if Target(R.range, "easy") == nil then return end
		if math.sqrt(DistTo(target.pos, H.pos)) < R.range then
			if (target.health + target.shieldAD + target.shieldAP) < getdmg("R", target, myHero) then
				CastX(3, target, 0.15)
			end
		end
	end
end

function Force(target)
	if target ~= nil then
		if _G.SDK then
			_G.SDK.Orbwalker.ForceTarget = target
		elseif _G.EOWLoaded then
			EOW:ForceTarget(target)
		elseif _G.GOS then
			GOS:ForceTarget(target)
		end
	else
		if _G.SDK then
			_G.SDK.Orbwalker.ForceTarget = nil
		elseif _G.EOWLoaded then
			EOW:ForceTarget(nil)
		elseif _G.GOS then
			GOS:ForceTarget(nil)
		end
	end
end

--SRU_OrderMinionSiege
--SRU_OrderMinionRanged
--SRU_OrderMinionMelee
--SRU_OrderMinionSuper
--SRU_ChaosMinionRanged
--SRU_ChaosMinionMelee
--SRU_ChaosMinionSiege
--SRU_ChaosMinionSuper

function MinionNumber(range, Type)
	if range == nil then return end
	local count = 0
	if Type == nil then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if DistTo(minion.pos, H.pos) < range then
				count = count + 1
			end
		end
	elseif Type == "ranged" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if H.team == 100 then
				if DistTo(minion.pos, H.pos) < range and minion.charName == "SRU_ChaosMinionRanged" then
					count = count + 1
				end
			elseif H.team == 200 then
				if DistTo(minion.pos, H.pos) < range and minion.charName == "SRU_OrderMinionRanged" then
					count = count + 1
				end
			end
		end
	elseif Type == "melee" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if H.team == 100 then
				if DistTo(minion.pos, H.pos) < range and minion.charName == "SRU_ChaosMinionMelee" then
					count = count + 1
				end
			elseif H.team == 200 then
				if DistTo(minion.pos, H.pos) < range and minion.charName == "SRU_OrderMinionRMelee" then
					count = count + 1
				end
			end
		end
	elseif Type == "siege" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if H.team == 100 then
				if DistTo(minion.pos, H.pos) < range and minion.charName == "SRU_ChaosMinionSiege" then
					count = count + 1
				end
			elseif H.team == 200 then
				if DistTo(minion.pos, H.pos) < range and minion.charName == "SRU_OrderMinionSiege" then
					count = count + 1
				end
			end
		end
	elseif Type == "super" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if H.team == 100 then
				if DistTo(minion.pos, H.pos) < range and minion.charName == "SRU_ChaosMinionSuper" then
					count = count + 1
				end
			elseif H.team == 200 then
				if DistTo(minion.pos, H.pos) < range and minion.charName == "SRU_OrderMinionSuper" then
					count = count + 1
				end
			end
		end
	end
	return count
end

function Combo()
	if H.activeSpell.valid then return end

	castXstate = 1
	OrbState("Global", true)
	if Target((QRange()), "damage") == nil then
		if H:GetSpellData(0).toggleState == 1 and Game.CanUseSpell(0) == 0 then 
			if H.attackData.state ~= 2 then
				OrbState("Global", true)
				CastOnly(HK_Q)
			end
		end
	end

	if Menu.Combo.UseQ:Value() and Game.CanUseSpell(0) == 0 then
		local target = Target(QRange()+50, "damage")
		if not EnemyOk(target) then return end
		if NeedLifesteal(H, QRange()) then return end
		if target ~= nil then
			if H:GetSpellData(0).toggleState == 1 and math.sqrt(DistTo(target.pos, H.pos)) > 650 and math.sqrt(DistTo(target.pos, H.pos)) <= QRange() then
				if H.mana < 20 then return end
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			elseif H:GetSpellData(0).toggleState == 2 and math.sqrt(DistTo(target.pos, H.pos)) <= 650 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			end
		end
	end
	if Menu.Combo.UseW:Value() and Game.CanUseSpell(1) == 0 then
		local target = Target(W.range, "easy")
		if target ~= nil then
			if math.sqrt(DistTo(target.pos, H.pos)) <= W.range and math.sqrt(DistTo(target.pos, H.pos)) > (QRange()+150) and not EnemyComing(target) then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastX(1, target, 0.15)
				end
			elseif math.sqrt(DistTo(target.pos, H.pos)) <= W.range and math.sqrt(DistTo(target.pos, H.pos)) > (QRange()+150) and target.ms > H.ms and not EnemyComing(target) then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastX(1, target, 0.15)
				end
			elseif math.sqrt(DistTo(target.pos, H.pos)) <= W.range and math.sqrt(DistTo(target.pos, H.pos)) > 1100 and EnemiesAround(2000) == 1 and not EnemyComing(target)then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastX(1, target, 0.15)
				end
			elseif math.sqrt(DistTo(target.pos, H.pos)) <= W.range and math.sqrt(DistTo(target.pos, H.pos)) > (QRange()+180) and EnemiesAround(W.range-200) == 1 and AbleCC(target) then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastX(1, target, 0.15)
				end
			end
		end
	end

	if Menu.Combo.UseE:Value() and Game.CanUseSpell(2) == 0 then
		local target = Target(E.range, "distance")
		if target ~= nil then
			if AbleCC(target) then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastX(2, target, 0.2)
				end
			elseif math.sqrt(DistTo(target.pos, H.pos)) < ((H.range+130) * 0.3) and EnemyComing(target) then
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
	if H.activeSpell.valid then return end
	castXstate = 1
	OrbState("Global", true)
	if target == nil then
		if H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then 
			if H.attackData.state ~= 2 then
				OrbState("Global", true)
				CastOnly(HK_Q)
			end
		end
	end
	if Menu.Harass.UseQ:Value() and Game.CanUseSpell(0) == 0 then
		if _G.SDK then
			for i = 0, Game.MinionCount() do
				local minion = Game.Minion(i)
				if math.sqrt(DistTo(minion.pos, H.pos)) < 640 then 
					if _G.SDK.HealthPrediction:GetPrediction(minion, Q.delay) then
						if H:GetSpellData(0).toggleState == 1 and Game.CanUseSpell(0) == 0 then 
							if H.attackData.state ~= 2 then
								OrbState("Global", true)
								CastOnly(HK_Q)
								return
							end
						end
					end
				end
			end
		elseif _G.EOWLoaded then
			for i = 0, Game.MinionCount() do
				local minion = Game.Minion(i)
				if math.sqrt(DistTo(minion.pos, H.pos)) < 650 then 
					if EOW:GetHealthPrediction(minion, Q.delay) then
						if H:GetSpellData(0).toggleState == 1 and Game.CanUseSpell(0) == 0 then 
							if H.attackData.state ~= 2 then
								OrbState("Global", true)
								CastOnly(HK_Q)
								return
							end
						end
					end
				end
			end
		else
			for i = 0, Game.MinionCount() do
				local minion = Game.Minion(i)
				if math.sqrt(DistTo(minion.pos, H.pos)) < 650 then 
					if GOS:HP_Pred(minion, Q.delay) then
						if H:GetSpellData(0).toggleState == 1 and Game.CanUseSpell(0) == 0 then 
							if H.attackData.state ~= 2 then
								OrbState("Global", true)
								CastOnly(HK_Q)
								return
							end
						end
					end
				end
			end
		end
		local target = Target(QRange()+50, "damage")
		if not EnemyOk(target) then return end
		if NeedLifesteal(H, QRange()) then return end
		if target ~= nil then
			if H:GetSpellData(0).toggleState == 1 and math.sqrt(DistTo(target.pos, H.pos)) > 580 and math.sqrt(DistTo(target.pos, H.pos)) <= QRange() then
				if H.mana < 20 then return end
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			elseif H:GetSpellData(0).toggleState == 2 and math.sqrt(DistTo(target.pos, H.pos)) <= 580 then
				if H.attackData.state ~= 2 then
					OrbState("Global", true)
					CastOnly(HK_Q)
				end
			end
		end
	end
	if Menu.Combo.UseW:Value() and Game.CanUseSpell(1) == 0 then
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
--SRU_OrderMinionSiege
--SRU_OrderMinionRanged
--SRU_OrderMinionMelee
--SRU_OrderMinionSuper
--SRU_ChaosMinionRanged
--SRU_ChaosMinionMelee
--SRU_ChaosMinionSiege
--SRU_ChaosMinionSuper
function Laneclear()
	if H.activeSpell.valid then return end
	castXstate = 1
	OrbState("Global", true)
	Force(nil)
	if Menu.Laneclear.UseQ:Value() then
		--[[if MinionNumber(QRange(), "siege") > 0 then	
			if H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then
				CastOnly(HK_Q)
			elseif H:GetSpellData(0).toggleState == 1 then
				for i = 0, Game.MinionCount() do
					local target = Game.Minion(i)
					if H.team == 100 and target.charName == "SRU_ChaosMinionSiege" then
						Force(target)
						break
					elseif H.team == 200 and target.charName == "SRU_OrderMinionSiege" then
						Force(target)
						break
					end
				end
			end
		end]]
		if H:GetSpellData(0).toggleState == 2 and Game.CanUseSpell(0) == 0 then
			CastOnly(HK_Q)
		end
	end
end

function Jungleclear()
	if H.activeSpell.valid then return end
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
	if H.activeSpell.valid then return end
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
	if H.activeSpell.valid then return end
	OrbState("Movement", true)
	OrbState("Attack", false)
	--Ajouter buff maitrise de move speed
end

--Callbacks
Callback.Add("Tick", function() Tick() end)
Callback.Add("Draw", function() Draws() end)
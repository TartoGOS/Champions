if myHero.charName ~= "Kennen" then return end

require 'Eternal Prediction'
require 'DamageLib'

class "Kennen"

local Q = {range = 1050, delay = 0.15, speed = 1700, width = 50}
local W = {range = 750}
local R = {range = 550}
local HeroIcon = "https://i11.servimg.com/u/f11/16/33/77/19/kennen15.png"
local QIcon = "https://i11.servimg.com/u/f11/16/33/77/19/kennen10.png"
local PassiveIcon = "https://i11.servimg.com/u/f11/16/33/77/19/kennen13.png"
local WIcon = "https://i11.servimg.com/u/f11/16/33/77/19/kennen12.png"
local EIcon = "https://i11.servimg.com/u/f11/16/33/77/19/kennen11.png"
local RIcon = "https://i11.servimg.com/u/f11/16/33/77/19/kennen14.png"
local H = myHero
local ping = Game.Latency()/1000
local ColorY, ColorZ = Draw.Color(255, 255, 255, 100), Draw.Color(255, 255, 200, 100)
local castXstate = 1
local castXtick = 0
local QSet = Prediction:SetSpell(Q, TYPE_LINE, true)
local customQvalid = 0
local customWvalid = 0
local customRvalid = 0
local AA = {Up = 0, Down = 0, range = 550}

print("Competitive Kennen Loaded !")

local Menu = MenuElement({id = "Menu", name = "Kennen", type = MENU, leftIcon = HeroIcon})
Menu:MenuElement({id = "Combo", name = "Combo", type = MENU})
Menu:MenuElement({id = "Harass", name = "Harass", type = MENU})
Menu:MenuElement({id = "Laneclear", name = "Laneclear", type = MENU})
Menu:MenuElement({id = "Lasthit", name = "Lasthit", type = MENU})
Menu:MenuElement({id = "Killsteal", name = "Killsteal", type = MENU})
--Menu:MenuElement({id = "Flee", name = "Flee", type = MENU})
Menu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
Menu:MenuElement({id = "AccuracyQ", name = "Q Hitchance", value = 0.15, min = 0.01, max = 1, step = 0.01})

Menu:MenuElement({name = "Version : 1.0", type = SPACE})
Menu:MenuElement({name = "By Tarto", type = SPACE})

--Combo
Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
Menu.Combo:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = WIcon})
Menu.Combo:MenuElement({id = "UseUltimate", name = "Use Ultimate", value = true, leftIcon = RIcon})
Menu.Combo:MenuElement({id = "UseR1v1", name = "Use R 1v1 mode", value = false, leftIcon = RIcon})
Menu.Combo:MenuElement({id = "UseRMini", name = "Minimum enemies to R", value = 1, min = 0, max = 5, leftIcon = RIcon})

--Harass
Menu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
Menu.Harass:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = WIcon})

--Laneclear
Menu.Laneclear:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})

--Lasthit
Menu.Lasthit:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
Menu.Lasthit:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = WIcon})

--Killsteal
Menu.Killsteal:MenuElement({id = "UseQ", name = "Use Q", value = false, leftIcon = QIcon})
Menu.Killsteal:MenuElement({id = "UseW", name = "Use W", value = false, leftIcon = WIcon})

--Flee
--Menu.Flee:MenuElement({id = "UseE", name = "Use E", value = true, leftIcon = EIcon})

--Drawings
Menu.Drawings:MenuElement({id = "DrawAuto", name = "Draw AA Range", value = true, leftIcon = HeroIcon})
Menu.Drawings:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true, leftIcon = QIcon})
Menu.Drawings:MenuElement({id = "DrawW", name = "Draw W Range", value = true, leftIcon = WIcon})
Menu.Drawings:MenuElement({id = "DrawR", name = "Draw R Range", value = true, leftIcon = RIcon})

function Tick()
	if H.dead then return end
	AATick()
	Stealable()
	CheckMode()
end

--_______________________________________________

function Combo()
	if H.activeSpell.valid or CheckSpellValid() then return end
	EnableAll()

	local target = Target(Q.range, "damage")
	if target == nil then return end

	local distance = math.sqrt(DistTo(target.pos, H.pos))

	if distance < Q.range and H.attackData.state ~= 2 then
		if Menu.Combo.UseW:Value() and Game.CanUseSpell(1) == 0 and distance < W.range and Buffed(target, "kennenmarkofstorm") then
			Control.CastSpell(HK_W)
		elseif Menu.Combo.UseQ:Value() and Game.CanUseSpell(0) == 0 then
			CastX(0, target, Menu.AccuracyQ:Value())
		end
		if Menu.Combo.UseUltimate:Value() and Game.CanUseSpell(3) == 0 and distance < R.range then
			if distance > 480 and target.ms > H.ms then return end
			if EnemiesAround(R.range) >= Menu.Combo.UseRMini:Value() then
				Control.CastSpell(HK_R)
			elseif Menu.Combo.UseR1v1:Value() and Game.CanUseSpell(0) ~= 0 or Game.CanUseSpell(1) ~= 0 and Buffed(target, "kennenmarkofstorm") then
				Control.CastSpell(HK_R)
			end
		end		
	end
end

function Harass()
	if H.activeSpell.valid or CheckSpellValid() then return end
	EnableAll()

	local target = Target(Q.range, "damage")
	if target == nil then return end

	local distance = math.sqrt(DistTo(target.pos, H.pos))

	if distance < Q.range and H.attackData.state ~= 2 then
		if Menu.Harass.UseW:Value() and Game.CanUseSpell(1) == 0 and distance < W.range and Buffed(target, "kennenmarkofstorm") then
			Control.CastSpell(HK_W)
		elseif Menu.Harass.UseQ:Value() and Game.CanUseSpell(0) == 0 then
			CastX(0, target, Menu.AccuracyQ:Value())
		end
	end
end

function Laneclear()
	if H.activeSpell.valid or CheckSpellValid() or Game.Timer() < 91 or H.attackData.state == 2 then return end
	EnableAll()

	for i = 0, Game.MinionCount() do
		local minion = Game.Minion(i)
		local mdistance = math.sqrt(DistTo(minion.pos, H.pos))
		local mcollision = minion:GetCollision(Q.width, Q.speed, Q.delay)
		if Menu.Laneclear.UseQ:Value() and Game.CanUseSpell(0) == 0 and mdistance < Q.range and mcollision == 0 and minion.isEnemy and not minion.dead then
			Control.CastSpell(HK_Q, minion)
		end
	end
end

function Jungleclear()
	--
end

function Lasthit()
	if H.activeSpell.valid or CheckSpellValid() or Game.Timer() < 91 then return end
	EnableAll()

	for i = 0, Game.MinionCount() do
		local minion = Game.Minion(i)
		if not minion.isEnemy then return end
		local mdistance = math.sqrt(DistTo(minion.pos, H.pos))
		local mcollision = minion:GetCollision(Q.width, Q.speed, Q.delay)
		local damageQ = getdmg("Q", minion, H)
		local damageW = getdmg("W", minion, H)
		local mhealth = minion
		if minion.isEnemy and not minion.dead then
			if Menu.Lasthit.UseQ:Value() and Game.CanUseSpell(0) == 0 and mdistance < Q.range and mcollision == 0 and damageQ > mhealth then
				Control.CastSpell(HK_Q, minion)
			elseif Menu.Lasthit.UseW:Value() and Game.CanUseSpell(1) == 0 and mdistance < W.range and damageW > mhealth and Buffed(minion, "kennenmarkofstorm") then
				Control.CastSpell(HK_W)
			end
		end
	end
end

function Flee()
	--
end

function Stealable()
	if H.activeSpell.valid or CheckSpellValid() then return end
	EnableAll()

	local target = Target(Q.range, "damage")
	if target == nil then return end

	local distance = math.sqrt(DistTo(target.pos, H.pos))
	local health = target.health + target.shieldAD + target.shieldAP
	local damageQ = getdmg("Q", target, H)
	local damageW = getdmg("W", target, H)

	if distance < Q.range and H.attackData.state ~= 2 then
		if Menu.Killsteal.UseW:Value() and Game.CanUseSpell(1) == 0 and distance < W.range and Buffed(target, "kennenmarkofstorm") and health < damageW then
			Control.CastSpell(HK_W)
		elseif Menu.Killsteal.UseQ:Value() and Game.CanUseSpell(0) == 0 and health < damageQ then
			CastX(0, target, Menu.AccuracyQ:Value())
		end
	end
end


--_______________________________________________

function AATick()
	if H.attackData.state == 2 then
		AAUp = Game.Timer()
	elseif H.attackData.state == 3 then
		AADown = Game.Timer()
	end
end

function HasMoved(target, time)
	local first, second, delay = target.pos, nil, Game.Timer()
	if Game.Timer() - delay > time then
		second = target.pos
		if first ~= second then
			return true
		end
	end
	return false
end

function CheckMode()
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
end

function Draws()
	if H.dead then return end
	if Menu.Drawings.DrawAuto:Value() then
		Draw.Circle(H.pos, AA.range, 2, ColorZ)
	end
	if Menu.Drawings.DrawQ:Value() then
		Draw.Circle(H.pos, Q.range, 2, ColorY)
	end
	if Menu.Drawings.DrawW:Value() then
		Draw.Circle(H.pos, W.range, 2, ColorY)
	end
	if Menu.Drawings.DrawR:Value() then
		Draw.Circle(H.pos, R.range, 2, ColorY)
	end
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
		if _G.SDK then 
			_G.SDK.Orbwalker:SetMovement(bool)
			_G.SDK.Orbwalker:SetAttack(bool)
		elseif EOWLoaded then
			EOW:SetAttacks(bool)
			EOW:SetMovements(bool)
		else
			GOS:BlockAttack(not bool)
			GOS:BlockMovement(not bool)
		end
	elseif state == "Attack" then
		if _G.SDK then 
			_G.SDK.Orbwalker:SetAttack(bool)
		elseif EOWLoaded then
			EOW:SetAttacks(bool)
		else
			GOS:BlockAttack(not bool)
		end
	elseif state == "Movement" then
		if _G.SDK then 
			_G.SDK.Orbwalker:SetMovement(bool)
		elseif EOWLoaded then
			EOW:SetMovements(bool)
		else
			GOS:BlockMovement(not bool)
		end
	end
end

function CastX(spell, target, hitchance, minion, hero)
	if H.activeSpell.valid then return end
	local Custom = {delay = ping, spell = spell, minion = minion, hero = hero, hitchance = hitchance, hotkey = nil, pred = nil, Delay = nil}
	if Custom.minion == nil then Custom.minion = 0 end
	if Custom.hero == nil then Custom.hero = 0 end
	if Custom.hitchance == nil then Custom.hitchance = 0.20 end
	if Custom.spell == 0 then
		Custom.hotkey = HK_Q
		Custom.Delay = Q.delay
	elseif Custom.spell == 1 then
		Custom.hotkey = HK_W
		Custom.Delay = 0
	elseif Custom.spell == 2 then
		Custom.hotkey = HK_R
		Custom.Delay = 0
	end
	if target ~= nil and Custom.hotkey ~= nil and Custom.Delay ~= nil and not target.dead then
		if castXstate == 1 and H.attackData.state ~= 2 then
			castXstate = 2
			local mLocation = nil
			if Custom.spell == 0 then
				if HealthPred(target, Custom.Delay + 0.1) < 1 or not target.toScreen.onScreen then return end
				local prediction = QSet:GetPrediction(target, H.pos)
				OrbState("Attack", false)
				if prediction and prediction.hitChance >= Custom.hitchance and prediction:hCollision() == Custom.hero and prediction:mCollision() == Custom.minion and not target.dead and (Game.Timer() - castXtick) > 1 then
					mLocation = mousePos
					if mLocation == nil then return end
					DelayAction(function() OrbState("Movement", false) end, Custom.delay)
					if target ~= nil then
						DelayAction(function() Control.SetCursorPos(prediction.castPos) end, Custom.delay)
						DelayAction(function() Control.KeyDown(Custom.hotkey) end, Custom.delay)
						DelayAction(function() Control.KeyUp(Custom.hotkey) end, Custom.delay)
						customQvalid = Game.Timer()
						DelayAction(function() Control.SetCursorPos(mLocation) end, (Custom.Delay*0.25 + Custom.delay))
						castXstate = 1
						castXtick = Game.Timer()
						DelayAction(function() OrbState("Global", true) end, (Custom.Delay*0.25 + Custom.delay))
					end
				end
			elseif Custom.spell == 1 then
				if HealthPred(target, Custom.Delay + 0.1) < 1 then return end
				if not target.dead and (Game.Timer() - castXtick) > 1 and target ~= nil then
					DelayAction(function() Control.CastSpell(Custom.hotkey) end, Custom.delay)
					customWvalid = Game.Timer()
					castXstate = 1
					castXtick = Game.Timer()
				end
			elseif Custom.spell == 2 then
				if HealthPred(target, Custom.Delay + 0.1) < 1 then return end
				if not target.dead and (Game.Timer() - castXtick) > 1 and target ~= nil then
					DelayAction(function() Control.CastSpell(Custom.hotkey) end, Custom.delay)
					customRvalid = Game.Timer()
					castXstate = 1
					castXtick = Game.Timer()
				end
			end
		elseif castXstate == 2 then return end
	end
end

function EnemyComing(target, time)
	if target == nil then return end
	local first, second, delay = target.pos, nil, Game.Timer()
	if Game.Timer() - delay > time then
		second = target.pos
		if DistTo(first, H.pos) > DistTo(second, H.pos) then
			return true
		elseif DistTo(first, H.pos) == DistTo(second, H.pos) then
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
	return (distf)
end

function TargetByDistance(range)
	local target = nil
	for i = 0, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if DistTo(Hero.pos, H.pos) <= range and Hero.isEnemy then
			if target == nil then target = Hero break end
			if DistTo(Hero.pos, H.pos) < DistTo(target.pos, H.pos) then
				target = Hero
			end
		end
	end
	return target
end

function EnemiesCloseCanAttack(range)
	local Count = 0
	for i = 0, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if DistTo(Hero.pos, H.pos) <= range and Hero.isEnemy then
			if DistTo(Hero.pos, H.pos) < Hero.range then
				Count = Count + 1
			end
		end
	end
	return Count
end

function HealthPred(target, time)
	if _G.SDK then
		return _G.SDK.HealthPrediction:GetPrediction(target, time)
	elseif EOWLoaded then
		return EOW:GetHealthPrediction(target, time)
	else
		return GOS:HP_Pred(target,time)
	end
end

function Force(target)
	if target ~= nil then
		if _G.SDK then
			_G.SDK.Orbwalker.ForceTarget = target
		elseif EOWLoaded then
			EOW:ForceTarget(target)
		elseif GOS then
			GOS:ForceTarget(target)
		end
	else
		if _G.SDK then
			_G.SDK.Orbwalker.ForceTarget = nil
		elseif EOWLoaded then
			EOW:ForceTarget(nil)
		elseif GOS then
			GOS:ForceTarget(nil)
		end
	end
end

function TurretEnemyAround(range, position)
	local count = 0
	for i = 0, Game.TurretCount() do
		local turret = Game.Turret(i)
		if turret.isEnemy and DistTo(turret.pos, position) <= range then
			count = count + 1
		end
	end
	return count
end

function EnemiesAround(CustomRange)
	local Count = 0
	for i = 0, Game.HeroCount() do
		local Enemy = Game.Hero(i)
		if DistTo(Enemy.pos, H.pos) <= CustomRange and Enemy.isEnemy then
			Count = Count + 1
		end
	end
	return Count
end

function MinionNumber(range, Type, who)
	if range == nil then return end
	if who == nil then who = H end
	local count = 0
	if Type == nil then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if DistTo(minion.pos, who.pos) < range and minion.isEnemy then
				count = count + 1
			end
		end
	elseif Type == "ranged" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if who.team == 100 then
				if DistTo(minion.pos, who.pos) < range and minion.charName == "SRU_ChaosMinionRanged" then
					count = count + 1
				end
			elseif who.team == 200 then
				if DistTo(minion.pos, who.pos) < range and minion.charName == "SRU_OrderMinionRanged" then
					count = count + 1
				end
			end
		end
	elseif Type == "melee" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if who.team == 100 then
				if DistTo(minion.pos, who.pos) < range and minion.charName == "SRU_ChaosMinionMelee" then
					count = count + 1
				end
			elseif who.team == 200 then
				if DistTo(minion.pos, who.pos) < range and minion.charName == "SRU_OrderMinionRMelee" then
					count = count + 1
				end
			end
		end
	elseif Type == "siege" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if who.team == 100 then
				if DistTo(minion.pos, who.pos) < range and minion.charName == "SRU_ChaosMinionSiege" then
					count = count + 1
				end
			elseif who.team == 200 then
				if DistTo(minion.pos, who.pos) < range and minion.charName == "SRU_OrderMinionSiege" then
					count = count + 1
				end
			end
		end
	elseif Type == "super" then
		local minion = 0
		for i = 0, Game.MinionCount() do
			local minion = Game.Minion(i)
			if who.team == 100 then
				if DistTo(minion.pos, who.pos) < range and minion.charName == "SRU_ChaosMinionSuper" then
					count = count + 1
				end
			elseif who.team == 200 then
				if DistTo(minion.pos, who.pos) < range and minion.charName == "SRU_OrderMinionSuper" then
					count = count + 1
				end
			end
		end
	end
	return count
end

function Buffed(target, buffname)
	if target == nil then return end
 	for i = 0, target.buffCount do
    	local buff = target:GetBuff(i)
    	if buff.count > 0 and buff.name == buffname and buff.duration > 0 then
			return true
		end
	end
end

function ForceMove(position)
	if position ~= nil then
		if _G.SDK then
			_G.SDK.Orbwalker.ForceMovement = position
		elseif EOWLoaded then
			EOW:ForceMovePos(position)
		elseif GOS then
			GOS:ForceMove(position)
		end
	else
		if _G.SDK then
			_G.SDK.Orbwalker.ForceMovement = nil
		elseif EOWLoaded then
			EOW:ForceMovePos(nil)
		elseif GOS then
			GOS:ForceMove(nil)
		end
	end
end

function CheckSpellValid()
	if Game.Timer() - customQvalid <= Q.delay then
		return true
	else return false
	end
end

function EnableAll()
	Force(nil)
	ForceMove(nil)
	castXstate = 1
	OrbState("Global", true)
end

Callback.Add("Tick", function() Tick() end)
Callback.Add("Draw", function() Draws() end)

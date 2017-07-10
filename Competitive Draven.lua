if myHero.charName ~= "Draven" then return end

require 'Eternal Prediction'
require 'DamageLib'

class "Draven"

local E = {range = 1050, delay = 0.25, speed = 1400, width = 130}
local R = {range = 2500, delay = 0.4, speed = 2000, width = 160}
local HeroIcon = "https://i11.servimg.com/u/f11/16/33/77/19/draven14.png"
local QIcon = "https://i11.servimg.com/u/f11/16/33/77/19/draven10.png"
local WIcon = "https://i11.servimg.com/u/f11/16/33/77/19/draven11.png"
local EIcon = "https://i11.servimg.com/u/f11/16/33/77/19/draven12.png"
local RIcon = "https://i11.servimg.com/u/f11/16/33/77/19/draven13.png"
local H = myHero
local ping = Game.Latency()/1000
local ColorY, ColorZ = Draw.Color(255, 255, 255, 100), Draw.Color(255, 255, 200, 100)
local castXstate = 1
local castXtick = 0
local ESet = Prediction:SetSpell(E, TYPE_LINE, true)
local RSet = Prediction:SetSpell(R, TYPE_LINE, true)
local customEvalid = 0
local customRvalid = 0
local AA = {Up = 0, Down = 0, range = 550, BuffedUp = 0, BuffedDown = 0}

print("Competitive Draven Loaded !")

local Menu = MenuElement({id = "Menu", name = "Draven", type = MENU, leftIcon = HeroIcon})
Menu:MenuElement({id = "Combo", name = "Combo", type = MENU})
Menu:MenuElement({id = "Harass", name = "Harass", type = MENU})
Menu:MenuElement({id = "Laneclear", name = "Laneclear", type = MENU})
Menu:MenuElement({id = "Lasthit", name = "Lasthit", type = MENU})
Menu:MenuElement({id = "Killsteal", name = "Killsteal", type = MENU})
--Menu:MenuElement({id = "Flee", name = "Flee", type = MENU})
Menu:MenuElement({id = "Drawings", name = "Drawings", type = MENU})
Menu:MenuElement({id = "AccuracyE", name = "E Hitchance", value = 0.12, min = 0.01, max = 1, step = 0.01})
Menu:MenuElement({id = "AccuracyR", name = "R Hitchance", value = 0.12, min = 0.01, max = 1, step = 0.01})

Menu:MenuElement({name = "Version : 1.0", type = SPACE})
Menu:MenuElement({name = "By Tarto", type = SPACE})

--Combo
Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
Menu.Combo:MenuElement({id = "UseQgrab", name = "Grab Q [not fully working]", value = false, leftIcon = QIcon})
Menu.Combo:MenuElement({id = "UseQgrabRange", name = "Grab Q Range", value = 150, min = 50, max = 350, step = 5, leftIcon = QIcon})
Menu.Combo:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = WIcon})
Menu.Combo:MenuElement({id = "UseWOften", name = "Use W for Attack Speed Buff", value = false, leftIcon = WIcon})
Menu.Combo:MenuElement({id = "UseWgrab", name = "Use W to grab Q", value = false, leftIcon = WIcon})
Menu.Combo:MenuElement({id = "WMana", name = "Mana mini to W", value = 40, min = 0, max = 100, step = 5, leftIcon = WIcon})
Menu.Combo:MenuElement({id = "UseE", name = "Use E", value = true, leftIcon = EIcon})
Menu.Combo:MenuElement({id = "UseEgp", name = "Use E gapcloser", value = false, leftIcon = EIcon})
Menu.Combo:MenuElement({id = "UseR", name = "Use R BURST", value = false, leftIcon = RIcon})
Menu.Combo:MenuElement({id = "RPress", name = "Semi-Auto R ", key = string.byte("Y"), leftIcon = RIcon})

--Harass
Menu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
Menu.Harass:MenuElement({id = "UseQgrab", name = "Grab Q", value = false, leftIcon = QIcon})
Menu.Harass:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = WIcon})
Menu.Harass:MenuElement({id = "UseWOften", name = "Use W for Attack Speed Buff", value = false, leftIcon = WIcon})
Menu.Harass:MenuElement({id = "WMana", name = "Mana mini to W", value = 40, min = 0, max = 100, step = 5, leftIcon = WIcon})

--Laneclear
Menu.Laneclear:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
Menu.Laneclear:MenuElement({id = "UseQgrab", name = "Grab Q", value = false, leftIcon = QIcon})
Menu.Laneclear:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = WIcon})
Menu.Laneclear:MenuElement({id = "UseWOften", name = "Use W for Attack Speed Buff", value = false, leftIcon = WIcon})
Menu.Laneclear:MenuElement({id = "WMana", name = "Mana mini to W", value = 40, min = 0, max = 100, step = 5, leftIcon = WIcon})

--Lasthit
Menu.Lasthit:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = QIcon})
Menu.Lasthit:MenuElement({id = "UseQgrab", name = "Grab Q", value = false, leftIcon = QIcon})

--Killsteal
Menu.Killsteal:MenuElement({id = "UseE", name = "Use E", value = false, leftIcon = QIcon})
Menu.Killsteal:MenuElement({id = "UseR", name = "Use R", value = false, leftIcon = WIcon})
Menu.Killsteal:MenuElement({id = "Safety", name = "Killsecure only", value = false, leftIcon = WIcon})

--Flee
--Menu.Flee:MenuElement({id = "UseE", name = "Use E", value = true, leftIcon = EIcon})

--Drawings
Menu.Drawings:MenuElement({id = "DrawAuto", name = "Draw AA Range", value = true, leftIcon = HeroIcon})
Menu.Drawings:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true, leftIcon = QIcon})
Menu.Drawings:MenuElement({id = "DrawE", name = "Draw E Range", value = true, leftIcon = EIcon})
Menu.Drawings:MenuElement({id = "DrawR", name = "Draw R Range", value = true, leftIcon = RIcon})

function Tick()
	if H.dead then return end
	AATick()
	RPress()
	particleglobal()
	CheckMode()
end

--dravenspinningleft
--DravenSpinning
--DravenSpinningAttack
--DravenFury
--dravenfurybuff

--DravenRCast
--DravenRDoublecast

--Reti

--_______________________________________________


function Combo()
	if H.activeSpell.valid or CheckSpellValid() then return end

	local target = Target(E.range, "damage")
	if target == nil then return end

	local distance = math.sqrt(DistTo(target.pos, H.pos))

	if distance < E.range and H.attackData.state ~= 2 then
		if Menu.Combo.UseQ:Value() and Game.CanUseSpell(0) == 0 and not Buffed(H, "dravenspinningleft") then
			if (Game.Timer() - AA.BuffedUp) <= 2 then return end
			if distance < (AA.range + 350) and H.ms*WSpeed() > target.ms and Game.CanUseSpell(1) == 0 and Menu.Combo.UseW:Value() then
				Control.CastSpell(HK_Q)
			elseif distance <= (AA.range + 100) then
				Control.CastSpell(HK_Q)
			end
		end
		if Menu.Combo.UseW:Value() and Game.CanUseSpell(1) == 0 and distance < (AA.range + 350) and Menu.Combo.WMana:Value() < 100*H.mana/H.maxMana then
			if not Buffed(H, "dravenfurybuff") then
				Control.CastSpell(HK_W)
			elseif not Buffed(H, "DravenFury") and Menu.Combo.UseWOften:Value() then
				Control.CastSpell(HK_W)
			end
		end
		if Menu.Combo.UseE:Value() and Game.CanUseSpell(2) == 0 then
			if target.isDashing and distance <= (E.range - 100) and Menu.Combo.UseEgp:Value() then
				CastX(0, target, Menu.AccuracyE:Value())
			elseif distance < (E.range*0.70) and H.ms < target.ms then
				CastX(0, target, Menu.AccuracyE:Value())
			elseif distance < 100 then
				CastX(0, target, Menu.AccuracyE:Value())
			end
		end
		if Menu.Combo.UseR:Value() and Game.CanUseSpell(3) == 0 and Qstate() == 1 then
			if distance <= AA.range and Game.CanUseSpell(2) ~= 0 then
				CastX(1, target, Menu.AccuracyR:Value())
			end
		end
	end
end

function Harass()
	if H.activeSpell.valid or CheckSpellValid() then return end

	local target = Target(E.range, "damage")
	if target == nil then return end

	local distance = math.sqrt(DistTo(target.pos, H.pos))

	if distance < (AA.range + 350) and H.attackData.state ~= 2 then
		if Menu.Harass.UseQ:Value() and Game.CanUseSpell(0) == 0 and not Buffed(H, "dravenspinningleft") then
			if (Game.Timer() - AA.BuffedUp) <= 2 then return end
			if distance < (AA.range + 350) and H.ms*WSpeed() > target.ms and Game.CanUseSpell(1) == 0 and Menu.Harass.UseW:Value() then
				Control.CastSpell(HK_Q)
			elseif distance <= (AA.range + 100) then
				Control.CastSpell(HK_Q)
			end
		end
		if Menu.Harass.UseW:Value() and Game.CanUseSpell(1) == 0 and distance < (AA.range + 350) and Menu.Harass.WMana:Value() < 100*H.mana/H.maxMana then
			if not Buffed(H, "dravenfurybuff") then
				Control.CastSpell(HK_W)
			elseif not Buffed(H, "DravenFury") and Menu.Harass.UseWOften:Value() then
				Control.CastSpell(HK_W)
			end
		end
	end
end

function Laneclear()
	if H.activeSpell.valid or CheckSpellValid() then return end

	for i = 0, Game.MinionCount() do
		local minion = Game.Minion(i)
		local distance = math.sqrt(DistTo(minion.pos, H.pos))

		if distance < AA.range and H.attackData.state ~= 2 then
			if (Game.Timer() - AA.BuffedUp) <= 2 then return end
			if Menu.Laneclear.UseQ:Value() and Game.CanUseSpell(0) == 0 and not Buffed(H, "dravenspinningleft") then
				Control.CastSpell(HK_Q)
			end
		end
		if Menu.Laneclear.UseW:Value() and Game.CanUseSpell(1) == 0 and distance < (AA.range + 350) and Menu.Laneclear.WMana:Value() < 100*H.mana/H.maxMana then
			if not Buffed(H, "dravenfurybuff") then
				Control.CastSpell(HK_W)
			elseif not Buffed(H, "DravenFury") and Menu.Laneclear.UseWOften:Value() then
				Control.CastSpell(HK_W)
			end
		end
	end
end

function Jungleclear()
	--
end

function Lasthit()
	if H.activeSpell.valid or CheckSpellValid() then return end

	for i = 0, Game.MinionCount() do
		local minion = Game.Minion(i)
		local distance = math.sqrt(DistTo(minion.pos, H.pos))

		if distance < AA.range and H.attackData.state ~= 2 then
			if (Game.Timer() - AA.BuffedUp) <= 2 then return end
			if Menu.Lasthit.UseQ:Value() and Game.CanUseSpell(0) == 0 and not Buffed(H, "dravenspinningleft") then
				Control.CastSpell(HK_Q)
			end
		end
	end
end

function Flee()
	--
end

function particleglobal()
	if H.activeSpell.valid or CheckSpellValid() then return end

	for i = 0, Game.ParticleCount() do
		local particle = Game.Particle(i)
		local particlePos = particle.pos
		local distancem = math.sqrt(DistTo(particlePos, mousePos))
		local distanceh = math.sqrt(DistTo(particlePos, H.pos))
		if particle.name == "Draven_Base_Q_reticle.troy" and distanceh <= 1000 then
			if distancem <= Menu.Combo.UseQgrabRange:Value() then
				if Menu.Combo.UseQgrab:Value()  and Game.CanUseSpell(1) == 0 then
					ForceMove(particlePos)
					if Menu.Combo.UseWgrab:Value() and Menu.Combo.WMana:Value() < 100*H.mana/H.maxMana then
						Control.CastSpell(HK_W)
					end
				elseif Menu.Harass.UseQgrab:Value() then
					ForceMove(particlePos)
					if Menu.Harass.UseWgrab:Value() and Menu.Harass.WMana:Value() < 100*H.mana/H.maxMana then
						Control.CastSpell(HK_W)
					end
				elseif Menu.Lasthit.UseQgrab:Value() then
					ForceMove(particlePos)
					if Menu.Lasthit.UseWgrab:Value() and Menu.Lasthit.WMana:Value() < 100*H.mana/H.maxMana then
						Control.CastSpell(HK_W)
					end
				elseif Menu.Laneclear.UseQgrab:Value() then
					ForceMove(particlePos)
					if Menu.Laneclear.UseWgrab:Value() and Menu.Laneclear.WMana:Value() < 100*H.mana/H.maxMana then
						Control.CastSpell(HK_W)
					end
				end
			end
		end
		if distanceh < 100 and particle.name == "Draven_Base_Q_ReticleCatchSuccess.troy" then
			EnableAll()
		end
	end
end

--[[function particleglobal()
	if H.activeSpell.valid or CheckSpellValid() then return end

	for i = 0, Game.MissileCount() do
		local axe = Game.Missile(i)
		local axePos = H.missileData.endPos
		local distancem = math.sqrt(DistTo(axePos, mousePos))
		local distanceh = math.sqrt(DistTo(axePos, H.pos))
		if axe.name == "DravenSpinningReturn" or "DravenSpinningReturnCatch" then
			if Menu.Combo.UseQgrab:Value() and distancem <= Menu.Combo.UseQgrabRange:Value() and distanceh > 80  then
				ForceMove(axePos)
				if Menu.Combo.UseWgrab:Value() and Game.CanUseSpell(1) == 0 and Menu.Combo.WMana:Value() < 100*H.mana/H.maxMana then
					Control.CastSpell(HK_W)
				end
			end
		else
			EnableAll()
		end
	end
end]]

function RPress()
	if H.activeSpell.valid or CheckSpellValid() then return end
	EnableAll()

	local target = Target(R.range, "damage")
	if target == nil then return end

	local distance = math.sqrt(DistTo(target.pos, H.pos))

	if Game.CanUseSpell(3) == 0 and Menu.Combo.RPress:Value() then
		CastX(1, target, Menu.AccuracyR:Value())
	end
end


--_______________________________________________

function AATick()
	if H.attackData.state == 2 then
		AA.Up = Game.Timer()
	elseif H.attackData.state == 3 then
		AA.Down = Game.Timer()
	end
	if H.attackData.state == 2 and Buffed(H, "dravenspinningleft") then
		AA.BuffedUp = Game.Timer()
	elseif H.attackData.state == 3 and Buffed(H, "dravenspinningleft") then
		AA.BuffedDown = Game.Timer()
	end
end

function WSpeed()
	if H:GetSpellData(1).level == 0 then return 1.4 end
	local speed = {1.4, 1.45, 1.5, 1.55, 1.6}
	return speed[H:GetSpellData(0).level]
end

function Qstate()
	if Game.CanUseSpell(0) == 0 and not Buffed(H, "dravenspinningleft") then
		return 2
	else return 1
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
		Draw.Circle(mousePos, Menu.Combo.UseQgrabRange:Value(), 2, ColorZ)
	end
	if Menu.Drawings.DrawE:Value() then
		Draw.Circle(H.pos, E.range, 2, ColorY)
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
		Custom.hotkey = HK_E
		Custom.Delay = E.delay
	elseif Custom.spell == 1 then
		Custom.hotkey = HK_R
		Custom.Delay = R.delay
	end
	if target ~= nil and Custom.hotkey ~= nil and Custom.Delay ~= nil and not target.dead then
		if castXstate == 1 then
			if H.attackData.state == 2 then return end
			castXstate = 2
			local mLocation = nil
			if Custom.spell == 0 then
				if HealthPred(target, Custom.Delay + 0.1) < 1 then return end
				if not target.toScreen.onScreen then
					return
				end
				local prediction = ESet:GetPrediction(target, H.pos)
				OrbState("Attack", false)
				if prediction and prediction.hitChance >= Custom.hitchance and not target.dead and (Game.Timer() - castXtick) > 1 then
					if H.attackData.state == 2 then return end
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
				local prediction = RSet:GetPrediction(target, H.pos)
				OrbState("Attack", false)
				if prediction and prediction.hitChance >= Custom.hitchance and not target.dead and (Game.Timer() - castXtick) > 1 then
					if H.attackData.state == 2 then return end
					mLocation = mousePos
					local MM = prediction.castPos:ToMM()
					if mLocation == nil then return end
					DelayAction(function() OrbState("Movement", false) end, Custom.delay)
					if target ~= nil then
						DelayAction(function() Control.SetCursorPos(MM.x, MM.y) end, Custom.delay)
						DelayAction(function() Control.KeyDown(Custom.hotkey) end, Custom.delay)
						DelayAction(function() Control.KeyUp(Custom.hotkey) end, Custom.delay)
						customQ3valid = Game.Timer()
						DelayAction(function() Control.SetCursorPos(mLocation) end, (Custom.Delay*0.25 + Custom.delay))
						castXstate = 1
						castXtick = Game.Timer()
						DelayAction(function() OrbState("Global", true) end, (Custom.Delay*0.25 + Custom.delay))
					end
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

function TargetByDistance(range)
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

function EnemiesCloseCanAttack(range)
	local Count = 0
	for i = 0, Game.HeroCount() do
		local Hero = Game.Hero(i)
		if math.sqrt(DistTo(Hero.pos, H.pos)) <= range and Hero.isEnemy then
			if math.sqrt(DistTo(Hero.pos, H.pos)) < Hero.range then
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
		if turret.isEnemy and math.sqrt(DistTo(turret.pos, position)) <= range then
			count = count + 1
		end
	end
	return count
end

function EnemiesAround(CustomRange)
	local Count = 0
	for i = 0, Game.HeroCount() do
		local Enemy = Game.Hero(i)
		if math.sqrt(DistTo(Enemy.pos, H.pos)) <= CustomRange and Enemy.isEnemy then
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
			if math.sqrt(DistTo(minion.pos, who.pos)) < range and minion.isEnemy then
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
	if Game.Timer() - customEvalid <= E.delay then
		return true
	elseif Game.Timer() - customRvalid <= R.delay then
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
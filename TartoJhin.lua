if myHero.charName ~= "Jhin" then return end

require 'DamageLib'
require 'Eternal Prediction'

class "TartoJhin"

function TartoJhin:__init()
    PrintChat("TartoJhin Loaded.")
    TartoJhin:LoadSpells()
    TartoJhin:LoadMenu()
    Callback.Add("Tick", function() TartoJhin.Tick() end)
    Callback.Add("Draw", function() TartoJhin.Draw() end)
end

-- Load Spells
function TartoJhin:LoadSpells()
	Q = {range = 550, delay = 0, speed = 1800, width = 80}
	W = {range = 2550, delay = 0.75, speed = 5000, width = 40}
	E = {range = 750, delay = 0.85, speed = 1600, width = 150}	
	R = {range = 3500, delay = 0.25, speed = 5000, width = 80}
end


function TartoJhin:LoadMenu()
-- Menus
	TartoJhin.Menu = MenuElement({id = "TartoJhin", name = "Jhin", type = MENU, leftIcon ="https://puu.sh/w5Hy1/772c7b6566.png"})
	TartoJhin.Menu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	TartoJhin.Menu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	TartoJhin.Menu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	TartoJhin.Menu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
	TartoJhin.Menu:MenuElement({id = "UltimateR", name = "Ultimate Options", type = MENU})
	TartoJhin.Menu:MenuElement({id = "Misc", name = "Misc", type = MENU})
	TartoJhin.Menu:MenuElement({id = "Draw", name = "Drawings", type = MENU})
	--TartoJhin.Menu:MenuElement({id = "Key", name = "Key Settings", type = MENU})
-- Combo Sub-Menu
	TartoJhin.Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = "https://puu.sh/w4zpp/8bd45baf09.png"})
	TartoJhin.Menu.Combo:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = "https://puu.sh/w4zrj/365ef7cc83.png"})
	TartoJhin.Menu.Combo:MenuElement({id = "UseWKillsteal", name = "Use W Killsteal", value = true, leftIcon = "https://puu.sh/w4zrj/365ef7cc83.png"})
	TartoJhin.Menu.Combo:MenuElement({id = "UseE", name = "Use E", value = true, leftIcon = "https://puu.sh/w4ztd/ebfeb7fe38.png"})
	TartoJhin.Menu.Combo:MenuElement({id = "EComboMana", name = "E Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "https://puu.sh/w4ztd/ebfeb7fe38.png"})
-- LaneClear Sub-Menu
	TartoJhin.Menu.LaneClear:MenuElement({id = "UseQ", name = "[SOON]Use Q", value = false, leftIcon = "https://puu.sh/w4zpp/8bd45baf09.png"})
	TartoJhin.Menu.LaneClear:MenuElement({id = "QLaneclearMana", name = "Q Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "https://puu.sh/w4zpp/8bd45baf09.png"})
	TartoJhin.Menu.LaneClear:MenuElement({id = "UseW", name = "[SOON]Use W", value = false, leftIcon = "https://puu.sh/w4zrj/365ef7cc83.png"})
	TartoJhin.Menu.LaneClear:MenuElement({id = "WLaneclearMana", name = "W Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "https://puu.sh/w4zrj/365ef7cc83.png"})
	TartoJhin.Menu.LaneClear:MenuElement({id = "UseE", name = "[SOON]Use E", value = false, leftIcon = "https://puu.sh/w4ztd/ebfeb7fe38.png"})
	TartoJhin.Menu.LaneClear:MenuElement({id = "ELaneclearMana", name = "E Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "https://puu.sh/w4ztd/ebfeb7fe38.png"})
-- Harass Sub-Menu
	TartoJhin.Menu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = "https://puu.sh/w4zpp/8bd45baf09.png"})
	TartoJhin.Menu.Harass:MenuElement({id = "QHarassMana", name = "Q Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "https://puu.sh/w4zpp/8bd45baf09.png"})
	TartoJhin.Menu.Harass:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = "https://puu.sh/w4zrj/365ef7cc83.png"})
	TartoJhin.Menu.Harass:MenuElement({id = "WComboMana", name = "W Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "https://puu.sh/w4zrj/365ef7cc83.png"})
-- LastHit Sub-Menu
	TartoJhin.Menu.LastHit:MenuElement({id = "UseQ", name = "[SOON]Use Q", value = true, leftIcon = "https://puu.sh/w4zpp/8bd45baf09.png"})
-- UltimateR Sub-Menu
	TartoJhin.Menu.UltimateR:MenuElement({id = "NoMove", name = "[SOON]Don't move while R", value = true})
	TartoJhin.Menu.UltimateR:MenuElement({id = "ForceR", name = "Press to Force Ultimate", key = string.byte("T"), leftIcon = "https://puu.sh/w4zut/d128a4c4dd.png"})
-- Misc Sub-Menu
	TartoJhin.Menu.Misc:MenuElement({id = "AutoW", name = "Auto Use W on CC", value = false, leftIcon = "https://puu.sh/w4zrj/365ef7cc83.png"})
	TartoJhin.Menu.Misc:MenuElement({id = "WMiscMana", name = "W Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "https://puu.sh/w4zrj/365ef7cc83.png"})
-- Draw Sub-Menu
	TartoJhin.Menu.Draw:MenuElement({id = "DrawReady", name = "Draw Only Ready Spells [?]", value = false})
	TartoJhin.Menu.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = false, leftIcon = "https://puu.sh/w4zpp/8bd45baf09.png"})
	TartoJhin.Menu.Draw:MenuElement({id = "DrawW", name = "Draw W Range", value = true, leftIcon = "https://puu.sh/w4zrj/365ef7cc83.png"})
	TartoJhin.Menu.Draw:MenuElement({id = "DrawE", name = "Draw E Range", value = false, leftIcon = "https://puu.sh/w4ztd/ebfeb7fe38.png"})
	TartoJhin.Menu.Draw:MenuElement({id = "DrawR", name = "Draw R Range", value = false, leftIcon = "https://puu.sh/w4zut/d128a4c4dd.png"})
-- Key Sub-Menu
	--TartoJhin.Menu.Key:MenuElement({id = "Combo", name = "Combo", key = string.byte("32")})
	--TartoJhin.Menu.Key:MenuElement({id = "Harass", name = "Harass", key = string.byte("C")})
	--TartoJhin.Menu.Key:MenuElement({id = "LaneClear", name = "LaneClear", key = string.byte("V")})
	--TartoJhin.Menu.Key:MenuElement({id = "LastHit", name = "LastHit", key = string.byte("X")})
	-- Infos
	TartoJhin.Menu:MenuElement({name = "Version : 1.2", type = SPACE})
	TartoJhin.Menu:MenuElement({name = "Patch   : 7.11", type = SPACE})
	TartoJhin.Menu:MenuElement({name = "by Tarto", type = SPACE})
end

function TartoJhin:Tick()
	if myHero.dead then return end

	TartoJhin:UltimateAimbot()
	TartoJhin:StealableTarget()
	TartoJhin:AutoW()

	if TartoJhin:GetMode() == "Combo" then
		TartoJhin:Combo()
	elseif TartoJhin:GetMode() == "Harass" then
		TartoJhin:Harass()
	elseif TartoJhin:GetMode() == "Clear" then
		TartoJhin:LaneClear()
	end
end


--From Weedle
local intToMode = {
   		[0] = "",
   		[1] = "Combo",
   		[2] = "Harass",
   		[3] = "LastHit",
   		[4] = "Clear"
	}

--From Weedle
function TartoJhin:GetMode()
	if _G.EOWLoaded then
		return intToMode[EOW.CurrentMode]
	elseif _G.SDK and _G.SDK.Orbwalker then
		if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
			return "Combo"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then
			return "Harass"	
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] or _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR] then
			return "Clear"
		elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT] then
			return "LastHit"
		end
	else
		return GOS.GetMode()
	end
end


function TartoJhin:Draw()
	if not myHero.alive then return end

	if TartoJhin.Menu.Draw.DrawReady:Value() then
		if TartoJhin:IsReady(_Q) and TartoJhin.Menu.Draw.DrawQ:Value() then
			Draw.Circle(myHero.pos, 600, 1, Draw.Color(255, 255, 255, 100))
		end
		if TartoJhin:IsReady(_W) and TartoJhin.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, 2550, 3, Draw.Color(255, 255, 255, 100))
        end
        if TartoJhin:IsReady(_E) and TartoJhin.Menu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos, 750, 1, Draw.Color(255, 255, 255, 100))
        end
        if TartoJhin:IsReady(_R) and TartoJhin.Menu.Draw.DrawR:Value() then
            Draw.Circle(myHero.pos, 3500, 2, Draw.Color(255, 255, 255, 100))
        end
    else
    	if TartoJhin.Menu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos, 600, 1, Draw.Color(255, 255, 255, 100))
        end
        if TartoJhin.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, 2550, 3, Draw.Color(255, 255, 255, 100))
        end
        if TartoJhin.Menu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos, 750, 1, Draw.Color(255, 255, 255, 100))
        end
        if TartoJhin.Menu.Draw.DrawR:Value() then
            Draw.Circle(myHero.pos, 3500, 2, Draw.Color(255, 255, 255, 100))
        end
    end
end

function TartoJhin:HasBuff(unit, buffname)
    for i, buff in pairs(TartoJhin:GetBuffs(unit)) do
		if buff.name == buffname then
			return true
		end
	end
	return false
end

function TartoJhin:GetBuffs(unit)
    local t = {}
 	for i = 0, unit.buffCount do
    	local buff = unit:GetBuff(i)
    	if buff.count > 0 then
      		table.insert(t, buff)
    	end
  	end
  return t
end

function TartoJhin:IsReady(spellSlot)
    if myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0 and TartoJhin:CheckMana(spellSlot) then
    	return true
    else
    	return false
    end
end

function TartoJhin:CheckMana(spellSlot)
    return myHero:GetSpellData(spellSlot).mana < myHero.mana
end

function TartoJhin:ValidTarget(target)
	if not target.dead and not target.IsImmortal and target.IsTargetable and target.IsEnemy then
		return true
		else return false
	end
end

function TartoJhin:GetTarget(range)
	if _G.SDK and _G.SDK.Orbwalker then
		local target = _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		return target
	elseif _G.EOWLoaded then
		local target = EOW:GetTarget(range, easykill_acd)
		return target
	elseif _G.GOS then
		local target = GOS:GetTarget(range, "AD")
		return target
	else PrintChat("No TargetSelector Loaded ..?")
	end
end

function TartoJhin:AllowMove(bool)
	if _G.SDK and _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:SetMovement(bool)
	elseif _G.Loaded then
		EOW:SetMovements(bool)
	else
		GOS.BlockMovement = not bool
	end
end

function TartoJhin:CastQ(target)
	Control.CastSpell(HK_Q, target)
end

function TartoJhin:CastQReset(target)
	if target == nil then return end
	if _G.SDK and _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:OnPostAttack(TartoJhin:CastQ(target))
	elseif _G.EOWLoaded then
		EOW:AddCallback(EOW.AfterAttack, TartoJhin:CastQ(target))
	else 
		GOS:OnAttackComplete(TartoJhin:CastQ(target))
	end
end

--Vrai début du script
--jhinpassiveattackbuff

local ETime = Game.Timer()

function TartoJhin:Combo()
	if TartoJhin:GetTarget(2550) == nil then return end

	--local ETick = GetTickCount()

	if TartoJhin.Menu.Combo.UseW:Value() and TartoJhin:IsReady(_W) then
		local target = TartoJhin:GetTarget(2550)
		if target == nil then return end
		if TartoJhin:HasBuff(target, "jhinespotteddebuff") then
			if myHero.activeSpell.valid then return end
			local WPred = Prediction:SetSpell(W, TYPE_LINE, true)
			local prediction = WPred:GetPrediction(target, myHero.pos)
			if prediction and prediction.hitChance >= 0.25 and prediction:hCollision() == 0 then
				Control.CastSpell(HK_W, prediction.castPos)
			end
		end
	else
		if TartoJhin.Menu.Combo.UseQ:Value() and TartoJhin:IsReady(_Q) then
			if myHero.activeSpell.valid then return end
			local target = TartoJhin:GetTarget(600)
			if TartoJhin:HasBuff(myHero, "jhinpassiveattackbuff") then return end
			if target == nil then return end
			TartoJhin:CastQReset(target)
		end
	end
	if TartoJhin.Menu.Combo.UseQ:Value() and TartoJhin:IsReady(_Q) then
		if myHero.activeSpell.valid then return end
		local target = TartoJhin:GetTarget(600)
		if TartoJhin:HasBuff(myHero, "jhinpassiveattackbuff") then return end
		if target == nil then return end
		if not TartoJhin:HasBuff(target, "jhinespotteddebuff") then
			TartoJhin:CastQReset(target)
		end
	end
	if not TartoJhin:IsReady(_Q) and not TartoJhin:IsReady(_W) then
		if TartoJhin.Menu.Combo.UseE:Value() and TartoJhin.Menu.Combo.EComboMana:Value() < (100*myHero.mana/myHero.maxMana) and TartoJhin:IsReady(_E) and myHero:GetSpellData(_E).ammo ~= 0 then
			if myHero.activeSpell.valid then return end
			local target = TartoJhin:GetTarget(750)
			if TartoJhin:HasBuff(myHero, "jhinpassiveattackbuff") then return end
			if target == nil then return end
			local EPred = Prediction:SetSpell(E, TYPE_CIRCULAR, true)
			local prediction = EPred:GetPrediction(target, myHero.pos)
			if Game.Timer() - ETime < 10 then return end
			if prediction and prediction.hitChance >= 0.25 then
				Control.CastSpell(HK_E, prediction.castPos)
				ETime = (Game.Timer() + E.delay)
			end
		end	
	end
end

function TartoJhin:LaneClear()
	-- LANECLEAR A FAIRE
end

function TartoJhin:Harass()
	if TartoJhin:GetTarget(2550) == nil then return end

	if TartoJhin.Menu.Harass.UseW:Value() and TartoJhin:IsReady(_W) then
		if myHero.activeSpell.valid then return end
		local target = TartoJhin:GetTarget(2550)
		if target == nil then return end
		if TartoJhin:HasBuff(target, "jhinespotteddebuff") then 
			local WPred = Prediction:SetSpell(W, TYPE_LINE, true)
			local prediction = WPred:GetPrediction(target, myHero.pos)
			if prediction and prediction.hitChance >= 0.25 and prediction:hCollision() == 0 then
				Control.CastSpell(HK_W, prediction.castPos)
			end
		end
	else
		if TartoJhin.Menu.Harass.UseQ:Value() and TartoJhin:IsReady(_Q) then
			if myHero.activeSpell.valid then return end
			local target = TartoJhin:GetTarget(600)
			if TartoJhin:HasBuff(myHero, "jhinpassiveattackbuff") then return end
			if target == nil then return end
			TartoJhin:CastQReset(target)
		end
	end
	if TartoJhin.Menu.Harass.UseQ:Value() and TartoJhin:IsReady(_Q) then
		if myHero.activeSpell.valid then return end
		local target = TartoJhin:GetTarget(600)
		if TartoJhin:HasBuff(myHero, "jhinpassiveattackbuff") then return end
		if target == nil then return end
		if not TartoJhin:HasBuff(target, "jhinespotteddebuff") then
			TartoJhin:CastQReset(target)
		end
	end
end

function TartoJhin:LastHit()
	-- LASTHIT A FAIRE
end

function TartoJhin:UltimateAimbot()
	if myHero:GetSpellData(_R).name == "JhinR" and TartoJhin:IsReady(_R) and TartoJhin.Menu.UltimateR.ForceR:Value() then
		if myHero.activeSpell.valid then return end
		TartoJhin:AllowMove(false)
		local target = TartoJhin:GetTarget(2500)
		Control.CastSpell(HK_R, target) return
	end
	if myHero:GetSpellData(_R).name == "JhinRShot" then
		if TartoJhin.Menu.UltimateR.ForceR:Value() then
			TartoJhin:AllowMove(false)
			local target = TartoJhin:GetTarget(3500)
			if target == nil then return end
			local RPred = Prediction:SetSpell(R, TYPE_LINE, true)
			local prediction = RPred:GetPrediction(target, myHero.pos)
			if prediction and prediction.hitChance >= 0.25 and prediction:hCollision() == 0 then
				Control.CastSpell(HK_R, prediction.castPos)
			end
		end
		TartoJhin:AllowMove(true)
	end
end

function TartoJhin:StealableTarget()
	if TartoJhin:GetTarget(2550) == nil then return end

	if TartoJhin.Menu.Combo.UseWKillsteal:Value() and TartoJhin:IsReady(_W) then
		if myHero.activeSpell.valid then return end
		local target = TartoJhin:GetTarget(2550)
		if target == nil then return end
		if (target.health + target.shieldAD + target.shieldAP) < getdmg("W", target, myHero) and target.distance >= (myHero.range + 250) then 
			local WPred = Prediction:SetSpell(W, TYPE_LINE, true)
			local prediction = WPred:GetPrediction(target, myHero.pos)
			if prediction and prediction.hitChance >= 0.25 and prediction:hCollision() == 0 then
				Control.CastSpell(HK_W, prediction.castPos)
			end
		end
	end
end

function TartoJhin:AutoW()
	if TartoJhin:GetTarget(2550) == nil then return end

	if TartoJhin.Menu.Misc.AutoW:Value() and TartoJhin:IsReady(_W) then
		if myHero.activeSpell.valid then return end
		local target = TartoJhin:GetTarget(2550)
		if target == nil then return end
		if TartoJhin:HasBuff(target, "jhinespotteddebuff") then 
			local WPred = Prediction:SetSpell(W, TYPE_LINE, true)
			local prediction = WPred:GetPrediction(target, myHero.pos)
			if prediction and prediction.hitChance >= 0.25 and prediction:hCollision() == 0 then
				Control.CastSpell(HK_W, prediction.castPos)
			end
		end
	end
end



function OnLoad()
	TartoJhin()
end
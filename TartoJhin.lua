if myHero.charName ~= "Jhin" then return end

class "TartoJhin"

require 'DamageLib'
require '2DGeometry'
require 'Collision'


local WCollision = Collision:SetSpell(3000, 5000, 0, 40, true)
local RCollision = Collision:SetSpell(3400, 828.5, 0, 0, true)

function TartoJhin:__init()
    PrintChat("TartoJhin Loaded.")
    TartoJhin.SpellIcons = {Q = "https://puu.sh/w4zpp/8bd45baf09.png",
						W = "https://puu.sh/w4zrj/365ef7cc83.png",
						E = "https://puu.sh/w4ztd/ebfeb7fe38.png",
						R = "https://puu.sh/w4zut/d128a4c4dd.png"}
    self:LoadSpells()
    self:LoadMenu()
    Callback.Add("Tick", function() TartoJhin.Tick() end)
    Callback.Add("Draw", function() TartoJhin.Draw() end)
end

-- Load Spells
function TartoJhin:LoadSpells()
	Q = {range = 550, delay = 0, speed = 1800, width = 80}
	W = {range = 3000, delay = 0, speed = 5000, width = 40}
	E = {range = 750, delay = 0, speed = 1000, width = 120}	
	R = {range = 3400, delay = 0, speed = 828.5, width = 0}
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
	TartoJhin.Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = TartoJhin.SpellIcons.Q})
	TartoJhin.Menu.Combo:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = TartoJhin.SpellIcons.W})
	TartoJhin.Menu.Combo:MenuElement({id = "UseWKillsteal", name = "Use W Killsteal", value = true, leftIcon = TartoJhin.SpellIcons.W})
	TartoJhin.Menu.Combo:MenuElement({id = "UseE", name = "Use E", value = true, leftIcon = TartoJhin.SpellIcons.E})
	TartoJhin.Menu.Combo:MenuElement({id = "EComboMana", name = "E Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = TartoJhin.SpellIcons.E})
-- LaneClear Sub-Menu
	TartoJhin.Menu.LaneClear:MenuElement({id = "UseQ", name = "[SOON]Use Q", value = false, leftIcon = TartoJhin.SpellIcons.Q})
	TartoJhin.Menu.LaneClear:MenuElement({id = "QLaneclearMana", name = "Q Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = TartoJhin.SpellIcons.Q})
	TartoJhin.Menu.LaneClear:MenuElement({id = "UseW", name = "[SOON]Use W", value = false, leftIcon = TartoJhin.SpellIcons.W})
	TartoJhin.Menu.LaneClear:MenuElement({id = "WLaneclearMana", name = "W Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = TartoJhin.SpellIcons.W})
	TartoJhin.Menu.LaneClear:MenuElement({id = "UseE", name = "[SOON]Use E", value = false, leftIcon = TartoJhin.SpellIcons.E})
	TartoJhin.Menu.LaneClear:MenuElement({id = "ELaneclearMana", name = "E Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = TartoJhin.SpellIcons.E})
-- Harass Sub-Menu
	TartoJhin.Menu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = TartoJhin.SpellIcons.Q})
	TartoJhin.Menu.Harass:MenuElement({id = "QHarassMana", name = "Q Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = TartoJhin.SpellIcons.Q})
	TartoJhin.Menu.Harass:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = TartoJhin.SpellIcons.W})
	TartoJhin.Menu.Harass:MenuElement({id = "WComboMana", name = "W Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = TartoJhin.SpellIcons.W})
-- LastHit Sub-Menu
	TartoJhin.Menu.LastHit:MenuElement({id = "UseQ", name = "[SOON]Use Q", value = true, leftIcon = TartoJhin.SpellIcons.Q})
-- UltimateR Sub-Menu
	TartoJhin.Menu.UltimateR:MenuElement({id = "NoMove", name = "[SOON]Don't move while R", value = true})
	TartoJhin.Menu.UltimateR:MenuElement({id = "ForceR", name = "Press to Force Ultimate", key = string.byte("T"), leftIcon = TartoJhin.SpellIcons.R})
-- Misc Sub-Menu
	TartoJhin.Menu.Misc:MenuElement({id = "AutoW", name = "[SOON]Auto Use W on CC", value = false, leftIcon = TartoJhin.SpellIcons.W})
	TartoJhin.Menu.Misc:MenuElement({id = "WMiscMana", name = "W Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = TartoJhin.SpellIcons.W})
	TartoJhin.Menu.Misc:MenuElement({id = "AutoE", name = "[SOON]Auto Use E on CC", value = false, leftIcon = TartoJhin.SpellIcons.E})
	TartoJhin.Menu.Misc:MenuElement({id = "EMiscMana", name = "E Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = TartoJhin.SpellIcons.E})
-- Draw Sub-Menu
	TartoJhin.Menu.Draw:MenuElement({id = "DrawReady", name = "Draw Only Ready Spells [?]", value = false})
	TartoJhin.Menu.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = false, leftIcon = TartoJhin.SpellIcons.Q})
	TartoJhin.Menu.Draw:MenuElement({id = "DrawW", name = "Draw W Range", value = true, leftIcon = TartoJhin.SpellIcons.W})
	TartoJhin.Menu.Draw:MenuElement({id = "DrawE", name = "Draw E Range", value = false, leftIcon = TartoJhin.SpellIcons.E})
	TartoJhin.Menu.Draw:MenuElement({id = "DrawR", name = "Draw R Range", value = false, leftIcon = TartoJhin.SpellIcons.R})
-- Key Sub-Menu
	--TartoJhin.Menu.Key:MenuElement({id = "Combo", name = "Combo", key = string.byte("32")})
	--TartoJhin.Menu.Key:MenuElement({id = "Harass", name = "Harass", key = string.byte("C")})
	--TartoJhin.Menu.Key:MenuElement({id = "LaneClear", name = "LaneClear", key = string.byte("V")})
	--TartoJhin.Menu.Key:MenuElement({id = "LastHit", name = "LastHit", key = string.byte("X")})
	-- Infos
	TartoJhin.Menu:MenuElement({name = "Version : 1.0", type = SPACE})
	TartoJhin.Menu:MenuElement({name = "Patch   : 7.11", type = SPACE})
	TartoJhin.Menu:MenuElement({name = "by Tarto", type = SPACE})
end

function TartoJhin:Tick()
	if not myHero.alive then return end

	TartoJhin:UltimateAimbot()
	TartoJhin:StealableTarget()

	if _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO] then
		TartoJhin:Combo()
	elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS] then
		TartoJhin:Harass()
	elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR] then
		TartoJhin:LaneClear()
	elseif _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT] then
		TartoJhin:LastHit()
	end
end


function TartoJhin:Draw()
	if not myHero.alive then return end

	if TartoJhin.Menu.Draw.DrawReady:Value() then
		if TartoJhin:IsReady(_Q) and TartoJhin.Menu.Draw.DrawQ:Value() then
			Draw.Circle(myHero.pos, 600, 3, Draw.Color(255, 255, 255, 100))
		end
		if TartoJhin:IsReady(_W) and TartoJhin.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, 2550, 3, Draw.Color(255, 255, 255, 100))
        end
        if TartoJhin:IsReady(_E) and TartoJhin.Menu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos, 750, 3, Draw.Color(255, 255, 255, 100))
        end
        if TartoJhin:IsReady(_R) and TartoJhin.Menu.Draw.DrawR:Value() then
            Draw.Circle(myHero.pos, 3500, 3, Draw.Color(255, 255, 255, 100))
        end
    else
    	if TartoJhin.Menu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos, 600, 3, Draw.Color(255, 255, 255, 100))
        end
        if TartoJhin.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, 2550, 3, Draw.Color(255, 255, 255, 100))
        end
        if TartoJhin.Menu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos, 750, 3, Draw.Color(255, 255, 255, 100))
        end
        if TartoJhin.Menu.Draw.DrawR:Value() then
            Draw.Circle(myHero.pos, 3500, 3, Draw.Color(255, 255, 255, 100))
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


--Vrai début du script
--jhinpassiveattackbuff
function TartoJhin:Combo()
	if _G.SDK.TargetSelector:GetTarget(2800, _G.SDK.DAMAGE_TYPE_PHYSICAL) == nil then return end

	--local ETick = GetTickCount()

	if TartoJhin.Menu.Combo.UseW:Value() and TartoJhin:IsReady(_W) then
		local target = _G.SDK.TargetSelector:GetTarget(2800, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		if TartoJhin:HasBuff(target, "jhinespotteddebuff") then 
			local prediction = target:GetPrediction(5000, 0.75)
			if WCollision:__GetHeroCollision(myHero, target, 3, target) then return end
			Control.CastSpell(HK_W, prediction)
		end
	else
		if TartoJhin.Menu.Combo.UseQ:Value() and TartoJhin:IsReady(_Q) then
			local target = _G.SDK.TargetSelector:GetTarget(600, _G.SDK.DAMAGE_TYPE_PHYSICAL)
			if TartoJhin:HasBuff(myHero, "jhinpassiveattackbuff") then return end
			if target == nil then return end
			local prediction = target:GetPrediction(1800, 0)
			Control.CastSpell(HK_Q, prediction)
		end
	end
	if TartoJhin.Menu.Combo.UseQ:Value() and TartoJhin:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(600, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if TartoJhin:HasBuff(myHero, "jhinpassiveattackbuff") then return end
		if target == nil then return end
		if not TartoJhin:HasBuff(target, "jhinespotteddebuff") then
			local prediction = target:GetPrediction(1800, 0)
			Control.CastSpell(HK_Q, prediction)
		end
	end
	if not TartoJhin:IsReady(_Q) and not TartoJhin:IsReady(_W) then

		if --[[TartoJhin:ETick() and]] TartoJhin.Menu.Combo.UseE:Value() and TartoJhin.Menu.Combo.EComboMana:Value() < (100*myHero.mana/myHero.maxMana) and TartoJhin:IsReady(_E) and myHero:GetSpellData(_E).ammo ~= 0 then
			local target = _G.SDK.TargetSelector:GetTarget(750, _G.SDK.DAMAGE_TYPE_PHYSICAL)
			if TartoJhin:HasBuff(myHero, "jhinpassiveattackbuff") then return end
			if target == nil then return end
			local prediction = target:GetPrediction(1600, 0.85)
			Control.CastSpell(HK_E, prediction)
		end
	end
end

function TartoJhin:LaneClear()
	-- LANECLEAR A FAIRE
end

function TartoJhin:Harass()
	if _G.SDK.TargetSelector:GetTarget(2800, _G.SDK.DAMAGE_TYPE_PHYSICAL) == nil then return end

	if TartoJhin.Menu.Harass.UseW:Value() and TartoJhin:IsReady(_W) then
		local target = _G.SDK.TargetSelector:GetTarget(2800, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		if TartoJhin:HasBuff(target, "jhinespotteddebuff") then 
			local prediction = target:GetPrediction(5000, 0.75)
			if WCollision:__GetHeroCollision(myHero, target, 3, target) then return end
			Control.CastSpell(HK_W, prediction)
		end
	else
		if TartoJhin.Menu.Harass.UseQ:Value() and TartoJhin:IsReady(_Q) then
			local target = _G.SDK.TargetSelector:GetTarget(600, _G.SDK.DAMAGE_TYPE_PHYSICAL)
			if TartoJhin:HasBuff(myHero, "jhinpassiveattackbuff") then return end
			if target == nil then return end
			local prediction = target:GetPrediction(1800, 0)
			Control.CastSpell(HK_Q, prediction)
		end
	end
	if TartoJhin.Menu.Harass.UseQ:Value() and TartoJhin:IsReady(_Q) then
		local target = _G.SDK.TargetSelector:GetTarget(600, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if TartoJhin:HasBuff(myHero, "jhinpassiveattackbuff") then return end
		if target == nil then return end
		if not TartoJhin:HasBuff(target, "jhinespotteddebuff") then
			local prediction = target:GetPrediction(1800, 0)
			Control.CastSpell(HK_Q, prediction)
		end
	end
end

function TartoJhin:LastHit()
	-- LASTHIT A FAIRE
end

--[[local Tick = GetTickCount()

function TartoJhin:ETick()
	local ETick = GetTickCount()
	if ETick - Tick > 450 then
		Tick = GetTickCount()
		return true
	else
		return false
	end

end]]

function TartoJhin:UltimateAimbot()
	if myHero:GetSpellData(_R).name == "JhinR" and TartoJhin:IsReady(_R) and TartoJhin.Menu.UltimateR.ForceR:Value() then
		local target = _G.SDK.TargetSelector:GetTarget(2500, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		Control.CastSpell(HK_R, target) return
	end
	if myHero:GetSpellData(_R).name == "JhinRShot" then
		if TartoJhin.Menu.UltimateR.ForceR:Value() then
			local target = _G.SDK.TargetSelector:GetTarget(3400, _G.SDK.DAMAGE_TYPE_PHYSICAL)
			if target == nil then return end
			local prediction = target:GetPrediction(828.5, 0)
			if RCollision:__GetHeroCollision(myHero, target, 3, target) then return end
			Control.CastSpell(HK_R, prediction)
		end
	end
end

function TartoJhin:StealableTarget()
	if _G.SDK.TargetSelector:GetTarget(2800, _G.SDK.DAMAGE_TYPE_PHYSICAL) == nil then return end

	if TartoJhin.Menu.Combo.UseWKillsteal:Value() and TartoJhin:IsReady(_W) then
		local target = _G.SDK.TargetSelector:GetTarget(2800, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		if (target.health + target.shieldAD + target.shieldAP) < getdmg("W", target, myHero) and target.distance >= (myHero.range + 250) then 
			local prediction = target:GetPrediction(5000, 0.75)
			if WCollision:__GetHeroCollision(myHero, target, 3, target) then return end
			Control.CastSpell(HK_W, prediction)
		end
	end
end

function TartoJhin:AutoW()
	if _G.SDK.TargetSelector:GetTarget(2800, _G.SDK.DAMAGE_TYPE_PHYSICAL) == nil then return end

	if TartoJhin.Menu.Misc.AutoW:Value() and TartoJhin:IsReady(_W) then
		local target = _G.SDK.TargetSelector:GetTarget(2800, _G.SDK.DAMAGE_TYPE_PHYSICAL)
		if target == nil then return end
		if TartoJhin:HasBuff(target, "jhinespotteddebuff") then 
			local prediction = target:GetPrediction(5000, 0.75)
			if WCollision:__GetHeroCollision(myHero, target, 3, target) then return end
			Control.CastSpell(HK_W, prediction)
		end
	end
end



function OnLoad()
	TartoJhin()
end

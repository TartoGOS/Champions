if myHero.charName ~= "Tristana" then return end

require 'DamageLib'
require 'Eternal Prediction'

class "TartoTristana"

function TartoTristana:__init()
	PrintChat("TartoTristana Loaded !")
	PrintChat("Use Eternal or IC's, better not use GOS for this one")
	TartoTristana:LoadSpells()
	TartoTristana:LoadMenu()
	Callback.Add("Tick", function() TartoTristana:Tick() end)
	Callback.Add("Draw", function() TartoTristana:Draw() end)
end

function TartoTristana:LoadSpells()
	Q = {range = myHero:GetSpellData(_Q).range, speed = myHero:GetSpellData(_Q).speed, delay = myHero:GetSpellData(_Q).delay, width = myHero:GetSpellData(_Q).width}
	W = {range = myHero:GetSpellData(_W).range, speed = myHero:GetSpellData(_W).speed, delay = myHero:GetSpellData(_W).delay, width = myHero:GetSpellData(_W).width}
	E = {range = myHero:GetSpellData(_E).range, speed = myHero:GetSpellData(_E).speed, delay = myHero:GetSpellData(_E).delay, width = myHero:GetSpellData(_E).width}
	R = {range = myHero:GetSpellData(_R).range, speed = myHero:GetSpellData(_R).speed, delay = myHero:GetSpellData(_R).delay, width = myHero:GetSpellData(_R).width}
end

function TartoTristana:LoadMenu()
	TartoTristana.Menu = MenuElement({id = "TartoTristana", name = "Tristana", type = MENU, leftIcon = "https://puu.sh/wi7Si/16b21a5a4d.png"})
	TartoTristana.Menu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	TartoTristana.Menu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	TartoTristana.Menu:MenuElement({id = "Draw", name = "Drawings", type = MENU})
	--Combo
	TartoTristana.Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = "https://i58.servimg.com/u/f58/16/33/77/19/trista10.png"})
	TartoTristana.Menu.Combo:MenuElement({id = "UseE", name = "Use E", value = true, leftIcon = "https://i58.servimg.com/u/f58/16/33/77/19/trista13.png"})
	TartoTristana.Menu.Combo:MenuElement({id = "UseR", name = "Use R", value = false, leftIcon = "https://i58.servimg.com/u/f58/16/33/77/19/trista11.png"})
	--Harass
	TartoTristana.Menu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = false, leftIcon = "https://i58.servimg.com/u/f58/16/33/77/19/trista10.png"})
	TartoTristana.Menu.Harass:MenuElement({id = "UseE", name = "Use E", value = true, leftIcon = "https://i58.servimg.com/u/f58/16/33/77/19/trista13.png"})
	TartoTristana.Menu.Harass:MenuElement({id = "EHarassMana", name = "E Mana manager", value = 40, min = 0, max = 100, step = 1, leftIcon = "https://i58.servimg.com/u/f58/16/33/77/19/trista13.png"})
	--Draw
	TartoTristana.Menu.Draw:MenuElement({id = "DrawReady", name = "Draw Only Ready Spells [?]", value = false})
	TartoTristana.Menu.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true, leftIcon = "https://i58.servimg.com/u/f58/16/33/77/19/trista10.png"})
	TartoTristana.Menu.Draw:MenuElement({id = "DrawW", name = "Draw W Range", value = true, leftIcon = "https://i58.servimg.com/u/f58/16/33/77/19/trista12.png"})
	TartoTristana.Menu.Draw:MenuElement({id = "DrawE", name = "Draw E Range", value = true, leftIcon = "https://i58.servimg.com/u/f58/16/33/77/19/trista13.png"})
	TartoTristana.Menu.Draw:MenuElement({id = "DrawR", name = "Draw R Range", value = false, leftIcon = "https://i58.servimg.com/u/f58/16/33/77/19/trista11.png"})
	--Infos
	TartoTristana.Menu:MenuElement({name = "Version : 1.0", type = SPACE})
	TartoTristana.Menu:MenuElement({name = "Patch   : 7.11", type = SPACE})
	TartoTristana.Menu:MenuElement({name = "by Tarto", type = SPACE})
end

function TartoTristana:Tick()
	if myHero.dead then return end

	if TartoTristana:GetMode() == "Combo" then
		TartoTristana:Combo()
	elseif TartoTristana:GetMode() == "Harass" then
		TartoTristana:Harass()
	elseif TartoTristana:GetMode() == "Clear" then
		TartoTristana:Clear()
	elseif TartoTristana:GetMode() == "LastHit" then
		TartoTristana:LastHit()
	end
end

--From Weedle, ty
local intToMode = {
   		[0] = "",
   		[1] = "Combo",
   		[2] = "Harass",
   		[3] = "LastHit",
   		[4] = "Clear"
	}

--From Weedle, ty
function TartoTristana:GetMode()
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

function TartoTristana:Draw()
	if myHero.dead then return end

	if TartoTristana.Menu.Draw.DrawReady:Value() then
		if TartoTristana:IsReady(_Q) and TartoTristana.Menu.Draw.DrawQ:Value() then
			Draw.Circle(myHero.pos, W.range, 2, Draw.Color(255, 255, 255, 100))
		end
		if TartoTristana:IsReady(_E) and TartoTristana.Menu.Draw.DrawE:Value() then
			Draw.Circle(myHero.pos, E.range, 3, Draw.Color(255, 255, 255, 100))
		end
		if TartoTristana:IsReady(_R) and TartoTristana.Menu.Draw.DrawR:Value() then
			Draw.Circle(myHero.pos, R.range, 3, Draw.Color(255, 255, 255, 100))
		end
	else
		if TartoTristana.Menu.Draw.DrawQ:Value() then
			Draw.Circle(myHero.pos, Q.range, 2, Draw.Color(255, 255, 255, 100))
		end
		if TartoTristana.Menu.Draw.DrawE:Value() then
			Draw.Circle(myHero.pos, E.range, 3, Draw.Color(255, 255, 255, 100))
		end
		if TartoTristana.Menu.Draw.DrawR:Value() then
			Draw.Circle(myHero.pos, R.range, 3, Draw.Color(255, 255, 255, 100))
		end
	end
end

function TartoTristana:GetTarget(range)
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

function TartoTristana:CheckMana(spellSlot)
	if myHero:GetSpellData(spellSlot).mana < myHero.mana then
		return true
	else
		return false
	end
end

function TartoTristana:IsReady(spellSlot)
    if myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0 and TartoTristana:CheckMana(spellSlot) then
    	return true
    else
    	return false
    end
end

function TartoTristana:EnableAttack(bool)
	if _G.SDK and _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:SetAttack(bool)
	elseif _G.Loaded then
		EOW:SetAttacks(bool)
	else
		GOS.BlockAttack = not bool
	end
end

function TartoTristana:EnableMove(bool)
	if _G.SDK and _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:SetMovement(bool)
	elseif _G.Loaded then
		EOW:SetMovements(bool)
	else
		GOS.BlockMovement = not bool
	end
end

function TartoTristana:GetBuffs(unit)
 	local t = {}
 	for i = 0, unit.buffCount do
    	local buff = unit:GetBuff(i)
    	if buff.count > 0 then
      		table.insert(t, buff)
    	end
	end
  return t
end

function TartoTristana:HasBuff(unit, buffname)
	for i, buff in pairs(TartoTristana:GetBuffs(unit)) do
		if buff.name == buffname then
			return true
		end
	end
	return false
end

function TartoTristana:AARange()
	local level = myHero.levelData.lvl
	local range = ({550,557,564,571,578,585,592,599,606,613,620,627,634,641,648,655,662,669})[level]
	return range
end

function TartoTristana:ValidEnemyE(range)
	for i = 1, Game.HeroCount() do
		local target = Game.Hero(i)
		if target.pos:DistanceTo(myHero.pos) <= range and TartoTristana:HasBuff(target, "tristanaechargesound") then
			return target
		end
	end
end

function TartoTristana:ForceE(target)
	if _G.SDK and _G.SDK.Orbwalker then
		if target.pos.DistanceTo(myHero.pos) <= TartoTristana:AARange() then
			_G.SDK.Orbwalker.ForceTarget = target
		end
	elseif _G.EOWLoaded then
		EOW:ForceTarget(target)
	elseif _G.GOS then
		GOS:ForceTarget(target)
	end
end

function TartoTristana:NoForce()
	if _G.SDK and _G.SDK.Orbwalker then
		_G.SDK.Orbwalker.ForceTarget = nil
	elseif _G.EOWLoaded then
		EOW:ForceTarget(nil)
	elseif _G.GOS then
		GOS:ForceTarget(nil)
	end
end


function TartoTristana:Combo()
	if TartoTristana:GetTarget(TartoTristana:AARange()) == nil then return end

	if TartoTristana:ValidEnemyE(TartoTristana:AARange()) ~= nil then
		local target = TartoTristana:ValidEnemyE(TartoTristana:AARange())
		TartoTristana:ForceE(target)
	elseif TartoTristana:ValidEnemyE(TartoTristana:AARange()) == nil then
		TartoTristana:NoForce()
	end

	--tristanaechargesound

	if TartoTristana.Menu.Combo.UseE:Value() and TartoTristana:IsReady(_E) then
		local target = TartoTristana:GetTarget(TartoTristana:AARange())
		TartoTristana:CastEReset(target)
	end
	if TartoTristana.Menu.Combo.UseQ:Value() and TartoTristana:IsReady(_Q) then
		TartoTristana:CastQ()
	end

	if TartoTristana.Menu.Combo.UseR:Value() and TartoTristana:IsReady(_R) then
		local target = TartoTristana:GetTarget(TartoTristana:AARange())
		if (target.health + target.shieldAD + target.shieldAP) < getdmg("R", target, myHero) then 
			TartoTristana:CastR(target)
		end
	end
end

function TartoTristana:Clear()
	TartoTristana:NoForce()
end

function TartoTristana:Harass()
	if TartoTristana:GetTarget(TartoTristana:AARange()) == nil then return end

	if TartoTristana:ValidEnemyE(TartoTristana:AARange()) ~= nil then
		local target = TartoTristana:ValidEnemyE(TartoTristana:AARange())
		TartoTristana:ForceE(target)
	elseif TartoTristana:ValidEnemyE(TartoTristana:AARange()) == nil then
		TartoTristana:NoForce()
	end

	if TartoTristana.Menu.Harass.UseE:Value() and TartoTristana:IsReady(_E) and TartoTristana.Menu.Harass.EHarassMana:Value() < (100*myHero.mana/myHero.maxMana) then
		local target = TartoTristana:GetTarget(TartoTristana:AARange())
		TartoTristana:CastEReset(target)
	end
	if TartoTristana.Menu.Harass.UseQ:Value() and TartoTristana:IsReady(_Q) then
		local target = TartoTristana:GetTarget(TartoTristana:AARange())
		TartoTristana:CastQ()
	end
end

function TartoTristana:LastHit()
	TartoTristana:NoForce()
end

function TartoTristana:CastEReset(target)
	if target == nil then return end
	if _G.SDK and _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:OnPostAttack(TartoTristana:CastE(target))
	elseif _G.EOWLoaded then
		EOW:AddCallback(EOW.AfterAttack, TartoTristana:CastE(target))
	else 
		GOS:OnAttackComplete(TartoTristana:CastE(target))
	end
end

function TartoTristana:CastQAttack()
	if target == nil then return end
	if _G.SDK and _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:OnAttack(TartoTristana:CastQ())
	elseif _G.EOWLoaded then
		EOW:AddCallback(EOW.OnAttack, TartoTristana:CastQ())
	else 
		GOS:OnAttack(TartoTristana:CastQ())
	end
end

function TartoTristana:CastQ()
	if myHero.attackData.state == STATE_WINDUP then
		Control.CastSpell(HK_Q)
	end
end

function TartoTristana:CastW(target)
	--
end

function TartoTristana:CastE(target)
	if target == nil then return end
	Control.CastSpell(HK_E, target)
end

function TartoTristana:CastR(target)
	if target == nil then return end
	Control.CastSpell(HK_R, target)
	
end

function OnLoad()
	TartoTristana()
end
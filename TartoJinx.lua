if myHero.charName ~= "Jinx" then return end

require 'DamageLib'
require 'Eternal Prediction'

class "TartoJinx"

function TartoJinx:__init()
	PrintChat("TartoJinx Loaded !")
	TartoJinx:LoadSpells()
	TartoJinx:LoadMenu()
	Callback.Add("Tick", function() TartoJinx:Tick() end)
	Callback.Add("Draw", function() TartoJinx:Draw() end)
end

function TartoJinx:LoadSpells()
	Q = {range = myHero:GetSpellData(_Q).range, speed = myHero:GetSpellData(_Q).speed, delay = myHero:GetSpellData(_Q).delay, width = myHero:GetSpellData(_Q).width}
	W = {range = 1500, speed = 3300, delay = 0.6, width = 60}
	E = {range = myHero:GetSpellData(_E).range, speed = myHero:GetSpellData(_E).speed, delay = myHero:GetSpellData(_E).delay, width = myHero:GetSpellData(_E).width}
	R = {range = 20000, speed = 1700, delay = 0.6, width = 140}
end

function TartoJinx:LoadMenu()
	TartoJinx.Menu = MenuElement({id = "TartoJinx", name = "Jinx", type = MENU, leftIcon = "https://puu.sh/wjmUo/6fcac89c6e.png"})
	TartoJinx.Menu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	TartoJinx.Menu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	TartoJinx.Menu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	TartoJinx.Menu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
	TartoJinx.Menu:MenuElement({id = "Hitchance", name = "Hitchance", type = MENU})
	TartoJinx.Menu:MenuElement({id = "Killsteal", name = "Killsteal", type = MENU})
	TartoJinx.Menu:MenuElement({id = "Draw", name = "Drawings", type = MENU})
	--Combo
	TartoJinx.Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = "https://puu.sh/wjmN5/aafda0c781.png"})
	TartoJinx.Menu.Combo:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = "https://puu.sh/wjmPk/900b665295.png"})
	TartoJinx.Menu.Combo:MenuElement({id = "UseE", name = "Auto-E on CC", value = false, leftIcon = "https://puu.sh/wjmRL/c494c6280d.png"})
	TartoJinx.Menu.Combo:MenuElement({id = "UseR", name = "Use R key", key = string.byte("T"), leftIcon = "https://puu.sh/wjmSz/9170a27129.png"})
	--Harass
	TartoJinx.Menu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true, leftIcon = "https://puu.sh/wjmN5/aafda0c781.png"})
	TartoJinx.Menu.Harass:MenuElement({id = "QMana", name = "Min mana to use rocket AA", value = 40, min = 0, max = 100, step = 1, leftIcon= "https://puu.sh/wjmMv/546108c680.png"})
	TartoJinx.Menu.Harass:MenuElement({id = "UseW", name = "Use W", value = true, leftIcon = "https://puu.sh/wjmPk/900b665295.png"})
	TartoJinx.Menu.Harass:MenuElement({id = "WMana", name = "Min mana to use W", value = 40, min = 0, max = 100, step = 1, leftIcon= "https://puu.sh/wjmPk/900b665295.png"})
	TartoJinx.Menu.Harass:MenuElement({id = "Switch", name = "Switch to Minigun to hit minion", value = true, leftIcon = "https://puu.sh/wjmN5/aafda0c781.png"})
	--LaneClear
	TartoJinx.Menu.LaneClear:MenuElement({id = "Switch", name = "Switch to Minigun to hit minion", value = true, leftIcon = "https://puu.sh/wjmN5/aafda0c781.png"})
	--LastHit
	TartoJinx.Menu.LastHit:MenuElement({id = "SwitchQ", name = "Switch to Minigun to hit minion", value = true, leftIcon = "https://puu.sh/wjmN5/aafda0c781.png"})
	--Hitchance
	TartoJinx.Menu.Hitchance:MenuElement({id = "WHit", name = "W Hitchance", value = 0.25, min = 0.05, max = 1, step = 0.05, leftIcon = "https://puu.sh/wjmPk/900b665295.png"})
	TartoJinx.Menu.Hitchance:MenuElement({id = "RHit", name = "R Hitchance", value = 0.25, min = 0.05, max = 1, step = 0.05, leftIcon = "https://puu.sh/wjmSz/9170a27129.png"})
	--Killsteal
	TartoJinx.Menu.Killsteal:MenuElement({id = "WKill", name = "W Killsteal", value = false, leftIcon = "https://puu.sh/wjmPk/900b665295.png"})
	TartoJinx.Menu.Killsteal:MenuElement({id = "RKill", name = "R Killsteal", value = false, leftIcon = "https://puu.sh/wjmSz/9170a27129.png"})
	--Draw
	TartoJinx.Menu.Draw:MenuElement({id = "DrawReady", name = "Draw Only Ready Spells [?]", value = false})
	TartoJinx.Menu.Draw:MenuElement({id = "DrawFish", name = "Draw Fishbones range", value = true, leftIcon = "https://puu.sh/wjmMv/546108c680.png"})
	TartoJinx.Menu.Draw:MenuElement({id = "DrawW", name = "Draw W Range", value = true, leftIcon = "https://puu.sh/wjmPk/900b665295.png"})
	TartoJinx.Menu.Draw:MenuElement({id = "DrawE", name = "Draw E Range", value = false, leftIcon = "https://puu.sh/wjmRL/c494c6280d.png"})
	TartoJinx.Menu.Draw:MenuElement({id = "DrawR", name = "Draw R Range", value = true, leftIcon = "https://puu.sh/wjmSz/9170a27129.png"})
	--Infos
	TartoJinx.Menu:MenuElement({name = "Version : 1.0", type = SPACE})
	TartoJinx.Menu:MenuElement({name = "Patch   : 7.12", type = SPACE})
	TartoJinx.Menu:MenuElement({name = "by Tarto", type = SPACE})
end

function TartoJinx:Tick()
	if myHero.dead then return end

	if TartoJinx:GetMode() == "Combo" then
		TartoJinx:Combo()
	elseif TartoJinx:GetMode() == "Harass" then
		TartoJinx:Harass()
	elseif TartoJinx:GetMode() == "Clear" then
		TartoJinx:LaneClear()
	elseif TartoJinx:GetMode() == "LastHit" then
		TartoJinx:LastHit()
	end

	TartoJinx:RPress()
	TartoJinx:StealableTarget()
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
function TartoJinx:GetMode()
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

function TartoJinx:Draw()
	if myHero.dead then return end

	if TartoJinx.Menu.Draw.DrawReady:Value() then
		if TartoJinx:IsReady(_W) and TartoJinx.Menu.Draw.DrawW:Value() then
			Draw.Circle(myHero.pos, W.range, 2, Draw.Color(255, 255, 255, 100))
		end
		if TartoJinx:IsReady(_E) and TartoJinx.Menu.Draw.DrawE:Value() then
			Draw.Circle(myHero.pos, E.range, 3, Draw.Color(255, 255, 255, 100))
		end
		if TartoJinx:IsReady(_R) and TartoJinx.Menu.Draw.DrawR:Value() then
			Draw.Circle(myHero.pos, 2500, 3, Draw.Color(255, 255, 255, 100))
		end
	else
		if TartoJinx.Menu.Draw.DrawW:Value() then
			Draw.Circle(myHero.pos, W.range, 2, Draw.Color(255, 255, 255, 100))
		end
		if TartoJinx.Menu.Draw.DrawE:Value() then
			Draw.Circle(myHero.pos, E.range, 3, Draw.Color(255, 255, 255, 100))
		end
		if TartoJinx.Menu.Draw.DrawR:Value() then
			Draw.Circle(myHero.pos, 2500, 3, Draw.Color(255, 255, 255, 100))
		end
	end
	if TartoJinx.Menu.Draw.DrawFish:Value() and myHero:GetSpellData(_Q).level ~= 0 then
		Draw.Circle(myHero.pos, TartoJinx:QRange(), 2, Draw.Color(255, 255, 255, 100))
	end
end

function TartoJinx:GetTarget(range)
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

function TartoJinx:CheckMana(spellSlot)
	if myHero:GetSpellData(spellSlot).mana < myHero.mana then
		return true
	else
		return false
	end
end

function TartoJinx:IsReady(spellSlot)
    if myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0 and TartoJinx:CheckMana(spellSlot) then
    	return true
    else
    	return false
    end
end

function TartoJinx:EnableAttack(bool)
	if _G.SDK and _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:SetAttack(bool)
	elseif _G.Loaded then
		EOW:SetAttacks(bool)
	else
		GOS.BlockAttack = not bool
	end
end

function TartoJinx:EnableMove(bool)
	if _G.SDK and _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:SetMovement(bool)
	elseif _G.Loaded then
		EOW:SetMovements(bool)
	else
		GOS.BlockMovement = not bool
	end
end

function TartoJinx:GetBuffs(unit)
 	local t = {}
 	for i = 0, unit.buffCount do
    	local buff = unit:GetBuff(i)
    	if buff.count > 0 then
      		table.insert(t, buff)
    	end
	end
  return t
end

function TartoJinx:HasBuff(unit, buffname)
	for i, buff in pairs(TartoJinx:GetBuffs(unit)) do
		if buff.name == buffname then
			return true
		end
	end
	return false
end

function TartoJinx:QRange()
	if myHero:GetSpellData(_Q).level == 0 then
		return
	elseif myHero:GetSpellData(_Q).level == 1 then
		return 600
	elseif myHero:GetSpellData(_Q).level == 2 then
		return 625
	elseif myHero:GetSpellData(_Q).level == 3 then
		return 650
	elseif myHero:GetSpellData(_Q).level == 4 then
		return 675
	elseif myHero:GetSpellData(_Q).level == 5 then
		return 700
	end
end

function TartoJinx:EnemyCCed()
	for i = 1, Game.HeroCount() do
		local target = Game.Hero(i)
		if TartoJinx:CCed(target) then
			return target
		end
	end
end
function TartoJinx:CCed(unit)
	if unit == nil then return end
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if unit.buffCount > 0 then
			if buff and (buff.type == 5 or buff.type == 8 or buff.type == 11 or buff.type == 22 or buff.type == 24 or buff.type == 29 or buff.type == 30) then
				return true
			end
		end
	end
	return false
end

function TartoJinx:Combo()
	if TartoJinx:GetTarget(1500) == nil then return end

	if TartoJinx.Menu.Combo.UseQ:Value() and TartoJinx:IsReady(_Q) then
		local target = TartoJinx:GetTarget(TartoJinx:QRange())
		TartoJinx:CastQ(target)
	end
	if myHero.attackData.state == STATE_WINDDOWN then
		if TartoJinx.Menu.Combo.UseW:Value() and TartoJinx:IsReady(_W) then
			if myHero.activeSpell.valid then return end
			local target = TartoJinx:GetTarget(W.range)
			TartoJinx:CastW(target)
		end
	end
	if TartoJinx.Menu.Combo.UseW:Value() and TartoJinx:IsReady(_W) then
		if myHero.activeSpell.valid then return end
		local target = TartoJinx:GetTarget(W.range)
		if target.pos:DistanceTo(myHero.pos) > TartoJinx:QRange() and target.pos:DistanceTo(myHero.pos) <= W.range then
			TartoJinx:CastW(target)
		end
	end
	if TartoJinx.Menu.Combo.UseE:Value() and TartoJinx:IsReady(_E) then
		local target = TartoJinx:GetTarget(E.range)
		if TartoJinx:CCed(target) then
			TartoJinx:CastE(target)
		end
	end
end

function TartoJinx:LaneClear()
	if TartoJinx.Menu.LaneClear.Switch:Value() then
		TartoJinx:CastQFarm()
	end
end

function TartoJinx:Harass()
	if TartoJinx.Menu.Combo.UseQ:Value() and TartoJinx:IsReady(_Q) and TartoJinx.Menu.Harass.QMana:Value() < (100*myHero.mana/myHero.maxMana) then
		local target = TartoJinx:GetTarget(TartoJinx:QRange())
		TartoJinx:CastQ(target)
	end
	if TartoJinx.Menu.Combo.UseW:Value() and TartoJinx:IsReady(_W) and TartoJinx.Menu.Harass.WMana:Value() < (100*myHero.mana/myHero.maxMana) then
		local target = TartoJinx:GetTarget(W.range)
		TartoJinx:CastW(target)
	end

	if TartoJinx:GetTarget(TartoJinx:QRange()) == nil and TartoJinx.Menu.Harass.Switch:Value() then
		TartoJinx:CastQFarm()
	end
end

function TartoJinx:LastHit()
	if TartoJinx.Menu.LastHit.SwitchQ:Value() then
		TartoJinx:CastQFarm()
	end
end

function TartoJinx:RPress()
	if TartoJinx.Menu.Combo.UseR:Value() and TartoJinx:IsReady(_R) then
		local target = TartoJinx:GetTarget(2500)
		if target == nil then return end
		if myHero.activeSpell.valid then return end
		local RPred = Prediction:SetSpell(R, TYPE_LINE, true)
		local prediction = RPred:GetPrediction(target, myHero.pos)
		if prediction and prediction.hitChance >= TartoJinx.Menu.Hitchance.RHit:Value() and prediction:hCollision() == 0 then
			Control.CastSpell(HK_R, prediction.castPos)
		end
	end
end

function TartoJinx:CastQFarm()
	if myHero:GetSpellData(_Q).toggleState == 2 then
		Control.CastSpell(HK_Q)
	end
end

function TartoJinx:CastQ(target)
	if target == nil then return end
	if myHero.activeSpell.valid then return end

	if myHero:GetSpellData(_Q).toggleState == 1 and target.pos:DistanceTo(myHero.pos) > 575 and target.pos:DistanceTo(myHero.pos) < TartoJinx:QRange() and myHero.mana > 20 then
		Control.CastSpell(HK_Q)
	elseif myHero:GetSpellData(_Q).toggleState == 2 and target.pos:DistanceTo(myHero.pos) <= 575 then
		Control.CastSpell(HK_Q)
	end
end

function TartoJinx:CastW(target)
	if target == nil then return end
	if myHero.activeSpell.valid then return end
	local WPred = Prediction:SetSpell(W, TYPE_LINE, true)
	local prediction = WPred:GetPrediction(target, myHero.pos)
	if prediction and prediction.hitChance >= TartoJinx.Menu.Hitchance.WHit:Value() and prediction:mCollision() == 0 and prediction:hCollision() == 0 then
		Control.CastSpell(HK_W, prediction.castPos)
	end
end

function TartoJinx:CastE(target)
	if target == nil then return end
	local EPred = Prediction:SetSpell(E, TYPE_GENERIC, true)
	local prediction = EPred:GetPrediction(target, myHero.pos)
	if prediction and prediction.hitChance >= 0.25 then
		Control.CastSpell(HK_E, prediction.castPos)
	end
end

function TartoJinx:CastR(target)
	--
end

function TartoJinx:StealableTarget()
	if TartoJinx:GetTarget(2500) == nil then return end

	if TartoJinx.Menu.Killsteal.WKill:Value() and TartoJinx:IsReady(_W) then
		if myHero.activeSpell.valid then return end
		local target = TartoJinx:GetTarget(1500)
		if target == nil then return end
		if target.pos:DistanceTo(myHero.pos) > TartoJinx:QRange() and target.pos:DistanceTo(myHero.pos) <= 1500 then
			if (target.health + target.shieldAD + target.shieldAP) < getdmg("W", target, myHero) then
				TartoJinx:CastW(target)
			end
		end
	end

	if TartoJinx.Menu.Killsteal.RKill:Value() and TartoJinx:IsReady(_R) then
		if myHero.activeSpell.valid then return end
		local target = TartoJinx:GetTarget(2500)
		if target == nil then return end
		if target.pos:DistanceTo(myHero.pos) > TartoJinx:QRange() and target.pos:DistanceTo(myHero.pos) <= R.range then
			if (target.health + target.shieldAD + target.shieldAP) < getdmg("R", target, myHero) then
				local RPred = Prediction:SetSpell(R, TYPE_LINE, true)
				local prediction = RPred:GetPrediction(target, myHero.pos)
				if prediction and prediction.hitChance >= TartoJinx.Menu.Hitchance.RHit:Value() and prediction:hCollision() == 0 then
					Control.CastSpell(HK_R, prediction.castPos)
				end
			end
		end
	end
end

function OnLoad()
	TartoJinx()
end
if myHero.charName ~= "Jhin" then return end

class "Jhin"

require('DamageLib')

local _shadow = myHero.pos

function Jhin:initiate()
    PrintChat("JhinTarto Loaded.")
    self.SpellIcons = {Q = "https://puu.sh/w4zpp/8bd45baf09.png",
						W = "https://puu.sh/w4zrj/365ef7cc83.png",
						E = "https://puu.sh/w4ztd/ebfeb7fe38.png",
						R = "https://puu.sh/w4zut/d128a4c4dd.png"}
    self:LoadSpells()
    self:LoadMenu()
    Callback.Add("Tick", function() self:Tick() end)
    Callback.Add("Draw", function() self:Draw() end)
end

-- Load Spells
function Jhin:LoadSpells()
	Q = {Range = myHero:GetSpellData(_Q).range, Delay = myHero:GetSpellData(_Q).delay, speed = myHero:GetSpellData(_Q).speed, width = myHero:GetSpellData(_Q).width}
	W = {Range = myHero:GetSpellData(_W).range, Delay = myHero:GetSpellData(_W).delay, speed = myHero:GetSpellData(_W).speed, width = myHero:GetSpellData(_W).width}
	E = {Range = myHero:GetSpellData(_E).range, Delay = myHero:GetSpellData(_E).delay, speed = myHero:GetSpellData(_E).speed, width = myHero:GetSpellData(_E).width}
	R = {Range = myHero:GetSpellData(_R).range, Delay = myHero:GetSpellData(_R).delay, speed = myHero:GetSpellData(_R).speed, width = myHero:GetSpellData(_R).width}
	PrintChat("JhinTarto Spells Loaded.")
end


-- Menus
function Jhin:LoadMenu()
	self.JhinMenu = MenuElement({id = "JhinTarto", name = "Jhin", type = MENU, leftIcon="https://vignette2.wikia.nocookie.net/leagueoflegends/images/5/57/JhinPortrait.png/revision/latest?cb=20160126071702&path-prefix=fr"})
	self.JhinMenu:MenuElement({id = "Combo", name = "Jhin", type = MENU})
	self.JhinMenu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	self.JhinMenu:MenuElement({id = "Harass", name = "Harass", type = MENU})
	self.JhinMenu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
	self.JhinMenu:MenuElement({id = "UltimateR", name = "Ultimate Options", type = MENU})
	self.JhinMenu:MenuElement({id = "Misc", name = "Misc", type = MENU})
	self.JhinMenu:MenuElement({id = "Draw", name = "Drawings", type = MENU})
	self.JhinMenu:MenuElement({id = "Key", name = "Key Settings", type = MENU})
-- Combo Sub-Menu
	self.JhinMenu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true})
	self.JhinMenu.Combo:MenuElement({id = "UseW", name = "Use W", value = true})
	self.JhinMenu.Combo:MenuElement({id = "UseWKillsteal", name = "Use W Killsteal", value = true})
	self.JhinMenu.Combo:MenuElement({id = "UseE", name = "Use E", value = true})
-- LaneClear Sub-Menu
	self.JhinMenu.LaneClear:MenuElement({id = "UseQ", name = "Use Q", value = false})
	self.JhinMenu.LaneClear:MenuElement({id = "UseW", name = "Use W", value = false})
	self.JhinMenu.LaneClear:MenuElement({id = "UseE", name = "Use E", value = false})
-- Harass Sub-Menu
	self.JhinMenu.Harass:MenuElement({id = "UseQ", name = "Use Q", value = true})
	self.JhinMenu.Harass:MenuElement({id = "UseW", name = "Use W", value = true})
-- LastHit Sub-Menu
	self.JhinMenu.LastHit:MenuElement({id = "UseQ", name = "Use Q", value = true})
-- UltimateR Sub-Menu
	self.JhinMenu.UltimateR:MenuElement({id = "NoMove", name = "Don't move while R", value = true})
	self.JhinMenu.UltimateR:MenuElement({id = "ForceR", name = "Press to Force Ultimate", value = true})
-- Misc Sub-Menu
	self.JhinMenu.Misc:MenuElement({id = "AutoW", name = "Auto Use W on CC", value = false})
	self.JhinMenu.Misc:MenuElement({id = "AutoE", name = "Auto Use E on CC", value = false})
-- Draw Sub-Menu
	self.JhinMenu.Draw:MenuElement({id = "DrawReady", name = "Draw Only Ready Spells [?]", value = false})
	self.JhinMenu.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = false})
	self.JhinMenu.Draw:MenuElement({id = "DrawW", name = "Draw W Range", value = false})
	self.JhinMenu.Draw:MenuElement({id = "DrawE", name = "Draw E Range", value = false})
	self.JhinMenu.Draw:MenuElement({id = "DrawR", name = "Draw R Range", value = false})
-- Key Sub-Menu
	self.JhinMenu.Key:MenuElement({id = "Combo", name = "Combo", key = string.byte("32")})
	self.JhinMenu.Key:MenuElement({id = "Harass", name = "Harass", key = string.byte("C")})
	self.JhinMenu.Key:MenuElement({id = "LaneClear", name = "LaneClear", key = string.byte("V")})
	self.JhinMenu.Key:MenuElement({id = "LastHit", name = "LastHit", key = string.byte("X")})

	PrintChat("JhinTarto Menu Loaded.")
end

function Jhin:Tick()
	if myHero.alive == false then return end
	if self:Mode() == "Combo" then
		self:Combo()
	elseif self:Mode() == "LaneClear" then
		self:LaneClear()
	elseif self:Mode() == "Harass" then
		self:Harass()
	elseif self:Mode() == "LastHit" then
		self:LastHit()
	end
end

function Jhin:Combo()
	-- COMBO A FAIRE
	if JhinMenu.Combo.UseW == true and IsReady(_W) then 
		CastW(_G.SDK.TargetSelector:GetTarget(3000, _G.SDK.DAMAGE_TYPE_PHYSICAL))
		return
	end
	PrintChat("Combo Loaded!")
end

function Jhin:LaneClear()
	-- LANECLEAR A FAIRE
	PrintChat("LaneClear Loaded!")
end

function Jhin:Harass()
	-- HARASS A FAIRE
	PrintChat("Harass Loaded!")
end

function Jhin:LastHit()
	-- LASTHIT A FAIRE
	PrintChat("LastHit Loaded!")
end

function Jhin:CastQ(position)
	if position then
		Control.CastSpell(HK_Q, position)
	end
end

function Jhin:CastW(position)
	if GetTarget(3000) and HasBuff(unit, "jhinespotteddebuff") then
		Control.CastSpell(HK_W, position)
	end
end

function Jhin:CastE(position)
	if position then
		Control.CastSpell(HK_E, position)
	end
end

function Jhin:CastR(target)
	if position then
		Control.CastSpell(HK_R, target)
	end
end

function Jhin:Draw()
	if myHero.dead then return end

	if self.JhinMenu.Draw.DrawReady:Value() then
		if self.IsReady(_Q) and self.JhinMenu.Draw.DrawQ.Value() then
			Draw.Circle(myHero.pos, Q.range, 1, Draw.Color(255, 255, 255, 255))
		end
		if self:IsReady(_W) and self.JhinMenu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, W.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self:IsReady(_E) and self.JhinMenu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos, E.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self:IsReady(_R) and self.JhinMenu.Draw.DrawR:Value() then
            Draw.Circle(myHero.pos, R.Range, 1, Draw.Color(255, 255, 255, 255))
        end
    else
    	if self.JhinMenu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos, Q.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self.JhinMenu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, W.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self.JhinMenu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos, E.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self.JhinMenu.Draw.DrawR:Value() then
            Draw.Circle(myHero.pos, R.Range, 1, Draw.Color(255, 255, 255, 255))
        end
    end
    local textPos = myHero.pos:To2D()
    Draw.Text("EST CE QUE CA MARCHE ?", 20, textPos.x - 80, textPos.y + 60, Draw.Color(255, 255, 0, 0))

    if self.JhinMenu.Draw.DrawTarget:Value() then
        local drawTarget = self:GetTarget(Q.Range)
        if drawTarget then
            Draw.Circle(drawTarget.pos,80,3,Draw.Color(255, 255, 0, 0))
        end
    end
end

function Jhin:Mode()
    if JhinMenu.Key.Combo:Value() then return "Combo" end
    if JhinMenu.Key.LaneClear:Value() then return "LaneClear" end
    if JhinMenu.Key.Harass:Value() then return "Harass" end
    if JhinMenu.Key.LastHit:Value() then return "LastHit" end
    return ""
end

function Jhin:GetTarget(range)
	local target
	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if self:IsValidTarget(hero, range) and hero.team ~= myHero.team then
			target = hero
			break
		end
	end
	return target
end

function Jhin:GetFarmTarget(range)
    local target
    for j = 1, Game.MinionCount() do
        local minion = Game.Minion(j)
        if self:IsValidTarget(minion, range) and minion.team ~= myHero.team then
            target = minion
            break
        end
    end
    return target
end

function Jhin:GetPercentHP(unit)
    return 100 * unit.health / unit.maxHealth
end

function Jhin:GetPercentMP(unit)
    return 100 * unit.mana / unit.maxMana
end

function Jhin:HasBuff(unit, buffname)
    for K, Buff in pairs(self:GetBuffs(unit)) do
        if Buff.name:lower() == buffname:lower() then
            return true
        end
    end
    return false
end

function Jhin:GetBuffs(unit)
    self.T = {}
    for i = 0, unit.buffCount do
        local Buff = unit:GetBuff(i)
        if Buff.count > 0 then
            table.insert(self.T, Buff)
        end
    end
    return self.T
end

--Fonction déclarée pour self.CanCast(spellSlot)
function Jhin:IsReady(spellSlot)
    return myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0
end

--Fonction déclarée pour self.CanCast(spellSlot)
function Jhin:CheckMana(spellSlot)
    return myHero:GetSpellData(spellSlot).mana < myHero.mana
end

function Jhin:CanCast(spellSlot)
    return self:IsReady(spellSlot) and self:CheckMana(spellSlot)
end

function Jhin:IsValidTarget(obj, spellRange)
    return obj ~= nil and obj.valid and obj.visible and not obj.dead and obj.isTargetable and obj.distance <= spellRange
end

function Jhin:IsMarked(unit)
	if GetTarget(3000) and HasBuff(unit, "jhinespotteddebuff") then return end
end

function OnLoad()
	Jhin()
end
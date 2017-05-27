if myHero.charName ~= "Jhin" then return end

local menu = MenuElement({id = "JhinTarto", name = "Jhin", type = MENU})
menu:MenuElement({id = "Combo", name = "Jhin", type = MENU})
menu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
menu:MenuElement({id = "Harass", name = "Harass", type = MENU})
menu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
menu:MenuElement({id = "Misc", name = "Misc", type = MENU})

OnDraw(function()
	local qRange = myHero:GetSpellData(3).range
	local qColor = Draw.Color(150,255,0,0)
	Draw.Circle(myHero.pos, qRange, 1, qColor)
	end)
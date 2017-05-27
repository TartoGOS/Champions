print(myHero.charName)

OnDraw(function()
	local qRange = myHero:GetSpellData(3).range
	local qColor = Draw.Color(150,255,0,0)
	Draw.Circle(myHero.pos, qRange, 1, qColor)
	end)
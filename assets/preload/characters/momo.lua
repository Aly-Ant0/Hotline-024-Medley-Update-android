local originy = 0
function onCreate()

	originy = getProperty('dad.y')

end

function onBeatHit()
	if getProperty('dad') then
		setProperty('dad.y',originy+math.random(15,20))
		doTweenY('wifjwiuuf','dad',originy,0.36,'sineOut')
	end

end
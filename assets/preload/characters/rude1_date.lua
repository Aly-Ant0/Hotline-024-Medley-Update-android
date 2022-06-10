local originy = 0
function onCreate()

	originy = getProperty('dad.y')

end

function onBeatHit()
	if getProperty('dad') then
		setProperty('dad.y',originy+20)
		doTweenY('wifjwiuuf','dad',originy,0.26,'sineOut')
	end

end
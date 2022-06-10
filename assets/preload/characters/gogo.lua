local originy = 0
function onCreate()

	originy = getProperty('boyfriend.y')

end

function onBeatHit()
	if getProperty('boyfriend') then
		setProperty('boyfriend.y',originy+math.random(15,20))
		doTweenY('wifjwiuuf2','boyfriend',originy,0.36,'sineOut')
	end

end
local originy = 0
function onCreate()

	originy = getProperty('boyfriend.y')

end

function onBeatHit()
	if getProperty('boyfriend')  then
		setProperty('boyfriend.y',originy+30)
		doTweenY('wifjwiaaf','boyfriend',originy,0.26,'sineOut')
	end

end
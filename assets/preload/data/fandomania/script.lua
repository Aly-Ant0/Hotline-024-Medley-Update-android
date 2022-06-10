function onStepHit()

	if curStep == 60 then
		doTweenAlpha('circInOut', 'camGame', 0, 0.1, 'linear')
        doTweenAlpha('fadeInn', 'camHUD', 0, 0.1, 'linear')
	end
    if curStep == 64 then
		doTweenAlpha('circInOut', 'camGame', 1, 0.000001, 'linear')
        doTweenAlpha('fadeInn', 'camHUD', 1, 0.000001, 'linear')
	end
end
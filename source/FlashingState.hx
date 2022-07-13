package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		/*var bg:FlxBackdrop = new FlxBackdrop(Paths.image('flashing/bg'), 0.2, 0.2, true, false);
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.velocity.x = 90;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);*/

		warnText = new FlxText(0, 0, FlxG.width,
			"hey you, thanks for playing this recreation!\n this recreation is made by\n MAYKOLLYOUTUBE and Aly-Ant\n we hope you all enjoy it\n credits in the credits menu\n to the original creators \n of hotline 024! press A to play /n also you can disable the shaders in graphic options /n and enable some optimization options if you have a low end phone. /n thank you.", 30);
		warnText.setFormat(Paths.font("goodbyeDespair.ttf"), 30, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

		#if android
		addVirtualPad(NONE, A);
		#end

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('nightlight'));
			// FlxG.sound.list.add(music);
			// music.play();
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('entersfx'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}

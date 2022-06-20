package;

import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import flixel.graphics.FlxGraphic;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;

using StringTools;

class ExtrasScreen extends MusicBeatState
{
	var buttonList:Array<String> = [
		'button1',
		'button2',
		'coversButton'
	];
	var bg:FlxSprite;
	var bars:FlxSprite;
	var bars2:FlxSprite;
	var cubes:FlxSprite;
	var button1:FlxSprite;
	var button2:FlxSprite;
	var coversButton:FlxSprite;
	var secret:FlxSprite;
	var text:FlxSprite;

	public static var curSelected:Int = 0;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		PlayState.noSkins = true;

		bg = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/bg'));
		bg.screenCenter();

		bars = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/bars1'));
		bars.screenCenter();

		bars2 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/bars2'));
		bars2.screenCenter();

		cubes = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/cubes'));
		cubes.screenCenter();

		button1 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/button1'));
		button1.screenCenter();

		button2 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/button2'));
		button2.screenCenter();

		coversButton = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/coversButton'));
		coversButton.screenCenter();

		text = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/extrasButton'));
		text.screenCenter();

		add(bg);
		add(bars);
		add(bars2);
		add(cubes);
		add(button1);
		add(button2);
		add(coversButton);
		add(text);

		changeExtra();
		super.create();

		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end
	}
	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			FlxG.sound.play(Paths.sound('selectsfx'));
			changeExtra(-1);
		}
		if (controls.UI_DOWN_P)
	{
			FlxG.sound.play(Paths.sound('selectsfx'));
			changeExtra(1);
		}
		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}
		if (controls.ACCEPT)
		{
			var extraChoice:String = buttonList[curSelected];
			switch(extraChoice)
			{
				case 'button1':
					PlayState.SONG = Song.loadFromJson('soda-disco-funk', 'soda-disco-funk');
					PlayState.isExtras = true;
					FlxG.sound.play(Paths.sound('entersfx'));
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						LoadingState.loadAndSwitchState(new PlayState());
					}); // lazyiness to delete the timer lol
				case 'button2':
					PlayState.SONG = Song.loadFromJson('armageddon',  'armageddon');
					PlayState.isExtras = true;
					FlxG.sound.play(Paths.sound('entersfx'));
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						LoadingState.loadAndSwitchState(new PlayState());
					});
				case 'coversButton':
					FlxG.sound.play(Paths.sound('entersfx'));
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
        		MusicBeatState.switchState(new CoversScreen());
					});
			}
		}
		super.update(elapsed);
	}
	function changeExtra(change:Int = 0)
	{
		curSelected += change;

				if (curSelected < 0)

			curSelected = buttonList.length - 1;

		if (curSelected >= buttonList.length)
			curSelected = 0;

		/*var extraSelected:FlxGraphic = Paths.image('hotline/menu/extras/' + buttonList[curSelected]);
		var extra:FlxGraphic = Paths.image('hotline/menu/extras/' + buttonList);*/

		//sadness
		switch(curSelected)
		{
			case 0:
				button1.alpha = 1;
				FlxTween.tween(button1, {y: button1.y + 5}, 2, {ease: FlxEase.quadInOut, type: PINGPONG});
				button2.alpha = 0.3;
				coversButton.alpha = 0.3;
			case 1:
				button1.alpha = 0.3;
				button2.alpha = 1;
				FlxTween.tween(button2, {y: button2.y + 5}, 2, {ease: FlxEase.quadInOut, type: PINGPONG});
				coversButton.alpha = 0.3;
			case 2:
				button1.alpha = 0.3;
				button2.alpha = 0.3;
				coversButton.alpha = 1;
		}
			/*for (i in 0...buttonList.length)
			{
				buttonList.alpha = 0.5;
			}

			buttonList[curSelected].alpha = 1;*/
	}
}
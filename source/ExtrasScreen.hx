package;

import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
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
import flixel.input.touch.FlxTouch;
import flixel.input.touch.FlxTouchManager;
import lime.utils.Assets;

using StringTools;

class ExtrasScreen extends MusicBeatState
{
	var buttonList:Array<String> = [
		'button1',
		'button2'
	];
	var extrasslct:Bool = true;
	var coverslct:Bool = false;
	var bg:FlxSprite;
	var bars:FlxSprite;
	var bars2:FlxSprite;
	var cubes:FlxSprite;
	var buttonGrp:FlxTypedGroup<FlxSprite>;
	var coversButton:FlxSprite;
	var secret:FlxSprite;
	var text:FlxSprite;
	var buttonLock:FlxSprite;
	public static var curSelected:Int = 0; // idk why is public but ok

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		PlayState.noSkins = true;

		bg = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/bg'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.screenCenter();

		bars = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/bars1'));
		bars.antialiasing = ClientPrefs.globalAntialiasing;
		bars.screenCenter();

		bars2 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/bars2'));
		bars2.screenCenter();

		cubes = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/cubes'));
		cubes.antialiasing = ClientPrefs.globalAntialiasing;
		cubes.screenCenter();

		buttonGrp = new FlxTypedGroup<FlxSprite>();

		for (i in buttonGrp.length)
		{
			var butt:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/button1'));
			//button1.setGraphicSize(Std.int(button1.width * 0.5));
			butt.screenCenter();
			butt.ID = i:
			butt.scale.x -= 0.3;
			butt.scale.y -= 0.3;
			butt.antialiasing = ClientPrefs.globalAntialiasing;
			buttonGrp.add(butt);
		}

		buttonLock = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/lock'));
		buttonLock.setPosition(1158, 16);
		buttonLock.antialiasing = ClientPrefs.globalAntialiasing;
		buttonLock.color = 0xFF363636;

		coversButton = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/coversButton'));
		coversButton.antialiasing = ClientPrefs.globalAntialiasing;
		if(coverslct)
			coversButton.color = 0xFFFFFFFF;
		else
			coversButton.color = 0xFF363636;
		coversButton.screenCenter();

		text = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/extrasButton'));
		text.antialiasing = ClientPrefs.globalAntialiasing;
		text.screenCenter();

		add(bg);
		add(bars);
		add(bars2);
		add(buttonGrp);
		add(cubes);
		add(coversButton);
		add(text);
		add(buttonLock);

		changeExtra();
		xd();
		super.create();

		#if android
		addVirtualPad(FULL, A_B);
		#end
	}
	override function update(elapsed:Float)
	{
		for (touch in FlxG.touches.list) {
			if (touch.overlaps(buttonLock) && FlxG.mouse.overlaps(buttonLock)) {
				buttonLock.color = 0xFFFFFFFF;

				if (touch.justPressed && FlxG.mouse.justPressed) {
					FlxG.sound.play(Paths.sound('selectsfx'));
					MusicBeatState.switchState(new CodeScreen());
				}
			}
			else {
				buttonLock.color = 0xFF363636;
			}
		}
		if (controls.UI_LEFT_P)
		{
			FlxG.sound.play(Paths.sound('selectsfx'));
			changeExtra(-1);
		}
		if (controls.UI_RIGHT_P)
		{
			FlxG.sound.play(Paths.sound('selectsfx'));
			changeExtra(1);
		}
		if (controls.UI_UP_P)
		{
			FlxG.sound.play(Paths.sound('selectsfx'));
			xd(-1);
		}
		if (controls.UI_DOWN_P)
		{
			FlxG.sound.play(Paths.sound('selectsfx'));
			xd(1);
		}
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('backsfx'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if (controls.ACCEPT)
		{
			var extraChoice:String = buttonList[curSelected];
			if (extrasslct)
			{
				FlxG.sound.play(Paths.sound('entersfx'));
				switch(extraChoice)
				{
					case 'button1':
						PlayState.SONG = Song.loadFromJson('soda-disco-funk', 'soda-disco-funk');
						PlayState.isExtras = true;
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							LoadingState.loadAndSwitchState(new PlayState());
						}); // lazyiness to delete the timer lol
					case 'button2':
						PlayState.SONG = Song.loadFromJson('armageddon',  'armageddon');
						PlayState.isExtras = true;
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							LoadingState.loadAndSwitchState(new PlayState());
						});
				}
			}
			if(coverslct){
				MusicBeatState.switchState(new CoversScreen());
			}
		}
		super.update(elapsed);
	}
	function changeExtra(change:Int = 0)
	{
		curSelected += change;

				if (curSelected < 0)

			curSelected = buttonGrp.length - 1;

		if (curSelected >= buttonGrp.length)
			curSelected = 0;

		/*var extraSelected:FlxGraphic = Paths.image('hotline/menu/extras/' + buttonList[curSelected]);
		var extra:FlxGraphic = Paths.image('hotline/menu/extras/' + buttonList);*/

		/*if (button1Twn != null) {
			button1Twn.cancel();
		}
		if (button2Twn != null) {
			button2Twn.cancel();
		}*/

		//sadness
		//0xFF363636 0xFFFFFFFF
		for (item in buttonGrp.members)
		{
			if(curSelected != item.ID){
				item.color = 0xFF363636;
				item.alpha = 0.4;
				FlxTween.tween(item, {"scale.x": 0.7, "scale.y": 0.7}, 0.2, {ease: FlxEase.expoOut});
			}
			else{
				item.color = 0xFFFFFFFF;
				item.alpha = 1;
				FlxTween.tween(item, {"scale.x": 1, "scale.y": 1}, 0.2, {ease: FlxEase.expoOut});
			}
		}
			/*for (i in 0...buttonList.length)
			{
				buttonList.alpha = 0.5;
			}

			buttonList[curSelected].alpha = 1;*/
	}

	function xd(value:Int = 0){
		if(value == -1){
			coverslct = false;
			extrasslct = true;
		}
		if(value == 1){
			coverslct = true;
			extrasslct = false;
		}
	}
}
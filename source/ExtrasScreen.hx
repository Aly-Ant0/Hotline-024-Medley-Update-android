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
		'button2',
		'coversButton'
	];
	var bg:FlxSprite;
	var bars:FlxSprite;
	var bars2:FlxSprite;
	var cubes:FlxSprite;
	var buttonGrp:FlxTypedGroup<FlxSprite>;
	var coversButton:FlxSprite;
	var secret:FlxSprite;
	var text:FlxSprite;
	var buttonLock:FlxSprite;
	var elapsedTime:Float =0;
	public static var curSelected:Int = 0; // idk why is public but ok
	// wip stuff
	var curSelection:Int = 0; // 0 is extras 1 is covers
	var selectingExtras:Bool = true; // null value
	var selectingCoverz:Bool = false;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		PlayState.noSkins = true;
		PlayState.isCovers = false;
		PlayState.isCode = false;
		PlayState.isExtras = true;
		PlayState.isFreeplay = false;

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

		for (i in 0...buttonList.length)
		{
			var butt:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/' + buttonList[i]));
			//button1.setGraphicSize(Std.int(button1.width * 0.5));
			butt.screenCenter();
			butt.ID = i;
			butt.scale.x -= 0.10;
			butt.scale.y -= 0.10;
			butt.antialiasing = ClientPrefs.globalAntialiasing;
			buttonGrp.add(butt);
		}

		buttonLock = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/lock'));
		buttonLock.setPosition(1158, 16);
		buttonLock.antialiasing = ClientPrefs.globalAntialiasing;
		buttonLock.color = 0xFF363636;

		text = new FlxSprite().loadGraphic(Paths.image('hotline/menu/extras/extrasButton'));
		text.antialiasing = ClientPrefs.globalAntialiasing;
		text.screenCenter();

		add(bg);
		add(bars);
		add(bars2);
		add(cubes);
		add(buttonGrp);
		add(text);
		add(buttonLock);

		changeExtra();
		//xd();
		super.create();

		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end
	}
	override function update(elapsed:Float)
	{
		for (touch in FlxG.touches.list) {
			if (touch.overlaps(buttonLock)) {
				buttonLock.color = 0xFFFFFFFF;

				if (touch.justPressed) {
					FlxG.sound.play(Paths.sound('selectsfx'));
					FlxG.switchState(new CodeScreen());
				}
			}
			else {
				buttonLock.color = 0xFF363636;
			}
		}
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
				FlxG.sound.play(Paths.sound('backsfx'));
				MusicBeatState.switchState(new MainMenuState());
		}
		if (controls.ACCEPT)
		{
				var extraChoice:String = buttonList[curSelected];
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
					case 'coversButton':
						MusicBeatState.switchState(new CoversScreen());
				}
		}
		for (item in buttonGrp.members){
			elapsedTime += elapsed * 30;
			if(item.ID == curSelected)
				item.y = (Math.sin(elapsedTime/29)*7.8);
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
		//gray(not selected): 0xFF363636
		//white(transparent and selected): 0xFFFFFFFF
		for (item in buttonGrp.members)
		{
			if(curSelected != item.ID){
				item.color = 0xFF363636;
				item.alpha = 0.4;
			}
			else{
				item.color = 0xFFFFFFFF;
				item.alpha = 1;
			}
		}
		switch(curSelected){
			case 0:
				FlxTween.tween(buttonGrp.members[0], {"scale.x": 1, "scale.y": 1}, 0.15, {ease: FlxEase.expoOut});

				FlxTween.tween(buttonGrp.members[1], {"scale.x": 0.90, "scale.y": 0.90}, 0.15, {ease: FlxEase.expoOut});
				case 1:
					FlxTween.tween(buttonGrp.members[1], {"scale.x": 1, "scale.y": 1}, 0.15, {ease: FlxEase.expoOut});

					FlxTween.tween(buttonGrp.members[0], {"scale.x": 0.90, "scale.y": 0.90}, 0.15, {ease: FlxEase.expoOut});
				case 2:
					// just tween the other buttons.

					FlxTween.tween(buttonGrp.members[1], {"scale.x": 0.90, "scale.y": 0.90}, 0.15, {ease: FlxEase.expoOut});

					FlxTween.tween(buttonGrp.members[0], {"scale.x": 0.90, "scale.y": 0.90}, 0.15, {ease: FlxEase.expoOut});
		}
		buttonGrp.members[2].scale.x = 1;
		buttonGrp.members[2].scale.y = 1;
			/*for (i in 0...buttonList.length)
			{
				buttonList.alpha = 0.5;
			}

			buttonList[curSelected].alpha = 1;*/
	}
}
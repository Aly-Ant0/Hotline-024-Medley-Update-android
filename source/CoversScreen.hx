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
import flixel.util.FlxColor;
import flixel.graphics.FlxGraphic;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;

using StringTools;

class CoversScreen extends MusicBeatState
{
	var buttonGrp:FlxTypedGroup<FlxSprite>;
	var text:FlxSprite;
	var bars:FlxSprite;

	public static var curSelected:Int = 0;

	var buttonList:Array<String> = [
		'button1',
		'button2',
		'button3',
		'button4'
	];
  
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		PlayState.noSkins = false;
		PlayState.isCovers = true;
		PlayState.isCode = false;
		PlayState.isExtras = false;
		PlayState.isFreeplay = false;

		text = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/text'));
		text.screenCenter();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/bg'));
		bg.screenCenter();

		bars = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/bars2'));
		bars.screenCenter();

		buttonGrp = new FlxTypedGroup<FlxSprite>();

		for (i in 0...buttonList.length) {
			var butt:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/' + buttonList[i]));
			butt.screenCenter();
			butt.ID = i;
			buttonGrp.add(butt);
		}
		/*button1 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button1'));
		button1.screenCenter();

		button2 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button2'));
		button2.screenCenter();

		button3 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button3'));
		button3.screenCenter();

		button4 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button4'));
		button4.screenCenter();

		button1Black = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button1'));
		button1Black.color = FlxColor.BLACK;
		button1.screenCenter();

		button2Black = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button2'));
		button2Black.color = FlxColor.BLACK;
		button2.screenCenter();

		button3Black = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button3'));
		button3Black.color = FlxColor.BLACK;
		button3Black.screenCenter();

		button4Black = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button4'));
		button4Black.color = FlxColor.BLACK;
    button4Black.screenCenter();*/

		add(bg);
		add(bars);
		add(text);
		add(buttonGrp);
		//add(button1Black);
		//add(button2Black);
		//add(button3Black);
		//add(button4Black);
		//add(button1);
		//add(button2);
		//add(button3);
		//add(button4);
		//add(buttonSelected);

		changeCover();
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
			changeCover(-1);
		}
		if (controls.UI_DOWN_P)
		{
			FlxG.sound.play(Paths.sound('selectsfx'));
			changeCover(1);
		}
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('backsfx'));
			MusicBeatState.switchState(new ExtrasScreen());
		}
		if (controls.ACCEPT)
		{
			var coverChoice:String = buttonList[curSelected];
			switch(coverChoice)
			{
				case 'button1':
					PlayState.SONG = Song.loadFromJson('thunderstorm', 'thunderstorm');
					PlayState.isCovers = true;
					FlxG.sound.play(Paths.sound('entersfx'));
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						MusicBeatState.switchState(new ChooseSkinState());
					}); // lazyiness to delete the timer lol
				case 'button2':
					PlayState.SONG = Song.loadFromJson('cg-megamix', 'cg-megamix');
					PlayState.isCovers = true;
					FlxG.sound.play(Paths.sound('entersfx'));
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						MusicBeatState.switchState(new ChooseSkinState());
					});
				case 'button3':
					PlayState.SONG = Song.loadFromJson('promenade', 'promenade');
					PlayState.isCovers = true;
					FlxG.sound.play(Paths.sound('entersfx'));
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						MusicBeatState.switchState(new ChooseSkinState());
					});
				case 'button4':
					PlayState.SONG = Song.loadFromJson('deathmatch', 'deathmatch');
					PlayState.isCovers = true;
					FlxG.sound.play(Paths.sound('entersfx'));
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						MusicBeatState.switchState(new ChooseSkinState());
					});
			}
		}
		for (butt in buttonGrp.members)
		{
			if(butt.ID == curSelected) {
					butt.y = (Math.sin(elapsedTime/35)*5.2/* <-this is the y*/);
			}
		}
		super.update(elapsed);
	}

	function changeCover(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = buttonList.length - 1;

		if (curSelected >= buttonList.length)
			curSelected = 0;

		/*var coverSelected:FlxGraphic = Paths.image('hotline/menu/covers/' + buttonList[curSelected]);

		var cover:FlxGraphic = Paths.image('hotline/menu/covers/' + buttonList);*/

			for (butt in buttonGrp.members)
			{
				butt.alpha = 0.65;
				butt.color = 0xFF363636;

				if(butt.ID == curSelected) {
					butt.alpha = 1;
					butt.color = 0xFFFFFFFF;
				}
			}
	}
}

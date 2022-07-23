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

class JukeboxScreen extends MusicBeatState
{
	public static var curSongPlaying:String = 'nightlight';
	var songList:Array<String> = [
		'customer-service',
		'nightlight',
		'broadcasting',
		'mirror-magic',
		'fandomania',
		'killer-queen',
		'hyperfunk',
		'sugarcrush',
		'smokebomb'
	];
	var textGrp:FlxTypedGroup<FlxSprite>;
	var bg:FlxSprite;
	var bars:FlxSprite;
	var jukebox:FlxSprite;

	public static var curSelected:Int = 0;

	override function create()
	{
		bg = new FlxSprite().loadGraphic(Paths.image('hotline/menu/jukebox/bg'));
		bg.screenCenter();
		add(bg);

		bars = new FlxSprite().loadGraphic(Paths.image('hotline/menu/jukebox/bars'));
		bars.screenCenter();
		add(bars);

		jukebox = new FlxSprite(603, 65);
		jukebox.frames = Paths.getSparrowAtlas('hotline/menu/jukebox/jukebox_play', 'preload');
		jukebox.scale.set(1.8, 1.8);
		jukebox.animation.addByPrefix('bruh', 'Jukebox', 24, true);
		jukebox.animation.play('bruh');
		add(jukebox);

		textGrp = new FlxTypedGroup<FlxSprite>();
		add(textGrp);

		for (i in 0...songList.length)
		{
			var text:FlxSprite = new FlxSprite(0, i * 160 + 40).loadGraphic(Paths.image('freeplaySongText/' + songList[i], 'shared'));
			text.screenCenter(X);
			//text.scale.set(0.6, 0.8);
			text.ID = i;
			//text.angle -= i;
			text.x -= 60;
			if (text.ID == curSelected)
			{
				text.angle += 6;
				text.scale.x += 8;
				text.scale.y += 8;
			}
			else
			{
				text.angle -= 6;
				text.scale.x -= 4;
				text.scale.y -= 4;
			}
			textGrp.add(text);
		}

		changeSelection();

		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end

		super.create();
	}
	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			//FlxG.sound.play(Paths.sound('selectsfx'));
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			//FlxG.sound.play(Paths.sound('selectsfx'));
			changeSelection(1);
		}
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('backsfx'));
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('selectsfx'), 0.8);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songList.length - 1;
		if (curSelected >= songList.length)
			curSelected = 0;

		var bullShit:Int = 0;
		for (item in textGrp.members)
		{
			item.y = bullShit - curSelected;
			bullShit++;
			if(item.ID == curSelected)
			{
				item.alpha = 1;
				if(change == 1)
				{
					FlxTween.angle(item, item.angle, item.angle + 5, 0.5, {ease: FlxEase.expoOut});
					FlxTween.tween(item, {x: item.x + 15}, 0.5, {ease: FlxEase.expoOut});
				}
				if(change == -1)
				{
					FlxTween.angle(item, item.angle, item.angle - 5, 0.5, {ease: FlxEase.expoOut});
					FlxTween.tween(item, {x: item.x + 15}, 0.5, {ease: FlxEase.expoOut});
				}
			}
			else
			{
				item.alpha = 0.5;
				if(change == 1)
				{
					FlxTween.angle(item, item.angle, item.angle - 5, 0.5, {ease: FlxEase.expoOut});
					FlxTween.tween(item, {x: item.x - 15}, 0.5, {ease: FlxEase.expoOut});
				}
				if(change == -1)
				{
					FlxTween.angle(item, item.angle, item.angle + 5, 0.5, {ease: FlxEase.expoOut});
					FlxTween.tween(item, {x: item.x - 15}, 0.5, {ease: FlxEase.expoOut});
				}
			}
			if (change == 1)
			{
				FlxTween.tween(item, {y: item.y + 140 + 60}, 0.5, {ease: FlxEase.expoOut});
			}
			if(change == -1)
			{
				FlxTween.tween(item, {y: item.y - 140 + 60}, 0.5, {ease: FlxEase.expoOut});
			}
		}
	}
}

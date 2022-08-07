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
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
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
	var textGrp:FlxTypedGroup<FreeplayText>;
	var bg:FlxSprite;
	var bars:FlxSprite;
	var jukebox:FlxSprite;
	var alias:Bool = ClientPrefs.globalAntialiasing;

	public static var curSelected:Int = 0;

	override function create()
	{
		bg = new FlxSprite().loadGraphic(Paths.image('hotline/menu/jukebox/bg'));
		bg.screenCenter();
		bg.antialiasing = alias;
		add(bg);

		jukebox = new FlxSprite(603, 65);
		jukebox.frames = Paths.getSparrowAtlas('hotline/menu/jukebox/jukebox_play', 'preload');
		jukebox.scale.set(1.8, 1.8);
		jukebox.animation.addByPrefix('bruh', 'Jukebox', 24, true);
		jukebox.animation.play('bruh');
		jukebox.antialiasing = alias;
		add(jukebox);

		textGrp = new FlxTypedGroup<FreeplayText>();
		add(textGrp);

		for (i in 0...songList.length)
		{
			var port:FreeplayText = new FreeplayText(50, 200, songList[i]);
			port.y += ((port.width - 350) + 50 * i);
			port.targetY = i;
			port.ID = i;
			port.setGraphicSize(Std.int(port.width * 1.2));
			//port.alpha = 1;
			textGrp.add(port);
		}

		bars = new FlxSprite().loadGraphic(Paths.image('hotline/menu/jukebox/bars'));
		bars.screenCenter();
		bars.antialiasing = alias;
		add(bars);

		changeSelection();

		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end

		super.create();
	}
	override function update(elapsed:Float)
	{
		for (port in textGrp.members) // the angle tween
		{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 7, 0, 1);
				if(port.targetY == 0)
				{
					var lastAngle:Float = port.angle;
					//var lastX:Float = port.x;
					//item.screenCenter(X);
					port.angle = FlxMath.lerp(lastAngle, 1 * port.targetY, lerpVal);
					//port.x = FlxMath.lerp(lastX, 310, lerpVal);
				}
				else
				{
					port.angle = FlxMath.lerp(port.angle, 6 * port.targetY, lerpVal);
					//port.x = FlxMath.lerp(port.x, 295, lerpVal);
				}
		}

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
			item.targetY = bullShit - curSelected;
			bullShit++;
			item.alpha = 0.6;
			if(item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}

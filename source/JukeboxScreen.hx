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
		'customer-service', 'Customer Service',
		'nightlight', 'Nightlight',
		'broadcasting', 'Broadcasting',
		'mirror-magic', 'Mirror-Magic',
		'fandomania', 'Fandomania',
		'killer-queen', 'Killer Queen',
		'hyperfunk', 'Hyperfunk',
		'sugarcrush', 'Sugarcrush',
		'smokebomb', 'Smokebomb'
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
		jukebox.setGraphicSize(Std.int(jukebox.width * 0.8));
		add(jukebox);

		textGrp = new FlxTypedGroup<FlxSprite>();
		add(textGrp);

		for (i in 0...songList.length)
		{
			var text:FlxSprite = new FlxSprite(0, i * 160 + 40).loadGraphic(Paths.image('freeplaySongText/' + songList[0][i], 'shared'));
			text.screenCenter(X);
			text.ID = i;
			text.angle -= text.angle * i - 10;
			//text.x -= 60;
			textGrp.add(text);
		}

		changeSelection();

		#if android
		addVitrualPad(UP_DOWN, A_B);
		#end

		super.create();
	}
	override function update()
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
		for (item in textGrp.members)
		{
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 7, 0, 1);
			if(item.ID == curSelected)
			{
				var lastAngle = item.angle;
				item.angle = FlxMath.lerp(lastAngle, item.angle + 8, lerpVal);
				item.angle = item.angle;
			}
			else
			{
				item.angle = FlxMath.lerp(item.angle, item.angle - 10, lerpVal);
				item.angle = item.angle;
			}
		}
	}
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('selectsfx'), 0.8);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songList.length - 1;
		if (curSelected >= songList.length)
			curSelected = 0;

		for (item in textGrp.members)
		{
			if(item.ID == curSelected)
			{
				item.alpha = 1;
			}
			else
			{
				item.alpha = 0.5;
			}
		}
	}
}

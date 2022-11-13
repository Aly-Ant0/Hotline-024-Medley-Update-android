package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.FlxSprite;

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Boyfriend;
	var deathSound:FlxSound = new FlxSound();
	var canCancel:Bool = false;
	var stageSuffix:String = "";

	public static var characterName:String = 'death';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'fatal-shot';
	public static var endSoundName:String = 'selectsfx';
	public static var vibrationTime:Int = 1900;//milliseconds

	public static var instance:GameOverSubstate;

	public static function resetVariables() {
		characterName ='death';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'fatal-shot';
		endSoundName = 'selectsfx';
		vibrationTime = 1900;
	}

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);

		super.create();
	}

	public function new()
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		boyfriend = new Boyfriend(0, 0, 'death');
		boyfriend.screenCenter();
		add(boyfriend);

			#if android
		addVirtualPad(NONE, A_B);
		addPadCamera();
		#end

		var blequi:FlxSprite = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		add(blequi);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx'), 1, false, null, true, function()
		{
			FlxTween.tween(blequi, {alpha: 0}, 1, {
				onComplete: function (twn:FlxTween){
					blequi.kill();
				}
			});
			coolStartDeath();
		});
		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
	}

	var isFollowingAlready:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);

		if (controls.ACCEPT)
		{
			if (canCancel){
				endBullshit();
			}
		}

		if (controls.BACK)
		{
			if (canCancel){
				FlxG.sound.music.stop();
				if (PlayState.isCovers)
				{
					MusicBeatState.switchState(new CoversScreen());
					FlxG.sound.playMusic(Paths.music('nightlight'), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.8);
				}
				if (PlayState.isExtras)
				{
					MusicBeatState.switchState(new ExtrasScreen());
					FlxG.sound.playMusic(Paths.music('nightlight'), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.8);
				}
				if (PlayState.isCode)
				{
					MusicBeatState.switchState(new CodeScreen());
					FlxG.sound.playMusic(Paths.music('codemenu'), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.8);
				}
				if (PlayState.isFreeplay)
				{
					FlxG.sound.playMusic(Paths.music('nightlight'), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.8);
					MusicBeatState.switchState(new FreeplayState());
				}

				PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	override function beatHit()
	{
		super.beatHit();

		//FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function coolStartDeath():Void
	{
		canCancel = true;
		boyfriend.playAnim('deathLoop');
		FlxG.sound.playMusic(Paths.music('fatal-shot'), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.8);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm');
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('selectsfx'));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}
}

package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<FlxSprite>;
	var bgstuff:FlxTypedGroup<FlxSprite>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['resume', 'restart', 'botplay', 'practice', 'exit'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);
	//var botplayText:FlxText;

	public static var songName:String = '';

	public function new(x:Float, y:Float)
	{
		super();
		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficulties.length) {
			var diff:String = '' + CoolUtil.difficulties[i];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');

		pauseMusic = new FlxSound();
		pauseMusic.loadEmbedded(Paths.music('memories'), true, true);
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		bgstuff = new FlxTypedGroup<FlxSprite>();
		add(bgstuff);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.45;
		bg.scrollFactor.set();
		bgstuff.add(bg);

		var cubes1:FlxSprite = new FlxSprite().loadGraphic(Paths.image('pause/cubes1', 'shared'));
		cubes1.screenCenter();
		cubes1.x = FlxG.width * 1.8;
		bgstuff.add(cubes1);

		var cubes2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('pause/cubes2', 'shared'));
		cubes2.screenCenter();
		cubes2.x = FlxG.width * 1.8;
		bgstuff.add(cubes2);

		var sidebar:FlxSprite = new FlxSprite().loadGraphic(Paths.image('pause/sidebar', 'shared'));
		sidebar.screenCenter();
		sidebar.x = FlxG.width * 1.8;
		bgstuff.add(sidebar);

		for (item in bgstuff.members) {
			FlxTween.tween(item, {x: 0}, 0.25 + (i * 0.25), {ease: FlxEase.linear, onComplete: function(twn:FlxTween) // i get this code from kade engine main menu
			{
				//finishedFunnyMove = true; 
				changeSelection();
			}});
		}

		grpMenuShit = new FlxTypedGroup<FlxSprite>();
		add(grpMenuShit);

		regenMenu();
		//cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		#if android
		addVirtualPad(UP_DOWN, A);
		#end
	}

	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
		updateSkipTextStuff();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		var daSelected:String = menuItems[curSelected];

		if (accepted)
		{
			if (menuItems == difficultyChoices)
			{
				if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
					var name:String = PlayState.SONG.song;
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					PlayState.changedDifficulty = true;
					PlayState.chartingMode = false;
					skipTimeTracker = null;

					if(skipTimeText != null)
					{
						skipTimeText.kill();
						remove(skipTimeText);
						skipTimeText.destroy();
					}
					skipTimeText = null;
					return;
				}

				menuItems = menuItemsOG;
				regenMenu();
			}

			switch (daSelected)
			{
				case "resume":
					close();
				case 'practice':
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					PlayState.changedDifficulty = true;
					practiceText.visible = PlayState.instance.practiceMode;
				case "restart":
					restartSong();
				case 'boyplay':
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				case "exit":
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					if(PlayState.isStoryMode) {
						MusicBeatState.switchState(new StoryMenuState());
					} if(PlayState.isCode) {
						MusicBeatState.switchState(new CodeScreen());
					} if (PlayState.isExtras) {
						MusicBeatState.switchState(new ExtrasScreen());
					} if (PlayState.isCovers) {
						MusicBeatState.switchState(new CoversScreen());
					} else {
						MusicBeatState.switchState(new FreeplayState());
					}
					PlayState.cancelMusicFadeTween();
					FlxG.sound.playMusic(Paths.music('nightlight'), 0);
					FlxG.sound.fadeIn(4, 4.5, 6, 8);
					PlayState.changedDifficulty = false;
					PlayState.chartingMode = false;
			}
		}
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('selectsfx'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		//var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if item.ID != curSelected)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new FlxSprite().loadGraphic(Paths.image('pause/' + menuItems[i], 'shared'));
			item.screenCenter();
			item.ID = i;
			grpMenuShit.add(item);
			item.x = FlxG.width * 1.6;

			FlxTween.tween(item, {x: 0}, 0.25 + (i * 0.25), {ease: FlxEase.linear, onComplete: function(twn:FlxTween) // i get this code from kade engine main menu
			{
				//finishedFunnyMove = true; 
				changeSelection();
			}});
		}
		curSelected = 0;
		//changeSelection();
	}
	
	function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}
}

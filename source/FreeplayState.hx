package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<String> = [
		'broadcasting',
		'mirror-magic',
		'fandomania',
		'killer-queen',
		'hyperfunk',
		'sugarcrush',
		'smokebomb',
		'overdrive',
		'expurgated'
	];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreText:FlxText;
	var nicu:FlxSprite;
	var textChapter:FlxSprite;
	var bars:FlxSprite;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	var intendedColor:Int;
	var colorTween:FlxTween;

	private var grpSongs:FlxTypedGroup<FreeplayText>;
	private var curPlaying:Bool = false;

	var bg2:FlxSprite;
	var bg:FlxSprite;
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.noSkins = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence('In Freeplay', null);
		#end

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(':');
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/
		
		bg2 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/freeplay/bg'));
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg2);
		bg2.alpha = 0;
		bg2.screenCenter();

		bg = new FlxSprite().loadGraphic(Paths.image('hotline/menu/freeplay/bg'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		nicu = new FlxSprite().loadGraphic(Paths.image('hotline/menu/freeplay/nikkuRender'));
		nicu.antialiasing = ClientPrefs.globalAntialiasing;
		nicu.screenCenter();
		add(nicu);

		FlxTween.tween(nicu, {y: nicu.y + 15}, 1.74, {ease: FlxEase.quadInOut, type: PINGPONG});

		grpSongs = new FlxTypedGroup<FreeplayText>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var port:FreeplayText = new FreeplayText(310, 200, songs[i]);
			port.y += ((port.width - 450) + 100 * i);
			port.targetY = i;
			port.ID = i;
			port.angle = -3;
			port.setGraphicSize(Std.int(port.width * 1.2));
			//port.alpha = 1;
			port.antialiasing = ClientPrefs.globalAntialiasing;
			grpSongs.add(port);
		}

		bars = new FlxSprite().loadGraphic(Paths.image('hotline/menu/freeplay/bars'));
		bars.screenCenter();
		bars.antialiasing = ClientPrefs.globalAntialiasing;
		add(bars);

		textChapter = new FlxSprite().loadGraphic(Paths.image('hotline/menu/freeplay/chapter1'));
		textChapter.screenCenter();
		textChapter.antialiasing = ClientPrefs.globalAntialiasing;
		add(textChapter);

		scoreText = new FlxText(FlxG.width + 100, 630, 0, '', 32);
		scoreText.setFormat(Paths.font('LEMONMILK-Bold.otf'), 32, FlxColor.WHITE, RIGHT);
		scoreText.alignment = CENTER;
		add(scoreText);

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		//changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, 'swag');

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end

		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		for (port in grpSongs.members) // the angle tween and skew test
		{
				//var direction:Float = -10; // not used shit
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 7, 0, 1);
				var maxSkew:Float = 0; // selected item
				var minSkew:Float = port.skew.x - 5; // not selected item
				var notSlctVal:Float = port.x - 30;
				//var directionLeft:Float = -1; // not used shit
				//var directionRight:Float = 1; // not used shit
				if(port.targetY == 0)
				{
					var lastSkew:Float = port.skew.x;
					//var lastAngle:Float = port.angle;
					var lastX:Float = port.x;
					//item.screenCenter(X);
					port.x = FlxMath.lerp(lastX, 310, lerpVal);
					port.forceX = port.x;
					port.skew.x = FlxMath.lerp(lastSkew, maxSkew, lerpVal); // using flxskewedsprite
					port.forceSkew = port.skew.x;
				}
				else
				{
					port.x = FlxMath.lerp(port.x, 280 + -10 * Math.abs(port.targetY), lerpVal);
					port.forceX = port.x;
					port.skew.x = FlxMath.lerp(port.skew.x, minSkew*Math.abs(port.targetY), lerpVal);
					port.forceSkew = port.skew.x;
				}
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;
			
		/*grpSongs.forEach(function(item:FlxSprite)
		{
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 10, 0, 1);
			var lastAngle:Float = item.angle;
			if (item.ID != curSelected)
			{
				item.angle = 0;
				item.angle = FlxMath.lerp(lastAngle, item.angle - 70, lerpVal);
			}
			else
			{
				item.angle = FlxMath.lerp(item.angle, 200 + -40 * Math.abs(item.y), lerpVal);
			}
		});*/
		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		//positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE #if android || _virtualpad.buttonX.justPressed #end;
		var ctrl = FlxG.keys.justPressed.CONTROL #if android || _virtualpad.buttonC.justPressed #end;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT #if android || _virtualpad.buttonZ.pressed #end) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP) changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			FlxG.sound.play(Paths.sound('backsfx'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if(ctrl)
		{
			#if android
			removeVirtualPad();
			#end
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				//Paths.currentModDirectory = songs[curSelected];
				var poop:String = Highscore.formatSong(songs[curSelected].toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		}

		else if (accepted)
		{
			FlxG.sound.play(Paths.sound('entersfx'));
			persistentUpdate = false;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected]);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
			/*#if MODS_ALLOWED
			if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
			#else
			if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
			#end
				poop = songLowercase;
				curDifficulty = 1;
				trace('Couldnt find file');
			}*/
			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			FlxG.log.add('sex: ' + songLowercase);
			//('CURRENT WEEK: ' + WeekData.getWeekFileName());
			
			if (FlxG.keys.pressed.SHIFT #if android || _virtualpad.buttonZ.pressed #end){
				LoadingState.loadAndSwitchState(new ChartingState());
				FlxG.sound.music.volume = 0;
			}else{
				for (item in grpSongs.members){
					var songslct:String = songs[curSelected];
					if(curSelected != item.ID)
					{
						FlxTween.tween(item, {alpha: 0}, 0.5, {
							ease: FlxEase.quadInOut,
							onComplete:function(twn:FlxTween)
							{
								item.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(item,0.6,0.05,false,false,function(flicker:FlxFlicker)
						{
							switch(songslct){
								case 'killer-queen':
									LoadingState.loadAndSwitchState(new PlayState());
								default:
									MusicBeatState.switchState(new ChooseSkinState());
							}
						});
					}
				}
			}
			destroyFreeplayVocals();
		}
		else if(controls.RESET #if android || _virtualpad.buttonY.justPressed #end)
		{
			#if android
			removeVirtualPad();
			#end
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected], curDifficulty, songs[curSelected]));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected], curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		//positionHighscore();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('selectsfx'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected], curDifficulty);
		#end

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			// item.setGraphicSize(Std.int(item.width * 0.8));
			item.alpha = 0.6;

			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
	}

	/*private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;
	}*/
}

class SongMetadata
{
	public var songName:String = '';
	public var week:Int = 0;
	public var songCharacter:String = '';
	public var color:Int = -7179779;
	public var folder:String = '';

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}

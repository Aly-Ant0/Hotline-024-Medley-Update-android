package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.touch.FlxTouch;
import flixel.input.touch.FlxTouchManager;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState // eu fiquei uma amanhã inteira programano o menu kkkk
{
	public static var psychEngineVersion:String = '0.5.2h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedSpriteGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'extras',
		'options'
	];
	var jukeboxText:FlxSprite;
	var selected:Bool = false;
	var jukeHitbox:FlxObject;
	var creditsHitbox:FlxObject;

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu", null);
		#end
		//debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxBackdrop = new FlxBackdrop(Paths.image('hotline/menu/bg'), 0.2, 0.2, true, false);
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.velocity.x = -90;
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		
		var bars:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hotline/menu/bars'));
		bars.updateHitbox();
		bars.screenCenter();
		bars.antialiasing = ClientPrefs.globalAntialiasing;
		add(bars);

		menuItems = new FlxTypedSpriteGroup<FlxSprite>();
		add(menuItems);

		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/ // nao precisa por sinal

		for (i in optionShit.length)
		{
			var item:FlxSprite = new FlxSprite(i * 670 + 50, 0);
			item.frames = Paths.getSparrowAtlas('hotline/' + optionShit[i]);
			item.antialiasing = ClientPrefs.globalAntialiasing;
			item.screenCenter(X);
			item.animation.addByPrefix('meuamigousacalsinhaescondido', "glow");
			item.animation.addByPrefix('agorausamaisnao', "normal");
			item.animation.play('agorausamaisnao');
			item.setGraphicSize(311, 550);
			item.ID = i;
			item.updateHitbox();
			menuItems.add(item);
		}

		jukeboxText = new FlxSprite().loadGraphic(Paths.image('hotline/menu/jukebox')); // eu nao vou programar o jukebox menu pq nao tem nenhum video que mostra o jukebox menu ent eu nao sei como é o jukebox menu e eu nao tenho pc // sadness
		jukeboxText.screenCenter();
		jukeboxText.antialiasing = ClientPrefs.globalAntialiasing;
		//jukeboxText.updateHitbox();
		add(jukeboxText);

		jukeHitbox = new FlxObject(0, 0, 175, 25);
		jukeHitbox.setPosition(512, 9);
		add(jukeHitbox);

		creditsImage = new FlxSprite().loadGraphic(Paths.image('hotline/menu/credits'));
		creditsImage.screenCenter();
		creditsImage.antialiasing = ClientPrefs.globalAntialiasing;
		//creditsImage.updateHitbox();
		add(creditsImage);

		creditsHitbox = new FlxObject(512, 684, 175, 25);
		creditsHitbox.setPosition(512, 684);
		add(creditsHitbox);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Hotline 024 v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		#if android
		addVirtualPad(LEFT_RIGHT, A_B); // no editors since idk what will happen honestly edit: nothing but dont will have editors menu lol
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;
	var canSelect:Bool = true;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		for (touch in FlxG.touches.list)
		{
			if(touch.overlaps(jukeHitbox))
			{
				jukeboxText.color = 0xFF363636;
				if(touch.justPressed)
				{
					MusicBeatState.switchState(new JukeboxScreen());
					FlxG.sound.play(Paths.sound('entersfx'));
				}
			}
			else
			{
				jukeboxText.color = 0xFFFFFFFF;
			}
		}
		if (!selectedSomethin && canSelect)
		{
			if (controls.UI_LEFT_P)
			{
				//FlxG.sound.play(Paths.sound('selectsfx'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				//FlxG.sound.play(Paths.sound('selectsfx'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('backsfx'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('entersfx'));
				if (optionShit[curSelected] == 'story_mode')
				{
					for (item in menuItems)
					{
						if(item.ID == curSelected)
						{
							FlxG.sound.play(Paths.sound('errorsfx'));
							FlxFlicker.flicker(item, 0.4, 0.06, false);
						}
					}
				}
				for (item in menuItems.members)
				{
					var daChoice:String = optionShit[curSelected];

					if (item.ID == curSelected)
					{
						FlxFlicker.flicker(item, 0.4, 0.06, false, false, function(flicker:FlxFlicker)
						{
							switch(daChoice)
							{
								case 'freeplay':
									MusicBeatState.switchState(new FreeplayState());
								case 'extras':
									MusicBeatState.switchState(new ExtrasScreen());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
							}
						});
					}
					else
					{
						FlxTween.tween(item, {alpha: 0}, 0.5, {
							onComplete:function(twn:FlxTween)
							{
								item.kill();
							}
						});
					}
				}
			}
			for (touch in FlxG.touches.list)
			{
				if (touch.overlaps(creditsHitbox)) {
					creditsImage.color = 0xFF363636;
					if(touch.justPressed)
					{
						MusicBeatState.switchState(new CreditsState());
						FlxG.sound.play(Paths.sound('entersfx'));
					}
				}
				else
				{
					creditsImage.color = 0xFFFFFFFF;
				}
			}
			#if (desktop) // only on pc lol
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		/*var scale:Int = 1;*/ // idk

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

			FlxG.sound.play(Paths.sound('selectsfx'));

			for (item in menuItems.members)
			{
				if (item.ID == curSelected)
				{
					item.alpha = 1;
					item.animation.play('meuamigousacalsinhaescondido');
				}
				else
				{
					item.alpha = 0.49;
					item.animation.play('agorausamaisnao');
				}
			}
			if(huh == 1)
			{
				canSelect = false;
				FlxTween.tween(menuItems, {x: menuItems.x + 480}, 0.5, {onComplete: function(twn:FlxTween)
					{
						canSelect = true;
					}
				});
			}
			if(huh == -1)
			{
				canSelect = false;
				FlxTween.tween(menuItems, {x: menuItems.x - 480}, 0.5, {onComplete: function(twn:FlxTween)
					{
						canSelect = true;
					}
				});
			}
			if(curSelected > optionShit.length && curSelected < optionShit.length)
			{
				if(huh == 1)
				{
					canSelect = false;
					FlxTween.tween(menuItems, {x: menuItems.x - 1920}, 0.5, {onComplete: function(twn:FlxTween)
					{
						canSelect = true;
					}});
				}
				if(change == -1)
				{
					canSelect = false;
					FlxTween.tween(menuItems, {x: menuItems.x + 1920}, 0.5, {onComplete: function(twn:FlxTween)
					{
						canSelect = true;
					}});
				}
		}
	}
}

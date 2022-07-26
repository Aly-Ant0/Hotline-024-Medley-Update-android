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
	var creditsImage:FlxSprite;
	var storyButton:FlxSprite;
	var storyButton2:FlxSprite;
	var freeplayButton:FlxSprite;
	var freeplayButton2:FlxSprite;
	var extrasButton:FlxSprite;
	var extrasButton2:FlxSprite;
	var optionsButton:FlxSprite;
	var optionsButton2:FlxSprite;
	var jukeboxText:FlxSprite;
	var selected:Bool = false;
	var jukeHitbox:FlxObject;
	var creditsHitbox:FlxObject;

	override function create()
	{
			FlxG.sound.playMusic(Paths.music('nightlight'), 0);
			FlxG.sound.music.fadeIn(0.4, 0.6, 1);

		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
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

		storyButton = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
		storyButton.frames = Paths.getSparrowAtlas('hotline/menu/story_mode');
		storyButton.animation.addByPrefix('idle', "normal");
		storyButton.animation.addByPrefix('selected', "glow");
		storyButton.animation.play('idle');
		storyButton.scrollFactor.set(0.1, 0);
		storyButton.antialiasing = ClientPrefs.globalAntialiasing;
		storyButton.scale.set(0.9, 0.9);
		storyButton.updateHitbox();

		freeplayButton = new FlxSprite(storyButton.x - 30, FlxG.height / 2);
		freeplayButton.frames = Paths.getSparrowAtlas('hotline/menu/freeplay');
		freeplayButton.animation.addByPrefix('idle', "normal");
		freeplayButton.animation.addByPrefix('selected', "glow");
		freeplayButton.animation.play('idle');
		add(freeplayButton);
		freeplayButton.scrollFactor.set(0.1, 0);
		freeplayButton.antialiasing = ClientPrefs.globalAntialiasing;
		freeplayButton.scale.set(0.9, 0.9);
		freeplayButton.updateHitbox();

		optionsButton = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
		optionsButton.frames = Paths.getSparrowAtlas('hotline/menu/options');
		optionsButton.animation.addByPrefix('idle', "normal");
		optionsButton.animation.addByPrefix('selected', "glow");
		optionsButton.animation.play('idle');
		add(optionsButton);
		optionsButton.scrollFactor.set(0.1, 0);
		optionsButton.antialiasing = ClientPrefs.globalAntialiasing;
		optionsButton.scale.set(0.9, 0.9);
		optionsButton.updateHitbox();

		extrasButton = new FlxSprite(storyButton.x + 30, FlxG.height / 2);
		extrasButton.frames = Paths.getSparrowAtlas('hotline/menu/extras');
		extrasButton.animation.addByPrefix('idle', "normal");
		extrasButton.animation.addByPrefix('selected', "glow");
		extrasButton.animation.play('idle');
		add(extrasButton);
		extrasButton.scrollFactor.set(0.1, 0);
		extrasButton.antialiasing = ClientPrefs.globalAntialiasing;
		extrasButton.scale.set(0.9, 0.9);
		extrasButton.updateHitbox();

		storyButton2 = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
		storyButton2.frames = Paths.getSparrowAtlas('hotline/menu/story_mode');
		storyButton2.animation.addByPrefix('idle', "normal");
		storyButton2.animation.addByPrefix('selected', "glow");
		storyButton2.animation.play('idle');
		add(storyButton2);
		storyButton2.scrollFactor.set(0.1, 0);
		storyButton2.antialiasing = ClientPrefs.globalAntialiasing;
		storyButton2.scale.set(0.9, 0.9);
		storyButton2.visible = false;
		storyButton2.updateHitbox();

		freeplayButton2 = new FlxSprite(freeplayButton.x, FlxG.height / 2);
		freeplayButton2.frames = Paths.getSparrowAtlas('hotline/menu/freeplay');
		freeplayButton2.animation.addByPrefix('idle', "normal");
		freeplayButton2.animation.addByPrefix('selected', "glow");
		freeplayButton2.animation.play('idle');
		add(freeplayButton2);
		freeplayButton2.scrollFactor.set(0.1, 0);
		freeplayButton2.antialiasing = ClientPrefs.globalAntialiasing;
		freeplayButton2.scale.set(0.9, 0.9);
		freeplayButton2.visible = false;
		freeplayButton2.updateHitbox();

		optionsButton2 = new FlxSprite(optionsButton.x, FlxG.height / 2);
		optionsButton2.frames = Paths.getSparrowAtlas('hotline/menu/options');
		optionsButton2.animation.addByPrefix('idle', "normal");
		optionsButton2.animation.addByPrefix('selected', "glow");
		optionsButton2.animation.play('idle');
		add(optionsButton2);
		optionsButton.scrollFactor.set(0.1, 0);
		optionsButton2.antialiasing = ClientPrefs.globalAntialiasing;
		optionsButton2.scale.set(0.9, 0.9);
		optionsButton2.visible = false;
		optionsButton2.updateHitbox();

		extrasButton2 = new FlxSprite(extrasButton.x, FlxG.height / 2);
		extrasButton2.frames = Paths.getSparrowAtlas('hotline/menu/extras');
		extrasButton2.animation.addByPrefix('idle', "normal");
		extrasButton2.animation.addByPrefix('selected', "glow");
		extrasButton2.animation.play('idle');
		add(extrasButton2);
		extrasButton2.scrollFactor.set(0.1, 0);
		extrasButton2.antialiasing = ClientPrefs.globalAntialiasing;
		extrasButton2.scale.set(0.9, 0.9);
		extrasButton2.visible = false;
		extrasButton2.updateHitbox();

		add(extrasButton);
		add(optionsButton);
		add(freeplayButton);
		add(storyButton);
		add(storyButton2);
		add(freeplayButton2);
		add(optionsButton2);
		add(extrasButton2);

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
		if (!selectedSomethin)
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
				if (optionShit[curSelected] == 'story_mode')
				{
							FlxG.sound.play(Paths.sound('errorsfx'));
							FlxFlicker.flicker(storyButton, 0.4, 0.06, false);
				}
					var daChoice:String = optionShit[curSelected];
					switch (daChoice)
					{
						case 'freeplay':
							FlxFlicker.flicker(freeplayButton2, 0.4, 0.06, false);
							MusicBeatState.switchState(new FreeplayState());
						case 'extras':
							FlxFlicker.flicker(extrasButton2, 0.4, 0.06, false);
							MusicBeatState.switchState(new ExtrasScreen());
						case 'options':
							FlxFlicker.flicker(optionsButton2, 0.4, 0.06, false);
							LoadingState.loadAndSwitchState(new options.OptionsState());
					}
			}
			for (touch in FlxG.touches.list)
			{
				if (touch.overlaps(creditsHitbox) && touch.justPressed) {
						MusicBeatState.switchState(new CreditsState());
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

		if (curSelected >= optionShit.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = optionShit.length - 1;

			FlxG.sound.play(Paths.sound('selectsfx'));

		//var porra:Int = 0;
		var option:String = optionShit[curSelected];

		switch(option) { // por enquando vai ser brusco mesmo e eu fiquei mt confuso pra programar isso puta que pariu
		// e os botão 2 é tipo o botao 1 so que eles são MACHO ALFA cof, cof, quer dizer, eles estão na frente pra não ficar todo lascado.
		// butao na frente: 500, 85,
		// buttao de tras: a mesma coisa do butao da frente,
		// butao no lado esquerdo: 160, 85,
		// butao no lado direito: 830, 85
			case 'story_mode':
				optionsButton2.visible = false;
				extrasButton2.visible = false;
				freeplayButton2.visible = false;
				storyButton2.visible = true;

				optionsButton.visible = true;
				extrasButton.visible = true;
				freeplayButton.visible = true;
				storyButton.visible = false;

				storyButton.setPosition(500, 85);
				freeplayButton.setPosition(830, 85);
				optionsButton.setPosition(160, 85);
				extrasButton.setPosition(500, 85);

				storyButton2.setPosition(500, 85);
				freeplayButton2.setPosition(830, 85);
				optionsButton2.setPosition(160, 85);
				extrasButton2.setPosition(500, 85);
			case 'freeplay':
				optionsButton2.visible = false;
				extrasButton2.visible = false;
				freeplayButton2.visible = true;
				storyButton2.visible = false;

				optionsButton.visible = true;
				extrasButton.visible = true;
				freeplayButton.visible = false;
				storyButton.visible = true;

				storyButton.setPosition(160, 85);
				freeplayButton.setPosition(500, 85);
				optionsButton.setPosition(500, 85);
				extrasButton.setPosition(830, 85);

				storyButton2.setPosition(160, 85);
				freeplayButton2.setPosition(500, 85);
				optionsButton2.setPosition(500, 85);
				extrasButton2.setPosition(830, 85);
			case 'extras':
				optionsButton2.visible = false;
				extrasButton2.visible = true;
				freeplayButton2.visible = false;
				storyButton2.visible = false;

				optionsButton.visible = true;
				extrasButton.visible = false;
				freeplayButton.visible = true;
				storyButton.visible = true;

				storyButton.setPosition(500, 85);
				freeplayButton.setPosition(160, 85);
				optionsButton.setPosition(830, 85);
				extrasButton.setPosition(500, 85);

				storyButton2.setPosition(500, 85);
				freeplayButton2.setPosition(160, 85);
				optionsButton2.setPosition(830, 85);
				extrasButton2.setPosition(500, 85);
			case 'options':
				optionsButton2.visible = true;
				extrasButton2.visible = false;
				freeplayButton2.visible = false;
				storyButton2.visible = false;

				optionsButton.visible = false;
				extrasButton.visible = true;
				freeplayButton.visible = true;
				storyButton.visible = true;

				storyButton.setPosition(830, 85);
				freeplayButton.setPosition(500, 85);
				optionsButton.setPosition(500, 85);
				extrasButton.setPosition(160, 85);

				storyButton2.setPosition(830, 85);
				freeplayButton2.setPosition(500, 85);
				optionsButton2.setPosition(500, 85);
				extrasButton2.setPosition(160, 85);
		}
	}
}

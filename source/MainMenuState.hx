package;

#if desktop
import Discord.DiscordClient; //your code sucks ass aly -Peppy
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

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.2h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedSpriteGroup<FlxSprite>;
	var mainMenuTxt:FlxText;
	
	var optionShit:Array<String> = [
		'story_mode',
		'extras',
		'options',
		'freeplay'
	];
	var jukeboxText:FlxSprite;
	var creditsImage:FlxSprite;
	var selected:Bool = false;
	var jukeClickArea:FlxObject;
	var creditsHitbox:FlxObject;

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu", null);
		#end
		//debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxBackdrop = new FlxBackdrop(Paths.image('hotline/menu/bg'), 0.2, 0.2, true, false, -30);
		bg.scrollFactor.set();
		//bg.setGraphicSize(Std.int(bg.width * 1.475));
		bg.velocity.x = -90;
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		menuItems = new FlxTypedSpriteGroup<FlxSprite>();
		add(menuItems);

		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/ // nao precisa por sinal

		for (i in 0...optionShit.length) // musk moment
		{
			var menuItem:FlxSprite = new FlxSprite(150 + (400 * i), 60);
			menuItem.frames = Paths.getSparrowAtlas('hotline/menu/' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', "normal", 24);
			menuItem.animation.addByPrefix('selected', "glow", 24);
			menuItem.animation.play('idle');
			menuItem.scale.set(0.66, 0.66);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
			menuItem.ID = i;
			menuItems.add(menuItem);
		}

		remove(menuItems.members[0]);
		remove(menuItems.members[1]);
		remove(menuItems.members[2]);
		remove(menuItems.members[3]);

		add(menuItems.members[3]);
		add(menuItems.members[1]);
		add(menuItems.members[0]);
		add(menuItems.members[2]);

		var bars:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hotline/menu/bars'));
		bars.updateHitbox();
		bars.screenCenter();
		bars.antialiasing = ClientPrefs.globalAntialiasing;
		add(bars);

		var disc:FlxSprite + new FlxSprite(FlxG.width - 28, FlxG.height - 705);
		disc.frames = Paths.h024MenuAnim('vinyl', 'NONE');
		disc.antialiasing = ClientPrefs.globalAntialiasing;
		add(disc);

		jukeboxText = new FlxSprite().loadGraphic(Paths.image('hotline/menu/jukebox'));
		jukeboxText.screenCenter();
		jukeboxText.antialiasing = ClientPrefs.globalAntialiasing;
		//jukeboxText.updateHitbox();
		add(jukeboxText);

		jukeClickArea = new FlxObject(0, 0, 175, 25);
		jukeClickArea.setPosition(552, 9);
		add(jukeClickArea);

		creditsImage = new FlxSprite().loadGraphic(Paths.image('hotline/menu/credits'));
		creditsImage.screenCenter();
		creditsImage.antialiasing = ClientPrefs.globalAntialiasing;
		//creditsImage.updateHitbox();
		add(creditsImage);

		creditsHitbox = new FlxObject(0, 0, 175, 25);
		creditsHitbox.setPosition(552, 684);
		add(creditsHitbox);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Hotline 024 v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		mainMenuTxt = new FlxText(disc.x - 125, disc.y + 5, FlxG.width, "", 26);
		mainMenuTxt.scrollFactor.set();
		mainMenuTxt.setFormat(Paths.font('LEMONMILK-Bold.otf'), 26, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(mainMenuTxt);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if android
		addVirtualPad(LEFT_RIGHT, A_B); // no editors since idk what will happen honestly edit: nothing but dont will have editors menu lol
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;
	var canSelect:Bool = true;

	override function update(elapsed:Float)
	{
		mainMenuTxt.text = Paths.menuMusic;
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		for (touch in FlxG.touches.list)
		{
			if(touch.overlaps(jukeClickArea))
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
				if (optionShit[curSelected] == 'story_mode')
				{
					for (item in menuItems)
					{
						if(item.ID == curSelected)
						{
							FlxG.sound.play(Paths.sound('errorsfx'));
							FlxFlicker.flicker(item, 0.4, 0.06, true);
						}
					}
				}
				for (item in menuItems.members)
				{
					var daChoice:String = optionShit[curSelected];
					if (daChoice=='story_mode'){
						FlxG.sound.play(Paths.sound('errorsfx'));
						if (item.ID==curSelected){
							FlxFlicker.flicker(item, 0.4, 0.06, true, false);
						}
					}
					else
					{
						if(item.ID==curSelected){
							FlxFlicker.flicker(item, 0.4, 0.06, false, false, function(flicker:FlxFlicker)
							{
								switch(daChoice)
								{
									case 'freeplay':
										FlxG.sound.play(Paths.sound('entersfx'));
										MusicBeatState.switchState(new FreeplayState());
									case 'extras':
										MusicBeatState.switchState(new ExtrasScreen());
										FlxG.sound.play(Paths.sound('entersfx'));
									case 'options':
										FlxG.sound.play(Paths.sound('entersfx'));
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
						if(item.ID!=curSelected)
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
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;
		FlxG.log.add('linda, cheirosa, gostos-: ' + optionShit[curSelected]);

		/*var scale:Int = 1;*/ // idk

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

			FlxG.sound.play(Paths.sound('selectsfx'));

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				spr.centerOffsets();
			}
		});
		switch (curSelected) // code from musk but with some changes (i requested the main menu code for him just for the buttons lmao)
		{
			case 0:
				FlxTween.tween(menuItems.members[0], {x: 150 + (400 * 1)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[1], {x: 150 + (400 * 2)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[2], {x: 150 + (400 * 0)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[3], {x: 150 + (400 * 0)}, 0.41, {ease: FlxEase.expoOut});

				menuItems.members[0].visible = true;
				menuItems.members[1].visible = true;
				menuItems.members[2].visible = false;
				menuItems.members[3].visible = true;

			case 1:
				FlxTween.tween(menuItems.members[0], {x: 150 + (400 * 0)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[1], {x: 150 + (400 * 1)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[2], {x: 150 + (400 * 2)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[3], {x: 150 + (400 * 1)}, 0.41, {ease: FlxEase.expoOut});

				menuItems.members[0].visible = true;
				menuItems.members[1].visible = true;
				menuItems.members[2].visible = true;
				menuItems.members[3].visible = false;

			case 2:
				FlxTween.tween(menuItems.members[0], {x: 150 + (400 * 1)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[1], {x: 150 + (400 * 0)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[2], {x: 150 + (400 * 1)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[3], {x: 150 + (400 * 2)}, 0.41, {ease: FlxEase.expoOut});

				menuItems.members[0].visible = false;
				menuItems.members[1].visible = true;
				menuItems.members[2].visible = true;
				menuItems.members[3].visible = true;

			case 3:
				menuItems.members[2].x = 150 + (400 * 1);

				FlxTween.tween(menuItems.members[0], {x: 150 + (400 * 2)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[1], {x: 150 + (400 * 1)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[2], {x: 150 + (400 * 0)}, 0.41, {ease: FlxEase.expoOut});
				FlxTween.tween(menuItems.members[3], {x: 150 + (400 * 1)}, 0.41, {ease: FlxEase.expoOut});

				menuItems.members[0].visible = true;
				menuItems.members[1].visible = false;
				menuItems.members[2].visible = true;
				menuItems.members[3].visible = true;
		}
	}
}

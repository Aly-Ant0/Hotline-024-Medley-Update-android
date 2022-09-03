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
	//fodase
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var optionShit:Array<String> = [
		'story_mode',
		'extras',
		'options',
		'freeplay'
	];

	var jukeboxText:FlxSprite;
	var creditsImage:FlxSprite;
	var jukeClickArea:FlxObject;
	var creditsClickArea:FlxObject;
	var menuState:Int = 0; // menu items position -aly ant

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu", null);
		#end
		//debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

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

		for (i in 0...optionShit.length) // original code from musk but i making some changes of it
		{
			var menuItem:FlxSprite = new FlxSprite(100 + (400 * i), 60);
			menuItem.frames = Paths.getSparrowAtlas('hotline/menu/' + optionShit[i]);
			menuItem.animation.addByPrefix('meuamigousacalcinhaescondido', "normal", 24);
			menuItem.animation.addByPrefix('agorausamaisnao', "glow", 24);
			menuItem.animation.play('meuamigousacalcinhaescondido');
			menuItem.setGraphicSize(Std.int(menuItem.width*0.6));
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
			menuItem.ID = i;
			menuItems.add(menuItem);
		}
		// pra que isso elom maski?
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

		creditsClickArea = new FlxObject(0, 0, 175, 25);
		creditsClickArea.setPosition(552, 684);
		add(creditsClickArea);

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

		#if android
		addVirtualPad(LEFT_RIGHT, A_B); // no editors since idk what will happen honestly edit: nothing but dont will have editors menu lol
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;
	var canSelect:Bool = true;
	override function update(elapsed:Float)
	{
		var lerpVal:Float = CoolUtil.boundTo(elapsed * 9, 0, 1);
		if (menuState == 0){
					FlxMath.lerp(menuItems.members[0].x, 150 + (400 * 1), lerpVal);
					FlxMath.lerp(menuItems.members[1].x, 150 + (400 * 2), lerpVal);
					FlxMath.lerp(menuItems.members[2].x, 150 + (400 * 0), lerpVal);
					FlxMath.lerp(menuItems.members[3].x, 150 + (400 * 0), lerpVal);

					menuItems.members[0].visible = true;
					menuItems.members[1].visible = true;
					menuItems.members[2].visible = false;
					menuItems.members[3].visible = true;
		}
		if (menuState == 1){
					FlxMath.lerp(menuItems.members[0].x, 100 + (400 * 0), lerpVal);
					FlxMath.lerp(menuItems.members[1].x, 100 + (400 * 1), lerpVal);
					FlxMath.lerp(menuItems.members[2].x, 100 + (400 * 2), lerpVal);
					FlxMath.lerp(menuItems.members[3].x, 100 + (400 * 1), lerpVal);

					menuItems.members[0].visible = true;
					menuItems.members[1].visible = true;
					menuItems.members[2].visible = true;
					menuItems.members[3].visible = false;
		}
		if (menuState == 2){
					FlxMath.lerp(menuItems.members[0].x, 100 + (400 * 1), lerpVal);
					FlxMath.lerp(menuItems.members[1].x, 100 + (400 * 0), lerpVal);
					FlxMath.lerp(menuItems.members[2].x, 100 + (400 * 1), lerpVal);
					FlxMath.lerp(menuItems.members[3].x, 100 + (400 * 2), lerpVal);

					menuItems.members[0].visible = false;
					menuItems.members[1].visible = true;
					menuItems.members[2].visible = true;
					menuItems.members[3].visible = true;
		}
		if (menuState == 3){
					menuItems.members[2].x = 100 + (400 * 1);
					FlxMath.lerp(menuItems.members[0].x, 100 + (400 * 2), lerpVal);
					FlxMath.lerp(menuItems.members[1].x, 100 + (400 * 1), lerpVal);
					FlxMath.lerp(menuItems.members[2].x, 100 + (400 * 0), lerpVal);
					FlxMath.lerp(menuItems.members[3].x, 100 + (400 * 1), lerpVal);

					menuItems.members[0].visible = true;
					menuItems.members[1].visible = false;
					menuItems.members[2].visible = true;
					menuItems.members[3].visible = true;
		}

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
				FlxG.sound.play(Paths.sound('backsfx'));
				MusicBeatState.switchState(new TitleState());
		}

		if (controls.ACCEPT)
		{
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
				if (touch.overlaps(creditsClickArea)) {
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
			spr.animation.play('meuamigousacalcinhaescondido');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('agorausamaisnao');
				spr.centerOffsets();
			}
		});

		switch (curSelected) // code from musk but with some changes (i requested the main menu code for him just for the buttons position lmao)
		{
			case 0:
				menuState = 0;
			case 1:
				menuState = 1;
			case 2:
				menuState = 2;
			case 3:
				menuState = 3;
		}
	}
}

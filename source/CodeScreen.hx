package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.input.FlxAccelerometer;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.input.touch.FlxTouch;
import flixel.input.touch.FlxTouchManager;
import flixel.FlxSprite;

class CodeScreen extends MusicBeatState
{
	/*var buttonnum:Array<Int> = [
		0,
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9
	];*/
	
	var bg:FlxSprite;
	var paineudicontroli:FlxSprite;
	var numbersSpr:FlxTypedGroup<FlxSprite>;
	var code:FlxText;
	var codes:FlxSprite;
	var selection:Int;

	var canSelect:Bool = true;
	var isCorrect:Bool = false;

	override function create()
	{
		FlxG.mouse.visible = false;

		PlayState.isStoryMode = false;
		PlayState.isCode = true;
		PlayState.isCovers = false;
		PlayState.isExtras = false;
		PlayState.isFreeplay = false;

		
		//PlayState.noSkins = true; // no skins?

		FlxG.sound.playMusic(Paths.music('codemenu'), 0);

		bg = new FlxSprite().loadGraphic(Paths.image('hotline/menu/code/bg'));
		bg.screenCenter();
		bg.alpha = 0;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		paineudicontroli = new FlxSprite().loadGraphic(Paths.image('hotline/menu/code/panel'));
		paineudicontroli.screenCenter();
		paineudicontroli.antialiasing = ClientPrefs.globalAntialiasing;
		add(paineudicontroli);

		codes = new FlxSprite().loadGraphic(Paths.image('hotline/menu/code/buttons/names/codes'));
		codes.screenCenter();
		codes.alpha = 0;
		codes.antialiasing = ClientPrefs.globalAntialiasing;
		add(codes);

		new FlxTimer().start(1.35, function(tmr:FlxTimer)
		{
			FlxTween.tween(bg, {alpha: 1}, 0.98, {ease: FlxEase.quadOut});
			if (FlxG.save.data.showcodes) {
				FlxTween.tween(codes, {alpha: 1}, 0.98, {ease: FlxEase.quadOut});
			}
		});

		numbersSpr = new FlxTypedGroup<FlxSprite>();
		add(numbersSpr);

		for (i in 0...10)
		{
			var button:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hotline/menu/code/buttons/BUTT' + i));
			button.antialiasing = ClientPrefs.globalAntialiasing;

			switch(i)
			{
				case 0:
					button.setPosition(588, 495);
						//button.setGraphicSize(58,33);
				case 1:
					button.setPosition(480, 238);
						// button.setGraphicSize(56,40);
				case 2:
					button.setPosition(588, 238);
						// button.setGraphicSize(58,34);
				case 3:
					button.setPosition(693, 238);
						// button.setGraphicSize(55,38);
				case 4:
					button.setPosition(480, 324);
						//button.setGraphicSize(53,36);
				case 5:
					button.setPosition(588, 324);
						//  button.setGraphicSize(57,33);
				case 6:
					button.setPosition(693, 324);
						//   button.setGraphicSize(54,37);
				case 7:
					button.setPosition(480, 408);
						//  button.setGraphicSize(57,39);
				case 8:
					button.setPosition(588, 408);
						//  button.setGraphicSize(59,35);
				case 9:
					button.setPosition(693, 408);
						//  button.setGraphicSize(56,39);
			}
			//button.screenCenter();
			button.ID = i;
			button.updateHitbox();
			//button.y -= 5;
			numbersSpr.add(button);
		}

		code = new FlxText(0, FlxG.height - 558, FlxG.width, "", 34);
		code.setFormat(Paths.font("LEMONMILK-Bold.otf"), 34, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		code.text = '';
		//code.textField = 0.40; dont have this variable lol
		code.screenCenter(X);
		add(code);

		#if android
		addVirtualPad(NONE, A_B);
		#end
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.3 * FlxG.elapsed;
		}

		numbersSpr.forEach(function(spr:FlxSprite)
		{
			selection = spr.ID;
		});
		//trace(selection);

		super.update(elapsed);

		if (controls.BACK && canSelect) //me when the so
		{
			FlxG.sound.play(Paths.sound('backsfx'));
			MusicBeatState.switchState(new ExtrasScreen());
			//FlxG.mouse.visible = false;
		}

			for (touch in FlxG.touches.list) {
				for (spr in numbersSpr) {
					if(touch.overlaps(spr) && canSelect) {
						//FlxG.sound.play(Paths.sound('codeHover'));
						spr.color = 0xFF363636;

						if(code.text.length < 12)
							if(touch.justPressed) {
								code.text += '  ' + spr.ID;
								FlxG.sound.play(Paths.sound('codeUp'));
							}
					}
					else {
						spr.color = 0xFFFFFFFF;
					}
				}
			}
				switch(code.text) {
					case '  2  4  8  0' | '  2  4  4  8' | '  5  1  4  1' | '  2  0  2  0' | '  2  1  5  1' | '  1  9  2  1' | '  1  3  9  1' | '  8  9  8  9' | '  6  1  2  0' | '  2  1  1  9':
						code.color = 0xFF00FF1D;
				}

			if(controls.ACCEPT) {
				switch(code.text)
				{
					case '  2  4  8  0': // code to show all the others codes
						LoadingState.loadAndSwitchState(new AllCodes());
						FlxG.mouse.visible = false;
						FlxG.sound.play(Paths.sound('entersfx'));
					case '  2  4  4  8': //naitilendi
						PlayState.SONG = Song.loadFromJson('nightland', 'nightland');
						PlayState.noSkins = false;
						FlxG.sound.play(Paths.sound('entersfx'));
						MusicBeatState.switchState(new ChooseSkinState());
						FlxG.mouse.visible = false;
					case '  5  1  4  1': // ema
						PlayState.SONG = Song.loadFromJson('uncanny-valley', 'uncanny-valley');
						PlayState.noSkins = true;
						FlxG.sound.play(Paths.sound('entersfx'));
						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.mouse.visible = false;
					case '  2  0  2  0': // extraterrestre
						PlayState.SONG = Song.loadFromJson('extraterrestrial', 'extraterrestrial');
						PlayState.noSkins = true;
						FlxG.sound.play(Paths.sound('entersfx'));
						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.mouse.visible = false;
					case '  2  1  5  1': // spooki
						PlayState.SONG = Song.loadFromJson('satellite-picnic', 'satellite-picnic');
						PlayState.noSkins = true;
						FlxG.sound.play(Paths.sound('entersfx'));
						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.mouse.visible = false;
					case '  1  9  2  1': // sus
						PlayState.SONG = Song.loadFromJson('sussy-pussy', 'sussy-pussy');
						PlayState.noSkins = true;
						FlxG.sound.play(Paths.sound('entersfx'));
						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.mouse.visible = false;
					case '  1  3  9  1': // i gonna shoot maself
						PlayState.SONG = Song.loadFromJson('close-chuckle', 'close-chuckle');
						PlayState.noSkins = true;
						FlxG.sound.play(Paths.sound('entersfx'));
						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.mouse.visible = false;
					case '  8  9  8  9': // nicu vs turma da mônica so que nao
						PlayState.SONG = Song.loadFromJson('deep-poems', 'deep-poems');
						PlayState.noSkins = true;
						FlxG.sound.play(Paths.sound('entersfx'));
						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.mouse.visible = false;
					case '  6  1  2  0': // fun is infinite
						PlayState.SONG = Song.loadFromJson('majin', 'majin');
						PlayState.noSkins = true;
						FlxG.sound.play(Paths.sound('entersfx'));
						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.mouse.visible = false;
					case '  2  1  1  9': // final song
						PlayState.SONG = Song.loadFromJson('astral-projection', 'astral-projection');
						PlayState.noSkins = true;
						FlxG.sound.play(Paths.sound('entersfx'));
						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.mouse.visible = false;
					default:
						FlxG.sound.play(Paths.sound('errorsfx'), 0.87);
						code.text = '';
						//isError = false;
				}
			}
	}
}

class AllCodes extends MusicBeatState
{
	var bg:FlxSprite;
	public static var save:Bool = true;

	override function create() {
		if (!FlxG.save.data.showcodes) // save data
			{
				FlxG.save.data.showcodes = true;
				FlxG.save.flush();
			}
		bg = new FlxSprite().loadGraphic(Paths.image('hotline/menu/code/buttons/code/fun'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.screenCenter();
		add(bg);

		#if android
		addVirtualPad(NONE, B);
		#end
		super.create();
	}
	override function update(elapsed:Float) {
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('backsfx'));
			MusicBeatState.switchState(new CodeScreen());
		}

		super.update(elapsed);
	}
}
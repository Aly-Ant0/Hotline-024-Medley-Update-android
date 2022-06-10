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

using StringTools;

class CoversScreen extends MusicBeatState
{
  var buttons:FlxSprite;
  var buttonSelected:FlxSprite;
  var button1:FlxSprite;
  var button2:FlxSprite;
  var button3:FlxSprite;
  var button4:FlxSprite;
  var button1Black:FlxSprite;
  var button2Black:FlxSprite;
  var button3Black:FlxSprite;
  var button4Black:FlxSprite;
  var text:FlxSprite;
  var bars:FlxSprite;
  public var songName:String = "";
  
  public static var curSelected:Int = 0;
  
  var coverList:Array<String> = [
    'thunderstorm',
    'cg-megamix',
    'promenade',
    'death-match'
  ];
  
  var buttonList:Array<String> = [
    'button1',
    'button2',
    'button3',
    'button4'
    ];
  
  override function create()
  {
    Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		PlayState.noSkins = false;

    text = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/text'));
    text.screenCenter();
    
    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/bg'));
    bg.screenCenter();
    
    bars = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/bars2'));
    bars.screenCenter();
    
    /*buttons = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/' + buttonList));
    buttons.screenCenter();
    
    buttonSelected = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/' + buttonList[curSelected]));
    buttonSelected.screenCenter();*/
    
    button1 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button1'));
    button1.screenCenter();
    
    button2 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button2'));
    button2.screenCenter();
    
    button3 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button3'));
    button3.screenCenter();
    
    button4 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button4'));
    button4.screenCenter();
   
    button1Black = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button1'));
    button1Black.color = FlxColor.BLACK;
    button1.screenCenter();
    
    button2Black = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button2'));
    button2Black.color = FlxColor.BLACK;
    button2.screenCenter();
    
    button3Black = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button3'));
    button3Black.color = FlxColor.BLACK;
    button3Black.screenCenter();
    
    button4Black = new FlxSprite().loadGraphic(Paths.image('hotline/menu/covers/button4'));
    button4Black.color = FlxColor.BLACK;
    button4Black.screenCenter();
    
    add(bg);
    add(bars);
    add(text);
    add(button1Black);
    add(button2Black);
    add(button3Black);
    add(button4Black);
    add(button1);
    add(button2);
    add(button3);
    add(button4);
    //add(buttonSelected);
    
    changeCover();
    super.create();
    
    #if android
    addVirtualPad(UP_DOWN, A_B);
    #end
  }
  override function update(elapsed:Float)
  {
    if (controls.UI_UP_P)
    {
      FlxG.sound.play(Paths.sound('selectsfx'));
      changeCover(-1);
    }
    if (controls.UI_DOWN_P)
    {
      FlxG.sound.play(Paths.sound('selectsfx'));
      changeCover(1);
    }
    if (controls.BACK)
    {
      MusicBeatState.switchState(new ExtrasScreen());
    }
    if (controls.ACCEPT)
    {
      var coverChoice:String = buttonList[curSelected];
      switch(coverChoice)
      {
				case 'button1':
					PlayState.SONG = Song.loadFromJson('thunderstorm', 'thunderstorm');
					PlayState.isCovers = true;
      		FlxG.sound.play(Paths.sound('entersfx'));
      		new FlxTimer().start(0.1, function(tmr:FlxTimer)
      		{
        		MusicBeatState.switchState(new ChooseSkinState());
      		}); // lazyiness to delete the timer lol
      	case 'button2':
					PlayState.SONG = Song.loadFromJson('cg-megamix', 'cg-megamix');
					PlayState.isCovers = true;
      		FlxG.sound.play(Paths.sound('entersfx'));
      		new FlxTimer().start(0.1, function(tmr:FlxTimer)
      		{
        		MusicBeatState.switchState(new ChooseSkinState());
      		});
      	case 'button3':
					PlayState.SONG = Song.loadFromJson('promenade', 'promenade');
					PlayState.isCovers = true;
      		FlxG.sound.play(Paths.sound('entersfx'));
      		new FlxTimer().start(0.1, function(tmr:FlxTimer)
      		{
        		MusicBeatState.switchState(new ChooseSkinState());
      		});
      	case 'button4':
					PlayState.SONG = Song.loadFromJson('deathmatch', 'deathmatch');
					PlayState.isCovers = true;
      		FlxG.sound.play(Paths.sound('entersfx'));
      		new FlxTimer().start(0.1, function(tmr:FlxTimer)
      		{
        		MusicBeatState.switchState(new ChooseSkinState());
      		});
      }
    }
    super.update(elapsed);
  }
  
  function changeCover(change:Int = 0)
  {
    curSelected += change;
    
        if (curSelected < 0)

			curSelected = buttonList.length - 1;

		if (curSelected >= buttonList.length)
			curSelected = 0;
			
		switch(curSelected)
		{
		  case 0:
		  button1.alpha = 1;
		  button1Black.alpha = 0;
		  //button2.color = FlxColor.BLACK;
		  button2.alpha = 0.15;
		  button2Black.alpha = 0.4;
		  //button3.color = FlxColor.BLACK;
		  button3.alpha = 0.15;
		  button3Black.alpha = 0.4;
		  //button4.color = FlxColor.BLACK;
		  button4.alpha = 0.15;
		  button4Black.alpha = 0.4;
		  case 1:
		  //button1.color = FlxColor.BLACK;
		  button1.alpha = 0.15;
		  button1Black.alpha = 0.4;
		  button2.alpha = 1;
		  button2Black.alpha = 0;
		  //button3.color = FlxColor.BLACK;
		  button3.alpha = 0.15;
		  button3Black.alpha = 0.4;
		  //button4.color = FlxColor.BLACK;
		  button4Black.alpha = 0.4;
		  button4.alpha = 0.15;
		  case 2:
		  //button1.color = FlxColor.BLACK;
		  button1.alpha = 0.15;
		  button1Black.alpha = 0.4;
		  //button2.color = FlxColor.BLACK;
		  button2.alpha = 0.15;
		  button2Black.alpha = 0.4;
		  button3.alpha = 1;
		  button3Black.alpha = 0;
		  //button4.color = FlxColor.BLACK;
		  button4.alpha = 0.15;
		  button4Black.alpha = 0.4;
		  case 3:
		  //button1.color = FlxColor.BLACK;
		  button1.alpha = 0.15;
		  button1Black.alpha = 0.4;
		  //button2.color = FlxColor.BLACK;
		  button2.alpha = 0.15;
		  button2Black.alpha = 0.4;
		  //button3.color = FlxColor.BLACK;
		  button3.alpha = 0.15;
		  button3Black.alpha = 0.4;
		  button4.alpha = 1;
		  button4Black.alpha = 0;
		}
		/*var coverSelected:FlxGraphic = Paths.image('hotline/menu/covers/' + buttonList[curSelected]);
		
		var cover:FlxGraphic = Paths.image('hotline/menu/covers/' + buttonList);
		
			for (i in 0...buttonList.length)
			{
				buttons.alpha = 0.48;
			}

			buttons.alpha = 1;*/
  }
}

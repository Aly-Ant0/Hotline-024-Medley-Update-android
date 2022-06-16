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
import flixel.graphics.FlxGraphic;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import lime.utils.Assets;

using StringTools;

//Choose the Nikku Skin
class ChooseSkinState extends MusicBeatState
{
	var skinShit:Array<String> = [
		'nikku',
		'nikku2',
		'jojo',
		'classic'
	];

  /*var nikku:FlxSprite;
  var nikkuShadow:FlxSprite;
  var classic:FlxSprite;
  var classicShadow:FlxSprite;
  var nikku2:FlxSprite;
  var nikku2Shadow:FlxSprite;
  var jojo:FlxSprite;
  var jojoShadow:FlxSprite;*/
  var skinS:FlxSprite;
  var skinShadow:FlxSprite;

  var chooseText:FlxSprite;
  var bg:FlxSprite;
  var bars:FlxSprite;
  var triangles:FlxSprite;

	public static var curSelected:Int = 0;

  override function create()
  {
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

    bg = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/bg'));
    add(bg);

    /*nikku = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/nikku'));
    nikku.screenCenter(XY);

    nikkuShadow = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/nikkuShadow'));
    nikkuShadow.screenCenter(XY);

    classic = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/classic'));
    classic.screenCenter(XY);

    classicShadow = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/classicShadow'));
    classicShadow.screenCenter(XY);

    jojo = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/jojo'));
    jojo.screenCenter(XY);

    jojoShadow = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/jojoShadow'));
    jojoShadow.screenCenter(XY);

    nikku2 = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/nikku2'));
    nikku2.screenCenter(XY);

    nikku2Shadow = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/nikku2Shadow'));
    nikku2Shadow.screenCenter(XY);*/
    
    skinS = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/' + skinShit[curSelected]));
    skinS.screenCenter(XY);
    
    skinShadow = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/' + skinShit[curSelected] + 'Shadow'));
    skinShadow.screenCenter(XY);
    
    bars = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/bars'));
    bars.screenCenter(XY);
    
    chooseText = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/text'));
    chooseText.screenCenter(XY);
    
    triangles = new FlxSprite().loadGraphic(Paths.image('hotline/menu/skins/triangles'));
    triangles.screenCenter(XY);
    
    /*add(nikkuShadow);
    add(nikku);
    add(classicShadow);
    add(classic);
    add(jojoShadow);
    add(jojo);*/
    add(skinShadow);
    add(skinS);
    add(bars);
    add(chooseText);
    add(triangles);

    changeSkin();
    super.create();

    #if android
    addVirtualPad(LEFT_RIGHT, A_B);
    #end
  }
  
  override function update(elapsed:Float)
  {
      if (controls.UI_LEFT_P)
      {
        FlxG.sound.play(Paths.sound('selectsfx'));
        changeSkin(-1);
      }
      if (controls.UI_RIGHT_P)
      {
        FlxG.sound.play(Paths.sound('selectsfx'));
        changeSkin(1);
      }

      if (controls.BACK)
      {
 				FlxG.sound.play(Paths.sound('backsfx'));
				if (PlayState.isCovers)
				{
					MusicBeatState.switchState(new CoversScreen());
				}
				if (PlayState.isExtras)
				{
					MusicBeatState.switchState(new ExtrasScreen());
				}
				else
				{
					MusicBeatState.switchState(new FreeplayState());
				}
      }
      if (controls.ACCEPT)
      {
        FlxG.sound.play(Paths.sound('entersfx'));
        new FlxTimer().start(0.1, function(tmr:FlxTimer)
        {
        	LoadingState.loadAndSwitchState(new PlayState());
        });
      }


 	 super.update(elapsed);
  }
  // i dont need twn variable

  //var skinTween:FlxTween;
  //var skinTween2:FlxTween;
  function changeSkin(change:Int = 0)
  {
      curSelected += change;
    
        if (curSelected < 0)

			curSelected = skinShit.length - 1;

		if (curSelected >= skinShit.length)
			curSelected = 0;

		var newSkin:FlxGraphic = Paths.image('hotline/menu/skins/' + skinShit[curSelected]);

		var newSkinShadow:FlxGraphic = Paths.image('hotline/menu/skins/' + skinShit[curSelected] + 'Shadow');
		
		if(skinS.graphic != newSkin)
		{
			if (change == 1)
			{
				skinS.loadGraphic(newSkin);
				skinS.x = -50;
				FlxTween.tween(skinS, {x: skinS.x + 50}, 0.75, {ease: FlxEase.smoothStepOut, onComplete: function(twn:FlxTween)
				{
					skinS.x = 0;
				}});
			}
			if (change == -1) {
			  skinS.loadGraphic(newSkin);
				skinS.x = 50;
				FlxTween.tween(skinS, {x: skinS.x - 50}, 0.75, {ease: FlxEase.smoothStepOut, onComplete: function(twn:FlxTween)
				{
					skinS.x = 0;
				}});
			}
		}
		if(skinShadow.graphic != newSkinShadow)
		{
			if (change == 1)
			{
				skinShadow.loadGraphic(newSkinShadow);
				skinShadow.alpha = 0.48;
				FlxTween.tween(skinShadow, {alpha: 1}, 0.1, {ease: FlxEase.smoothStepOut, onComplete: function(twn:FlxTween)
				{
					// do nothing 
				}});
			}
			if (change == -1)
			{
			  skinShadow.loadGraphic(newSkinShadow);
				skinShadow.alpha = 0.48;
				skinShadow.x = 5;
				FlxTween.tween(skinShadow, {x: skinShadow.x - 5, alpha: 1}, 0.1, {ease: FlxEase.smoothStepOut, onComplete: function(twn:FlxTween)
				{
					skinShadow.x = 0;
				}});
			}
		}
	}
  /*var skinTween3:FlxTween;
  var skinTween4:FlxTween;
  function changeLeft(change:Int = 0)
  {
      curSelected += change;
    
        if (curSelected < 0)

			curSelected = skinShit.length - 1;

		if (curSelected >= skinShit.length)
			curSelected = 0;
			
		var newSkin2:FlxGraphic = Paths.image('hotline/menu/skins/' + skinShit);
		
		var newSkinShadow2:FlxGraphic = Paths.image('hotline/skins/' + skinShit + 'Shadow');

		if(skinS.graphic != newSkin2)
		{
				skinS.x -= 5;
				skinS.alpha = 0;
				if(skinTween3 != null) skinTween3.cancel();
				skinTween3 = FlxTween.tween(skinS, {x: skinS.x - 5}, 0.7, {onComplete: function(twn:FlxTween)
			{
				skinTween3 = null;
			}});
		}
		if(skinShadow.graphic != newSkinShadow2)
		{
		  	skinShadow.alpha = 0;
				skinShadow.x += 10;
				if(skinTween4 != null) skinTween4.cancel();
				skinTween4 = FlxTween.tween(skinShadow, {x: skinShadow.x - 10, alpha: 1}, 1.2, {onComplete: function(twn:FlxTween)
			{
				skinTween4 = null;
			}});
		}
  }*/
}
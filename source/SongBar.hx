package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;
using flixel.util.FlxSpriteUtil;

class SongBar extends FlxSpriteGroup // culpa do bolsonaro
{
	var size:Float = 0;
	var fontSize:Int = 42;
	public var stringShit:String = "";

	public function new(x:Float, y:Float) {
		super(x, y);
		var text:FlxText = new FlxText(0, 0, 0, stringShit, fontSize);
		text.setFormat(Paths.font("Coco-Sharp-Heavy-Italic-trial.ttf"), fontSize, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		size = text.fieldWidth;
		var bg:FlxSprite = new FlxSprite(fontSize/-2, fontSize/-2).makeGraphic(Math.floor(size + fontSize) + 20, Math.floor(text.height + fontSize), FlxColor.BLACK);
		bg.alpha = 0.67;
		add(bg);
		add(text);
		x -= size;

	}
	public function tweenStartLololololololololololololololololololololollllmlllmlloololololololololololololololollololololollolololololllololololooloololoooloololoolooloollololllollllolookooilolololololololololololollolololololploololololololollollolllolololllololololololololololoololololllollolololololollollllololololololololololololooololololololol(){ //ok stop spamming lol pls
		FlxTween.tween(this, {x: x + size + (fontSize/2)}, 1, {ease: FlxEase.cubeInOut, startDelay:0.5, onComplete:function(twn:FlxTween){
			FlxTween.tween(this, {x: x - size}, 1, {ease: FlxEase.cubeInOut, startDelay: 5, onComplete: function(twn:FlxTween){ this.destroy(); }});
		}});
	}
}
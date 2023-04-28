package;

#if sys
import sys.io.File;
#end

import lime.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;
using flixel.util.FlxSpriteUtil;

class SongBar extends FlxSpriteGroup
{
	var meta:Array<Array<String>> = [];
	var size:Float = 0;
	var fontSize:Int = 24;

	public function new(_x:Float, _y:Float, _song:String) {
		super(_x, _y);

		var pulledText:String = Assets.getText(Paths.txt(_song.toLowerCase().replace(' ', '-') + "/info"));
		pulledText += '\n';

		var text = new FlxText(0, 0, 0, "", fontSize);
		text.setFormat(Paths.font("Coco-Sharp-Heavy-Italic-trial.ttf.ttf"), fontSize, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		text.text = pulledText;
		text.updateHitbox();

		size = text.fieldWidth;

		var bg = new FlxSprite(fontSize/-2, fontSize/-2).makeGraphic(Math.floor(size + fontSize), Std.int(text.height + 15), FlxColor.WHITE);
		bg.alpha = 0.47;
		text.text += "\n";

		add(bg);
		add(text);

		x -= size;
		alpha = 0.00000001; 
	}

	public function start(){
		alpha = 1;

		FlxTween.tween(this, {x: x + size + (fontSize/2)}, 1, {ease: FlxEase.quintInOut, onComplete: function(twn:FlxTween){
			FlxTween.tween(this, {x: x - size - 50}, 1, {ease: FlxEase.quintInOut, startDelay: 2, onComplete: function(twn:FlxTween){ 
				this.destroy(); 
			}});
		}});
	}
}
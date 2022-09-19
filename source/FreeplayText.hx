package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class FreeplayText extends FlxSkewedSprite
{
	public var targetY:Float = 0;
	public var maxSkew:Float = 15; // selected item
	public var minSkew:Float = -15; // not selected item
	public var skewDirection:Int = 1; // lmao
	public var skewSpeed:Float = 2.3;

	public function new(x:Float, y:Float, portName:String = '')
	{
		super(x, y);

		forceX = Math.NEGATIVE_INFINITY;
		forceSkew = Math.NEGATIVE_INFINITY;

		loadGraphic(Paths.image('freeplaySongText/' + portName, 'shared'));
		//trace('Test added: ' + WeekData.getWeekNumber(weekNum) + ' (' + weekNum + ')');
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		y = FlxMath.lerp(y, (targetY * 150) - -10, CoolUtil.boundTo(elapsed * 6, 0, 1));
		//x = x * (targetY - 0.5);
	}
}

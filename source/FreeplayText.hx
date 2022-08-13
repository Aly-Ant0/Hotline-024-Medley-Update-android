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
	public var forceX:Float = Math.NEGATIVE_INFINITY;
	public var forceSkew:Float = Math.NEGATIVE_INFINITY;
	public var flashingInt:Int = 0;

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

		if(forceX != Math.NEGATIVE_INFINITY) {
				x = forceX;
		}

		if(forceSkew != Math.NEGATIVE_INFINITY) {
				skew.x = forceSkew;
		}

		y = FlxMath.lerp(y, (targetY * 150) - -10, CoolUtil.boundTo(elapsed * 10.2, 0, 1));
		//x = x * (targetY - 0.5);
	}
}

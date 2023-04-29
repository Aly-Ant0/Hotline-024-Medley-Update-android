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
	public var maxSkew:Float = 13; // selected item
	public var minSkew:Float = -13; // not selected item
	public var skewDirection:Float = 0; // lmao
	public var skewSpeed:Float = 2.3;

	public function new(x:Float, y:Float, portName:String = '')
	{
		super(x, y);

		this.x = x;
		this.y = y;

		forceX = Math.NEGATIVE_INFINITY;

		loadGraphic(Paths.image('freeplaySongText/' + portName, 'shared'));
		//trace('Test added: ' + WeekData.getWeekNumber(weekNum) + ' (' + weekNum + ')');
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		y = FlxMath.lerp(y, (targetY * 187) + -10, CoolUtil.boundTo(elapsed * 6, 0, 1));
		//x = x * (targetY - 0.5);
		if(forceX != Math.NEGATIVE_INFINITY) {
			x = forceX;
		}
	}
}

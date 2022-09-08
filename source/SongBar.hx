package;

import flixel.FlxSprite;
import flixel.FlxG;
import Song.SwagSong;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sys.io.File;
import sys.FileSystem;

class SongBar // dont extends with someone 
{
	var suamae:FlxSprite = new FlxSprite();
	var txt:FlxText;
	public static var stringShit:String = '';
	public function new(x:Float, y:Float)
	{
		super(x, y);

		suamae.makeGraphic(1, 90, FlxColor.BLACK)!;
		add(suamae);
	}

	public function getSongInfo(shit:String)
	{
		
	}

	public function write(crap:String)
	{
		
	}
}
import flixel.FlxSprite;
import flixel.FlxG;
import Song.SwagSong;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sys.io.File;
import sys.FileSystem;

class SongBar extends FlxSprite
{
	var bar:FlxSprite;
	var songTxt:FlxText;

	override function create() {
		bar = new FlxSprite().makeGraphic(1, 90, FlxColor.BLACK);
		bar.alpha = 0.34;
		bar.scale.x = FlxG.width - songTxt.x + 15;
		bar.x = FlxG.width - (bar.scale.x / 2);
		add(bar);

		songTxt = new FlxText(FlxG.width + 10, bar.y + 9, 0, "", 37);
		songTxt.setFormat(Paths.font("LEMONMILK-Bold.otf"), 32, FlxColor.WHITE, RIGHT);
		add(songTxt);
		super.create();
	}

	override function update(elapsed:Float) {
		var songName:String = Paths.formatToSongPath(SONG.song);
		var directory:String = 'data/' + songName + '/';
		var content:String = directory + 'info.txt';
		//var get:String = c
		if(FileSystem.exists(content)) {
			songTxt.text = File.getContent(content);
		}
		else {
			songTxt.text = 'null';
		}
		super.update(elapsed);
	}
}
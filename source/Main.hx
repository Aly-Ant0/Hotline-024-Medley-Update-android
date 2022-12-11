package;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.system.System;

class Main extends Sprite
{
	var stateStart = #if debug MainMenuState #else TitleState;
	public static var framerate:Int = #if desktop 144 #else 60 #end;
	public static var fpsVar:FPS;
	//public static var songname:String = ''; // will be used in main menu 
	public static var path:String = System.applicationStorageDirectory;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();
		SUtil.gameCrashCheck();
		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		SUtil.doTheCheck();
		ClientPrefs.loadDefaultKeys();
		#if (flixel >= "5.0.0")
		addChild(new FlxGame(1280, 720, stateStart, framerate, framerate, true));
		#else
		addChild(new FlxGame(1280, 720, stateStart, 1, framerate, framerate, true));
		#end

		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}

		#if debug
		// debugging shit
		// and get from indie cross source
		FlxG.console.registerObject("Paths", Paths);
		FlxG.console.registerObject("Conductor", Conductor);
		FlxG.console.registerObject("PlayState", PlayState);
		FlxG.console.registerObject("MainMenuState", MainMenuState);
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}
}

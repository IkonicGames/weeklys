package ;

import flixel.FlxG;
import flixel.system.FlxSound;

class G
{
	public static inline var TILES_FLOOR:String = "images/FloorTiles.png";
	public static inline var TILES_DANGER:String = "images/DangerTiles.png";

	public static inline var LEVELS_START:Int = 0;
	public static inline var LEVELS_TOTAL:Int = 20;

	public static inline var PLAYER_START_Y:Float = 205;
	public static inline var PLAYER_SPEED:Float = 160;
	public static inline var PLAYER_JUMP:Float = -300;
	public static inline var PLAYER_JUMP_ANGLE:Float = 10;
	public static inline var PLAYER_MAX_FALL:Float = 1000;

	public static inline var GRAVITY:Float = 1000;

	public static inline var TXT_PLAY_AGAIN:String = 
#if flash
		"Press Space to Play Again!";
#end
#if cpp
		"Tap the Screen to Play Again.";
#end

	public static inline var TXT_INSTRUCTIONS:String =
#if flash
		"Press Space to Jump.";
#end
#if mobile
		"Tap the Screen to Jump.";
#end

	public static function loadSound(sound:String):FlxSound
	{
		var snd:String = sound.substring(0, sound.length - 3);
#if flash
		snd = snd + "mp3";
#end

#if cpp
		snd = snd + "wav";
#end

		return FlxG.sound.load(snd);	
	}
}

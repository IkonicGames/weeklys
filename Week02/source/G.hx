package ;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.util.FlxRandom;
import flixel.util.FlxColorUtil;
import flixel.system.FlxSound;

class G
{
	public static inline var PLAYER_SPEED:Float = 150;
	public static inline var PLAYER_SHOOT_TIMER:Float = 0.1;

	public static inline var BULLET_MAX_COUNT:Int = 2;
	public static inline var BULLET_SPEED:Float = 300;
	public static inline var BULLET_DAMAGE:Float = 1;

	public static inline var ENEMY_POINTS:Float = 10;
	public static inline var ENEMY_SPAWN_TIME_MAX:Float = 2;
	public static inline var ENEMY_SPAWN_TIME_MIN:Float = 0.1;
	public static inline var ENEMY_SPAWN_TIME_TO_MIN:Float = 45;
	public static inline var ENEMY_ACCEL_Y:Float = 10;
	public static inline var ENEMY_SPEED_Y:Float = 75;
	public static inline var ENEMY_SPEED_X:Float = 10;
	public static inline var ENEMY_HEALTH_START:Float = 3;
	public static inline var ENEMY_ELASTICITY:Float = -0.5;

	public static function init():Void
	{
		_save = new FlxSave();
		_save.bind("gameSave");

		_bgColor = FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 359), 0.5, 0.3, 255);
		_pallet = [];
	}

	public static function loadSound(sound:String):FlxSound
	{
		var snd:String;
		snd = sound.substring(0, sound.length - 3);

#if flash
		snd = snd + "mp3";
#end

#if cpp
		snd = snd + "wav";
#end
		
		return FlxG.sound.load(snd);
	}

	// HIGH SCORE

	static var _save:FlxSave;

	public static function checkHighScore(score:Float):Bool
	{
		if(_save.data.highScore == null)
			return true;

		return score > _save.data.highScore;
	}

	public static function setHighScore(score:Float):Void
	{
		if(!checkHighScore(score))
			return;
		
		_save.data.highScore = score;
	}

	public static function getHighscore():Float
	{
		if(_save.data.highScore == null)
			return 0;

		return _save.data.highScore;
	}

	// COLOR

	static var _pallet:Array<Int>;
	static var _bgColor:Int;
	static var _playerColor:Int;
	static var _particleColor:Int;

	public static function initPallet():Void
	{
		_pallet = new Array<Int>();
		var hue:Float = FlxRandom.float();
		_playerColor = FlxColorUtil.HSVtoARGB(hue * 359, 0.7, 0.95, 255);
		hue = goldenHue(hue);
		_particleColor = FlxColorUtil.HSVtoARGB(hue * 359, 0.7, 0.95, 255);
		hue = goldenHue(hue);
		_pallet[0] = FlxColorUtil.HSVtoARGB(hue * 359, 0.7, 0.95, 255);
		hue = goldenHue(hue);
		_pallet[1] = FlxColorUtil.HSVtoARGB(hue * 359, 0.7, 0.95, 255);
		hue = goldenHue(hue);
		_pallet[2] = FlxColorUtil.HSVtoARGB(hue * 359, 0.7, 0.95, 255);
		hue = goldenHue(hue);
		_pallet[3] = FlxColorUtil.HSVtoARGB(hue * 359, 0.7, 0.95, 255);
		hue = goldenHue(hue);
		_pallet[4] = FlxColorUtil.HSVtoARGB(hue * 359, 0.7, 0.95, 255);
	}

	private static function goldenHue(hueIn:Float):Float
	{
		hueIn += 0.618033988749895;
		hueIn %= 1;
		return hueIn;
	}

	public static function getBackgroundColor():Int
	{
		return _bgColor;
	}

	public static function getPlayerColor():Int
	{
		return _playerColor;
	}

	public static function getParticleColor():Int
	{
		return _particleColor;
	}

	public static function getEnemyColor():Int
	{
		return _pallet[FlxRandom.intRanged(0, 4)];
	}
}

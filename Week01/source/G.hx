package ;

import flixel.util.FlxSave;

class G
{
	public static inline var PLAYER_MAX_SPEED:Float = 150;
	public static inline var PLAYER_ACCEL:Float = 800;
	public static inline var PLAYER_DRAG:Float = 200;

	public static inline var ENEMY_SPEED:Float = 80;
	public static inline var ENEMY_ANGLE_RANGE:Float = 30;

	public static function getTimeString(time:Float):String
	{
		var minutes = Math.ffloor(time / 60);
		var seconds = Math.floor(time - (minutes * 60));
		return Std.string(minutes) + ":" + (seconds < 10 ? "0" : "") + Std.string(seconds);
	}

	private static var _gameSave:FlxSave;
	private static function checkGameSave():Void
	{
		if(_gameSave == null)
		{
			_gameSave = new FlxSave();
			_gameSave.bind("gameSave");
			if(_gameSave.data.highScore == null)
				_gameSave.data.highScore = 0;
		}
	}

	public static function setHighScore(score:Float):Void
	{
		checkGameSave();

		if(_gameSave.data.highScore < score)
		{
			_gameSave.data.highScore = score;
		}
	}

	public static function checkHighScore(score:Float):Bool
	{
		checkGameSave();
		return _gameSave.data.highScore < score;
	}

	public static function getHighScore():Float
	{
		checkGameSave();
		return _gameSave.data.highScore;
	}
}

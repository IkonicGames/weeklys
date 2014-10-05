import flixel.util.FlxSave;
import flixel.util.FlxMath;

class G
{
	public static inline var GRAVITY:Float = 300;

	public static inline var PLR_JUMP:Float = 200;

	public static inline var GRPL_LENGTH:Float = 100;
	public static inline var GRPL_LENGTH_RANGE:Float = 50;
	public static inline var GRPL_LERP:Float = 0.25;

	public static function getTimeString(time:Float):String
	{
		var minutes = Math.ffloor(time / 60);
		var seconds = Math.floor(time - (minutes * 60));
		return Std.string(minutes) + ":" + (seconds < 10 ? "0" : "") + Std.string(seconds);
	}

	// ---- Score ----

	private static var _saveGame:FlxSave;
	private static function checkSaveGame():Void
	{
		if(_saveGame == null)
		{
			_saveGame = new FlxSave();
			_saveGame.bind("CogLove");
			_saveGame.erase();
			if(_saveGame.data.highScore == null)
				_saveGame.data.highScore = new Array<Int>();
		}
	}

	public static var lastScore:Float;

	public static function checkHighScore(level:Int, score:Float):Bool
	{
		checkSaveGame();
		if(_saveGame.data.highScore[level] == null)
			_saveGame.data.highScore[level] = FlxMath.MAX_VALUE;
		return _saveGame.data.highScore[level] > score;
	}

	public static function setHighScore(level:Int, score:Float):Void
	{
		checkSaveGame();
		if(checkHighScore(level, score))
			_saveGame.data.highScore[level] = score;
	}

	public static function getHighScore(level:Int):Float
	{
		checkSaveGame();
		if(_saveGame.data.highScore.length < level)
			return 0;
		return _saveGame.data.highScore[levelNum];
	}

	// ---- Level Info ----

	private static var _levels:Array<String> = ["Level01", "Level02", "Level03", "Level04", "Level05", "Level06", "Level07"];
	public static var levelNum(default, null):Int = 6;

	public static var gameOver(get, null):Bool;
	private static function get_gameOver():Bool
	{
		return levelNum >= _levels.length;
	}

	public static var currentLevel(get, null):String;
	private static function get_currentLevel():String
	{
		return "assets/data/tiled/" + _levels[levelNum] + ".tmx";
	}

	public static function levelCompleted(score:Float):Void
	{
		lastScore = score;
		levelNum++;
	}

	public static function restartLevels():Void
	{
		levelNum = 0;
	}
}

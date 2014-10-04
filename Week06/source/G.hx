class G
{
	public static inline var GRAVITY:Float = 300;

	public static inline var PLR_JUMP:Float = 200;

	public static inline var GRPL_LENGTH:Float = 100;
	public static inline var GRPL_LENGTH_RANGE:Float = 50;
	public static inline var GRPL_LERP:Float = 0.25;

	// ---- Level Info ----

	private static var _levels:Array<String> = ["testLevel", "testLevel1"];
	public static var levelNum(default, null):Int = 0;

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

	public static function levelCompleted():Void
	{
		levelNum++;
	}

	public static function restartLevels():Void
	{
		levelNum = 0;
	}
}

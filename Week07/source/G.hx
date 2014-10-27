import flixel.FlxG;

class G
{
	public static inline var SWEEPS:Int = 15;

	public static inline var BRD_START_ROWS:Int = 2;
	public static inline var BRD_CLEAR_SIZE:Int = 3;
	public static inline var BRD_ROWS:Int = 5;
	public static inline var BRD_COLS:Int = 5;
	public static inline var BRD_WIDTH:Int = 288;
	public static inline var BRD_HEIGHT:Int = 360;

	public static inline var BRD_TOP:Float = 128;
	public static var BRD_BOTTOM(get, null):Float;
	private static inline function get_BRD_BOTTOM():Float
	{
		return BRD_TOP + BLOCK_PAD / 2 + (BLOCK_PAD + BLOCK_SIZE) * BRD_ROWS;
	}

	public static var BRD_LEFT(get, null):Float;
	private static inline function get_BRD_LEFT():Float
	{
		return (FlxG.width - BLOCK_PAD / 2 - (BLOCK_PAD + BLOCK_SIZE) * BRD_COLS) / 2;
	}

	public static var BRD_RIGHT(get, null):Float;
	private static inline function get_BRD_RIGHT():Float
	{
		return FlxG.width - BRD_LEFT;
	}

	public static inline var BLOCK_SIZE:Int = 48;
	public static inline var BLOCK_PAD:Int = 8;

	public static inline var QUEUE_HEIGHT:Int = 32;

	public static inline var MTR_SPEED:Float = 1;
}

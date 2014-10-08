import flixel.util.FlxRandom;

class BlockType {
	public static inline var EMPTY:Int = 0;
	public static inline var CLEARED:Int = 0xCCCCCC;
	public static inline var A:Int = 0xFF0000;
	public static inline var B:Int = 0x00FF00;
	public static inline var C:Int = 0x0000FF;
	public static inline var D:Int = 0xFF00FF;

	public static function choose():Int
	{
		var choice = FlxRandom.intRanged(0, 3);
		switch(choice)
		{
			case 0:
				return A;

			case 1:
				return B;

			case 2:
				return C;

			case 3:
				return D;
		}

		return EMPTY;
	}
}

import flixel.util.FlxRandom;

class BlockType {
	public static inline var BACKGROUND:Int = 0xBFDDFC;

	public static inline var EMPTY:Int = 0x111111;
	public static inline var CLEARED:Int = 0x556270;
	public static inline var A:Int = 0x4ECDC4;
	public static inline var B:Int = 0xC7F464;
	public static inline var C:Int = 0xFF6B6B;
	public static inline var D:Int = 0xFF00FF;

	public static function choose():Int
	{
		var choice = FlxRandom.intRanged(0, 2);
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

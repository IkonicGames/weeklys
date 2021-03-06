package ;

import openfl.Assets;
import flixel.FlxG;
import flixel.graphics.frames.FlxBitmapFont;

class G
{
	public static var FONT(get, null):FlxBitmapFont;
	private static inline function get_FONT():FlxBitmapFont
	{
		if(FONT == null)
			FONT = FlxBitmapFont.fromAngelCode(AssetPaths.league_gothic_0__png, Xml.parse(Assets.getText(AssetPaths.league_gothic__fnt)));

		return FONT;
	}

	public static inline var PLR_GRND_ACCEL:Float = 150;
	public static inline var PLR_GRND_SPEED:Float = 150;
	public static inline var PLR_GRND_ROT_SPEED:Float = 270;
	public static inline var PLR_AIR_GRAVITY:Float = 200;
	public static inline var PLR_MAX_SPEED:Float = 200;
	public static inline var PLR_ELACTICIY:Float = 0.5;
	public static inline var PLR_HEALTH_START:Float = 1000;
	public static inline var PLR_HEALTH_DECAY:Float = 20;

	public static inline var EDBL_SPD_MIN:Float = 40;
	public static inline var EDBL_SPD_MAX:Float = 100;
	public static inline var EDBL_HEIGHT_MIN:Float = 0.4;
	public static inline var EDBL_HEIGHT_MAX:Float = 0.2;
	public static inline var EDBL_POINTS:Int= 5;
	public static inline var EDBL_HEALTH_BONUS:Float = 50;

	public static inline var EDBL_MGR_COUNT_MIN:Int = 3;
	public static inline var EDBL_MGR_COUNT_MAX:Int = 8;
	public static inline var EDBL_MGR_COUNT_TIME:Float = 120;
	public static inline var EDBL_MGR_SPAWN_CHANCE:Int= 10;

	public static inline var PLN_COUNT_MIN:Int = 0;
	public static inline var PLN_COUNT_MAX:Int = 5;
	public static inline var PLN_COUNT_TIME:Float = 120;
	public static inline var PLN_SPAWN_CHANCE:Int = 1;
	public static inline var PLN_SPD_MIN:Float = 100;
	public static inline var PLN_SPD_MAX:Float = 175;
	public static inline var PLN_HEIGHT_MIN:Float = 0.05;
	public static inline var PLN_HEIGHT_MAX:Float = 0.15;
	public static inline var PLN_BOMB_FREQ_MIN:Float = 150;
	public static inline var PLN_BOMB_FREQ_MAX:Float = 250;

	public static inline var BOMB_GRAVITY:Float = 100;
	public static inline var BOMB_XVEL_PCT:Float = 0.3;
	public static inline var BOMB_DMG:Float = 200;

	public static inline var SCORE_AIR_TIME:Float = 0.01;

	public static inline var BOMB_EXPLOSION_LIFE:Float = 1;
	public static inline var BOMB_EXPLOSION_QTY:Int = 25;
	public static inline var BOMB_EXPLOSION_SIZE:Int = 64;

}

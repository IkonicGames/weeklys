package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;

class Bomb extends FlxSprite
{
	public function new()
	{
		super();

		this.acceleration.y = G.BOMB_GRAVITY;

		this.makeGraphic(8, 8, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawCircle(this);
	}
}

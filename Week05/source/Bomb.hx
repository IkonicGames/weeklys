package ;

import flixel.FlxG;
import flixel.FlxSprite;

class Bomb extends FlxSprite
{
	public function new()
	{
		super();

		this.acceleration.y = G.BOMB_GRAVITY;

		this.makeGraphic(8, 8);
	}
}

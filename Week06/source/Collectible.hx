package ;

import flixel.FlxG;
import flixel.FlxSprite;

class Collectible extends FlxSprite
{
	public function new(?X:Float, ?Y:Float)
	{
		super(X, Y);

		this.loadGraphic(AssetPaths.Collectible__png);

		this.x -= this.width / 2;
		this.y -= this.height / 2;
	}
}

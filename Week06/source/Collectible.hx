package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Collectible extends FlxSprite
{
	public function new(?X:Float, ?Y:Float)
	{
		super(X, Y);

		this.loadGraphic(AssetPaths.Collectible__png);

		this.x -= this.width / 2;
		this.y -= this.height / 2;

		this.angularVelocity = 30;

		FlxTween.linearMotion(this, x, y, x, y - height / 2, 1, true, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut});
	}
}

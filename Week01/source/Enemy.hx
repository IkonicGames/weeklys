package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxMath;
import flixel.util.FlxAngle;
import flixel.util.FlxRandom;

class Enemy extends FlxSprite
{

	public function new()
	{
		super();

		this.loadGraphic(AssetPaths.Enemy01__png, true, 16, 16);
		this.animation.add("loop", [0, 1], 8, true);
		this.animation.play("loop");
	}

	public function setVelocity():Void
	{
		this.angle = FlxAngle.asDegrees(Math.atan2(FlxG.height / 2 - this.y, FlxG.width / 2 - this.x));
		this.angle += FlxRandom.floatRanged(-G.ENEMY_ANGLE_RANGE, G.ENEMY_ANGLE_RANGE);
		FlxAngle.rotatePoint(G.ENEMY_SPEED, 0, 0, 0, this.angle, this.velocity);
		this.angle += 90;
	}
}

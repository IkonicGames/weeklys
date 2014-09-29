package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxRandom;

class Edible extends FlxSprite
{
	public function new()
	{
		super();

		this.loadGraphic(AssetPaths.Flyer__png, true, 8, 8);
		this.animation.add("fly", [1,2,3,4,5,6,7,8,9,10,11,12,13,14]);
		this.animation.play("fly");

		this.scale.set(2, 2);
	}

	override public function update():Void
	{
		super.update();

		if(!this.inWorldBounds())
			this.kill();
	}

	override public function reset(X:Float, Y:Float):Void
	{
		super.reset(X, Y);

		this.velocity.y = 0;
		this.velocity.x = FlxRandom.floatRanged(G.EDBL_SPD_MIN, G.EDBL_SPD_MAX);
		if(x > FlxG.width)
			this.velocity.x = -this.velocity.x;
	}
}

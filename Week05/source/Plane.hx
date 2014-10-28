package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRandom;

class Plane extends FlxSprite
{
	var _bombDist:Float;
	var _nextDrop:Float;

	public function new()
	{
		super();

		this.loadGraphic(AssetPaths.Plane__png, true, 32, 12);
		this.animation.add("fly", [0,1,2,3,4,5]);
		this.animation.play("fly");

		resetBombDrop();
	}

	override public function update(dt:Float):Void
	{
		super.update(dt);

		if(!this.inWorldBounds())
			this.kill();

		if(this.isOnScreen())
		{
			_bombDist += Math.abs(this.velocity.x * FlxG.elapsed);
			if(_bombDist >_nextDrop)
			{
				BombSpawner.instance.spawn(this.x + this.width / 2, this.y + this.height, this.velocity.x);
				resetBombDrop();
			}
		}
	}

	override public function reset(X:Float, Y:Float):Void
	{
		super.reset(X, Y);

		_bombDist = 0;

		this.velocity.y = 0;
		this.velocity.x = FlxG.random.float(G.PLN_SPD_MIN, G.PLN_SPD_MAX);
		if(x > FlxG.width)
			this.velocity.x = -this.velocity.x;

		this.flipX = this.velocity.x < 0;
	}

	function resetBombDrop():Void
	{
		_nextDrop = FlxG.random.float(G.PLN_BOMB_FREQ_MIN, G.PLN_BOMB_FREQ_MAX);
		_bombDist = 0;
	}
}

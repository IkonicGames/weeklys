package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxRandom;
import flixel.util.FlxRandom;

class Plane extends FlxSprite
{
	var _bombDist:Float;
	var _nextDrop:Float;

	public function new()
	{
		super();

		this.makeGraphic(32, 12);


		resetBombDrop();
	}

	override public function update():Void
	{
		super.update();

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
		this.velocity.x = FlxRandom.floatRanged(G.PLN_SPD_MIN, G.PLN_SPD_MAX);
		if(x > FlxG.width)
			this.velocity.x = -this.velocity.x;
	}

	function resetBombDrop():Void
	{
		_nextDrop = FlxRandom.floatRanged(G.PLN_BOMB_FREQ_MIN, G.PLN_BOMB_FREQ_MAX);
		_bombDist = 0;
	}
}

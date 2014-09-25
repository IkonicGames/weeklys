package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxPool;

class ObjectSpawner<T:FlxObject> extends FlxTypedGroup<T>
{
	var _pool:FlxPool<T>;

	var _currElapsed:Float;

	var _cntMin:Int;
	var _cntMax:Int;
	var _cntTime:Float;
	var _chance:Int;

	var _heightMin:Float;
	var _heightMax:Float;

	public function new(t:Class<T>, cntMin:Int, cntMax:Int, cntTime:Float, chance:Int, heightMin:Float, heightMax:Float)
	{
		super();

		_pool = new FlxPool<T>(t);
		_currElapsed = 0;

		_cntMin = cntMin;
		_cntMax = cntMax;
		_cntTime = cntTime;
		_chance = chance;
		_heightMin = heightMin;
		_heightMax = heightMax;
	}

	override public function update():Void
	{
		super.update();

		_currElapsed += FlxG.elapsed;

		// just get what the current maximum number of edibles there can be
		var cnt:Int = cast FlxMath.lerp(_cntMin, _cntMax, FlxMath.bound(0, 1, _currElapsed / _cntTime));
		if(this.countLiving() < cnt && FlxRandom.chanceRoll(_chance))
			spawnObject();
	}

	function spawnObject():Void
	{
		var obj = _pool.get();

		var ex = FlxRandom.chanceRoll(50) ? -20 : FlxG.width + 20;
		var ey = FlxG.height * FlxRandom.floatRanged(_heightMin, _heightMax);
		obj.reset(ex, ey);
		this.add(obj);
	}
}

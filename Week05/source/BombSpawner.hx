package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxPool;

class BombSpawner extends FlxTypedGroup<Bomb>
{
	private static var _instance:BombSpawner;
	public static var instance(get_instance, null):BombSpawner;
	private static function get_instance():BombSpawner {
		return _instance;
	}

	var _pool:FlxPool<Bomb>;

	public function new()
	{
		super();

		_instance = this;

		_pool = new FlxPool<Bomb>(Bomb);
	}

	public function spawn(X:Float, Y:Float, XVel:Float):Void
	{
		var bomb:Bomb = _pool.get();
		bomb.reset(X, Y);
		bomb.velocity.x = XVel * G.BOMB_XVEL_PCT;
		this.add(bomb);
	}

}

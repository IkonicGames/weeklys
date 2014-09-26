package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.group.FlxGroup;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var _player:Player;
	var _ground:FlxSprite;
	var _bounds:FlxGroup;

	var _mgrEdible:ObjectSpawner<Edible>;
	var _mgrPlane:ObjectSpawner<Plane>;
	var _bombSpawner:BombSpawner;

	var _gameHud:GameHUD;
	var _scoreMult:Int;
	var _scoreMultPool:Float;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		_scoreMult = 1;
		_scoreMultPool = 0;
		FlxG.worldBounds.set(-50, -50, FlxG.width + 100, FlxG.height + 100);

		_ground = new FlxSprite(0, FlxG.height * 0.6);
		_ground.makeGraphic(FlxG.width, Std.int(FlxG.height * 0.4));
		_ground.color = FlxColor.BROWN;
		_ground.immovable = true;
		this.add(_ground);

		_player = new Player();
		_player.x = FlxG.width / 2;
		_player.y = FlxG.height / 2;
		this.add(_player);

		_bounds = new FlxGroup(4);
		_bounds.add(new FlxObject(-20, -20, 20, FlxG.height + 40)); // left
		_bounds.add(new FlxObject(FlxG.width, -20, 20, FlxG.height + 40)); // right
		_bounds.add(new FlxObject(-20, FlxG.height, FlxG.width + 40, 20)); // bottom
		_bounds.add(new FlxObject(-20, -20, FlxG.width + 40, 20)); // top
		_bounds.forEachOfType(FlxObject, function(obj:FlxObject):Void {
			obj.immovable = true;
		});
		this.add(_bounds);

		_mgrEdible = new ObjectSpawner<Edible>(Edible, G.EDBL_MGR_COUNT_MIN, G.EDBL_MGR_COUNT_MAX, G.EDBL_MGR_COUNT_TIME, G.EDBL_MGR_SPAWN_CHANCE, G.EDBL_HEIGHT_MIN, G.EDBL_HEIGHT_MAX);
		this.add(_mgrEdible);

		_mgrPlane = new ObjectSpawner<Plane>(Plane, G.PLN_COUNT_MIN, G.PLN_COUNT_MAX, G.PLN_COUNT_TIME, G.PLN_SPAWN_CHANCE, G.PLN_HEIGHT_MIN, G.PLN_HEIGHT_MAX);
		this.add(_mgrPlane);

		_bombSpawner = new BombSpawner();
		this.add(_bombSpawner);

		_gameHud = new GameHUD();
		this.add(_gameHud);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		FlxG.overlap(_player, _ground, onOverlapGround);
		FlxG.collide(_player, _bounds);

		FlxG.overlap(_player, _mgrEdible, onOverlapEdible);

		FlxG.collide(_bombSpawner, _ground, onBombHitGround);

		if(!_player.inGround)
		{
			_scoreMultPool += FlxG.elapsed;
			while(_scoreMultPool > G.SCORE_AIR_TIME)
			{
				_player.score += _scoreMult;
				_scoreMultPool -= G.SCORE_AIR_TIME;
			}
		}

		_gameHud.setScore(_player.score);
		_gameHud.setMult(_scoreMult);
		_gameHud.setHealthPct(_player.health / G.PLR_HEALTH_START);
	}	

	private function onOverlapGround(player:FlxObject, ground:FlxObject):Void
	{
		_player.setInGround();
		_scoreMult = 1;
	}

	public function onOverlapEdible(player:FlxObject, edible:FlxObject):Void
	{
		edible.kill();
		_player.score += G.EDBL_POINTS * _scoreMult;
		_player.addHealth(G.EDBL_HEALTH_BONUS * _scoreMult);
		_scoreMult++;
	}
	
	public function onBombHitGround(bomb:FlxObject, ground:FlxObject):Void
	{
		bomb.kill();
	}
}

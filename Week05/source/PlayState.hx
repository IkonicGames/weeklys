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

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		FlxG.worldBounds.set(-100, -100, FlxG.width + 200, FlxG.height + 200);

		_ground = new FlxSprite(0, FlxG.height / 2);
		_ground.makeGraphic(FlxG.width, Std.int(FlxG.height / 2));
		_ground.color = FlxColor.BROWN;
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
	}	

	private function onOverlapGround(player:FlxObject, ground:FlxObject):Void
	{
		_player.setInGround();
	}
}

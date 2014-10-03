package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var _player:Player;
	var _floor:FlxSprite;
	var _grapple:FlxSprite;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		_floor = new FlxSprite(0, Std.int(FlxG.height * 0.8));
		_floor.makeGraphic(FlxG.width, Std.int(FlxG.height * 0.2));
		_floor.immovable = true;
		this.add(_floor);

		_grapple = new FlxSprite(FlxG.width / 2, FlxG.height / 4);
		_grapple.makeGraphic(32, 32);
		_grapple.immovable;
		this.add(_grapple);

		_player = new Player(FlxG.width / 4, FlxG.height / 20);
		_player.addGrappleObject(_grapple);
		this.add(_player);
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
		FlxG.collide(_player, _floor);
		super.update();

	}	
}

package ;

import flixel.FlxG;
import flixel.FlxSprite;

class GameBlock extends FlxSprite
{
	public var type(default, null):Int;

	public function new()
	{
		super();

		this.makeGraphic(G.BLOCK_SIZE, G.BLOCK_SIZE);
	}

	override public function setPosition(X:Float = 0, Y:Float = 0):Void
	{
		super.setPosition(X, Y);
	}

	public function setType(type:Int):Void
	{
		this.type = type;

		this.color = this.type;
	}

}

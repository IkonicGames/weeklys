package ;

import flixel.FlxG;
import flixel.FlxSprite;

class BlockSelector extends FlxSprite
{
	public var selected(default, null):GameBlock;

	public function new()
	{
		super();

		this.makeGraphic(8, 8);
	}

	public function select(block:GameBlock):Void
	{
		selected = block;
		setPosition(selected.x, selected.y);
		visible = true;
	}

	public function clearSelection():Void
	{
		selected = null;
		visible = false;
	}
}

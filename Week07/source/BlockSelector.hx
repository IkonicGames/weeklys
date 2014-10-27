package ;

import flixel.FlxG;
import flixel.FlxSprite;

class BlockSelector extends FlxSprite
{
	public var selected(default, null):GameBlock;

	public function new()
	{
		super();

		this.loadGraphic(AssetPaths.selection__png);
		this.blend = flash.display.BlendMode.ADD;
	}

	public function select(block:GameBlock):Void
	{
		selected = block;
		setPosition(selected.x, selected.y);
		visible = true;
		this.color = block.color;
	}

	public function clearSelection():Void
	{
		selected = null;
		visible = false;
	}
}

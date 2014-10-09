package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;

class BlockQueue extends FlxTypedGroup<GameBlock>
{
	public var colors(default, null):Array<Int>;

	var _blocks:Array<GameBlock>;

	public function new()
	{
		super();

		colors = new Array<Int>();
		_blocks = new Array<GameBlock>();

		var left = G.BLOCK_PAD + (FlxG.width - (G.BLOCK_SIZE + G.BLOCK_PAD) * G.BRD_COLS) / 2;
		for(i in 0...G.BRD_COLS)
		{
			var block = new GameBlock();
			block.y = G.QUEUE_HEIGHT;
			block.x = left + (G.BLOCK_SIZE + G.BLOCK_PAD) * i;
			_blocks.push(block);
			this.add(block);
			colors[i] = BlockType.choose();
		}

		randomizeColors();
	}

	public function randomizeColors():Void
	{
		for(i in 0...G.BRD_COLS)
		{
			colors[i] = BlockType.choose();
			_blocks[i].setType(colors[i]);
		}
	}
}

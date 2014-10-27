package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.group.FlxSpriteGroup;
import flash.geom.Rectangle;

class GameGrid extends FlxSpriteGroup
{
	public function new()
	{
		super();

		var sprite:FlxUI9SliceSprite = new FlxUI9SliceSprite(G.BRD_LEFT, G.BRD_TOP + G.BLOCK_PAD / 2, AssetPaths.panel__png, new Rectangle(0, 0, G.BRD_WIDTH, G.BRD_BOTTOM - G.BRD_TOP + G.BLOCK_PAD / 2), [10,10,28,28]);
		sprite.color = 0x8FA5BC;
		this.add(sprite);

		for(i in 0...G.BRD_COLS)
		{
			for(j in 0...G.BRD_ROWS)
			{
				var block = new FlxSprite();
				block.loadGraphic(AssetPaths.emptybutton__png);
				block.color = BlockType.CLEARED;
				block.setPosition(4 + G.BRD_LEFT + G.BLOCK_PAD / 2 + (G.BLOCK_PAD + G.BLOCK_SIZE) * i, 4 + G.BRD_TOP + G.BLOCK_PAD + (G.BLOCK_PAD + G.BLOCK_SIZE) * j);
				this.add(block);
			}
		}
	}
}

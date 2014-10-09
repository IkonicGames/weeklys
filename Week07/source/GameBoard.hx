package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSignal;
import flixel.util.FlxPool;

class GameBoard extends FlxSpriteGroup
{
	public var onGameOver(default, null):FlxSignal;
	public var onClicked(default, null):FlxTypedSignal<GameBlock -> Void>;

	public var gameOver(default, null):Bool;

	public var top(default, null):Float;
	public var bottom(default, null):Float;
	public var left(default, null):Float;
	public var right(default, null):Float;

	var _blocks:Array<Array<GameBlock>>;
	var _cleared:Array<Array<Int>>;

	var _blockPool:FlxPool<GameBlock>;

	public function new()
	{
		super();

		onGameOver = new FlxSignal();
		onClicked = new FlxTypedSignal<GameBlock -> Void>();

		_blocks = new Array<Array<GameBlock>>();
		_cleared = new Array<Array<Int>>();

		top = G.BRD_TOP;
		bottom = G.BRD_TOP + (G.BLOCK_PAD + G.BLOCK_SIZE) * G.BRD_ROWS;
		left = (FlxG.width - (G.BLOCK_PAD + G.BLOCK_SIZE) * G.BRD_COLS) / 2;
		right = FlxG.width - left;

		for(i in 0...G.BRD_COLS)
		{
			var clearCol = new Array<Int>();
			_cleared.push(clearCol);

			var blockCol = new Array<GameBlock>();
			_blocks.push(blockCol);

			for(j in 0...G.BRD_ROWS)
			{
				clearCol.push(BlockType.EMPTY);

				var block = new GameBlock();
				blockCol.push(block);
				if(j > G.BRD_ROWS - G.BRD_START_ROWS - 1)
					block.setType(BlockType.choose());
				else
					block.setType(BlockType.EMPTY);
				block.setPosition(left + G.BLOCK_PAD + (G.BLOCK_PAD + G.BLOCK_SIZE) * i, G.BRD_TOP + G.BLOCK_PAD + (G.BLOCK_PAD + G.BLOCK_SIZE) * j);
				block.setIndex(i, j);
				block.onClicked.add(onBlockClicked);
				this.add(block);
			}
		}
	}

	public function checkRow(row:Int):Void
	{
		if(row >= G.BRD_ROWS)
			return;

		var lastType:Int = -1;
		var typeCount:Int = 0;
		var currType:Int;
		for(i in 0...G.BRD_COLS)
		{
			currType = getBlockType(i, row);
			if(currType == BlockType.CLEARED || currType == BlockType.EMPTY)
			{
				lastType = currType;
				typeCount = 0;
				continue;
			}
			
			// check if block below or to the left was cleared and of the same color
			if(row < G.BRD_ROWS && 
					_cleared[i][row + 1] == currType ||
					i > 0 && _cleared[i - 1][row] == currType)
			{
				addCleared(row, i, 1, currType);
				// check to the left until another type is found.
				var left:Int = i - 1;
				while(left >= 0 && getBlockType(left, row) == currType)
				{
					addCleared(row, left, 1, currType);
					left--;
				}
			}

			if(currType != lastType)
			{
				lastType = currType;
				typeCount = 0;
				continue;
			}

			typeCount++;

			if(typeCount >= G.BRD_CLEAR_SIZE - 1)
			{
				addCleared(row, i, typeCount + 1, lastType);
			}
		}
	}

	public function addBlockRow(row:Array<Int>, rowNum:Int = 0):Void
	{
		for(i in 0...G.BRD_COLS)
		{
			if(getBlockType(i, rowNum) != BlockType.EMPTY)
			{
				gameOver = true;
				onGameOver.dispatch();
				break;
			}

			var blockRow = rowNum;
			while(blockRow < G.BRD_ROWS && getBlockType(i, blockRow) == BlockType.EMPTY)
				blockRow++;

			setBlockType(i, blockRow - 1, row[i]);
		}

		if(gameOver)
			return;
	}

	public function clearCleared():Void
	{
		for(i in 0...G.BRD_COLS)
		{
			for(j in 0...G.BRD_ROWS)
			{
				if(_cleared[i][j] != BlockType.EMPTY)
					setBlockType(i, j, BlockType.CLEARED);
				_cleared[i][j] = BlockType.EMPTY;
			}
		}
	}

	public function dropClearedBlocks():Void
	{
		/**
		  for each column,
		  start at the bottom
		  check for cleared
		  if empty, count it
		  if empty count > 0 && blocktype is not empty
		  drop all blocks above by empty count.
		 **/
		for(i in 0...G.BRD_COLS)
		{
			var clearCount:Int = 0;
			var row:Int;
			var currType:Int;
			for(j in 0...G.BRD_ROWS)
			{
				row = G.BRD_ROWS - j - 1;
				currType = getBlockType(i, row);

				// TODO this never happens
				if(currType == BlockType.CLEARED)
				{
					setBlockType(i, row, BlockType.EMPTY);
					clearCount++;
					continue;
				}

				if(clearCount != 0 && currType != BlockType.CLEARED)
				{
					setBlockType(i, row + clearCount, currType);
					setBlockType(i, row, BlockType.EMPTY);
				}
			}
		}
	}

	public function swapBlocks(block1:GameBlock, block2:GameBlock):Void
	{
		var type:Int = block1.type;
		block1.setType(block2.type);
		block2.setType(type);
	}

	private function addCleared(row:Int, lastCol:Int, count:Int, type:Int):Void
	{
		while(count > 0)
		{
			count--;
			_cleared[lastCol - count][row] = type;
			setBlockType(lastCol - count, row, BlockType.CLEARED);
		}
	}

	private function getBlockType(col:Int, row:Int):Int
	{
		if(_blocks[col][row] == null)
			return BlockType.EMPTY;

		return _blocks[col][row].type;
	}

	private function setBlockType(col:Int, row:Int, type:Int):Void
	{
		if(_blocks[col][row] == null)
			return;

		_blocks[col][row].setType(type);
	}

	private function onBlockClicked(block:GameBlock):Void
	{
		onClicked.dispatch(block);
	}
}

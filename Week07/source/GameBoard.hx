package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSignal;
import flixel.util.FlxPool;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;

class GameBoard extends FlxSpriteGroup
{
	public var onGameOver(default, null):FlxSignal;
	public var onClicked(default, null):FlxTypedSignal<GameBlock -> Void>;
	public var onReleased(default, null):FlxTypedSignal<GameBlock -> Void>;
	public var onMouseOut(default, null):FlxTypedSignal<GameBlock -> FlxPoint -> Void>;

	public var onColorMatched(default, null):FlxTypedSignal<Int -> Int -> Void>;
	public var onBlockPaired(default, null):FlxTypedSignal<Int -> Void>;
	public var onCheckRow(default, null):FlxSignal;
	public var onClearComplete(default, null):FlxSignal;

	public var gameOver(default, null):Bool;
	public var sweeps(default, null):Int;

	var _blocks:Array<Array<GameBlock>>;
	var _cleared:Array<Array<Int>>;

	public function new()
	{
		super();

		onGameOver = new FlxSignal();
		onClicked = new FlxTypedSignal<GameBlock -> Void>();
		onReleased = new FlxTypedSignal<GameBlock -> Void>();
		onMouseOut = new FlxTypedSignal<GameBlock -> FlxPoint -> Void>();

		onColorMatched = new FlxTypedSignal<Int -> Int -> Void>();
		onBlockPaired = new FlxTypedSignal<Int -> Void>();
		onCheckRow = new FlxSignal();
		onClearComplete = new FlxSignal();

		_blocks = new Array<Array<GameBlock>>();
		_cleared = new Array<Array<Int>>();

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
				block.setType(BlockType.choose());
				block.setPosition(G.BRD_LEFT + G.BLOCK_PAD / 2 + (G.BLOCK_PAD + G.BLOCK_SIZE) * i, G.BRD_TOP + G.BLOCK_PAD + (G.BLOCK_PAD + G.BLOCK_SIZE) * j);
				block.setIndex(i, j);
				block.onClicked.add(onBlockClicked);
				block.onMouseOut.add(onBlockMouseOut);
				this.add(block);
			}
		}
	}

	public function checkRow(row:Int, dir:Int = -1):Void
	{
		if(row >= G.BRD_ROWS)
			return;

		onCheckRow.dispatch();

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
					_cleared[i][row + dir] == currType ||
					i > 0 && _cleared[i - 1][row] == currType)
			{
				addCleared(row, i, 1, currType);
				onBlockPaired.dispatch(1);

				// check to the left until another type is found.
				var left:Int = i - 1;
				while(left >= 0 && getBlockType(left, row) == currType)
				{
					addCleared(row, left, 1, currType);
					onBlockPaired.dispatch(1);
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
				onColorMatched.dispatch(lastType, typeCount + 1);
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

	public function dropClearedBlocks(dir:Int = -1):Void
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
				if(dir == 1)
					row = G.BRD_ROWS - j - 1;
				else
					row = j;
				currType = getBlockType(i, row);

				if(currType == BlockType.CLEARED)
				{
					setBlockType(i, row, BlockType.EMPTY);
					clearCount += dir;
					continue;
				}

				if(clearCount != 0 && currType != BlockType.CLEARED)
				{
					setBlockType(i, row + clearCount, currType);
					setBlockType(i, row, BlockType.EMPTY);
				}
			}
		}

		onClearComplete.dispatch();
	}

	public function swapBlocks(block1:GameBlock, dir:FlxPoint):Void
	{
		// you can only swap horizontal or vertical
		if(dir.x != 0 && dir.y != 0)
			return;

		var temp:Int;
		var swap:GameBlock = null;
		if(dir.x != 0)
			swap = _blocks[Std.int(FlxMath.bound(block1.col + dir.x, 0, G.BRD_COLS))][block1.row];
		if (dir.y != 0)
			swap = _blocks[block1.col][Std.int(FlxMath.bound(block1.row + dir.y, 0, G.BRD_ROWS))];

		if(swap == null)
			return;

		if(swap.type == BlockType.CLEARED)
			return;

		temp = block1.type;
		block1.setType(swap.type);
		swap.setType(temp);
	}

	public function fillBoard():Void
	{
		for(i in 0...G.BRD_COLS)
		{
			for(j in 0...G.BRD_ROWS)
			{
				if(_blocks[i][j].type == BlockType.EMPTY)
				{
					_blocks[i][j].setType(BlockType.choose());
				}
			}
		}
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

	private function onBlockReleased(block:GameBlock):Void
	{
		onReleased.dispatch(block);
	}

	private function onBlockMouseOut(block:GameBlock, dir:FlxPoint):Void
	{
		onMouseOut.dispatch(block, dir);
	}
}

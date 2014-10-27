package ;

import flixel.FlxG;
import flixel.util.FlxPoint;

class GameInput
{
	var _gameBoard:GameBoard;
	var _blockSelector:BlockSelector;

	public function new(gameBoard:GameBoard, blockSelector:BlockSelector)
	{
		_gameBoard = gameBoard;
		_gameBoard.onClicked.add(onBlockClicked);
		_gameBoard.onMouseOut.add(onBlockMouseOut);

		_blockSelector = blockSelector;
	}

	private function onBlockClicked(block:GameBlock):Void
	{
		_blockSelector.select(block);
	}

	private function onBlockRelease(block:GameBlock):Void
	{
		_blockSelector.clearSelection();
	}

	private function onBlockMouseOut(block:GameBlock, dir:FlxPoint):Void
	{
		if(_blockSelector.selected == null)
			return;

		_gameBoard.swapBlocks(block, dir);
		_blockSelector.clearSelection();
	}
}

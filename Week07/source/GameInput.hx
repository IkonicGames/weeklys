package ;

import flixel.FlxG;

class GameInput
{
	var _gameBoard:GameBoard;
	var _blockSelector:BlockSelector;

	public function new(gameBoard:GameBoard, blockSelector:BlockSelector)
	{
		_gameBoard = gameBoard;
		_gameBoard.onClicked.add(onBlockClicked);

		_blockSelector = blockSelector;
	}

	private function onBlockClicked(block:GameBlock):Void
	{
		if(block == _blockSelector.selected)
		{
			_blockSelector.clearSelection();
			return;
		}

		if(_blockSelector.selected == null)
		{
			_blockSelector.select(block);
			return;
		}

		var selected = _blockSelector.selected;
		var horizontal = (block.col == selected.col - 1 || block.col == selected.col + 1);
		var vertical = (block.row == selected.row - 1 || block.row == selected.row + 1);
		if((!horizontal && vertical) || (horizontal && !vertical))
		{
			_gameBoard.swapBlocks(block, selected);
		}

		_blockSelector.clearSelection();
	}
}

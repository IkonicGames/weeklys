package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSignal;

class Metronome extends FlxSprite
{
	public var onRowComplete:FlxSignal;

	var _gameBoard:GameBoard;

	var _currRow:Int;
	var _iterDir:Int;

	public function new(gameBoard:GameBoard)
	{
		super();

		_gameBoard = gameBoard;
		_currRow = G.BRD_ROWS;
		_iterDir = -1;

		this.makeGraphic(FlxG.width, 3);

		onRowComplete = new FlxSignal();

		this.y = _gameBoard.bottom;

		onMoveComplete();
	}

	private function onMoveComplete(?tween:FlxTween):Void
	{
		_currRow += _iterDir;
		if(_currRow < 0 || _currRow > G.BRD_ROWS)
		{
			_iterDir = -_iterDir;
			_gameBoard.clearCleared();
			_gameBoard.dropClearedBlocks();
			_gameBoard.fillBoard();
		}

		if(_iterDir < 0)
			_gameBoard.checkRow(_currRow, -_iterDir);
		else
			_gameBoard.checkRow(_currRow - 1, -_iterDir);
		var rowY = _gameBoard.top + (G.BLOCK_PAD + G.BLOCK_SIZE) * _currRow;
		FlxTween.linearMotion(this, 0, this.y, 0, rowY, 1, true, {complete:onMoveComplete});
	}
}

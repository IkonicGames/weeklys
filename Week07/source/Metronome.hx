package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSignal;

class Metronome extends FlxSprite
{
	public var onRowComplete:FlxSignal;

	var _gameBoard:GameBoard;
	var _blockQueue:BlockQueue;

	var _currRow:Int;

	public function new(gameBoard:GameBoard, blockQueue:BlockQueue)
	{
		super();

		_gameBoard = gameBoard;
		_blockQueue = blockQueue;
		_currRow = G.BRD_ROWS;

		this.makeGraphic(FlxG.width, 3);

		onRowComplete = new FlxSignal();

		this.y = _gameBoard.bottom;

		onMoveComplete();
	}

	private function onMoveComplete(?tween:FlxTween):Void
	{
		_currRow--;
		if(_currRow < 0)
		{
			_currRow = G.BRD_ROWS;
			_gameBoard.clearCleared();
			_gameBoard.dropClearedBlocks();
			_gameBoard.addBlockRow(_blockQueue.colors);
			_blockQueue.randomizeColors();
			FlxTween.linearMotion(this, 0, this.y, 0, _gameBoard.bottom, 1, true, {complete:onMoveComplete});
			return;
		}

		_gameBoard.checkRow(_currRow);
		var rowY = _gameBoard.top + (G.BLOCK_PAD + G.BLOCK_SIZE) * _currRow;
		FlxTween.linearMotion(this, 0, this.y, 0, rowY, 1, true, {complete:onMoveComplete});
	}
}

package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

class Metronome extends FlxSprite
{
	public var onSweepComplete(default, null):FlxSignal;
	public var sweepsLeft(default, null):Int;

	var _gameBoard:GameBoard;

	var _currRow:Int;

	public function new(gameBoard:GameBoard)
	{
		super();

		_gameBoard = gameBoard;
		_currRow = G.BRD_ROWS;

		onSweepComplete = new FlxSignal();
		sweepsLeft = G.SWEEPS;

		//this.makeGraphic(FlxG.width, 3);
		this.loadGraphic(AssetPaths.metronome__png);
		this.origin.y = -this.height / 2;

		this.x = -18;
		this.y = G.BRD_BOTTOM - this.height / 2;

		var timer = new FlxTimer(0.5, onStartTimer);
		timer.start(0.5, onStartTimer);
	}

	private function onMoveComplete(?tween:FlxTween):Void
	{
		_currRow--;
		if(_currRow < 0)
		{
			_currRow = G.BRD_ROWS;
			_gameBoard.clearCleared();
			_gameBoard.dropClearedBlocks(1);
			_gameBoard.fillBoard();
			sweepsLeft--;
			onSweepComplete.dispatch();
			FlxTween.linearMotion(this,this.x, this.y, this.x, G.BRD_BOTTOM - this.height / 2, 2, true, {complete:onMoveComplete});
			return;
		}

		_gameBoard.checkRow(_currRow, 1);
		var rowY = G.BRD_TOP + (G.BLOCK_PAD + G.BLOCK_SIZE) * _currRow;
		FlxTween.linearMotion(this, this.x, this.y, this.x, rowY - this.height / 2, 1, true, {complete:onMoveComplete});
	}

	private function onStartTimer(?timer:FlxTimer):Void
	{
		onMoveComplete();
	}
}

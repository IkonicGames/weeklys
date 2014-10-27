package ;

import flixel.FlxG;
import flixel.util.FlxSave;

class Score
{
	public static inline var MATCH_3:Int = 100;
	public static inline var MATCH_4:Int = 150;
	public static inline var MATCH_5:Int = 250;
	public static inline var MATCH_6:Int = 500;

	var MATCH:Array<Int> = [100, 150, 250, 500];

	public var score(default, null):Int;
	public var multiplier(default, null):Int;

	public var highScore(get, null):Int;
	private function get_highScore():Int
	{
		if(_save.data.highScore == null || _save.data.highScore == 0)
			_save.data.highScore = 0;

		return _save.data.highScore;
	}

	var _matchCountRow:Map<Int, Int>;
	var _matchCountTotal:Map<Int, Int>;

	var _save:FlxSave;
	var _gameBoard:GameBoard;

	public function new()
	{
		_save = new FlxSave();
		_save.bind("Cubics");

		_matchCountRow = new Map<Int, Int>();
		_matchCountRow.set(BlockType.A, 0);
		_matchCountRow.set(BlockType.B, 0);
		_matchCountRow.set(BlockType.C, 0);

		_matchCountTotal = new Map<Int, Int>();
		_matchCountTotal.set(BlockType.A, 0);
		_matchCountTotal.set(BlockType.B, 0);
		_matchCountTotal.set(BlockType.C, 0);

		multiplier = 1;
		score = 0;
	}

	public function attachToBoard(gameBoard:GameBoard):Void
	{
		_gameBoard = gameBoard;
		_gameBoard.onBlockPaired.add(addMult);
		_gameBoard.onColorMatched.add(scoreMatch);
		_gameBoard.onCheckRow.add(nextRow);
		_gameBoard.onClearComplete.add(doScore);
	}

	public function nextRow():Void
	{
		for(type in _matchCountRow.keys())
		{
			_matchCountTotal.set(type, _matchCountTotal.get(type) + _matchCountRow.get(type));
			_matchCountRow.set(type, 0);
		}
	}

	public function scoreMatch(color:Int, count:Int):Void
	{
		_matchCountRow.set(color, count);
	}

	public function addMult(mult:Int = 1):Void
	{
		multiplier += mult;
	}

	public function clearMult():Void
	{
		multiplier = 1;
	}

	public function doScore():Void
	{
		for(type in _matchCountTotal.keys())
		{
			var total = 0;
			score += MATCH[_matchCountTotal.get(type) - 3] * multiplier;

			_matchCountTotal.set(type, 0);
			_matchCountRow.set(type, 0);
		}

		multiplier = 1;
	}

	public function resetAll():Void
	{
		score = 0;
		multiplier = 1;

		for(type in _matchCountRow.keys())
		{
			_matchCountRow.set(type, 0);
			_matchCountTotal.set(type, 0);
		}
	}

	public function updateHighScore():Void
	{
		if(this.highScore < this.score)
			_save.data.highScore = this.score;
	}
}

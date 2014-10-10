package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class TestBoardState extends FlxState
{
	var _gameInput:GameInput;
	var _gameBoard:GameBoard;
	var _blockSelector:BlockSelector;
	var _metronome:Metronome;
	var _currRow:Int;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		_gameBoard = new GameBoard();
		_blockSelector = new BlockSelector();
		_metronome = new Metronome(_gameBoard);
		_gameInput = new GameInput(_gameBoard, _blockSelector);

		this.add(_gameBoard);
		this.add(_blockSelector);
		this.add(_metronome);

		_currRow = G.BRD_ROWS - 1;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		if(FlxG.keys.justPressed.DOWN)
		{
			var row = randomRow();
			_gameBoard.addBlockRow(row, 0);
		}

		if(FlxG.keys.justPressed.SPACE)
		{
			if(_currRow == 0)
			{
				_gameBoard.clearCleared();
				_gameBoard.dropClearedBlocks();
				_currRow = G.BRD_ROWS - 1;
			}
			_gameBoard.checkRow(_currRow);
			_currRow--;
		}
	}	

	public function randomRow():Array<Int>
	{
		var row:Array<Int> = [];
		for(i in 0...G.BRD_COLS)
		{
			row.push(BlockType.choose());
		}

		return row;
	}
}

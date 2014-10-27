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
class PlayState extends FlxState
{
	var _score:Score;
	var _gameHUD:GameHUD;

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

		FlxG.camera.bgColor = BlockType.BACKGROUND;
		FlxG.camera.fade(BlockType.BACKGROUND, 0.5, true, onFadeInComplete);

		_gameBoard = new GameBoard();
		_blockSelector = new BlockSelector();
		_metronome = new Metronome(_gameBoard);
		_gameInput = new GameInput(_gameBoard, _blockSelector);

		this.add(new GameGrid());
		this.add(_gameBoard);
		this.add(_blockSelector);
		this.add(_metronome);

		_score = new Score();
		_score.attachToBoard(_gameBoard);

		_gameHUD = new GameHUD(_score, _metronome);
		this.openSubState(_gameHUD);
		this.persistentUpdate = true;

		_metronome.active = false;
		_blockSelector.active = false;
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

		if(_metronome.sweepsLeft == 0)
		{
			FlxG.camera.fade(BlockType.BACKGROUND, 0.5, false, onFadeOutComplete);
		}
	}	

	private function onFadeInComplete():Void
	{
		_metronome.active = true;
		_blockSelector.active = true;
	}

	private function onFadeOutComplete():Void
	{
		FlxG.switchState(new GameOverState(_score));
	}
}

package ;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

// TODO changing text size breaks the game.

class GameOverState extends FlxState
{
	var _txtLives:FlxText;
	var _txtPlayAgain:FlxText;

	public function new(deaths:Int)
	{
		super();
		
		_txtLives = new FlxText(FlxG.width / 2, FlxG.height * 0.33, 0, "You Died " + Std.string(deaths) + " times.");
		// _txtLives.size = 16;
		_txtLives.x -= _txtLives.width / 2;
		this.add(_txtLives);

		_txtPlayAgain = new FlxText(FlxG.width / 2, FlxG.height * 0.5, 0, "Press SPACE to Play Again.");
		// _txtPlayAgain.size = 16;
		_txtPlayAgain.x -= _txtPlayAgain.width / 2;
		this.add(_txtPlayAgain);

		FlxG.camera.fade(0, 0.33, true);
	}

	override public function update():Void
	{
		super.update();

		if(FlxG.keys.pressed.SPACE)
			FlxG.switchState(new PlayState());
	}
}

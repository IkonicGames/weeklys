package ;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;

class GameOverSubState extends FlxSubState
{
	var _txtPlayAgain:FlxText;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		_txtPlayAgain = new FlxText(FlxG.width / 2, FlxG.height * 0.8, 0, "Click to Play Again.", 16);
		_txtPlayAgain.x -= _txtPlayAgain.width / 2;
		this.add(_txtPlayAgain);

		super.create();
	}

	override public function update():Void
	{
		super.update();

		if(FlxG.keys.justPressed.ANY)
		{
			G.restartLevels();
			FlxG.switchState(new PlayState());
		}
	}
}

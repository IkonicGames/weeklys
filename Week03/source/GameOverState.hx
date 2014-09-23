package ;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

// TODO changing text size breaks the game.

class GameOverState extends FlxState
{
	var _txtLives:FlxText;
	var _txtPlayAgain:FlxText;

	var _deaths:Int;
	public function new(deaths:Int = 0)
	{
		super();
		
		_deaths = deaths;
	}

	override public function create():Void
	{
		super.create();


		_txtLives = new FlxText(FlxG.width / 2, FlxG.height * 0.33, 0, "You Died " + Std.string(_deaths) + " times.", 16);
		_txtLives.x -= _txtLives.width / 2;
		this.add(_txtLives);

		_txtPlayAgain = new FlxText(FlxG.width / 2, FlxG.height * 0.5, 0, G.TXT_PLAY_AGAIN, 16);
		_txtPlayAgain.x -= _txtPlayAgain.width / 2;
		this.add(_txtPlayAgain);
		
		FlxG.camera.fade(0, 0.33, true);
	}

	override public function update():Void
	{
		super.update();

#if flash
		if(FlxG.keys.pressed.SPACE)
#end
#if mobile
		if(FlxG.touches.getFirst() != null)
#end
			FlxG.switchState(new PlayState());
	}
}

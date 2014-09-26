package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class GameOverState extends FlxState
{
	var _txtScore:FlxText;
	var _txtPlayAgain:FlxText;

	public function new(score:Int)
	{
		super();

		_txtScore = new FlxText(FlxG.width / 2, FlxG.height * 0.2, 0, "Score: " + StringTools.lpad(Std.string(score), "0", 8), 16);
		_txtScore.x -= _txtScore.width / 2;
		this.add(_txtScore);

		_txtPlayAgain = new FlxText(FlxG.width / 2, FlxG.height * 0.8, 0, "Press Any Key to Play Again!!!", 16);
		_txtPlayAgain.x -= _txtPlayAgain.width / 2;
		this.add(_txtPlayAgain);
	}

	override public function create():Void
	{
		super.create();
	}
	
	override public function update():Void
	{
		super.update();

		if(FlxG.keys.justPressed.ANY)
			FlxG.switchState(new PlayState());
	}

}

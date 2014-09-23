package ;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;

class GameOverState extends FlxState
{
	var _gameOverText:FlxText;
	var _txtPlayAgain:FlxText;
	var _txtScore:FlxText;

	var _score:Float;

	public function new(score:Float)
	{
		super();

		_score = score;
	}

	override public function create():Void
	{
		super.create();

		_gameOverText = new FlxText(FlxG.width / 2, 20, 0, "Game Over...");
		_gameOverText.x -= _gameOverText.width / 2;
		this.add(_gameOverText);

#if flash
		_txtPlayAgain = new FlxText(FlxG.width / 2, FlxG.height * 0.75, 0, "Press ANY Key to Play Again!");
#end
#if mobile
		_txtPlayAgain = new FlxText(FlxG.width / 2, FlxG.height * 0.75, 0, "Touch the Screen to Play Again!");
#end
		_txtPlayAgain.x -= _txtPlayAgain.width / 2;
		this.add(_txtPlayAgain);

		var txt:FlxText = new FlxText(FlxG.width / 2, FlxG.height * 0.3, 0, "Time: " + G.getTimeString(_score));
		txt.x -= txt.width / 2;
		this.add(txt);

		if(G.checkHighScore(_score))
		{
			G.setHighScore(_score);
			txt = new FlxText(FlxG.width / 2, FlxG.height / 2, 0, "New Survival Record!");
			txt.x -= txt.width / 2;
			this.add(txt);
		}
		else
		{
			txt = new FlxText(FlxG.width / 2, FlxG.height / 2, 0, "Best Time: " + G.getTimeString(G.getHighScore()));
			txt.x -= txt.width / 2;
			this.add(txt);
		}
	}
	override public function update():Void
	{
		super.update();

#if flash
		if(FlxG.keys.firstPressed() != "")
			FlxG.switchState(new PlayState());
#end

#if mobile
		var touch = FlxG.touches.getFirst();
		if(touch != null && touch.justPressed)
			FlxG.switchState(new PlayState());
#end
	}
}

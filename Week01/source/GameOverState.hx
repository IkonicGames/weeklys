package ;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;

class GameOverState extends FlxState
{
	var _gameOverText:FlxText;
	var _txtPlayAgain:FlxText;
	var _txtScore:FlxText;

	public function new(score:Float)
	{
		super();

		_gameOverText = new FlxText(FlxG.width / 2, 20, 0, "Game Over...");
		_gameOverText.x -= _gameOverText.width / 2;
		this.add(_gameOverText);

		_txtPlayAgain = new FlxText(FlxG.width / 2, FlxG.height * 0.75, 0, "Press ANY Key to Play Again!");
		_txtPlayAgain.x -= _txtPlayAgain.width / 2;
		this.add(_txtPlayAgain);

		var txt:FlxText = new FlxText(FlxG.width / 2, FlxG.height * 0.3, 0, "Score: " + G.getTimeString(score));
		txt.x -= txt.width / 2;
		this.add(txt);

		if(G.checkHighScore(score))
		{
			G.setHighScore(score);
			txt = new FlxText(FlxG.width / 2, FlxG.height / 2, 0, "New High Score!");
			txt.x -= txt.width / 2;
			this.add(txt);
		}
		else
		{
			txt = new FlxText(FlxG.width / 2, FlxG.height / 2, 0, "High Score: " + G.getTimeString(G.getHighScore()));
			txt.x -= txt.width / 2;
			this.add(txt);
		}
	}

	override public function update():Void
	{
		super.update();

		if(FlxG.keys.firstPressed() != "")
			FlxG.switchState(new PlayState());
	}
}

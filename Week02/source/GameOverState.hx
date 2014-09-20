package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class GameOverState extends FlxState
{
	var _txtPlayAgain:FlxText;
	var _txtScore:FlxText;
	var _txtHighScore:FlxText;
	var _txtHighScoreLabel:FlxText;

	var _score:Float;
	
	public function new(score:Float)
	{
		super();

		_score = score;
	}

	override public function create():Void
	{
		super.create();

		_txtPlayAgain = new FlxText(FlxG.width / 2, FlxG.height * 0.7, 0, "Press Any Key to Play Again!!!");
		_txtPlayAgain.x -= _txtPlayAgain.width / 2;
		_txtPlayAgain.color = G.getPlayerColor();
		this.add(_txtPlayAgain);

		_txtScore = new FlxText(FlxG.width / 2, FlxG.height * 0.25, 0, Std.string(Math.floor(_score)));
		_txtScore.x -= _txtScore.width / 2;
		_txtScore.color = G.getPlayerColor();
		this.add(_txtScore);

		var s:String;
		if(G.checkHighScore(_score))
		{
			s = "New High Score!!!";
			G.setHighScore(_score);
		}
		else
		{
			_txtHighScoreLabel = new FlxText(FlxG.width / 2, FlxG.height * 0.45, 0 , "High Score:");
			_txtHighScoreLabel.x -= _txtHighScoreLabel.width / 2;
			_txtHighScoreLabel.color = G.getPlayerColor();
			this.add(_txtHighScoreLabel);

			s = Std.string(Math.floor(G.getHighscore()));
		}
		_txtHighScore = new FlxText(FlxG.width / 2, FlxG.height * 0.5, 0, s);
		_txtHighScore.x -= _txtHighScore.width / 2;
		_txtHighScore.color = G.getPlayerColor();
		this.add(_txtHighScore);
	}

	override public function update():Void
	{
		super.update();

#if (web || flash)
		if(FlxG.keys.justPressed.ANY)
			FlxG.switchState(new PlayState());

#end
#if mobile
		var touch = FlxG.touches.getFirst();
		if(touch != null)
			FlxG.switchState(new PlayState());
#end
	}
}

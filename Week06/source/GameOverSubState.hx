package ;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;

class GameOverSubState extends FlxSubState
{
	var _sprBackground:FlxSprite;

	var _txtScore:FlxText;
	var _txtHighScore:FlxText;
	var _txtNextLevel:FlxText;

	var _highScore:Bool;

	public function new(highScore:Bool)
	{
		super();

		_highScore = highScore;
	}

	override public function create():Void
	{
		_sprBackground = new FlxSprite();
		_sprBackground.scrollFactor.set(0, 0);
		_sprBackground.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		this.add(_sprBackground);
		_sprBackground.alpha = 0;
		FlxTween.tween(_sprBackground, {alpha:0.7}, 0.3);

		_txtScore = new FlxText(FlxG.width / 2, FlxG.height / 3, 0, "Time: " + G.getTimeString(G.lastScore), 16);
		_txtScore.scrollFactor.set(0, 0);
		_txtScore.x -= _txtScore.width / 2;
		this.add(_txtScore);

		var highScore = _highScore ? "New High Score!!!" : "High Score: " + G.getTimeString(G.getHighScore(G.levelNum));
		_txtHighScore = new FlxText(FlxG.width / 2, FlxG.height / 2, 0, highScore);
		_txtHighScore.scrollFactor.set(0, 0);
		_txtHighScore.x -= _txtHighScore.width / 2;
		this.add(_txtHighScore);
		
		_txtNextLevel = new FlxText(FlxG.width / 2, FlxG.height * 0.8, 0, "Click to Play the Next Level.", 16);
		_txtNextLevel.scrollFactor.set(0, 0);
		_txtNextLevel.x -= _txtNextLevel.width / 2;
		this.add(_txtNextLevel);

		super.create();
	}

	override public function update():Void
	{
		super.update();

		if(FlxG.mouse.justPressed)
		{
			FlxG.camera.fade(0x00000, 0.3, false, onCameraFadeComplete);
		}
	}

	private function onCameraFadeComplete():Void
	{
		G.restartLevels();
		FlxG.switchState(new PlayState());
	}
}

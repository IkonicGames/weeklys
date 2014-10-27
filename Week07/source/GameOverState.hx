package ;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIState;

class GameOverState extends FlxUIState
{
	var _score:Score;

	public function new(?score:Score)
	{
		super();

		_score = score;

	}

	override public function create():Void
	{
		_xml_id = "game_over";
		FlxG.camera.fade(BlockType.BACKGROUND, 0.5, true);

		super.create();

		if(_score != null)
		{
			var score = this._ui.getFlxText("label_score_value");
			score.text = StringTools.lpad(Std.string(_score.score), "0", 8);

			var highScore = this._ui.getFlxText("label_high_value");
			highScore.text = StringTools.lpad(Std.string(_score.highScore), "0", 8);

			_score.updateHighScore();
		}
	}

	override public function update():Void
	{
		if(FlxG.mouse.justPressed)
		{
			FlxG.switchState(new PlayState());
		}

		super.update();
	}
}

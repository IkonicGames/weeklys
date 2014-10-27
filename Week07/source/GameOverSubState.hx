package ;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIState;

class GameOvertate extends FlxUIState
{
	var _score:Score;

	public function new(score:Score)
	{
		super();

		_score = score;
	}

	override public function create():Void
	{
		_xml_id = "game_over";

		super.create();
	}
}

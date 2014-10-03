package ;

import flixel.FlxG;
import flixel.FlxState;
import flash.events.Event;

class PauseOnLoadState extends FlxState
{
	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.update();

		FlxG.stage.dispatchEvent(new Event(Event.DEACTIVATE));
	}
}

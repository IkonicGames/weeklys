package ;

import flixel.FlxG;
import flixel.addons.ui.FlxUIState;

class TutorialState extends FlxUIState
{
	public function new()
	{
		super();

		FlxG.camera.bgColor = BlockType.BACKGROUND;
	}

	override public function create():Void
	{
		_xml_id = "tutorial";

		super.create();
	}

	override public function update():Void
	{
		super.update();

		if(FlxG.mouse.justPressed)
			FlxG.camera.fade(BlockType.BACKGROUND, 0.5, false, onFadeComplete);
	}

	private function onFadeComplete():Void
	{
		FlxG.switchState(new PlayState());
	}
}

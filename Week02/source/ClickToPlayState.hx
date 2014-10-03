package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class ClickToPlayState extends FlxState
{
	public static var title:String;
	public static var playState:Class<FlxState>;

	var _txtClick:FlxText;
	var _txtTitle:FlxText;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		_txtTitle = new FlxText(FlxG.width / 2, FlxG.height * 0.3, 0, title, 8);
		_txtTitle.x -= _txtTitle.width / 2;
		this.add(_txtTitle);

		_txtClick = new FlxText(FlxG.width / 2, FlxG.height / 2, 0, "Click To Play", 12);
		_txtClick.x -= _txtClick.width / 2;
		this.add(_txtClick);
	}

	override public function update():Void
	{
		super.update();

		if(FlxG.mouse.justPressed)
			FlxG.switchState(cast Type.createInstance(playState, []));
	}
}

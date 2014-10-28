package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.text.FlxBitmapText;

class ClickToPlayState extends FlxState
{
	public static var title:String;
	public static var playState:Class<FlxState>;

	var _txtClick:FlxBitmapText;
	var _txtTitle:FlxBitmapText;

	public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();

		_txtTitle = new FlxBitmapText(G.FONT);
		_txtTitle.x = FlxG.width / 2;
		_txtTitle.y = FlxG.height / 3;
		_txtTitle.text = title;
		_txtTitle.x -= _txtTitle.width / 2;
		this.add(_txtTitle);

		_txtClick = new FlxBitmapText(G.FONT);
		_txtClick.x = FlxG.width / 2;
		_txtClick.y = FlxG.height / 2;
		_txtClick.text = "Click to Play";
		_txtClick.x -= _txtClick.width / 2;
		this.add(_txtClick);
	}

	override public function update(dt:Float):Void
	{
		super.update(dt);

		if(FlxG.mouse.justPressed)
			FlxG.switchState(cast Type.createInstance(playState, []));
	}
}

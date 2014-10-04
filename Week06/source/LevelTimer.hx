package ;

import flixel.FlxG;
import flixel.text.FlxText;

class LevelTimer extends FlxText
{
	public var elapsed(default, null):Float;

	public function new(?X:Float, ?Y:Float, ?Width:Float, ?Text:String, ?Size:Int)
	{
		super(X, Y, Width, Text, Size);
		
		elapsed = 0;
	}

	override public function update():Void
	{
		super.update();

		elapsed += FlxG.elapsed;

		text = G.getTimeString(elapsed);
	}
}

package ;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

class GameHUD extends FlxGroup
{
	var _txtScore:FlxText;
	var _txtMult:FlxText;

	public function new()
	{
		super();

		_txtScore = new FlxText(FlxG.width / 2, FlxG.height * 0.02, 0, "00000000", 16); 
		_txtScore.x -= _txtScore.width / 2;
		this.add(_txtScore);

		_txtMult = new FlxText(FlxG.width / 2, FlxG.height * 0.08, 0, "x 1", 16);
		_txtMult.x -= _txtMult.width / 2;
		this.add(_txtMult);
	}

	public function setScore(score:Int):Void
	{
		_txtScore.text = StringTools.lpad(Std.string(score), "0", 8);
	}
	
	public function setMult(mult:Int):Void
	{
		_txtMult.text = "x " + Std.string(mult);
	}
}

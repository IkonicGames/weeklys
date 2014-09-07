package ;

import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.text.FlxText;

class HUD extends FlxGroup
{
	var _txtScore:FlxText;
	var _txtMult:FlxText;

	public function new()
	{
		super();

		_txtScore = new FlxText(FlxG.width / 2, FlxG.height * 0.02, 0, "00000000");
		_txtScore.x -= _txtScore.width / 2;
		_txtScore.color = G.getPlayerColor();
		this.add(_txtScore);

		_txtMult = new FlxText(_txtScore.x + _txtScore.width * 1.1, FlxG.height * 0.02, 0, "x 1");
		_txtMult.color = G.getPlayerColor();
		this.add(_txtMult);
	}

	public function setScore(score:Float):Void
	{
		var s = Std.string(Math.floor(score));
		s = StringTools.lpad(s, "0", 8);
		_txtScore.text = s;
	}

	public function setMultiplier(multiplier:Float):Void
	{
		var s = "x " + Std.string(Math.floor(multiplier));
		_txtMult.text = s;
	}
}

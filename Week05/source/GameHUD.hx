package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;

class GameHUD extends FlxGroup
{
	var _txtScore:FlxText;
	var _txtMult:FlxText;

	var _healthBar:FlxSprite;

	public function new()
	{
		super();

		_txtScore = new FlxText(FlxG.width / 2, FlxG.height * 0.02, 0, "00000000", 16); 
		_txtScore.x -= _txtScore.width / 2;
		this.add(_txtScore);

		_txtMult = new FlxText(FlxG.width / 2, FlxG.height * 0.08, 0, "x 1", 16);
		_txtMult.x -= _txtMult.width / 2;
		this.add(_txtMult);

		_healthBar = new FlxSprite(FlxG.width * 0.1, FlxG.height * 0.9);
		_healthBar.makeGraphic(Std.int(FlxG.width * 0.8), Std.int(FlxG.height * 0.02));
		this.add(_healthBar);
	}

	public function setScore(score:Int):Void
	{
		_txtScore.text = StringTools.lpad(Std.string(score), "0", 8);
	}
	
	public function setMult(mult:Int):Void
	{
		_txtMult.text = "x " + Std.string(mult);
	}

	public function setHealthPct(pct:Float):Void
	{
		_healthBar.scale.x = FlxMath.bound(pct, 0, 1);
	}
}

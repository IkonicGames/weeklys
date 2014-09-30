package ;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

class Directions extends FlxGroup
{
	var _txtYouAre:FlxText;
	var _txtBirdies:FlxText;
	var _txtBombs:FlxText;
	var _txtMove:FlxText;

	public function new()
	{
		super();

		_txtYouAre = new FlxText(FlxG.width / 2, FlxG.height / 3, 0, "Super Mega Giant Worm!!!", 16);
		_txtYouAre.x -= _txtYouAre.width / 2;
		this.add(_txtYouAre);

		_txtBirdies = new FlxText(FlxG.width / 2, FlxG.height * 0.5, 0, "MMMM Birds!!!", 12);
		_txtBirdies.x -= _txtBirdies.width / 2;
		this.add(_txtBirdies);

		_txtBombs = new FlxText(FlxG.width / 2, FlxG.height * 0.6, 0, "Boo Bombs!!!", 12);
		_txtBombs.x -= _txtBombs.width / 2;
		this.add(_txtBombs);

		_txtMove = new FlxText(FlxG.width / 2, FlxG.height * 0.7, 0, "Yay Moving!!!  LEFT/A and RIGHT/D", 16);
		_txtMove.x -= _txtMove.width / 2;
		this.add(_txtMove);
	}

	override public function update():Void
	{
		super.update();

		if(FlxG.keys.justPressed.ANY)
			FlxG.state.remove(this);
	}
}

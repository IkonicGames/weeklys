package ;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

class GameHUD extends FlxGroup
{
	public var levelTimer(default, null):LevelTimer;
	var _txtLevelNum:FlxText;

	public function new()
	{
		super();

		_txtLevelNum = new FlxText(10, 10, 0, "Level - " + Std.string(G.levelNum + 1), 16);
		this.add(_txtLevelNum);

		levelTimer = new LevelTimer(10, _txtLevelNum.height + 20, 0 , "Time - 0:00", 16);
		this.add(levelTimer);
	}
}

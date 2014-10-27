package ;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUISubState;
import flash.geom.Rectangle;

class GameHUD extends FlxUISubState
{
	var _score:Score;
	var _metronome:Metronome;

	var _txtScore:FlxText;
	var _txtMult:FlxText;
	var _txtSweeps:FlxText;

	public function new(score:Score, metronome:Metronome)
	{
		super();

		_score = score;
		_metronome = metronome;
		_metronome.onSweepComplete.add(onSweepComplete);
	}

	override public function create():Void
	{
		_xml_id = "game_hud";

		super.create();

		_txtScore = this._ui.getFlxText("label_score_value");
		_txtMult = this._ui.getFlxText("label_mult_value");
		_txtSweeps = this._ui.getFlxText("label_sweeps_value");
		_txtSweeps.text = Std.string(G.SWEEPS);
	}

	override public function update():Void
	{
		super.update();

		_txtScore.text = StringTools.lpad(Std.string(_score.score), "0", 8);
		_txtMult.text = "x" + Std.string(_score.multiplier);
	}

	private function onSweepComplete():Void
	{
		_txtSweeps.text = Std.string(_metronome.sweepsLeft);
	}
}

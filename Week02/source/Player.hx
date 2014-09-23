package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.system.FlxSound;

using flixel.util.FlxSpriteUtil;

class Player extends FlxSprite
{
	var _moveDir:Float;
	var _sndExplode:FlxSound;

	public function new()
	{
		super();

		this.loadGraphic(AssetPaths.Player__png);
		this.color = G.getPlayerColor();

		_sndExplode = G.loadSound(AssetPaths.Explosion1__mp3);
	}

	override public function update():Void
	{
		super.update();

		updateInput();
		updateMovement();
	}

	override public function kill():Void
	{
		super.kill();
		_sndExplode.play();
	}

	private function updateInput():Void
	{
		_moveDir = 0;

#if (web || flash)
		if(FlxG.keys.anyPressed(["A", "LEFT"])) _moveDir -= 1;
		if(FlxG.keys.anyPressed(["D", "RIGHT"])) _moveDir += 1;
#end

#if mobile
		var touch = FlxG.touches.getFirst();
		if(touch != null)
		{
			if(touch.screenX < FlxG.width / 2) _moveDir -= 1;
			if(touch.screenX > FlxG.width / 2) _moveDir += 1;
		}

#end
	}

	private function updateMovement():Void
	{
		this.velocity.x = _moveDir * G.PLAYER_SPEED;
		this.bound(0, FlxG.width, 0, FlxG.height);
	}
}

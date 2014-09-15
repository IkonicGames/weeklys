package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.system.FlxSound;
import flixel.util.FlxMath;

class Player extends FlxSprite
{
	var _sndJump:FlxSound;
	var _sndLand:FlxSound;

	public function new() {
		super();

		this.makeGraphic(8, 12);

		_sndJump = FlxG.sound.load(AssetPaths.jump__mp3);
		_sndLand = FlxG.sound.load(AssetPaths.land__mp3);

		this.health = 0;
		this.elasticity = 0;
		this.acceleration.y = G.GRAVITY;
		this.velocity.x = G.PLAYER_SPEED;
	}

	override public function update():Void
	{
		if(FlxG.keys.pressed.SPACE && this.isTouching(FlxObject.FLOOR))
		{
			this.velocity.y = G.PLAYER_JUMP;
			_sndJump.play();
		}

		if(this.justTouched(FlxObject.FLOOR))
			_sndLand.play();

		if(!this.isTouching(FlxObject.FLOOR))
			this.angle = FlxMath.lerp(-G.PLAYER_JUMP_ANGLE, G.PLAYER_JUMP_ANGLE, this.velocity.y / G.PLAYER_JUMP);
		else
			this.angle = 0;

		super.update();
	}

	override public function reset(X, Y):Void
	{
		super.reset(X, Y);

		this.acceleration.y = G.GRAVITY;
		this.velocity.x = G.PLAYER_SPEED;
	}
}

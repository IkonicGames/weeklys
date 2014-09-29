package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxVector;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.addons.effects.FlxTrail;
import flixel.system.FlxSound;

class Player extends FlxSprite
{
	public var score:Int;

	var _tail:FlxTrail;
	
	var _sndLand:FlxSound;
	var _sndJump:FlxSound;

	var _moveDir:FlxVector;
	var _inputDir:Float;
	var _inGround:Bool;
	public var inGround(get_inGround, null):Bool;
	private function get_inGround():Bool
	{
		return _inGround;
	}

	public function new()
	{
		super();

		this.health = G.PLR_HEALTH_START;

		_inGround = true;
		_moveDir = new FlxVector();

		this.velocity.y = 1;
		this.elasticity = G.PLR_ELACTICIY;

		this.makeGraphic(24, 24, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawCircle(this, -1, -1, -1, FlxColor.WHITE);

		_tail = new FlxTrail(this, null, 15, 3, 1, 0);
		FlxG.state.add(_tail);

		_sndJump = FlxG.sound.load(AssetPaths.Land__mp3);
		_sndLand = FlxG.sound.load(AssetPaths.Jump__mp3);
	}

	override public function update():Void
	{
		super.update();

		updateInput();
		updateMovement();

		this.health -= G.PLR_HEALTH_DECAY * FlxG.elapsed;
		if(this.health <= 0)
			this.kill();
	}

	private function updateMovement():Void
	{
		if(_inGround)
		{
			_moveDir.set(this.velocity.x, this.velocity.y);
			_moveDir.rotateByDegrees(_inputDir * G.PLR_GRND_ROT_SPEED * FlxG.elapsed);
			if(_moveDir.length > G.PLR_MAX_SPEED)
				_moveDir.length = G.PLR_MAX_SPEED;
			this.velocity.set(_moveDir.x, _moveDir.y);

			_moveDir.normalize();
			_moveDir.scale(G.PLR_GRND_ACCEL);

			this.acceleration.set(_moveDir.x, _moveDir.y);
		}
		else
		{
			this.acceleration.set(0, G.PLR_AIR_GRAVITY);
		}
		_inGround = false;

		this.angle = FlxAngle.asDegrees(Math.atan2(-this.velocity.x, this.velocity.y));

	}

	private function updateInput():Void
	{
		_inputDir = 0;
		if(FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT)
			_inputDir -= 1;
		if(FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT)
			_inputDir += 1;
	}

	public function setInGround():Void
	{
		_inGround = true;
	}

	public function addHealth(add:Float):Void
	{
		this.health += add;
		this.health = FlxMath.bound(this.health, 0, G.PLR_HEALTH_START);
	}

	override public function hurt(Damage:Float):Void
	{
		super.hurt(Damage);

		FlxG.camera.flash(FlxColor.RED, 0.05);
	}
}

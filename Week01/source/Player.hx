package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxVector;
import flixel.util.FlxMath;
import flixel.effects.particles.FlxEmitter;

class Player extends FlxSprite
{
	var _up:Bool = false;
	var _down:Bool = false;
	var _left:Bool = false;
	var _right:Bool = false;

	var _moveDir:FlxVector;
	var _moveVel:FlxVector;

	var _emitter:FlxEmitter;

	public var emitter(get_emitter, null):FlxEmitter;
	private function get_emitter():FlxEmitter
	{
		return _emitter;
	}

	public function new()
	{
		super();

		this.loadGraphic(AssetPaths.Player__png);

		_moveDir = new FlxVector();
		_moveVel = new FlxVector();

		this.maxVelocity.set(G.PLAYER_MAX_SPEED, G.PLAYER_MAX_SPEED);
		this.drag.set(G.PLAYER_DRAG, G.PLAYER_DRAG);

		_emitter = new FlxEmitter();
		_emitter.makeParticles(AssetPaths.pixels__png, 50);
		_emitter.setXSpeed(-10, 10);
		_emitter.setYSpeed(-10, 10);
		_emitter.start(false, 1, 0.01, 0, 0.2);
	}


	override public function update():Void
	{
		super.update();

		updateInput();
		updateMovement();
		checkBounds();

		_emitter.at(this);
	}

	private function updateMovement():Void
	{
		_moveDir.set(0, 0);

		if(_up)
			_moveDir.y -=1;
		if(_down)
			_moveDir.y += 1;
		if(_left)
			_moveDir.x -= 1;
		if(_right)
			_moveDir.x += 1;

		if(_moveDir.x != 0 && _moveDir.y != 0)
			_moveDir.normalize();

		this.acceleration.x = _moveDir.x * G.PLAYER_ACCEL;
		this.acceleration.y = _moveDir.y * G.PLAYER_ACCEL;

		_moveVel.set(this.velocity.x, this.velocity.y);
		if(_moveVel.length > G.PLAYER_MAX_SPEED)
		{
			_moveVel.length = G.PLAYER_MAX_SPEED;
			this.velocity.set(_moveVel.x, _moveVel.y);
		}
	}

	private function updateInput():Void
	{
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
	}

	private function checkBounds():Void
	{
		if(this.x < 0 || this.x > FlxG.width)
			this.velocity.x = -this.velocity.x;
		if(this.y < 0 || this.y > FlxG.height)
			this.velocity.y = -this.velocity.y;

		this.x = FlxMath.bound(this.x, 0, FlxG.width);
		this.y = FlxMath.bound(this.y, 0, FlxG.height);
	}
}

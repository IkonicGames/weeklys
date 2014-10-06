package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.system.FlxSound;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxVector;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import flixel.util.FlxAngle;
import flixel.util.FlxSpriteUtil;
import flixel.addons.display.shapes.FlxShapeLine;

enum PlayerState {
	Stationary;
	Jumping;
	Grappling;
}

class Player extends FlxSprite
{
	public var grapplingHook(default, null):FlxSprite;

	var _currState:PlayerState;

	var _vel:FlxVector;

	var _grpGrapple:FlxTypedGroup<FlxTilemap>;
	var _grappleLine:FlxShapeLine;
	var _grapplePoint:FlxPoint;
	var _grappleVec:FlxVector;
	var _currRatio:Float;

	var _sndJump:FlxSound;
	var _sndLand:FlxSound;
	var _sndGrappleOn:FlxSound;
	var _sndGrappleOff:FlxSound;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);

		this.makeGraphic(16, 16);

		_currState = PlayerState.Jumping;

		_grpGrapple = new FlxTypedGroup<FlxTilemap>();
		_grapplePoint = FlxPoint.get();
		_grappleVec = FlxVector.get();

		_vel = new FlxVector();
		this.acceleration.y = G.GRAVITY;

		grapplingHook = new FlxSprite(x, y, AssetPaths.GrapplingHook__png);
		grapplingHook.visible = false;

		_sndJump = FlxG.sound.load(AssetPaths.Jump__mp3);
		_sndLand = FlxG.sound.load(AssetPaths.Land__mp3);
		_sndGrappleOn = FlxG.sound.load(AssetPaths.GrappleOn__mp3);
		_sndGrappleOff = FlxG.sound.load(AssetPaths.GrappleOff__mp3);
	}

	override public function update():Void
	{
		this.acceleration.set(0, G.GRAVITY);

		switch(_currState){
			case PlayerState.Stationary:
				if(FlxG.mouse.justPressed && this.isTouching(FlxObject.FLOOR))
				{
					_vel.set(FlxG.mouse.x - this.x, FlxG.mouse.y - this.y);
					_vel = _vel.normalize();
					_vel.length = G.PLR_JUMP;

					this.velocity.set(_vel.x, _vel.y);

					_currState = PlayerState.Jumping;

					_sndJump.play();
				}

			case PlayerState.Jumping:
				if(this.isTouching(FlxObject.FLOOR))
				{
					_currState = PlayerState.Stationary;
					this.velocity.x = 0;
					_sndLand.play();
				}
				else if(FlxG.mouse.justPressed)
				{
					_grapplePoint.set(FlxG.mouse.x, FlxG.mouse.y);
					var len = FlxMath.distanceToPoint(this, _grapplePoint);
					if(len < G.GRPL_LENGTH + G.GRPL_LENGTH_RANGE)
					{
						_grpGrapple.forEachOfType(FlxTilemap, function(tilemap:FlxTilemap):Void {
							if(tilemap.overlapsPoint(FlxG.mouse))
							{
								_currState = PlayerState.Grappling;
								_currRatio = (len - G.GRPL_LENGTH) / G.GRPL_LENGTH_RANGE;

								_sndGrappleOn.play();
							}
						});
					}
				}

			case PlayerState.Grappling:
				if(FlxG.mouse.justReleased || this.isTouching(FlxObject.FLOOR))
				{
					_currState = PlayerState.Jumping;
					_sndGrappleOff.play();
				}
				else
				{
					updateGrapplingConstraint();
				}
		}

		super.update();

		FlxSpriteUtil.bound(this, FlxG.worldBounds.x, FlxG.worldBounds.width, FlxG.worldBounds.y, FlxG.worldBounds.height);
		updateGrapplingHook();
	}

	private function updateGrapplingConstraint():Void
	{
		// Do distance constraint.
		// hacked together from wildbunny
		// http://www.wildbunny.co.uk/blog/2011/04/06/physics-engines-for-dummies/
		var len = FlxMath.distanceToPoint(this, _grapplePoint);
		if(len > G.GRPL_LENGTH)
		{
			_currRatio = FlxMath.bound(_currRatio - FlxG.elapsed * G.GRPL_LERP, 0, 1);
			var currLength = FlxMath.lerp(G.GRPL_LENGTH, G.GRPL_LENGTH + G.GRPL_LENGTH_RANGE, _currRatio);

			var mid = this.getMidpoint();
			_grappleVec.set(mid.x - _grapplePoint.x, mid.y - _grapplePoint.y);
			var unit = _grappleVec.normalize();

			// calculate and remove from velocity with and 'impulse'
			var vel = FlxVector.get(this.velocity.x, this.velocity.y);
			var relVel = vel.dotProduct(unit);
			var relDist = len - currLength;
			var remove = relVel + relDist / FlxG.elapsed;
			FlxVelocity.accelerateTowardsPoint(this, _grapplePoint, remove, 5000, 5000);
			this.acceleration.y += G.GRAVITY;

			/* angle velocity along tangent.  There is no adjustment for how
			   much vel should have been lost due to the edge of the constraint 
			   so the player will always accelerate on the swing.

			   TODO: velocity should be reduced at sharp angles
			*/
			var speed = vel.length * G.GRPL_VEL_MULT;
			var rl = vel.degreesBetween(unit.leftNormal());
			var rr = vel.degreesBetween(unit.rightNormal());
			var norm:FlxVector;
			if(rl < rr)
				norm = unit.leftNormal();
			else
				norm = unit.rightNormal();
			this.velocity.set(norm.x * speed, norm.y * speed);

			// Move the player within the constraint.
			var diff = len - currLength;
			unit = unit.negate();
			this.x += unit.x * diff;
			this.y += unit.y * diff;

		}
	}

	private function updateGrapplingHook():Void
	{
		if(_currState != PlayerState.Grappling)
		{
			grapplingHook.visible = false;
			return;
		}

		grapplingHook.visible = true;
		grapplingHook.x = _grapplePoint.x + (x - _grapplePoint.x) / 2;
		grapplingHook.y = _grapplePoint.y + (y - _grapplePoint.y) / 2;
		grapplingHook.angle = FlxAngle.angleBetweenPoint(this, _grapplePoint, true);

		var dist = FlxMath.distanceToPoint(this, _grapplePoint);
		grapplingHook.scale.x = dist / 16;
	}

	public function setGrappleGroup(grp:FlxTypedGroup<FlxTilemap>):Void
	{
		_grpGrapple = grp;
	}
}

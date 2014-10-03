package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxVector;
import flixel.util.FlxVelocity;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import flixel.util.FlxAngle;

enum PlayerState {
	Stationary;
	Jumping;
	Grappling;
}

class Player extends FlxSprite
{
	var _currState:PlayerState;

	var _vel:FlxVector;
	var _grappleObjects:List<FlxObject>;
	var _grapplePoint:FlxPoint;
	var _grappleVec:FlxVector;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);

		this.makeGraphic(8, 8);

		_currState = PlayerState.Jumping;

		_grappleObjects = new List<FlxObject>();
		_grapplePoint = FlxPoint.get();
		_grappleVec = FlxVector.get();

		_vel = new FlxVector();
		this.acceleration.y = G.GRAVITY;

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
				}

			case PlayerState.Jumping:
				if(this.isTouching(FlxObject.FLOOR))
				{
					_currState = PlayerState.Stationary;
					this.velocity.x = 0;
				}
				else if(FlxG.mouse.justPressed)
				{
					for(obj in _grappleObjects)
					{
						if(obj.overlapsPoint(FlxG.mouse))
						{
							_currState = PlayerState.Grappling;
							_grapplePoint = FlxG.mouse;
						}
					}
				}

			case PlayerState.Grappling:
				if(FlxG.mouse.justReleased || this.isTouching(FlxObject.FLOOR))
				{
					_currState = PlayerState.Jumping;
				}
				else
				{
					// Do distance constraint.
					// hacked together from wildbunny
					// http://www.wildbunny.co.uk/blog/2011/04/06/physics-engines-for-dummies/
					var dist = FlxMath.distanceToPoint(this, _grapplePoint);
					if(dist > G.GRPL_LENGTH)
					{
						var mid = this.getMidpoint();
						_grappleVec.set(mid.x - _grapplePoint.x, mid.y - _grapplePoint.y);
						var unit = _grappleVec.normalize();

						// calculate and remove from velocity with and 'impulse'
						var vel = FlxVector.get(this.velocity.x, this.velocity.y);
						var relVel = vel.dotProduct(unit);
						var relDist = dist - G.GRPL_LENGTH;
						var remove = relVel + relDist / FlxG.elapsed;
						FlxVelocity.accelerateTowardsPoint(this, _grapplePoint, remove, 5000, 5000);
						this.acceleration.y += G.GRAVITY;

						/* angle velocity along tangent.  There is no adjustment for how
						   much vel should have been lost due to the edge of the constraint 
						   so the player will always accelerate on the swing.

						   TODO: velocity should be reduced at sharp angles
						*/
						var speed = vel.length;
						var rl = vel.degreesBetween(unit.leftNormal());
						var rr = vel.degreesBetween(unit.rightNormal());
						var norm:FlxVector;
						if(rl < rr)
							norm = unit.leftNormal();
						else
							norm = unit.rightNormal();
						this.velocity.set(norm.x * speed, norm.y * speed);

						// Move the player within the constraint.
						var diff = dist - G.GRPL_LENGTH;
						unit = unit.negate();
						this.x += unit.x * diff;
						this.y += unit.y * diff;
					}
				}
		}

		super.update();
	}

	public function addGrappleObject(obj:FlxObject):Void
	{
		_grappleObjects.add(obj);
	}
}

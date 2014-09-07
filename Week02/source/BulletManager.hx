package ;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

class BulletManager extends FlxSpriteGroup
{
	var _tmrShot:FlxTimer;
	var _sndShoot:FlxSound;

	public function new()
	{
		super();

		_tmrShot = new FlxTimer(G.PLAYER_SHOOT_TIMER);
		this.maxSize = G.BULLET_MAX_COUNT;

		_sndShoot = FlxG.sound.load(AssetPaths.Laser_Shoot__mp3);
	}

	override public function update():Void
	{
		super.update();

		checkOnScreen();
	}

	public function fireBullet(X:Float, Y:Float):Void
	{
		if(!_tmrShot.finished || this.countLiving() == this.maxSize)
			return;

		var bullet = this.getFirstDead();
		if(bullet == null)
			bullet = createBullet();

		bullet.x = X - bullet.width / 2;
		bullet.y = Y;
		bullet.velocity.y = -G.BULLET_SPEED;
		bullet.velocity.x = 0;
		bullet.revive();

		_tmrShot.reset();
		_sndShoot.play(true);
	}

	private function createBullet():FlxSprite
	{
		var bullet:FlxSprite = new FlxSprite();
		bullet.makeGraphic(4, 8);
		bullet.velocity.y = -G.BULLET_SPEED;
		bullet.color = G.getPlayerColor();
		this.add(bullet);

		return bullet;
	}

	private function checkOnScreen():Void
	{
		this.forEachAlive(function(bullet:FlxSprite):Void {
			if(!bullet.isOnScreen())
				bullet.kill();
		});
	}


}

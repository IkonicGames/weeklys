package ;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxMath;

class EnemyManager extends FlxSpriteGroup
{
	var _tmrSpawn:FlxTimer;
	var _elapsed:Float;

	public function new()
	{
		super();

		_tmrSpawn = new FlxTimer();
		_tmrSpawn.start(G.ENEMY_SPAWN_TIME_MAX, spawnEnemy);

		_elapsed = 0;
	}

	override public function update():Void
	{
		super.update();

		checkOnScreen();
		_elapsed += FlxG.elapsed;
	}


	private function spawnEnemy(timer:FlxTimer):Void
	{
		var enemy = this.getFirstDead();
		if(enemy == null)
		{
			enemy = new FlxSprite();
			enemy.loadGraphic(AssetPaths.Enemy__png, true, 8, 8);
		}

		enemy.revive();
		enemy.animation.randomFrame();
		enemy.health = G.ENEMY_HEALTH_START;
		enemy.color = G.getEnemyColor();
		enemy.y = -16;
		enemy.x = FlxRandom.float() * FlxG.width;
		enemy.velocity.y = G.ENEMY_SPEED_Y;
		enemy.velocity.x = FlxRandom.floatRanged(-G.ENEMY_SPEED_X, G.ENEMY_SPEED_X);
		enemy.elasticity = G.ENEMY_ELASTICITY;
		FlxSpriteUtil.bound(enemy, 0, FlxG.width);

		this.add(enemy);

		var t = FlxMath.bound(1 - _elapsed / G.ENEMY_SPAWN_TIME_TO_MIN, 0, 1);
		_tmrSpawn.reset(FlxMath.lerp(G.ENEMY_SPAWN_TIME_MIN, G.ENEMY_SPAWN_TIME_MAX, t));
	}

	private function checkOnScreen():Void
	{
		this.forEachAlive(function(enemy:FlxSprite):Void {
			if(enemy.y > FlxG.height || enemy.y < -enemy.health * 2)
				enemy.kill();
			if(enemy.x < 0 || enemy.x + enemy.width > FlxG.width)
				enemy.velocity.x = -enemy.velocity.x;
		});
	}
}

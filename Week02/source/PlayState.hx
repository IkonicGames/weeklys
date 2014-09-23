package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flash.events.Event;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var _player:Player;
	var _bulletManager:BulletManager;
	var _enemyMgr:EnemyManager;
	var _enemyExplosions:EnemyExplosions;

	var _sndBulletHit:FlxSound;

	var _hud:HUD;
	var _score:Float;
	var _multiplier:Float;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		G.initPallet();

		FlxG.camera.bgColor = G.getBackgroundColor();

		_player = new Player();
		_player.x = FlxG.width / 2;
		_player.y = FlxG.height * 0.9;
		this.add(_player);

		_bulletManager = new BulletManager();
		this.add(_bulletManager);

		_enemyMgr = new EnemyManager();
		this.add(_enemyMgr);

		_enemyExplosions = new EnemyExplosions();
		this.add(_enemyExplosions);

		_hud = new HUD();
		this.add(_hud);
		_score = 0;
		_multiplier = 1;

		_sndBulletHit = G.loadSound(AssetPaths.Hit_Hurt__mp3);

		FlxG.camera.fade(G.getBackgroundColor(), 1, true);
#if flash
		FlxG.stage.dispatchEvent(new Event(Event.DEACTIVATE));
#end
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		FlxG.collide(_bulletManager, _enemyMgr, onBulletHit);
		FlxG.collide(_player, _enemyMgr, onPlayerHit);
		
		if(_player.alive)
		{
			_bulletManager.fireBullet(_player.getMidpoint().x, _player.y);
			_score += FlxG.elapsed * _multiplier;
			_hud.setScore(_score);
		}
	}	

	private function onBulletHit(bullet:FlxObject, enemy:FlxObject):Void
	{
		bullet.kill();
		enemy.hurt(G.BULLET_DAMAGE);
		if(!enemy.alive)
		{
			_enemyExplosions.explodeAt(enemy);
			_score += G.ENEMY_POINTS * _multiplier;
			_multiplier += 1;
			_hud.setScore(_score);
			_hud.setMultiplier(_multiplier);
		}
		else
			_sndBulletHit.play(true);
	}

	private function onPlayerHit(player:FlxObject, enemy:FlxObject):Void
	{
		player.kill();
		FlxG.camera.fade(G.getBackgroundColor(), 1, false, onFadeOut);
		FlxG.camera.shake(0.05, 0.25);

		_enemyExplosions.explodeAt(_player, false);
	}

	private function onFadeOut():Void
	{
		FlxG.switchState(new GameOverState(_score));
	}
}

package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxRect;
import flixel.util.FlxTimer;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.text.FlxText;
import flixel.effects.particles.FlxEmitterExt;
import flixel.util.FlxSave;
import flixel.util.FlxDestroyUtil;
import flixel.system.FlxSound;
import flash.events.Event;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var _player:Player;
	var _grpEnemy:FlxTypedGroup<Enemy>;

	var _enemySpawnRect:FlxRect;
	var _enemySpawnTimer:FlxTimer;

	var _txtDirections:FlxText;

	var _lifeTime:Float;
	var _txtTime:FlxText;

	var _emitter:FlxEmitterExt;

	var _sndGameOver:FlxSound;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		_enemySpawnRect = FlxRect.get(-20, -20, FlxG.width + 40, FlxG.height + 40);
		_grpEnemy = new FlxTypedGroup<Enemy>();
		this.add(_grpEnemy);
		addPlayer();

		_enemySpawnTimer = new FlxTimer(5, addEnemy);
		addEnemy();

#if flash
		_txtDirections = new FlxText(FlxG.width / 2, FlxG.height * 0.75, 0, "WASD or Arrows to move.");
#end
#if mobile
		_txtDirections = new FlxText(FlxG.width / 2, FlxG.height * 0.75, 0, "Slide your finger on the screen to move.");
#end
		_txtDirections.x -= _txtDirections.width / 2;
		this.add(_txtDirections);

		_lifeTime = 0;
		_txtTime = new FlxText(FlxG.width / 2, FlxG.height * 0.05, 0, "0:00");
		_txtTime.x -= _txtTime.width / 2;
		this.add(_txtTime);

		_emitter = new FlxEmitterExt();
		_emitter.setXSpeed(-100, 100);
		_emitter.setYSpeed(-100, 100);
		_emitter.makeParticles(AssetPaths.pixels__png,100, 0, true, 0);
		this.add(_emitter);

#if flash
		_sndGameOver = FlxG.sound.load(AssetPaths.PlayerDied__mp3);
#end
#if mobile
		_sndGameOver = FlxG.sound.load(AssetPaths.PlayerDied__wav);
#end

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

		FlxDestroyUtil.destroy(_player);
		FlxDestroyUtil.destroy(_grpEnemy);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		_grpEnemy.forEach(function(e:Enemy):Void {
			if(!_enemySpawnRect.containsFlxPoint(FlxPoint.get(e.x, e.y)))
				resetEnemy(e);
		});

#if flash
		if(FlxG.keys.firstJustPressed() != "" && _txtDirections.alive)
#end
#if mobile
		if(FlxG.touches.getFirst() != null && _txtDirections.alive)
#end
			this.remove(_txtDirections);

		if(_player.alive)
		{
			FlxG.collide(_player, _grpEnemy, onPlayerCollide);
			_lifeTime += FlxG.elapsed;
			_txtTime.text = G.getTimeString(_lifeTime);
		}
	}	

	private function addPlayer():Void
	{
		_player = new Player();
		_player.x = FlxG.width / 2;
		_player.y = FlxG.height / 2;
		this.add(_player);
		this.add(_player.emitter);
	}

	private function addEnemy(?timer:FlxTimer):Void
	{
		var e:Enemy = new Enemy();
		_grpEnemy.add(e);
		resetEnemy(e);

		_enemySpawnTimer.reset(5);
	}

	private function resetEnemy(e:Enemy):Void
	{
		var lr = FlxRandom.chanceRoll(50);
		if(lr)
		{
			var l = FlxRandom.chanceRoll(50);
			e.y = FlxRandom.floatRanged(0, FlxG.height);
			if(l)
				e.x = -16;
			else
				e.x = FlxG.width + 15;
		}
		else
		{
			var t = FlxRandom.chanceRoll(50);
			e.x = FlxRandom.floatRanged(0, FlxG.width);
			if(t)
				e.y = -16; 
			else
				e.y = FlxG.height + 15;
		}
		e.setVelocity();
	}

	private function onPlayerCollide(p:FlxObject, coll:FlxObject):Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 1, false, onFadeOutComplete);

		_player.kill();
		this.remove(_player.emitter);
		this.remove(_player);

		_emitter.at(_player);
		_emitter.start(true, 2, 0, 100, 2);

		_sndGameOver.play();
	}

	private function onFadeOutComplete():Void
	{
		FlxG.switchState(new GameOverState(_lifeTime));
	}
}

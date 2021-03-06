package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxPool;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxMath;

class Explosions extends FlxGroup
{

	var _emitters:FlxPool<FlxEmitter>;
	var _poppers:FlxPool<FlxEmitter>;

	var _sndExplosions:FlxSound;

	var _player:Player;

	public function new(player:Player) 
	{
		super();

		_emitters = new FlxPool<FlxEmitter>(FlxEmitter);
		_poppers = new FlxPool<FlxEmitter>(FlxEmitter);

		_sndExplosions = FlxG.sound.load(AssetPaths.Explosion__mp3);

		_player = player;
	}

	override public function update(dt:Float):Void
	{
		super.update(dt);

		this.forEachOfType(FlxEmitter, function(emitter:FlxEmitter):Void {
			if(!emitter.members[0].active)
			{
				emitter.kill();
				_emitters.put(emitter);
			}
		});

		this.forEachOfType(FlxEmitter, function(popper:FlxEmitter):Void {
			if(!popper.members[0].active)
			{
				popper.kill();
				_poppers.put(popper);
			}
		});
	}

	public function explodeAt(sprite:FlxSprite, type:ExplType):Void
	{
		var emitter = getEmitter();
		emitter.setPosition(sprite.x, sprite.y);
		emitter.start(true, G.BOMB_EXPLOSION_LIFE);

		var popper = getPopper();
		popper.setPosition(sprite.x, sprite.y);
		popper.start(true, G.BOMB_EXPLOSION_LIFE / 2);

		if(type == ExplType.Bomb)
		{
			FlxG.camera.shake(0.01, 0.1);
		}

		_sndExplosions.play(true);

		// Damage player.
		var dist = FlxMath.distanceBetween(_player, sprite);
		if(dist < G.BOMB_EXPLOSION_SIZE)
		{
			var ratio = 1 - (dist / G.BOMB_EXPLOSION_SIZE);
			_player.hurt(G.BOMB_DMG * ratio);
		}
	}

	private function getEmitter():FlxEmitter
	{
		var emitter = _emitters.get();
		if(emitter.members.length == 0)
		{
			emitter.loadParticles(AssetPaths.pixels__png, G.BOMB_EXPLOSION_QTY);
		}
		emitter.alpha.end.set(0, 0);
		emitter.scale.set(2);
		emitter.speed.set(0, 100);
		this.add(emitter);

		return emitter;
	}

	private function getPopper():FlxEmitter
	{
		var popper = _poppers.get();
		if(popper.members.length == 0)
		{
			popper.loadParticles(AssetPaths.Circle__png, 1);
		}
		popper.alpha.start.set(0.5, 0.5);
		popper.alpha.end.set(0, 0);
		popper.scale.set(2);
		popper.speed.set(0);
		this.add(popper);

		return popper;
	}
}

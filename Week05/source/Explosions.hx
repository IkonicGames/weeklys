package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.effects.particles.FlxEmitterExt;
import flixel.util.FlxPool;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

class Explosions extends FlxGroup
{

	var _emitters:FlxPool<FlxEmitterExt>;
	var _explostions:FlxPool<FlxSprite>;

	var _sndExplosions:FlxSound;

	public function new() 
	{
		super();

		_emitters = new FlxPool<FlxEmitterExt>(FlxEmitterExt);
		_explostions = new FlxPool<FlxSprite>(FlxSprite);

		for(i in 0...5)
		{
			var explosion = new FlxSprite();
			explosion.makeGraphic(G.BOMB_EXPLOSION_SIZE, G.BOMB_EXPLOSION_SIZE, FlxColor.TRANSPARENT);
			FlxSpriteUtil.drawCircle(explosion);
			_explostions.put(explosion);
		}

		_sndExplosions = FlxG.sound.load(AssetPaths.Explosion__mp3);
	}

	override public function update():Void
	{
		super.update();

		this.forEachOfType(FlxEmitterExt, function(emitter:FlxEmitterExt):Void {
			if(!emitter.members[0].active)
				emitter.kill();
		});

		this.forEachOfType(FlxSprite, function(explosion:FlxSprite):Void {
			this.remove(explosion);
			_explostions.put(explosion);
		});
	}

	public function explodeAt(X:Float, Y:Float, type:ExplType):Void
	{
		var emitter = getEmitter();
		emitter.setPosition(X, Y);
		emitter.start(true, G.BOMB_EXPLOSION_LIFE);

		if(type == ExplType.Bomb)
		{
			FlxG.camera.shake(0.01, 0.1);
			var explosion = _explostions.get();
			explosion.setPosition(X, Y);
			this.add(explosion);
		}

		_sndExplosions.play();
	}

	private function getEmitter():FlxEmitterExt
	{
		var emitter = _emitters.get();
		if(emitter.members.length == 0)
		{
			emitter.makeParticles(AssetPaths.pixels__png, G.BOMB_EXPLOSION_QTY);
		}
		emitter.endAlpha.set(0, 0);
		emitter.startScale.set(2, 2);
		emitter.endScale.set(2, 2);
		emitter.setXSpeed(80, 100);
		emitter.setYSpeed(80, 100);
		this.add(emitter);

		return emitter;
	}
}

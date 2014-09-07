package ;

import flixel.group.FlxTypedGroup;
import flixel.FlxG;
import flixel.util.FlxPool;
import flixel.effects.particles.FlxEmitterExt;
import flixel.FlxObject;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

// TODO change color of emitters...

class EnemyExplosions extends FlxTypedGroup<FlxEmitterExt>
{
	var _sndExplosion:FlxSound;

	public function new()
	{
		super();

		for(i in 0...10)
		{
			var emitter = new FlxEmitterExt(0, 0, 25);
			emitter.makeParticles(AssetPaths.pixels__png, 25);
			emitter.endAlpha.set(0, 0);
			emitter.setXSpeed(-100, 100);
			emitter.setYSpeed(-100, 100);
			emitter.acceleration.y = 10;
			emitter.life.set(1, 1);
			emitter.kill();
			this.add(emitter);
		}

		_sndExplosion = FlxG.sound.load(AssetPaths.Explosion2__mp3);
	}

	override public function update():Void
	{
		super.update();

		this.forEachAlive(function(emitter:FlxEmitterExt) {
			if(!emitter.members[0].alive)
				emitter.kill();
		});
	}

	public function explodeAt(obj:FlxObject, ?playSnd:Bool = true):Void
	{
		var emitter = getFirstDead();
		emitter.revive();
		emitter.at(obj);
		emitter.start(true, 1);

		if(playSnd)
			_sndExplosion.play(true);
	}
}

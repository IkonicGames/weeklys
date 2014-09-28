package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.effects.particles.FlxEmitterExt;
import flixel.util.FlxPool;

class Explosions extends FlxGroup
{
	var _emitters:FlxPool<FlxEmitterExt>;
	var _explostions:FlxPool<FlxSprite>;

	public function new() 
	{
		super();

		_emitters = new FlxPool<FlxEmitterExt>(FlxEmitterExt);
		_explostions = new FlxPool<FlxSprite>(FlxSprite);
	}

	override public function update():Void
	{
		super.update();

		this.forEachOfType(FlxEmitterExt, function(emitter:FlxEmitterExt):Void {
			if(!emitter.members[0].active)
				emitter.kill();
		});
	}

	public function explodeAt(X:Float, Y:Float):Void
	{
		var emitter = getEmitter();
		emitter.setPosition(X, Y);
		emitter.start(true, G.BOMB_EXPLOSION_LIFE);
	}

	private function getEmitter():FlxEmitterExt
	{
		var emitter = _emitters.get();
		if(emitter.members.length == 0)
		{
			emitter.makeParticles(AssetPaths.pixels__png, G.BOMB_EXPLOSION_QTY);
		}
		emitter.endAlpha.set(0, 0);
		emitter.setSize(2, 2);
		this.add(emitter);

		return emitter;
	}
}

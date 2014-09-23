package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.text.FlxText;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.tweens.misc.VarTween;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flash.events.Event;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var _player:Player;
	var _floorTiles:FlxTypedGroup<FlxTilemap>;
	var _dangerTiles:FlxTypedGroup<FlxTilemap>;

	var _currLevel:Int = G.LEVELS_START;
	var _level:TiledLevel;
	var _levels:Array<TiledLevel>;

	var _txtLevel:FlxText;
	var _txtLives:FlxText;
	var _txtInstructions:FlxText;

	var _sndStart:FlxSound;
	var _sndNextLevel:FlxSound;
	var _sndHurt:FlxSound;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		FlxG.worldBounds.x = -10;
		FlxG.worldBounds.width = FlxG.width * 2;
		FlxG.camera.bgColor = FlxColor.PLUM;

		_floorTiles = new FlxTypedGroup<FlxTilemap>();
		_dangerTiles = new FlxTypedGroup<FlxTilemap>();
		this.add(_floorTiles);
		this.add(_dangerTiles);

		_levels = new Array<TiledLevel>();
		for(i in 0...G.LEVELS_TOTAL)
		{
			var tmxPath = "assets/data/tiled/level" + Std.string(i + 1) + ".tmx";
			var lvl = new TiledLevel(tmxPath);
			_levels.push(lvl);
		}

		_level = _levels[_currLevel];
		_floorTiles.add(_level.floorTiles);
		_dangerTiles.add(_level.dangerTiles);
		addNextLevel();
		_currLevel++;
		_level = _levels[_currLevel];

		_player = new Player();
		_player.y = G.PLAYER_START_Y;
		this.add(_player);

		_txtLevel = new FlxText(8, 8, 0, "Lvl - 1");
		_txtLevel.scrollFactor.set(0, 0);
		_txtLevel.size = 16;
		this.add(_txtLevel);

		_txtLives = new FlxText(8, 32, 0, "Deaths - 0");
		_txtLives.scrollFactor.set(0, 0);
		_txtLives.size = 16;
		this.add(_txtLives);

		_txtInstructions = new FlxText(FlxG.width / 2, FlxG.height * 0.33, 0, G.TXT_INSTRUCTIONS, 16);
		_txtInstructions.x -= _txtInstructions.width / 2;
		this.add(_txtInstructions);

		_sndNextLevel = G.loadSound(AssetPaths.levelComplete__mp3);
		_sndHurt = G.loadSound(AssetPaths.hurt__mp3);
		_sndStart = G.loadSound(AssetPaths.start__mp3);
		_sndStart.play();

#if flash
		// FlxG.stage.dispatchEvent(new Event(Event.DEACTIVATE));
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
		FlxG.collide(_player, _floorTiles);
		FlxG.collide(_player, _dangerTiles, onCollideDanger);

		if(!_player.isOnScreen())
		{
			nextScreen();
		}
		
		super.update();
	}	

	private function nextScreen():Void
	{
		if(_currLevel < _levels.length)
		{
			// FlxG.camera.scroll.x = FlxG.width * _currLevel;
			var camTarget = FlxG.width * _currLevel;
			FlxTween.tween(FlxG.camera.scroll, { x:camTarget }, 0.25, { complete:onNextComplete, ease:FlxEase.sineInOut });
			FlxG.worldBounds.x = FlxG.width * _currLevel - 10;
			_player.x = FlxG.width * _currLevel;
			_player.active = false;
		}
		else
		{
			FlxG.camera.fade(0, 0.33, false, onFadeOut);
			_sndNextLevel.play();
			return;
		}

		addNextLevel();

		_sndNextLevel.play();

		_currLevel++;
		if(_currLevel < _levels.length)
		{
			_level = _levels[_currLevel];
			_txtLevel.text = "Lvl - " + Std.string(_currLevel);
		}
	}

	private function addNextLevel():Void
	{
		if(_currLevel >= _levels.length)
			return;

		if(_currLevel > 1)
		{
			_floorTiles.remove(_levels[_currLevel - 2].floorTiles);
			_dangerTiles.remove(_levels[_currLevel - 2].dangerTiles);
		}

		var nextLevel = _currLevel + 1;
		if(nextLevel >= _levels.length)
			return;
		_floorTiles.add(_levels[nextLevel].floorTiles);
		_dangerTiles.add(_levels[nextLevel].dangerTiles);
		_levels[nextLevel].offsetTiles(FlxG.width * nextLevel);
	}

	private function onCollideDanger(player:FlxObject, tiles:FlxObject):Void
	{
		FlxG.camera.shake(0.005, 0.2);
		// _player.reset(FlxG.camera.scroll.x, G.PLAYER_START_Y);
		_player.health++;
		_player.active = false;
		_player.solid = false;
		FlxTween.tween(_player, { x:FlxG.camera.scroll.x, y:G.PLAYER_START_Y }, 0.25, { ease:FlxEase.sineOut, complete:onCollideTweenComplete });

		_txtLives.text = "Deaths - " + Std.string(_player.health);

		_sndHurt.play();
	}

	private function onCollideTweenComplete(tween:FlxTween):Void
	{
		_player.reset(FlxG.camera.scroll.x, G.PLAYER_START_Y);
		_player.active = true;
		_player.solid = true;
	}

	private function onNextComplete(tween:FlxTween):Void
	{
		_player.active = true;
	}

	private function onFadeOut():Void
	{
		FlxG.switchState(new GameOverState(cast _player.health));
	}
}

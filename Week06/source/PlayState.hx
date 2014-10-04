package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.tile.FlxTilemap;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var _tilemaps:FlxTypedGroup<FlxTilemap>;
	var _grpCollectibles:FlxGroup;
	var _grpText:FlxGroup;
	var _player:Player;
	var _levelTimer:LevelTimer;

	var _gameOverState:FlxSubState;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		FlxG.camera.bgColor = 0x090404;

		var map = new TiledLevel(G.currentLevel);

		_tilemaps = new FlxTypedGroup<FlxTilemap>();
		_tilemaps.add(map.baseTilemap);
		_tilemaps.add(map.onewayTilemap);
		this.add(_tilemaps);

		_grpCollectibles = map.grpCollectibles;
		this.add(_grpCollectibles);

		_player = map.player;
		_player.setGrappleGroup(_tilemaps);
		this.add(_player.grapplingHook);
		this.add(_player);

		_grpText = map.grpText;
		this.add(_grpText);

		_levelTimer = new LevelTimer(10, 10, 0, "", 16);
		this.add(_levelTimer);
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
		FlxG.collide(_player, _tilemaps);
		FlxG.overlap(_player, _grpCollectibles, onOverlapCollectible);
		super.update();

	}	

	private function onOverlapCollectible(player:FlxObject, collectible:FlxObject):Void
	{
		collectible.kill();
		if(_grpCollectibles.countLiving() == 0)
		{
			G.levelCompleted(_levelTimer.elapsed);
			if(G.gameOver)
			{
				var gameOver = new GameOverSubState();
				this.openSubState(gameOver);
			}
			else
			{
				FlxG.switchState(new PlayState());
			}
		}
	}
}

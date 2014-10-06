package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.FlxCamera;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxMath;
import flixel.text.FlxText;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var _playerTilemaps:FlxTypedGroup<FlxTilemap>;
	var _grappleTilemaps:FlxTypedGroup<FlxTilemap>;
	var _grapplemap:FlxTilemap;
	var _grpCollectibles:FlxGroup;
	var _grpText:FlxGroup;
	var _player:Player;
	var _gameHUD:GameHUD;

	var _sndPickup:FlxSound;
	var _sndLevelComplete:FlxSound;

	var _gameOverState:FlxSubState;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		_sndPickup = FlxG.sound.load(AssetPaths.Pickup__mp3);
		_sndLevelComplete = FlxG.sound.load(AssetPaths.LevelComplete__mp3);

		var map = new TiledLevel(G.currentLevel);
		FlxG.worldBounds.set(0, 0, map.fullWidth, map.fullHeight);

		_playerTilemaps = new FlxTypedGroup<FlxTilemap>();
		_playerTilemaps.add(map.baseTilemap);
		_playerTilemaps.add(map.onewayTilemap);

		_grpCollectibles = map.grpCollectibles;
		this.add(_grpCollectibles);

		_grappleTilemaps = new FlxTypedGroup<FlxTilemap>();
		_grappleTilemaps.add(map.baseTilemap);
		_grappleTilemaps.add(map.onewayTilemap);
		_grappleTilemaps.add(map.grappleTilemap);
		this.add(_grappleTilemaps);

		_player = map.player;
		_player.setGrappleGroup(_grappleTilemaps);
		this.add(_player.grapplingHook);
		this.add(_player);

		_grpText = map.grpText;
		this.add(_grpText);

		_gameHUD = new GameHUD();
		this.add(_gameHUD);

		FlxG.camera.fade(0, 0.3, true);
		FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER, null, 1);
		FlxG.camera.setBounds(0, 0, map.fullWidth, map.fullHeight);
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
		FlxG.collide(_player, _playerTilemaps);
		FlxG.overlap(_player, _grpCollectibles, onOverlapCollectible);
		super.update();
	}	

	private function onOverlapCollectible(player:FlxObject, collectible:FlxObject):Void
	{
		_sndPickup.play(true);

		collectible.kill();

		if(_grpCollectibles.countLiving() == 0)
		{
			_sndLevelComplete.play();

			G.levelCompleted(_gameHUD.levelTimer.elapsed);
			if(G.gameOver)
			{
				var gameOver = new LevelTransitionSubState(_gameHUD.levelTimer.elapsed, true);
				this.openSubState(gameOver);
			}
			else
			{
				this.openSubState(new LevelTransitionSubState(_gameHUD.levelTimer.elapsed));
			}
		}
	}
}

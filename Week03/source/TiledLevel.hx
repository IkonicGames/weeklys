package ;

import haxe.io.Path;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxTypedGroup;
import flixel.FlxBasic;

class TiledLevel extends TiledMap
{
	public var floorTiles(get, null):FlxTilemap;
	private function get_floorTiles():FlxTilemap
	{
		return floorTiles;
	}

	public var dangerTiles(get, null):FlxTilemap;
	private function get_dangerTiles():FlxTilemap
	{
		return dangerTiles;
	}

	public function new(tileLevel:Dynamic)
	{
		super(tileLevel);

		for( tileLayer in this.layers ){
			var tileSheetName:String = tileLayer.properties.get("tileset");

			if(tileSheetName == null)
				throw "Tileset property not defined for the " + tileLayer.name + " layer";

			var tileset:TiledTileSet = null;
			for( ts in tilesets ){
				if(ts.name == tileSheetName)
				{
					tileset = ts;
					break;
				}
			}

			var imagePath = new Path(tileset.imageSource);
			var processedPath = "assets/images/tiles/" + imagePath.file + "." + imagePath.ext;

			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.immovable = true;
			tilemap.elasticity = 0;
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileset.tileWidth, tileset.tileHeight, 0, 1, 1, 1);

			if(tileLayer.name == "Floor")
			{
				floorTiles = tilemap;
			}
			else
			{
				dangerTiles = tilemap;
			}
		}
	}

	public function offsetTiles(xOffset:Float = 0):Void
	{
		floorTiles.x = xOffset;
		dangerTiles.x = xOffset;
	}
}

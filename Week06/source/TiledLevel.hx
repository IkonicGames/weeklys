package ;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.text.FlxText;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;
import haxe.io.Path;

class TiledLevel extends TiledMap
{
	public var baseTilemap(default, null):FlxTilemap;
	public var onewayTilemap(default, null):FlxTilemap;
	public var grappleTilemap(default, null):FlxTilemap;
	public var player(default, null):Player;
	public var grpCollectibles(default, null):FlxGroup;
	public var grpText(default, null):FlxGroup;

	public function new(tileLevel:Dynamic)
	{
		super(tileLevel);

		for(tileLayer in this.layers)
		{
			var tileset = this.tilesets.get("FloorTiles");

			var tilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.immovable = true;
			tilemap.elasticity = 0;

			switch(tileLayer.name)
			{
				case "OneWayTiles":
					onewayTilemap = tilemap;
					onewayTilemap.allowCollisions = FlxObject.UP;

				case "BaseTiles":
					baseTilemap = tilemap;

				case "GrappleTiles":
					grappleTilemap = tilemap;

			}
			
			// This happens after allowCollisions is set because tiles won't be one-way otherwise
			tilemap.loadMap(tileLayer.tileArray, AssetPaths.FloorTiles__png, tileset.tileWidth, tileset.tileHeight, 0, 1, 1, 1);
		}

		for(objGroup in this.objectGroups)
		{
			switch(objGroup.name)
			{
				case "Player":
					var plr = objGroup.objects[0];
					if(plr == null)
						continue;
					player = new Player();
					player.x = plr.x;
					player.y = plr.y;

				case "Collectibles":
					grpCollectibles = new FlxGroup();
					for(obj in objGroup.objects)
					{
						var collectible = new Collectible(obj.x, obj.y);
						grpCollectibles.add(collectible);
					}

				case "Text":
					grpText = new FlxGroup();
					for(obj in objGroup.objects)
					{
						var txt = obj.custom.get("Text");
						var size = obj.custom.contains("Size") ? Std.parseInt(obj.custom.get("Size")) : 8;
						var txtObj = new FlxText(obj.x, obj.y, 0, txt, size);
						txtObj.x -= txtObj.width / 2;
						grpText.add(txtObj);
					}
			}
		}
	}
}

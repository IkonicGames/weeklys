package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSignal;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class GameBlock extends FlxSprite
{
	public var type(default, null):Int;

	public var onClicked(default, null):FlxTypedSignal<GameBlock -> Void>;
	public var onReleased(default, null):FlxTypedSignal<GameBlock ->Void>;
	public var onMouseOut(default, null):FlxTypedSignal<GameBlock -> FlxPoint -> Void>;
	var mouseOver:Bool;

	public var row(default, null):Int;
	public var col(default, null):Int;

	public function new()
	{
		super();

		this.loadGraphic(AssetPaths.gameblock__png);

		onClicked = new FlxTypedSignal<GameBlock -> Void>();
		onReleased = new FlxTypedSignal<GameBlock -> Void>();
		onMouseOut = new FlxTypedSignal<GameBlock -> FlxPoint -> Void>();
		mouseOver = false;
	}

	override public function update():Void
	{
		super.update();

		if(FlxG.mouse.justPressed && this.overlapsPoint(FlxG.mouse) &&
				type != BlockType.EMPTY && type != BlockType.CLEARED)
			onClicked.dispatch(this);

		if(FlxG.mouse.justReleased && this.overlapsPoint(FlxG.mouse))
			onReleased.dispatch(this);

		if(mouseOver && !this.overlapsPoint(FlxG.mouse))
		{
			var dir = FlxPoint.get();
			if(FlxG.mouse.x < this.x) dir.x = -1;
			if(FlxG.mouse.x > this.x + this.width) dir.x = 1;
			if(FlxG.mouse.y < this.y) dir.y = -1;
			if(FlxG.mouse.y > this.y + this.height) dir.y = 1;

			onMouseOut.dispatch(this, dir);
		}

		mouseOver = this.overlapsPoint(FlxG.mouse);
	}

	public function setType(type:Int):Void
	{
		this.type = type;

		if(type == BlockType.CLEARED || type == BlockType.EMPTY)
		{
			if(this.alpha == 1)
			{
				FlxTween.tween(this, {alpha:0}, 0.1, {complete:function(t:FlxTween) {this.color = this.type;}});
			}
		}
		else
		{
			this.alpha = 0;
			FlxTween.tween(this, {alpha:1}, 0.1, {startDelay:0.1});
			this.color = this.type;
		}
	}

	public function setIndex(col:Int, row:Int):Void
	{
		this.col = col;
		this.row = row;
	}
}

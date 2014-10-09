package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSignal;

class GameBlock extends FlxSprite
{
	public var type(default, null):Int;

	public var onClicked(default, null):FlxTypedSignal<GameBlock -> Void>;

	public var row(default, null):Int;
	public var col(default, null):Int;

	public function new()
	{
		super();

		this.makeGraphic(G.BLOCK_SIZE, G.BLOCK_SIZE);

		onClicked = new FlxTypedSignal<GameBlock -> Void>();
	}

	override public function update():Void
	{
		super.update();

		if(FlxG.mouse.justPressed && this.overlapsPoint(FlxG.mouse) &&
				type != BlockType.EMPTY && type != BlockType.CLEARED)
			onClicked.dispatch(this);
	}

	override public function setPosition(X:Float = 0, Y:Float = 0):Void
	{
		super.setPosition(X, Y);
	}

	public function setType(type:Int):Void
	{
		this.type = type;

		this.color = this.type;
	}

	public function setIndex(col:Int, row:Int):Void
	{
		this.col = col;
		this.row = row;
	}
}

package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Bullet extends FlxSprite 
{
	static private var normalSpeed:Int = -250;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(1, 2);
		
		kill();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		checkBoundaries();
	}
		
	override public function reset(X, Y)
	{
		super.reset(X, Y);
		velocity.y = normalSpeed;
	}
	
	private function checkBoundaries():Void
	{
		if (y < 0)
		{
			kill();
		}
	}
}
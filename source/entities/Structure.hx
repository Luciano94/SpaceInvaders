package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Structure extends FlxSprite 
{
	private var hitPoints:Int = 3;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(16, 4);
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		checkResistance();
	}
	
	public function getDamage():Void
	{
		hitPoints -= 1;
	}
	
	public function checkResistance():Void
	{
		if (hitPoints <= 0)
		{
			destroy();
		}
	}
}
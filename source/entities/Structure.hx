package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Structure extends FlxSprite 
{
	private var hitPoints:Int = 3;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.EstructuraEntera__png, true, 16, 4);
		
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
		if (hitPoints == 2)
		{
			loadGraphic(AssetPaths.ed1__png, true, 16, 4);
		}
		if (hitPoints == 1)
		{
			loadGraphic(AssetPaths.ed2__png, true, 16, 4);
		}
	}
}
package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class UFO extends FlxSprite 
{
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(24, 8);
		kill();
	}
	
	override public function reset(X, Y):Void
	{
		super.reset(X, Y);
		
		velocity.x = 10;
	}
}
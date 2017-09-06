package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class EnemyBullet extends FlxSprite 
{
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(1, 2);
		velocity.y = 50;
	}
	
	override public function reset(X, Y)
	{
		super.reset(X, Y);
		
		velocity.y = 50;
	}	
}
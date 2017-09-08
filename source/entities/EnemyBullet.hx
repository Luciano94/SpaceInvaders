package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class EnemyBullet extends FlxSprite 
{
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.BalaEnemigo__png, true, 1, 2);
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
		
		velocity.y = 50;
	}
	
	private function checkBoundaries():Void
	{
		if (y > FlxG.height)
			kill();
	}
}
package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Player extends FlxSprite 
{
	static private var normalSpeed:Int = 80;
	private var shot:Bullet = new Bullet(-1, -1);
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(8, 8);
		
		FlxG.state.add(shot);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		move();
		shoot();
	}
	
	private function move():Void
	{
		if (FlxG.keys.pressed.RIGHT)
			velocity.x = normalSpeed;
		if (FlxG.keys.justReleased.RIGHT || x >= FlxG.width - width)
		{
			velocity.x = 0;
			if (FlxG.keys.pressed.LEFT)
				velocity.x = -normalSpeed;
		}
		if (FlxG.keys.pressed.LEFT)
			velocity.x = -normalSpeed;
		if (FlxG.keys.justReleased.LEFT || x <= 0)
		{
			velocity.x = 0;
			if (FlxG.keys.pressed.RIGHT)
				velocity.x = normalSpeed;
		}
	}
	
	private function shoot():Void
	{
		if (FlxG.keys.justPressed.SPACE && !shot.alive)
		{
			shot.reset(x + width / 2, y);
		}
	}
}
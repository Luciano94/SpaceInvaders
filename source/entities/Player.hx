package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Player extends FlxSprite 
{
	static private var normalSpeed:Int = 80;
	public var lives(get, null):Int = Reg.maxLives;
	public var shot(get, null):Bullet;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(8, 8);
		shot = new Bullet();	
		FlxG.state.add(shot);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		move();
		shoot();
	}
	
	override public function kill():Void
	{
		super.kill();
		
		lives--;
		if (lives > 0)
		{
			reset(FlxG.width / 2, FlxG.height - 16);
		}
		else
		{
			if (Reg.score > Reg.highestScore)
				Reg.highestScore = Reg.score;
			Reg.score = 0;
			Reg.gameOver = true;
		}
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
	
	function get_shot():Bullet 
	{
		return shot;
	}
	
	function get_lives():Int 
	{
		return lives;
	}
}
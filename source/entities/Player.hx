package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Player extends FlxSprite 
{
	static private var normalSpeed:Int = 80;
	public var lives(get, null):Int = Reg.maxLives;
	public var shot(get, null):Bullet;
	private var invincibilityTime: Float;
	public var hasJustBeenHit(get, null): Bool;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic(AssetPaths.player__png, true, 8, 8);
		animation.add("idle", [0], 6, true);
		animation.play("idle");
		shot = new Bullet();	
		FlxG.state.add(shot);
		invincibilityTime = 0;
		hasJustBeenHit = false;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		hitChecking();
		move();
		shoot();
	}
	
	override public function kill():Void
	{
		loadGraphic(AssetPaths.player__png, true, 8, 8);
		animation.add("damage", [0, 1], 6, true);
		animation.play("damage");
		
		lives--;
		if (lives > 0)
		{
			reset(FlxG.width / 2, FlxG.height - 16);
			hasJustBeenHit = true;
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
			shot.reset(x + width / 2 - shot.width / 2, y);
		}
	}
	
	function hitChecking():Void 
	{
		if (hasJustBeenHit)
		{
			invincibilityTime += FlxG.elapsed;
			if (invincibilityTime >= 3)
			{
				hasJustBeenHit = false;
				invincibilityTime = 0;
				loadGraphic(AssetPaths.player__png, true, 8, 8);
				animation.add("idle", [0], 6, true);
				animation.play("idle");
			}
		}
	}
	
	function get_shot():Bullet 
	{
		return shot;
	}
	
	public function get_hasJustBeenHit():Bool
	{
		return hasJustBeenHit;
	}
	
	function get_lives():Int 
	{
		return lives;
	}
}
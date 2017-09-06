package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import entities.EnemyBullet;


class Enemy extends FlxSprite 
{
	private var origenX:Float;
	private var time:Int;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(8, 8);
		velocity.x = 8;
		origenX = X;
		time = 10 ;
	}
	
	override public function update(elapsed:Float):Void
	{
		if (x < origenX - 8)
		{
			x = origenX - 8;
			velocity.x = -velocity.x;
			velocity.y++;
		}
		
		if (x > origenX + 16) 
		{
			x = origenX + 16;
			velocity.x = -velocity.x;
		}
			
		super.update(elapsed);
	}
	
	public function killMe(bullet:Bullet):Void
	{
		if (FlxG.overlap(this, bullet))
		{
			bullet.kill();
			kill();
		}
	}
	
	public function canShoot(bullet:EnemyBullet):Bool
	{
		if (!bullet.alive && time == 0)
		{
			time = 10;
			return true;
		}
		
		time--;
		return false;
	}
	
	public function shoot(bullet:EnemyBullet):Void
	{
		bullet.reset(x + width / 2, y);
	}
}
package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import entities.EnemyBullet;


class Enemy extends FlxSprite 
{
	
	private var origenX: Float;
	private var balin: EnemyBullet;
	private var time: Int;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(8, 8);
		
		velocity.x = 8;
		origenX = X;
		time = 15 ;
	}
	
	override public function update(elapsed: Float): Void
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
	
	public function killMe( bullet: Bullet): Void
	{
		if (FlxG.overlap(this, bullet))
		{
			bullet.kill();
			kill();
		}
	}
	
	public function canShot(bullet: EnemyBullet): Bool
	{
		if ((bullet.y > 150) && (time == 0))
		{
			time = 15;
			return true;
		}
		
		time --;
		return false;
	}
	
	public function shot(bullet: EnemyBullet): Void
	{
		bullet.reset(x, y);
	}
}
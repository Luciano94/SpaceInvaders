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
		
		loadGraphic(AssetPaths.Enemigo__png, true, 8, 8);
		animation.add("idle", [0, 1, 2, 3], 6, true);
		animation.play("idle");
		velocity.x = 8;
		origenX = X;
		time = 10 ;
	}
	
	public function killMe(bullet:Bullet):Bool
	{
		if (FlxG.overlap(this, bullet))
		{
			Reg.score += Reg.enemyPoints;
			bullet.kill();
			kill();
			FlxG.sound.play(AssetPaths.enemyDeath__wav);
			return true;
		}
		return false;
	}
	
	public function canShoot(bullet:EnemyBullet):Bool
	{
		if (!bullet.alive && time == 0)
		{
			time = 5;
			return true;
		}
		
		time--;
		return false;
	}
	
	public function shoot(bullet:EnemyBullet):Void
	{
		bullet.reset(x + width / 2 - width / 2, y);
		FlxG.sound.play(AssetPaths.enemyShot__wav);
	}
}
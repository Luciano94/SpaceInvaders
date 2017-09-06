package states;

import entities.Player;
import entities.Bullet;
import entities.EnemyBullet;
import entities.Enemy;
import entities.Structure;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	private var player:Player;
	private var structures:FlxTypedGroup<Structure>;
	private var enemies:FlxTypedGroup<Enemy>;
	private var enemy:Enemy;
	private var eneBullet:EnemyBullet;
	
	override public function create():Void
	{
		super.create();
		
		player = new Player(FlxG.width / 2, FlxG.height - 16);
		structures = new FlxTypedGroup<Structure>();
		enemies = new FlxTypedGroup<Enemy>();
		eneBullet = new EnemyBullet();
		
		for (i in 1...5)
		{
			for (j in 1...8)
			{
				enemy = new Enemy(16 * j, i * 10);
				enemies.add(enemy);
			}
		}
		
		for (i	in 0...4) 
		{
			var structure = new Structure(16 + 36 * i, FlxG.height * 2/3);
			structures.add(structure);
		}
		
		add(player);
		add(enemies);
		add(eneBullet);
		add(structures);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		structureCollision();
		enemysCollision();
		enemysShot();
		playersDeath();
	}
	
	private function enemysShot():Void
	{
		var randomEnemy = enemies.getRandom(); 
		
		if (randomEnemy.canShoot(eneBullet) && randomEnemy.alive)
		{
			randomEnemy.shoot(eneBullet);
		}
	}
	
	private function structureCollision():Void
	{
		FlxG.overlap(player.shot, structures, damageStructure);
		FlxG.overlap(eneBullet, structures, damageStructure2);
	}
	
	private function damageStructure(shot:Bullet, structure:Structure):Void
	{
		shot.kill();
		structure.getDamage();
	}
	
	private function damageStructure2(shot:EnemyBullet, structure:Structure):Void // Improve this!
	{
		shot.kill();
		structure.getDamage();
	}
	
	private function playersDeath():Void
	{
		if (FlxG.overlap(player, eneBullet))
		{
			eneBullet.kill();
			player.kill();
		}
	}
	
	private function enemysCollision():Void
	{
		for (i in enemies.iterator())
		{
			i.killMe(player.shot);
			for (j in structures.iterator())
			{
				if (FlxG.overlap(i, j))
					j.getDamage();
			}
		}
	}
}
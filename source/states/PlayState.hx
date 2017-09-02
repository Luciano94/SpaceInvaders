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
	private var enemys:FlxTypedGroup<Enemy>;
	private var enemy: Enemy;
	private var eneBullet: EnemyBullet;
	
	override public function create():Void
	{
		super.create();
		
		player = new Player(FlxG.width / 2, FlxG.height - 16);
		structures = new FlxTypedGroup<Structure>();
		enemys = new FlxTypedGroup<Enemy>();
		eneBullet = new EnemyBullet(0, 160);
		
		for (j in 1...5)
		{
			for (i in 1...8)
			{
				if (i == 0)
					enemy = new Enemy((16 + (16 * i)), j * 10);
				else
					enemy = new Enemy(16 * i, j * 10);
				enemys.add(enemy);
			}
		}
		
		for (i	in 0...4) 
		{
			var structure = new Structure(16 + 36 * i, FlxG.height * 2/3);
			structures.add(structure);
		}
		
		add(player);
		add(enemys);
		add(eneBullet);
		add(structures);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		structureCollision();
		enemysCollision();
		enemysShot();
		playerDeath();
		
		
	}
	
	private function enemysShot(){
		
		var i = enemys.getRandom(); 
		
		if ((i.canShot(eneBullet)) && (i.alive)){
			i.shot(eneBullet);
		}
	}
	
	private function structureCollision():Void
	{
		FlxG.overlap(player.shot, structures, damageStructure);
	}
	
	private function damageStructure(shot:Bullet, structure:Structure):Void
	{
		shot.kill();
		structure.getDamage();
	}
	
	private function playerDeath()
	{
		if (FlxG.overlap(player, eneBullet))
			player.kill();
	}
	
	private function enemysCollision(): Void
	{
		for (i in enemys.iterator())
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
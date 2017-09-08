package states;

import entities.Player;
import entities.Bullet;
import entities.EnemyBullet;
import entities.Enemy;
import entities.Structure;
import entities.UFO;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxRandom;

class PlayState extends FlxState
{
	private var player:Player;
	private var structures:FlxTypedGroup<Structure>;
	private var enemies:FlxTypedGroup<Enemy>;
	private var enemy:Enemy;
	private var eneBullet:EnemyBullet;
	private var lives:FlxText;
	private var score:FlxText;
	private var ufo:UFO;
	
	override public function create():Void
	{
		super.create();
		
		player = new Player(FlxG.width / 2, FlxG.height - 16);
		structures = new FlxTypedGroup<Structure>();
		enemies = new FlxTypedGroup<Enemy>();
		eneBullet = new EnemyBullet();
		lives = new FlxText(FlxG.width * 2 / 3, 0, 0, 8);
		score = new FlxText(16, 0, 0, 8);
		ufo = new UFO();
		
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
		add(lives);
		add(score);
		add(ufo);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		lives.text = "Lives: " + player.lives;
		score.text = "Score: " + Reg.score;
		otherCollisions();
		enemysCollision();
		enemysShot();
		playersDeath();
		spawnUFO(elapsed);
	}
	
	private function enemysShot():Void
	{
		var randomEnemy:Enemy = enemies.getRandom(); 
		
		if (randomEnemy.canShoot(eneBullet) && randomEnemy.alive)
		{
			randomEnemy.shoot(eneBullet);
		}
	}
	
	private function otherCollisions():Void
	{
		FlxG.overlap(player.shot, structures, damageStructure);
		FlxG.overlap(eneBullet, structures, damageStructure);
		FlxG.overlap(player.shot, ufo, damageUfo);
	}
	
	private function damageStructure(shot, structure:Structure):Void
	{
		shot.kill();
		structure.getDamage();
	}
	
	private function damageUfo(shot, ufo:UFO):Void
	{
		shot.kill();
		ufo.hasJustBeenDestroyed = true;
		ufo.kill();
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
	
	private function spawnUFO(elapsed:Float):Void
	{
		Reg.timeSinceStart += elapsed;
		if (Reg.timeSinceStart - Reg.timeAtLastUfoAppearance > Reg.ufoSpawnTime)
		{
			Reg.timeAtLastUfoAppearance = Reg.timeSinceStart;
			ufo.reset(0, 8);
		}
	}
}
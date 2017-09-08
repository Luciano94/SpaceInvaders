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
	private var highestScore:FlxText;
	private var ufo:UFO;
	
	override public function create():Void
	{
		super.create();
		
		player = new Player(FlxG.width / 2, FlxG.height - 16);
		structures = new FlxTypedGroup<Structure>();
		enemies = new FlxTypedGroup<Enemy>();
		eneBullet = new EnemyBullet();
		lives = new FlxText(FlxG.width / 2 - 24, 0, 0, 8);
		score = new FlxText(2, 0, 0, 8);
		highestScore = new FlxText(FlxG.width * 2/3 - 12, 0, 0, 8);
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
		add(highestScore);
		add(ufo);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		lives.text = "Lives: " + player.lives;
		score.text = "Score: " + Reg.score;
		highestScore.text = "Best Score: " + Reg.highestScore;
		otherCollisions();
		enemysCollision();
		enemyMovment();
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
			if (i.killMe(player.shot))
			{
				movmentVelocity();
			}
			for (j in structures.iterator())
			{
				if (FlxG.overlap(i, j))
					j.getDamage();
			}
		}
	}
	// Funcion que se encarga del movimiento del grupo de enemigos
	private function enemyMovment():Void 
	{	
		var back:Enemy = enemies.members[enemies.length - 1];
		var forward:Enemy = enemies.members[0];
		
		for (i in enemies.iterator())
		{
			if (back.x < i.x)
				back = i;
			else if (forward.x > i.x)
					forward = i;
		}
		if (forward.x < 0)
		{
			for (j in enemies.iterator())
			{
				j.velocity.x = -j.velocity.x;
				j.y += 4;
			}
		}
		if ( back.x > FlxG.width - 8)
		{
			for (j in enemies.iterator())
			{
				j.velocity.x = -j.velocity.x;
				j.y += 4;
			}
		}
	}	
	// funcion que acelera a los enemigos cuando uno muere
	private function movmentVelocity():Void 
	{
		for (i in enemies.iterator())
		{
			if (i.velocity.x < 0)
				i.velocity.x -=3;
			else if (i.velocity.x > 0) 
				i.velocity.x +=3;
		}
	}
	
	private function spawnUFO(elapsed:Float):Void
	{
		Reg.timeSinceStart += elapsed;
		if (Reg.timeSinceStart - Reg.timeAtLastUfoAppearance > Reg.ufoSpawnTime)
		{
			Reg.timeAtLastUfoAppearance = Reg.timeSinceStart;
			ufo.reset(0, 16);
		}
	}
}
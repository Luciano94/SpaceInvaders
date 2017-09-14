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
import flixel.util.FlxColor;

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
	private var paused:FlxText;
	private var gameOver:FlxText;
	private var ufo:UFO;
	
	override public function create():Void
	{
		super.create();
		
		player = new Player(FlxG.width / 2, FlxG.height - 16);
		structures = new FlxTypedGroup<Structure>();
		enemies = new FlxTypedGroup<Enemy>();
		eneBullet = new EnemyBullet();
		lives = new FlxText(0, 0, 160, 8);
		score = new FlxText(0, 0, 160, 8);
		highestScore = new FlxText(0, 0, 160, 8);
		paused = new FlxText(0, FlxG.height / 2 - 4, 160, "Paused", 8);
		gameOver = new FlxText(0,FlxG.height / 2 - 4, 160, "Game Over", 8);
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
		
		highestScore.visible = false;
		paused.visible = false;
		gameOver.visible = false;
		
		lives.setFormat(8, 0x04FF00, FlxTextAlign.CENTER);
		score.setFormat(8, 0xFFF700, FlxTextAlign.LEFT);
		highestScore.setFormat(8, 0xFF0000, FlxTextAlign.RIGHT);
		paused.setFormat(8, 0xFFF700, FlxTextAlign.CENTER);
		gameOver.setFormat(8, 0xFF0000, FlxTextAlign.CENTER);
		
		add(player);
		add(enemies);
		add(eneBullet);
		add(structures);
		add(lives);
		add(score);
		add(highestScore);
		add(paused);
		add(gameOver);
		add(ufo);
	}

	override public function update(elapsed:Float):Void
	{	
		if (!Reg.gamePaused && !Reg.gameOver)
		{
			super.update(elapsed);
			otherCollisions();
			enemysCollision();
			enemyMovement();
			enemysShot();
			playersDeath();
			bulletCollision();
			spawnUFO(elapsed);
			resetEnemies();
		}
		
		lives.text = "Lives: " + player.lives;
		score.text = "Score: " + Reg.score;
		highestScore.text = "Best: " + Reg.highestScore;
		
		if (Reg.highestScore > 0)
		{
			highestScore.visible = true;
		}
		
		if (FlxG.keys.justPressed.ENTER && !Reg.gameOver)
		{
			Reg.gamePaused = !Reg.gamePaused;
			paused.visible = !paused.visible;
		}
		
		if (Reg.gameOver)
		{
			gameOver.visible = true;
			if (FlxG.keys.justPressed.R)
			{
				restartGame();
			}
		}
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
		FlxG.sound.play(AssetPaths.structureDamage__wav);
	}
	
	private function damageUfo(shot, ufo:UFO):Void
	{
		shot.kill();
		ufo.hasJustBeenDestroyed = true;
		ufo.kill();
	}
	
	private function playersDeath():Void
	{
		if (!player.get_hasJustBeenHit())
		{
			if (FlxG.overlap(player, eneBullet))
			{
				eneBullet.kill();
				player.kill();
			}
			if (FlxG.overlap(player, enemies))
			{
				if (Reg.score > Reg.highestScore)
					Reg.highestScore = Reg.score;
				Reg.score = 0;
				Reg.gameOver = true;
				FlxG.sound.play(AssetPaths.gameOver__wav);
			}
		}
	}
	private function bulletCollision():Void
	{
		if (FlxG.overlap(eneBullet, player.shot))
		{
			eneBullet.kill();
			player.shot.kill();
		}
	}
	private function enemysCollision():Void
	{
		for (i in enemies.iterator())
		{
			if (i.killMe(player.shot))
			{
				movementVelocity();
			}
			for (j in structures.iterator())
			{
				if (FlxG.overlap(i, j))
					j.getDamage();
			}
		}
	}
	// Funcion que se encarga del movimiento del grupo de enemigos
	private function enemyMovement():Void 
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
		if (back.x > FlxG.width - 8)
		{
			for (j in enemies.iterator())
			{
				j.velocity.x = -j.velocity.x;
				j.y += 4;
			}
		}
	}	
	// funcion que acelera a los enemigos cuando uno muere
	private function movementVelocity():Void 
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
	
	private function resetEnemies():Void
	{
		if (enemies.countDead() == 28)
		{
			enemies.destroy();
			
			enemies = new FlxTypedGroup<Enemy>();
			
			for (i in 1...5)
			{
				for (j in 1...8)
				{
					enemy = new Enemy(16 * j, i * 10);
					enemies.add(enemy);
				}
			}
			
			add(enemies);
		}
	}
	
	private function restartGame():Void
	{
		player.destroy();
		player.shot.destroy();
		enemies.destroy();
		eneBullet.destroy();
		structures.destroy();
		ufo.destroy();
		
		Reg.gameOver = false;
		Reg.timeSinceStart = 0;
		Reg.timeAtLastUfoAppearance = 0;
		
		player = new Player(FlxG.width / 2, FlxG.height - 16);
		enemies = new FlxTypedGroup<Enemy>();
		eneBullet = new EnemyBullet();
		structures = new FlxTypedGroup<Structure>();
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
		
		gameOver.visible = false;
		
		add(player);
		add(enemies);
		add(eneBullet);
		add(structures);
		add(ufo);
	}
}
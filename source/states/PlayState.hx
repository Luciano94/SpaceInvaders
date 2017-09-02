package states;

import entities.Player;
import entities.Bullet;
import entities.Structure;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	private var player:Player;
	private var structures:FlxTypedGroup<Structure>;
	
	override public function create():Void
	{
		super.create();
		
		player = new Player(FlxG.width / 2, FlxG.height - 16);
		structures = new FlxTypedGroup<Structure>();
		
		for (i	in 0...4) 
		{
			var structure = new Structure(16 + 36 * i, FlxG.height * 2/3);
			structures.add(structure);
		}
		
		add(player);
		add(structures);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		structureCollision();
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
}
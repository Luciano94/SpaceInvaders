package states;

import entities.Player;
import entities.Bullet;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

class PlayState extends FlxState
{
	private var player:Player;
	
	override public function create():Void
	{
		super.create();
		
		player = new Player(FlxG.width / 2, FlxG.height - 16);
		
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
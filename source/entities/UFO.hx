package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class UFO extends FlxSprite 
{
	private var speed:Int = 25;
	public var hasJustBeenDestroyed(null, set):Bool;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		hasJustBeenDestroyed = false;
		makeGraphic(24, 8);
		kill();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		checkBoundaries();
	}
	
	override public function reset(X, Y):Void
	{
		super.reset(X, Y);
		
		hasJustBeenDestroyed = false;
		//speed += Reg.randomNumber.float(5, 10, Reg.excluded);
		velocity.x = speed;
	}
	
	override public function kill():Void
	{
		super.kill();
		
		if (hasJustBeenDestroyed)
			Reg.score += Reg.ufoPoints;
	}
	
	public function checkBoundaries():Void
	{
		if (x > FlxG.width)
			kill();
	}
	
	function set_hasJustBeenDestroyed(value:Bool):Bool 
	{
		return hasJustBeenDestroyed = value;
	}
}
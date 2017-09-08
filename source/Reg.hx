package;
import flixel.math.FlxRandom;


class Reg 
{
	static public var randomNumber:FlxRandom = new FlxRandom();
	
	inline static public var maxLives:Int = 3;
	static public var ufoSpawnTime:Float = randomNumber.float(15, 25);
	static public var enemyPoints:Int = 10;
	static public var ufoPoints:Int = randomNumber.int(30, 50);
	static public var score:Int = 0;
	static public var timeSinceStart:Float = 0;
	static public var timeAtLastUfoAppearance:Float = 0;
}
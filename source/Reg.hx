package;
import flixel.math.FlxRandom;


class Reg 
{
	static public var randomNumber:FlxRandom = new FlxRandom();
	static public var excluded:Array<Int> = [31, 32, 33, 34, 36, 37, 38, 39, 41, 42, 43, 44, 46, 47, 48, 49];
	
	inline static public var maxLives:Int = 3;
	static public var ufoSpawnTime:Float = randomNumber.float(15, 25);
	static public var enemyPoints:Int = 10;
	static public var ufoPoints:Int = randomNumber.int(30, 50, excluded);
	static public var score:Int = 0;
	static public var highestScore:Int = 0;
	static public var timeSinceStart:Float = 0;
	static public var timeAtLastUfoAppearance:Float = 0;
}
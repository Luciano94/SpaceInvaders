package;

import flixel.system.FlxBasePreloader;

class CustomPreloader extends FlxBasePreloader 
{

	public function new(MinDisplayTime:Float=0, ?AllowedURLs:Array<String>) 
	{
		super(MinDisplayTime, ?AllowedURLs);
		
	}
	
}
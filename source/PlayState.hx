package;

import flixel.FlxState;

class PlayState extends FlxState
{
	// map containing UFNF versions (DO NOT MODIFY FOR MODS)
	var versions:Map<String, String> = ["0.7.2 (Latest)" => ""];

	// map containing UFNF mods (PUT YOUR MOD ON THIS)
	var mods:Map<String, String> = [];

	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

package;

import flixel.FlxState;

class PlayState extends FlxState
{
	// map containing UFNF versions (DO NOT MODIFY FOR MODS)
	var versions:Map<String, String> = [
		"0.7.2 (Latest)" => "https://github.com/thepercentageguy/Unnamed-FNF-Engine/releases/download/v0.7.2/ufnf-0_7_2.zip"
	];

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

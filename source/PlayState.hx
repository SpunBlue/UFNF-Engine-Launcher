package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	override public function create()
	{
		FlxG.camera.antialiasing = true;

		var title = new FlxText(0, 10, FlxG.width, "UFNF Engine Launcher");
		title.alignment = CENTER;
		title.size = 32;
		add(title);

		var changelog = new FlxText(0, 70, FlxG.width - 10, "Changelogs:");
		changelog.alignment = LEFT;
		changelog.screenCenter(X);
		add(changelog);

		// lil test
		#if !js
		var versions = sys.Http.requestUrl("https://thepercentageguy.github.io/UFNF-Engine-Launcher/").split(",");

		for (version in versions)
		{
			changelog.text += '\n\n${version}:';
			for (line in sys.Http.requestUrl('https://thepercentageguy.github.io/UFNF-Engine-Launcher/${version}/changelog.txt').split("\n"))
			{
				changelog.text += '\n    - ${line}';
			}
		}
		#end

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

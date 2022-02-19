package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.StrNameLabel;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import haxe.exceptions.NotImplementedException;
import lime.app.Application;

using StringTools;

class PlayState extends FlxState
{
	var funnyVersion:FlxUIDropDownMenu;

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

		var funkyOverlay = new FlxSprite(0, FlxG.height - 50);
		funkyOverlay.makeGraphic(FlxG.width, 50, 0xFFA1A1A1);
		add(funkyOverlay);

		var playButton = new FlxButton(0, funkyOverlay.y, "Play", onPlayClick);
		playButton.screenCenter(X);
		playButton.y += 25 - playButton.height / 2;
		add(playButton);

		// lil test
		#if !js
		var versions = sys.Http.requestUrl("https://raw.githubusercontent.com/thepercentageguy/UFNF-Engine-Launcher/master/versions/index.html").split(",");
		trace(versions);

		// changelog loop
		for (version in versions)
		{
			var ver = version.split(":")[0];

			if (!ver.trim().endsWith("--S"))
			{
				changelog.text += '\n\n${ver.trim()}:';
				for (line in sys.Http.requestUrl('https://raw.githubusercontent.com/thepercentageguy/UFNF-Engine-Launcher/master/versions/${ver.trim()}/changelog.txt')
					.split("\n"))
				{
					changelog.text += '\n    - ${line}';
				}
			}
		}

		// version loop
		var finalArray = [];
		for (version in versions)
		{
			var ver = version.split(":")[0];

			if (ver.trim().endsWith("--S"))
			{
				var tmpString = "";
				var tempArray = ver.trim().split("");
				tempArray.pop();
				tempArray.pop();
				tempArray.pop();
				tmpString = tempArray.join("");
				finalArray.push(new StrNameLabel(tmpString, tmpString));
			}
			else
			{
				finalArray.push(new StrNameLabel(ver.trim(), ver.trim()));
			}
		}
		funnyVersion = new FlxUIDropDownMenu(10, funkyOverlay.y, finalArray);
		funnyVersion.y = playButton.y;
		add(funnyVersion);

		if (!sys.FileSystem.exists("downloads"))
		{
			sys.FileSystem.createDirectory("downloads");
		}
		#end

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function onPlayClick()
	{
		#if !js
		// first check if the selected version is already downloaded
		if (sys.FileSystem.exists('downloads/${funnyVersion.selectedId.trim()}'))
		{
			// just launch the game
			Sys.command('start runGame.bat ${funnyVersion.selectedId} ${funnyVersion.selectedId.trim().split("-")[0]}');
			// Sys.command('start downloads/${funnyVersion.selectedId.trim()}/${funnyVersion.selectedId.trim().split("-")[0]}.exe');
		}
		else
		{
			// download the game
			Application.current.window.alert("Downloading game...", "Please wait...");
		}
		#end
	}
}

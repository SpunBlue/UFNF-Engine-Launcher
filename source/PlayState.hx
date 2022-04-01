package;

import haxe.io.Path;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.StrNameLabel;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import haxe.exceptions.NotImplementedException;
import lime.app.Application;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class PlayState extends FlxState
{
	var funnyVersion:FlxUIDropDownMenu;
	var playButton:FlxButton;
	var allowPlay = true;

	var link:String = "";

	override public function create()
	{
		FlxG.camera.antialiasing = true;

		/*var title = new FlxText(0, FlxG.height - 32, FlxG.width, "UFNF Engine Launcher");
		title.alignment = CENTER;
		title.size = 32;
		add(title);*/

		var bg = new FlxSprite(0, 0, "data/stageback.png");
		bg.antialiasing = true;
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		add(bg);

		var logoBl = new FlxSprite(20, -45);
		logoBl.frames = FlxAtlasFrames.fromSparrow('data/logoBumpin.png', 'data/logoBumpin.xml');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, true);
		logoBl.animation.play('bump');
		logoBl.setGraphicSize(Std.int(logoBl.graphic.width * 0.35));
		logoBl.updateHitbox();
		add(logoBl);

		var changelog = new FlxText(0, 70, FlxG.width - 10, "Changelogs:");
		changelog.alignment = LEFT;
		changelog.screenCenter(X);
		add(changelog);

		var funkyOverlay = new FlxSprite(0, 0);
		funkyOverlay.makeGraphic(FlxG.width, 50, 0xFFA1A1A1);
		add(funkyOverlay);

		playButton = new FlxButton(0, funkyOverlay.y, "Play", onPlayClick);
		playButton.screenCenter(X);
		playButton.y += 25 - playButton.height / 2;
		add(playButton);

		// lil test
		#if !js
		var versions = sys.Http.requestUrl("https://raw.githubusercontent.com/SpunBlue/UFNF-Engine-Launcher/master/versions/index.html").split(",");
		trace(versions);

		// changelog loop
		for (version in versions)
		{
			var ver = version.split(":")[0];
			link = version.split(":")[1];

			if (!ver.trim().endsWith("--S"))
			{
				changelog.text += '\n\n${ver.trim()}:';
				for (line in sys.Http.requestUrl('https://raw.githubusercontent.com/SpunBlue/UFNF-Engine-Launcher/master/versions/${ver.trim()}/changelog.txt')
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
		if (allowPlay)
		{
			#if !js
			// first check if the selected version is already downloaded
			if (sys.FileSystem.exists('downloads/${funnyVersion.selectedId.trim()}'))
			{
				// just launch the game
				Sys.command('start runGame.bat ${funnyVersion.selectedId.trim()}');
				Sys.exit(0);
				// Sys.command('start downloads/${funnyVersion.selectedId.trim()}/${funnyVersion.selectedId.trim().split("-")[0]}.exe');
			}
			else
			{
				// download the game
				Application.current.window.alert("Downloading game...", "Please wait...");
				sys.FileSystem.createDirectory('downloads/${funnyVersion.selectedId.trim()}');
				playButton.text = "Downloading...";
				allowPlay = false;
				var isDone = false;
				sys.thread.Thread.create(() ->
				{
					Sys.command('powershell -command "iwr -outf downloads/${funnyVersion.selectedId.trim()}/${funnyVersion.selectedId.trim()}.zip ${link}"');
					isDone = true;
					if (isDone)
						Util.unzipFile('downloads/${funnyVersion.selectedId.trim()}/${funnyVersion.selectedId.trim()}.zip',
							'downloads/${funnyVersion.selectedId.trim()}');
					Application.current.window.alert("Launching game!", "Done!");
					Sys.command('start runGame.bat ${funnyVersion.selectedId.trim()}');
					Sys.exit(0);
				});
			}
			#end
		}
	}
}

#if !js
import sys.FileSystem;
import sys.io.File;

class Util
{
	public static function unzipFile(srcZip:String, dstDir:String, ignoreRootFolder:Bool = false)
	{
		FileSystem.createDirectory(dstDir);

		var inFile = sys.io.File.read(srcZip);
		var entries = haxe.zip.Reader.readZip(inFile);
		inFile.close();

		for (entry in entries)
		{
			var fileName = entry.fileName;
			if (fileName.charAt(0) != "/" && fileName.charAt(0) != "\\" && fileName.split("..").length <= 1)
			{
				var dirs = ~/[\/\\]/g.split(fileName);
				if ((ignoreRootFolder != false && dirs.length > 1) || ignoreRootFolder == false)
				{
					if (ignoreRootFolder != false)
					{
						dirs.shift();
					}

					var path = "";
					var file = dirs.pop();
					for (d in dirs)
					{
						path += d;
						sys.FileSystem.createDirectory(dstDir + "/" + path);
						path += "/";
					}

					if (file == "")
					{
						// if (path != "") log("    created " + path);
						continue; // was just a directory
					}
					path += file;
					// log("    unzip " + path);

					var data = haxe.zip.Reader.unzip(entry);
					var f = File.write(dstDir + "/" + path, true);
					f.write(data);
					f.close();
				}
			}
		} // _entry

		var contents = sys.FileSystem.readDirectory(dstDir);
		if (contents.length > 0)
		{
			trace('Unzipped successfully to ${dstDir}: (${contents.length} top level items found)');
		}
		else
		{
			throw 'No contents found in "${dstDir}"';
		}
	}
}
#end

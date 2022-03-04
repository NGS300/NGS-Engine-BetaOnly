package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths{
	inline public static var SoundComplement = #if web "mp3" #else "ogg" #end;
	static var currentLevel:String;
	static public function setCurrentLevel(name:String){
		currentLevel = name.toLowerCase();
	}
	static function getPath(file:String, type:AssetType, library:Null<String>){
		if (library != null)
			return getLibraryPath(file, library);
		if (currentLevel != null){
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}
		return getPreloadPath(file);
	}
	static public function getLibraryPath(file:String, library = "preload"){
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}
	inline static function getLibraryPathForce(file:String, library:String){
		return '$library:assets/$library/$file';
	}
	inline static function getPreloadPath(file:String){
		return 'assets/$file';
	}
	inline static public function file(file:String, type:AssetType = TEXT, ?library:String){
		return getPath(file, type, library);
	}





	// Text Push
	inline static public function txt(key:String, ?library:String){
		return getPath('data/$key.txt', TEXT, library);
	}
	inline static public function txtChart(key:String, ?library:String){
		return getPath('dataChart/$key.txt', TEXT, library);
	}
	inline static public function txtAny(key:String, ?library:String){
		return getPath('$key.txt', TEXT, library);
	}
	inline static public function txtExistiShi(path:String){
		return OpenFlAssets.exists(path, AssetType.TEXT);
	}




	// Xml Push
	inline static public function xml(key:String, ?library:String){
		return getPath('data/$key.xml', TEXT, library);
	}
	inline static public function xmlAny(key:String, ?library:String){
		return getPath('$key.xml', TEXT, library);
	}






	// Json Push
	inline static public function json(key:String, ?library:String){
		return getPath('dataChart/$key.json', TEXT, library);
	}
	inline static public function jsonAny(key:String, ?library:String){
		return getPath('$key.json', TEXT, library);
	}





	// Sounds Push
	static public function sound(key:String, ?library:String){
		return getPath('sounds/$key.$SoundComplement', SOUND, library);
	}
	static public function soundAny(key:String, ?library:String){
		return getPath('$key.$SoundComplement', SOUND, library);
	}
	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String){
		return sound(key + FlxG.random.int(min, max), library);
	}


	// Music
	inline static public function music(key:String, ?library:String){
		return getPath('music/$key.$SoundComplement', MUSIC, library);
	}
	inline static public function musicAny(key:String, ?library:String){
		return getPath('$key.$SoundComplement', MUSIC, library);
	}




	// Inst & Vocal
	inline static public function voices(song:String){
		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SoundComplement';
	}
	inline static public function inst(song:String){
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SoundComplement';
	}




	// Image
	inline static public function image(key:String, ?library:String){
		return getPath('images/$key.png', IMAGE, library);
	}
	inline static public function imageAny(key:String, ?library:String){
		return getPath('$key.png', IMAGE, library);
	}




	// Font
	inline static public function font(key:String){
		return 'assets/fonts/$key';
	}
	inline static public function fontAny(key:String){
		return '$key';
	}




	// Get Image & Xml
	inline static public function getSparrowAtlas(key:String, ?library:String){
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}
	inline static public function getPackerAtlas(key:String, ?library:String){
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}
}

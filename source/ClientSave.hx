import openfl.Lib;
import flixel.FlxG;
class ClientSave{
	public static function data(){
		// Scroll \\
		//if (FlxG.save.data.hideScrollOpponent == null)
			//FlxG.save.data.hideScrollOpponent = false;
		if (FlxG.save.data.midScroll == null)
			FlxG.save.data.midScroll = false;
		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		//if (FlxG.save.data.weekUnlocked == null)
			//FlxG.save.data.weekUnlocked = 7;

		// HUD \\
		if (FlxG.save.data.ratingHUD == null)
			FlxG.save.data.ratingHUD = 2;
		if (FlxG.save.data.iconHUD == null)
			FlxG.save.data.iconHUD = true;
		if (FlxG.save.data.judgementCounter == null)
			FlxG.save.data.judgementCounter = true;

		// Gamplay \\
		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;
		if (FlxG.save.data.endless == null)
			FlxG.save.data.endless = false;
		if (FlxG.save.data.opponentGlownHit == null)
			FlxG.save.data.opponentGlownHit = true;
		if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;
		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;
		if (FlxG.save.data.engineMark == null)
			FlxG.save.data.engineMark = true;
		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;
		if (FlxG.save.data.cameraFPS == null)
			FlxG.save.data.cameraFPS = 30;
		if (FlxG.save.data.mode == null)
			FlxG.save.data.mode = 0;

		// Aparence & Optimize \\
		if (FlxG.save.data.map == null)
			FlxG.save.data.map = true;
		if (FlxG.save.data.antialiasing == null)
			FlxG.save.data.antialiasing = true;
		if (FlxG.save.data.distractions == null)
			FlxG.save.data.distractions = true;
		if (FlxG.save.data.colourCharIcon == null)
			FlxG.save.data.colourCharIcon = true;
		if (FlxG.save.data.flashing == null)
			FlxG.save.data.flashing = true;

		// Other \\
		if (FlxG.save.data.missSounds == null)
			FlxG.save.data.missSounds = true;
		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;
		if (FlxG.save.data.resetButton == null)
			FlxG.save.data.resetButton = false;
		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		// Cams
		if (FlxG.save.data.cameramovehitnote == null)
			FlxG.save.data.cameramovehitnote = true;
		if (FlxG.save.data.camerazoom == null)
			FlxG.save.data.camerazoom = true;
		if (FlxG.save.data.scoreScreen == null)
			FlxG.save.data.scoreScreen = true;

		//FlxG.save.data.cacheImages = false;

		/*if (FlxG.save.data.shitMs == null)
			FlxG.save.data.shitMs = 160.0;
		if (FlxG.save.data.badMs == null)
			FlxG.save.data.badMs = 135.0;
		if (FlxG.save.data.goodMs == null)
			FlxG.save.data.goodMs = 90.0;
		if (FlxG.save.data.sickMs == null)
			FlxG.save.data.sickMs = 45.0;*/
		//Conductor.recalculateTimings();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();
		Main.engineMark = FlxG.save.data.engineMark;
	}
}
import openfl.Lib;
import flixel.FlxG;

class ClientSave{
	public static function data(){
		if (FlxG.save.data.endless == null)
			FlxG.save.data.endless = false;
		// Scroll
		//if (FlxG.save.data.hideScrollOpponent == null)
			//FlxG.save.data.hideScrollOpponent = false;
		if (FlxG.save.data.midScroll == null)
			FlxG.save.data.midScroll = false;
		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		//if (FlxG.save.data.weekUnlocked == null)
			//FlxG.save.data.weekUnlocked = 7;

		// HUD
		if (FlxG.save.data.ratingHUD == null)
			FlxG.save.data.ratingHUD = true;


		
		if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.antialiasing == null)
			FlxG.save.data.antialiasing = true;

		if (FlxG.save.data.missSounds == null)
			FlxG.save.data.missSounds = true;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;

		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = false;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;

		if (FlxG.save.data.changedHit == null){
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 120;

		if (FlxG.save.data.fpsCap > 340 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 120;

		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = false;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.engineMark == null)
			FlxG.save.data.engineMark = true;

		if (FlxG.save.data.distractions == null)
			FlxG.save.data.distractions = true;

		if (FlxG.save.data.colourCharIcon == null)
			FlxG.save.data.colourCharIcon = true;

		if (FlxG.save.data.flashing == null)
			FlxG.save.data.flashing = true;

		if (FlxG.save.data.resetButton == null)
			FlxG.save.data.resetButton = false;

		if (FlxG.save.data.InstantRespawn == null)
			FlxG.save.data.InstantRespawn = false;

		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		if (FlxG.save.data.opponentGlownHit == null)
			FlxG.save.data.opponentGlownHit = true;

		if (FlxG.save.data.strumline == null)
			FlxG.save.data.strumline = false;

		if (FlxG.save.data.customStrumLine == null)
			FlxG.save.data.customStrumLine = 0;

		// Cams
		if (FlxG.save.data.cameramovehitnote == null)
			FlxG.save.data.cameramovehitnote = true;

		if (FlxG.save.data.camerazoom == null)
			FlxG.save.data.camerazoom = true;

		if (FlxG.save.data.scoreScreen == null)
			FlxG.save.data.scoreScreen = true;

		if (FlxG.save.data.imputMode == null)
			FlxG.save.data.imputMode = true;

		if (FlxG.save.data.map == null)
			FlxG.save.data.map = true;

		//FlxG.save.data.cacheImages = false;

		if (FlxG.save.data.editorBG == null)
			FlxG.save.data.editor = false;

		if (FlxG.save.data.zoom == null)
			FlxG.save.data.zoom = 1;

		if (FlxG.save.data.judgementCounter == null)
			FlxG.save.data.judgementCounter = true;

		if (FlxG.save.data.shitMs == null)
			FlxG.save.data.shitMs = 160.0;

		if (FlxG.save.data.badMs == null)
			FlxG.save.data.badMs = 135.0;

		if (FlxG.save.data.goodMs == null)
			FlxG.save.data.goodMs = 90.0;

		if (FlxG.save.data.sickMs == null)
			FlxG.save.data.sickMs = 45.0;

		/*Rating.timingWindows = [
			FlxG.save.data.shitMs,
			FlxG.save.data.badMs,
			FlxG.save.data.goodMs,
			FlxG.save.data.sickMs
		];*/

		if (FlxG.save.data.noteskin == null)
			FlxG.save.data.noteskin = 0;
		if (FlxG.save.data.overrideNoteskins == null)
			FlxG.save.data.overrideNoteskins = false;

		//Conductor.recalculateTimings();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();

		Main.engineMark = FlxG.save.data.engineMark;
	}
}
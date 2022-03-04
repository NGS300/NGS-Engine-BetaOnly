package;

import lime.app.Application;
import lime.system.DisplayMode;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class Option{
	public function new(){
		display = updateDisplay();
	}
	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;
	public var acceptType:Bool = false;
	public var waitingType:Bool = false;
	public final function getDisplay():String{
		return display;
	}
	public final function getAccept():Bool{
		return acceptValues;
	}
	public final function getDescription():String{
		return description;
	}
	public function getValue():String{
		return updateDisplay();
	};
	public function onType(text:String){}
	public function press():Bool{
		return true;
	}
	private function updateDisplay():String{
		return "";
	}
	public function left():Bool{
		return false;
	}
	public function right():Bool{
		return false;
	}
}
class EndlessShitOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.endless = !FlxG.save.data.endless;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Endless: < " + (FlxG.save.data.endless ? "on" : "off") + " >";
	}
}
class DFJKOption extends Option{
	public function new(){
		super();
		description = "Edit Your Keybindings";
	}
	public override function press():Bool{
		OptionsMenu.instance.selectedCatIndex = 5;
		OptionsMenu.instance.switchCat(OptionsMenu.instance.options[5], false);
		OptionsMenu.itIsNecessaryToRestart = false;
		return false;
	}
	private override function updateDisplay():String{
		return "Edit Keybindings";
	}
}
// KeyBinds
class UpKeybind extends Option{ // Up Arrow Bind
	public function new(desc:String){
		super();
		description = desc;
		acceptType = true;
	}
	public override function onType(text:String){
		if (waitingType){
			FlxG.save.data.upBind = text;
			waitingType = false;
		}
	}
	public override function press(){
		waitingType = !waitingType;
		return true;
	}
	private override function updateDisplay():String{
		return "UP: " + (waitingType ? "> " + FlxG.save.data.upBind + " <" : FlxG.save.data.upBind) + "";
	}
}
class DownKeybind extends Option{ // Down Arrow Bind
	public function new(desc:String){
		super();
		description = desc;
		acceptType = true;
	}
	public override function onType(text:String){
		if (waitingType){
			FlxG.save.data.downBind = text;
			waitingType = false;
		}
	}
	public override function press(){
		waitingType = !waitingType;
		return true;
	}
	private override function updateDisplay():String{
		return "DOWN: " + (waitingType ? "> " + FlxG.save.data.downBind + " <" : FlxG.save.data.downBind) + "";
	}
}
class RightKeybind extends Option{ // Right Arrow Bind
	public function new(desc:String){
		super();
		description = desc;
		acceptType = true;
	}
	public override function onType(text:String){
		if (waitingType){
			FlxG.save.data.rightBind = text;
			waitingType = false;
		}
	}
	public override function press(){
		waitingType = !waitingType;
		return true;
	}
	private override function updateDisplay():String{
		return "RIGHT: " + (waitingType ? "> " + FlxG.save.data.rightBind + " <" : FlxG.save.data.rightBind) + "";
	}
}
class LeftKeybind extends Option{ // Left Arrow Bind
	public function new(desc:String){
		super();
		description = desc;
		acceptType = true;
	}
	public override function onType(text:String){
		if (waitingType){
			FlxG.save.data.leftBind = text;
			waitingType = false;
		}
	}
	public override function press(){
		waitingType = !waitingType;
		return true;
	}
	private override function updateDisplay():String{
		return "LEFT: " + (waitingType ? "> " + FlxG.save.data.leftBind + " <" : FlxG.save.data.leftBind) + "";
	}
}
class DodgeKeybind extends Option{ // Dodge Bind
	public function new(desc:String){
		super();
		description = desc;
		acceptType = true;
	}
	public override function onType(text:String){
		if (waitingType){
			FlxG.save.data.dodgeBind = text;
			waitingType = false;
		}
	}
	public override function press(){
		waitingType = !waitingType;
		return true;
	}
	private override function updateDisplay():String{
		return "DODGE: " + (waitingType ? "> " + FlxG.save.data.dodgeBind + " <" : FlxG.save.data.dodgeBind) + "";
	}
}
class PauseKeybind extends Option{ // Pause Game Bind
	public function new(desc:String){
		super();
		description = desc;
		acceptType = true;
	}
	public override function onType(text:String){
		if (waitingType){
			FlxG.save.data.pauseBind = text;
			waitingType = false;
		}
	}
	public override function press(){
		waitingType = !waitingType;
		return true;
	}
	private override function updateDisplay():String{
		return "PAUSE: " + (waitingType ? "> " + FlxG.save.data.pauseBind + " <" : FlxG.save.data.pauseBind) + "";
	}
}
class ResetBind extends Option{ // Reset/Kill Bind
	public function new(desc:String){
		super();
		description = desc;
		acceptType = true;
	}
	public override function onType(text:String){
		if (waitingType){
			FlxG.save.data.resetBind = text;
			waitingType = false;
		}
	}
	public override function press(){
		waitingType = !waitingType;
		return true;
	}
	private override function updateDisplay():String{
		return "Bind Kill: " + (waitingType ? "> " + FlxG.save.data.resetBind + " <" : FlxG.save.data.resetBind) + "";
	}
}
class MuteBind extends Option{ // Mute Sound Bind
	public function new(desc:String){
		super();
		description = desc;
		acceptType = true;
	}
	public override function onType(text:String){
		if (waitingType){
			FlxG.save.data.muteBind = text;
			waitingType = false;
		}
	}
	public override function press(){
		waitingType = !waitingType;
		return true;
	}
	private override function updateDisplay():String{
		return "Volume Mute Bind: " + (waitingType ? "> " + FlxG.save.data.muteBind + " <" : FlxG.save.data.muteBind) + "";
	}
}
class FPSCamOption extends Option{
	public function new(desc:String){
		super();
		description = desc + " (Press R to Reset)";
		acceptType = true;
	}
	public override function left():Bool{
		FlxG.save.data.cameraFPS--;
		if (FlxG.save.data.cameraFPS < 0)
			FlxG.save.data.cameraFPS = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		FlxG.save.data.cameraFPS++;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function onType(char:String){
		if (char.toLowerCase() == "r")
			FlxG.save.data.cameraFPS = 30;
	}
	private override function updateDisplay():String{
		return "FPSCamera: < " + FlxG.save.data.cameraFPS + " fps >";
	}
}
class ModesOption extends Option{
	public function new(desc:String){
		super();
		if (OptionsMenu.isInPause)
			description = "This Option Cannot be Toggled in the Pause Menu.";
		else
			description = desc + " (Press R to Reset)";
		acceptType = true;
	}
	public override function left():Bool{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.save.data.mode--;
		if (FlxG.save.data.mode < 0)
			FlxG.save.data.mode = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		trace(FlxG.save.data.mode + " Mode");
		return true;
	}
	public override function right():Bool{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.save.data.mode++;
		if (FlxG.save.data.mode > 3)
			FlxG.save.data.mode = 3;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		trace(FlxG.save.data.mode + " Mode");
		return true;
	}
	public override function onType(char:String){
		if (char.toLowerCase() == "r")
			FlxG.save.data.mode = 0;
	}
	private override function updateDisplay():String{
		var dicktext:String = '';
		switch (FlxG.save.data.mode){
			case 0:
				dicktext = 'Normal';
			case 1:
				dicktext = 'Hard';
			case 2:
				dicktext = 'Hell';
			case 3:
				dicktext = 'Hybrid';
		}
		return "< " + dicktext + " > Mode";
	}
}
class HUDOption extends Option{
	public function new(){
		super();
		description = "Edit your HUD";
	}
	public override function press():Bool{
		OptionsMenu.instance.selectedCatIndex = 6;
		OptionsMenu.instance.switchCat(OptionsMenu.instance.options[6], false);
		OptionsMenu.itIsNecessaryToRestart = false;
		return false;
	}
	private override function updateDisplay():String{
		return "Edit HUD";
	}
}
class RatingHUDOption extends Option{
	public function new(desc:String){
		super();
		description = desc + " (Press R to Reset)";
		acceptType = true;
	}
	public override function left():Bool{
		FlxG.save.data.ratingHUD--;
		if (FlxG.save.data.ratingHUD < 0)
			FlxG.save.data.ratingHUD = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		FlxG.save.data.ratingHUD++;
		if (FlxG.save.data.ratingHUD > 2)
			FlxG.save.data.ratingHUD = 2;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function onType(char:String){
		if (char.toLowerCase() == "r")
			FlxG.save.data.ratingHUD = 0;
	}
	private override function updateDisplay():String{
		var wellSexy:String = '';
		switch (FlxG.save.data.ratingHUD){
			case 0:
				wellSexy = 'Default';
			case 1:
				wellSexy = 'CamDefault';
			case 2:
				wellSexy = 'Strum';
		}
		return "Rating: < " + wellSexy + " >";
	}
}
class IconHUDOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.iconHUD = !FlxG.save.data.iconHUD;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Icon: < " + (!FlxG.save.data.iconHUD ? "off" : "on") + " >";
	}
}

class SickMSOption extends Option{
	public function new(desc:String){
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}
	public override function left():Bool{
		FlxG.save.data.sickMs--;
		if (FlxG.save.data.sickMs < 0)
			FlxG.save.data.sickMs = 0;
		display = updateDisplay();
		return true;
	}
	public override function right():Bool
	{
		FlxG.save.data.sickMs++;
		display = updateDisplay();
		return true;
	}
	public override function onType(char:String){
		if (char.toLowerCase() == "r")
			FlxG.save.data.sickMs = 45;
	}
	private override function updateDisplay():String{
		return "SICK: < " + FlxG.save.data.sickMs + " ms >";
	}
}
class GoodMsOption extends Option{
	public function new(desc:String){
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}
	public override function left():Bool{
		FlxG.save.data.goodMs--;
		if (FlxG.save.data.goodMs < 0)
			FlxG.save.data.goodMs = 0;
		display = updateDisplay();
		return true;
	}
	public override function right():Bool{
		FlxG.save.data.goodMs++;
		display = updateDisplay();
		return true;
	}
	public override function onType(char:String){
		if (char.toLowerCase() == "r")
			FlxG.save.data.goodMs = 90;
	}
	private override function updateDisplay():String{
		return "GOOD: < " + FlxG.save.data.goodMs + " ms >";
	}
}
class BadMsOption extends Option{
	public function new(desc:String){
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}
	public override function left():Bool{
		FlxG.save.data.badMs--;
		if (FlxG.save.data.badMs < 0)
			FlxG.save.data.badMs = 0;
		display = updateDisplay();
		return true;
	}
	public override function right():Bool{
		FlxG.save.data.badMs++;
		display = updateDisplay();
		return true;
	}
	public override function onType(char:String){
		if (char.toLowerCase() == "r")
			FlxG.save.data.badMs = 135;
	}
	private override function updateDisplay():String{
		return "BAD: < " + FlxG.save.data.badMs + " ms >";
	}
}
class ShitMsOption extends Option{
	public function new(desc:String){
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}
	public override function left():Bool{
		FlxG.save.data.shitMs--;
		if (FlxG.save.data.shitMs < 0)
			FlxG.save.data.shitMs = 0;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			FlxG.save.data.shitMs = 160;
	}

	public override function right():Bool
	{
		FlxG.save.data.shitMs++;
		display = updateDisplay();
		return true;
	}
	private override function updateDisplay():String{
		return "SHIT: < " + FlxG.save.data.shitMs + " ms >";
	}
}

class OpponentStrumNoteHit extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.opponentGlownHit = !FlxG.save.data.opponentGlownHit;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Opponent Note: < " + (FlxG.save.data.opponentGlownHit ? "Light" : "Static") + " >" + " Hit";
	}
}

class GraphicLoading extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.cacheImages = !FlxG.save.data.cacheImages;
		display = updateDisplay();
		return true;
	}
	private override function updateDisplay():String{
		return "";
	}
}

class EditorRes extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.editorBG = !FlxG.save.data.editorBG;

		display = updateDisplay();
		return true;
	}
	public override function right():Bool{
		left();
		return true;
	}
	private override function updateDisplay():String{
		return "Editor Grid: < " + (FlxG.save.data.editorBG ? "Shown" : "Hidden") + " >";
	}
}

class DownscrollOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Scroll: < " + (FlxG.save.data.downscroll ? "Downscroll" : "Upscroll") + " >";
	}
}

class SongPositionOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function getValue():String{
		return "Song Position Bar: < " + (!FlxG.save.data.songPosition ? "off" : "on") + " >";
	}
}

class DistractionsAndEffectsOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.distractions = !FlxG.save.data.distractions;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Distractions: < " + (!FlxG.save.data.distractions ? "off" : "on") + " >";
	}
}

class ColourBarIconCharOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.colourCharIcon = !FlxG.save.data.colourCharIcon;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Colored HP Bars: < " + (FlxG.save.data.colourCharIcon ? "on" : "off") + " >";
	}
}

class ResetBindOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.resetButton = !FlxG.save.data.resetButton;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "Reset Bind: < " + (!FlxG.save.data.resetButton ? "off" : "on") + " >";
	}
}

class InstantRespawn extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.InstantRespawn = !FlxG.save.data.InstantRespawn;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "Instant Respawn: < " + (!FlxG.save.data.InstantRespawn ? "off" : "on") + " >";
	}
}

class FlashingLightsOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.flashing = !FlxG.save.data.flashing;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Flashing Lights: < " + (!FlxG.save.data.flashing ? "off" : "on") + " >";
	}
}

class AntialiasingOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.antialiasing = !FlxG.save.data.antialiasing;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Antialiasing: < " + (!FlxG.save.data.antialiasing ? "off" : "on") + " >";
	}
}

class MissSoundsOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.missSounds = !FlxG.save.data.missSounds;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "Miss Sounds: < " + (!FlxG.save.data.missSounds ? "off" : "on") + " >";
	}
}

class NewInput extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.newInput = !FlxG.save.data.newInput;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "< " + (FlxG.save.data.newInput ? "New" : "Old") + " > :Input";
	}
}

class Judgement extends Option{
	public function new(desc:String){
		super();
		description = desc;
		acceptValues = true;
	}
	public override function press():Bool{
		OptionsMenu.instance.selectedCatIndex = 6;
		OptionsMenu.instance.switchCat(OptionsMenu.instance.options[6], false);
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Edit Judgements";
	}
}

class FPSOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "Show FPS: < " + (!FlxG.save.data.fps ? "off" : "on") + " >";
	}
}

class MapOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.map = !FlxG.save.data.map;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Map: < " + (!FlxG.save.data.map ? "off" : "on") + " >";
	}
}

class ScoreScreen extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.scoreScreen = !FlxG.save.data.scoreScreen;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Score Screen: < " + (FlxG.save.data.scoreScreen ? "on" : "off") + " >";
	}
}

/*
class ScrollSpeedOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
		acceptValues = true;
	}
	public override function press():Bool{
		return false;
	}
	private override function updateDisplay():String{
		return "Scroll Speed: < " + HelperFunctions.truncateFloat(FlxG.save.data.scrollSpeed, 1) + " >";
	}
	override function right():Bool{
		FlxG.save.data.scrollSpeed += 0.1;
		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.scrollSpeed > 4)
			FlxG.save.data.scrollSpeed = 4;
		return true;
	}
	override function getValue():String{
		return "Scroll Speed: < " + HelperFunctions.truncateFloat(FlxG.save.data.scrollSpeed, 1) + " >";
	}
	override function left():Bool{
		FlxG.save.data.scrollSpeed -= 0.1;
		if (FlxG.save.data.scrollSpeed < 1)
			FlxG.save.data.scrollSpeed = 1;
		if (FlxG.save.data.scrollSpeed > 4)
			FlxG.save.data.scrollSpeed = 4;
		return true;
	}
}

class NPSDisplayOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.npsDisplay = !FlxG.save.data.npsDisplay;
		display = updateDisplay();
		return true;
	}
	public override function right():Bool{
		left();
		return true;
	}
	private override function updateDisplay():String{
		return "NPS Display: < " + (!FlxG.save.data.npsDisplay ? "off" : "on") + " >";
	}
}

/*class CustomizeGameplay extends Option{
	public function new(desc:String){
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}
	public override function press():Bool{
		if (OptionsMenu.isInPause)
			return false;
		trace("switch");
		FlxG.switchState(new GameplayCustomizeState());
		return false;
	}
	private override function updateDisplay():String{
		return "Customize Gameplay";
	}
}*/

class EngineMarkOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		Main.engineMark = !Main.engineMark;
		FlxG.save.data.engineMark = Main.engineMark;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "EngineMark: < " + (Main.engineMark ? "on" : "off") + " >";
	}
}

/*class OffsetMenu extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		PlayState.SONG = Song.loadFromJson('tutorial', '');
		PlayState.isStoryMode = false;
		PlayState.mainDifficulty = 0;
		PlayState.storyWeek = 0;
		PlayState.offsetTesting = true;
		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());
		return false;
	}
	private override function updateDisplay():String{
		return "Time your offset";
	}
}*/

/*class OffsetThing extends Option{
	public function new(desc:String){
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}
	public override function left():Bool{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.save.data.offset--;
		display = updateDisplay();
		return true;
	}
	public override function right():Bool{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.save.data.offset++;
		display = updateDisplay();
		return true;
	}
	private override function updateDisplay():String{
		return "Note offset: < " + HelperFunctions.truncateFloat(FlxG.save.data.offset, 0) + " >";
	}
	public override function getValue():String{
		return "Note offset: < " + HelperFunctions.truncateFloat(FlxG.save.data.offset, 0) + " >";
	}
}*/

class BotPlay extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.botplay = !FlxG.save.data.botplay;
		trace('BotPlay: ' + FlxG.save.data.botplay);
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "BotPlay: < " + (FlxG.save.data.botplay ? "on" : "off") + " >";
	}
}

class CamMoveOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.cameramovehitnote = !FlxG.save.data.cameramovehitnote;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Camera Move: < " + (!FlxG.save.data.cameramovehitnote ? "off" : "on") + " >";
	}
}

class CamZoomOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.camerazoom = !FlxG.save.data.camerazoom;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Camera Zoom: < " + (!FlxG.save.data.camerazoom ? "off" : "on") + " >";
	}
}

class JudgementCounter extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.judgementCounter = !FlxG.save.data.judgementCounter;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "Judgement Counter: < " + (FlxG.save.data.judgementCounter ? "on" : "off") + " >";
	}
}


// Scroll
class MidScrollOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		//if (!FlxG.save.data.hideScrollOpponent)
		FlxG.save.data.midScroll = !FlxG.save.data.midScroll;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Mid Scroll: < " + (FlxG.save.data.midScroll ? "on" : "off") + " >";
	}
}

/*class OpponentScrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		if (!FlxG.save.data.midScroll)
		FlxG.save.data.hideScrollOpponent = !FlxG.save.data.hideScrollOpponent;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Opponent Scroll: < " + (FlxG.save.data.hideScrollOpponent ? "Show" : "Hide") + " >";
	}
}*/

/*class NoteskinOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.save.data.noteskin--;
		if (FlxG.save.data.noteskin < 0)
			FlxG.save.data.noteskin = NoteskinHelpers.getNoteskins().length - 1;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (OptionsMenu.isInPause)
			return false;
		FlxG.save.data.noteskin++;
		if (FlxG.save.data.noteskin > NoteskinHelpers.getNoteskins().length - 1)
			FlxG.save.data.noteskin = 0;
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Current Noteskin: < " + NoteskinHelpers.getNoteskinByID(FlxG.save.data.noteskin) + " >";
	}
}*/

class HealthBarOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function left():Bool{
		FlxG.save.data.healthBar = !FlxG.save.data.healthBar;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		left();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "Health Bar: < " + (FlxG.save.data.healthBar ? "on" : "off") + " >";
	}
}

class DebugMode extends Option{
	public function new(desc:String){
		description = desc;
		super();
	}
	public override function press():Bool{
		FlxG.switchState(new AnimationDebug());
		return false;
	}
	private override function updateDisplay():String{
		return "Animation Debug";
	}
}

class LockWeeksOption extends Option{
	var confirm:Bool = false;
	public function new(desc:String){
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}
	public override function press():Bool{
		if (OptionsMenu.isInPause)
			return false;
		if (!confirm){
			confirm = true;
			display = updateDisplay();
			return true;
		}
		FlxG.save.data.weekUnlocked = 1;
		StoryMenuState.weekUnlocked = [true, true];
		confirm = false;
		trace('Weeks Locked');
		display = updateDisplay();
		return true;
	}
	private override function updateDisplay():String{
		return confirm ? "Confirm Story Reset" : "Reset Story Progress";
	}
}

/*class ResetScoreOption extends Option{
	var confirm:Bool = false;
	public function new(desc:String){
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}
	public override function press():Bool{
		if (OptionsMenu.isInPause)
			return false;
		if (!confirm){
			confirm = true;
			display = updateDisplay();
			return true;
		}
		FlxG.save.data.songScores = null;
		for (key in Highscore.songScores.keys()){
			Highscore.songScores[key] = 0;
		}
		FlxG.save.data.songCombos = null;
		for (key in Highscore.songCombos.keys()){
			Highscore.songCombos[key] = '';
		}
		confirm = false;
		trace('Highscores Wiped');
		display = updateDisplay();
		return true;
	}
	private override function updateDisplay():String{
		return confirm ? "Confirm Score Reset" : "Reset Score";
	}
}*/

class ResetSettings extends Option{
	var confirm:Bool = false;
	public function new(desc:String){
		super();
		if (OptionsMenu.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}
	public override function press():Bool{
		if (OptionsMenu.isInPause)
			return false;
		if (!confirm){
			confirm = true;
			display = updateDisplay();
			return true;
		}
		FlxG.save.data.weekUnlocked = null;
		FlxG.save.data.newInput = null;
		FlxG.save.data.downscroll = null;
		FlxG.save.data.antialiasing = null;
		FlxG.save.data.missSounds = null;
		FlxG.save.data.dfjk = null;
		//FlxG.save.data.offset = null;
		FlxG.save.data.songPosition = null;
		FlxG.save.data.fps = null;
		FlxG.save.data.changedHit = null;
		FlxG.save.data.fpsRain = null;
		FlxG.save.data.fpsCap = null;
		FlxG.save.data.scrollSpeed = null;
		FlxG.save.data.npsDisplay = null;
		FlxG.save.data.frames = null;
		FlxG.save.data.engineMark = null;
		FlxG.save.data.ghost = null;
		FlxG.save.data.distractions = null;
		FlxG.save.data.colour = null;
		FlxG.save.data.stepMania = null;
		FlxG.save.data.flashing = null;
		FlxG.save.data.resetButton = null;
		FlxG.save.data.botplay = null;
		FlxG.save.data.cpuStrums = null;
		FlxG.save.data.strumline = null;
		FlxG.save.data.customStrumLine = null;
		FlxG.save.data.camzoom = null;
		FlxG.save.data.scoreScreen = null;
		FlxG.save.data.inputShow = null;
		FlxG.save.data.map = null;
		FlxG.save.data.cacheImages = null;
		FlxG.save.data.editor = null;
		ClientSave.data();
		confirm = false;
		trace('Reset Settings');
		display = updateDisplay();
		return true;
	}
	private override function updateDisplay():String{
		return confirm ? "Confirm Settings Reset" : "Reset Settings";
	}
}
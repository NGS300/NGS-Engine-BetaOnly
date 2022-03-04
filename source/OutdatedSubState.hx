package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
class OutdatedSubState extends MusicBeatState{
	//var updateVersion:String = "My Dick is Big";
	public static var leftState:Bool = false;
	override function create(){
		super.create();
		/*if (Client.lean)
			Opa Você Está numa Versão da Engine Desatualizado
		else*/
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var updateTxtCheck:FlxText = new FlxText(0, 0, FlxG.width,
			"Hey! You're on an Outdated Engine Version\nCurrent Engine Version Using: "
			+ MainMenuState.engineVersion
			+ " \nNew Version is Available, Update Now "
			+ TitleState.updateVersion
			+ " \nPress Enter to Go to Github or ESCAPE to Ignore This Shit.",
			32);
		updateTxtCheck.setFormat("Highman.ttf", 35, FlxColor.WHITE, CENTER); // Font VCR OSD Mono
		updateTxtCheck.screenCenter();
		add(updateTxtCheck);
	}
	override function update(elapsed:Float){
		if (controls.ACCEPT)
			fancyOpenURL("https://github.com/NGS300/Ngs-Engine/releases");
		if (controls.BACK){
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;

class OptionsDirect extends MusicBeatState{
	override function create(){
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = true;

		StateImage.BGSMenus('Options');
		for (i in StateImage.suckAdd){
			add(i);
		}

		openSubState(new OptionsMenu());
	}
}
package;
import flixel.tweens.FlxTween;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
using StringTools;
class SongMetadata{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public function new(song:String, week:Int, songCharacter:String){
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
class FreeplayState extends MusicBeatState{
	public static var instance:FreeplayState = null;
	public var songs:Array<SongMetadata> = [];
	public var songText:Alphabet;
	public var curSelected:Int = 0;
	var curDifficulty:Int = 2;
	public var curColor:Int;
	public var colorTween:FlxTween;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var iconArray:Array<HealthIcon> = [];
	override function create(){
		instance = this;
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('FreeplayTrackList', 'config'));
		for (i in 0...initSonglist.length)
			songs.push(new SongMetadata(initSonglist[i], 1, 'gf')); // Tutorial Week 0
		if (StoryMenuState.weekUnlocked[2]) // Week 1
			addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);
		if (StoryMenuState.weekUnlocked[2]) // Week 2
			addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster']);
		if (StoryMenuState.weekUnlocked[3]) // Week 3
			addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);
		if (StoryMenuState.weekUnlocked[4]) // Week 4
			addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);
		if (StoryMenuState.weekUnlocked[5]) // Week 5
			addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents', 'parents', 'monster-christmas']);
		if (StoryMenuState.weekUnlocked[6]) // Week 6
			addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai-pixel', 'senpai-pixel', 'spirit-pixel']);
		StateImage.BGSMenus('Freeplay');
		for (i in StateImage.suckAdd){
			add(i);
		}
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);
		for (i in 0...songs.length){
			songText = new Alphabet(0, (90 * i) + 40, songs[i].songName, true, false);
			songText.isFreeplayItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("Highman.ttf"), 36, FlxColor.WHITE, RIGHT);
		scoreText.x -= 425;
		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.75;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);
		add(scoreText);

		changeSelection();
		changeDiff();
		super.create();
	}
	override function update(elapsed:Float){
		super.update(elapsed);
		if (FlxG.sound.music.volume < 0.7)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));
		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		scoreText.text = "Best Score: " + lerpScore;
		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		var rightP = controls.RIGHT_P;
		var goBack = controls.BACK;
		var accepted = controls.ACCEPT;
		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);
		if (leftP)
			changeDiff(-1);
		if (rightP)
			changeDiff(1);
		if (goBack){
			if (colorTween != null)
				colorTween.cancel();
			FlxG.switchState(new MainMenuState());
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
		if (accepted){
			PlayState.SONG = Song.loadFromJson(Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty), songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.mainDifficulty = curDifficulty;
			if (Client.endless)
				PlayState.stateShit = 'Endless';
			else
				PlayState.stateShit = 'Freeplay';
			if (colorTween != null)
				colorTween.cancel();
			StoryMenuState.storyWeek = songs[curSelected].week;
			trace('Current Week ' + "[" + StoryMenuState.storyWeek + "] " + " \nCurrent Difficulty: " + curDifficulty);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}
	function changeSelection(change:Int = 0){
		curSelected += change;
		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
		StateImage.BGSMenus('FreeplayFackShit');
		#if desktop
		DiscordClient.changePresence("In the Freeplay Menu", '\nSelected Track: ' + songs[curSelected].songName, StateImage.changeIcon); // Updating Discord Rich Presence
		#end
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end
		// if (keybind to play){
			#if PRELOAD_ALL
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
			#end
		var bullShit:Int = 0;
		for (i in 0...iconArray.length)
			iconArray[i].alpha = 0.25;
		iconArray[curSelected].alpha = 1;
		for (item in grpSongs.members){
			item.targetY = bullShit - curSelected;
			bullShit++;
			item.alpha = 0.25;
			if (item.targetY == 0)
				item.alpha = 1;
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
	public function addSong(songName:String, weekNum:Int, songCharacter:String){
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}
	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>){
		if (songCharacters == null)
			songCharacters = ['bf'];
		var num:Int = 0;
		for (song in songs){
			addSong(song, weekNum, songCharacters[num]);
			if (songCharacters.length != 1)
				num++;
		}
	}
	function pussy(creampie:Dynamic){
		if (curDifficulty < 0)
			curDifficulty = creampie;
		if (curDifficulty > creampie)
			curDifficulty = 0;
	}
	function changeDiff(change:Int = 0){
		curDifficulty += change;
		if (FlxG.save.data.mode == 3){ // HybridMode
			pussy(CoolUtil.difficultyArray.length);
		}else if (FlxG.save.data.mode == 2){ // HellMode
			pussy(7);
		}else if (FlxG.save.data.mode == 1){ // HardMode
			pussy(5);
		}else{ // NormalMode
			pussy(3);
		}
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end
		diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
	}
}
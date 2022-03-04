package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

using StringTools;

class StoryMenuState extends MusicBeatState{
	var numWeekShit:Int = 0;
	var scoreText:FlxText;
	var weekData:Array<Dynamic> = [ // Week Data Tracks
		['Tutorial'],
		['Bopeebo', 'Fresh', 'Dadbattle'],
		['Spookeez', 'South', "Monster"],
		['Pico', 'Philly', "Blammed"],
		['Satin-Panties', "High", "Milf"],
		['Cocoa', 'Eggnog', 'Winter-Horrorland'],
		['Senpai', 'Roses', 'Thorns']
	];
	public static var storyWeek:Int = 0;
	var curDiffcultyWeek:Int = 1;
	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true];
	var weekCharacters:Array<Dynamic> = [ // Week Chars
		['dad', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['spooky', 'bf', 'gf'],
		['pico', 'bf', 'gf'],
		['mom', 'bf', 'gf'],
		['parents', 'bf', 'gf'],
		['senpai-pixel', 'bf', 'gf']
	];
	var weekNames:Array<String> = [ // Week Names in Story
		"Tutorial",
		"Daddy Dearest",
		"Spooky Month",
		"Pico",
		"Mommy Must Murder",
		"Red Snow",
		"Hating Simulator ft. Moawling"
	];
	var txtWeekTitle:FlxText;
	var curDickStory:Int = 0;
	var txtTracklist:FlxText;
	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	var grpLocks:FlxTypedGroup<FlxSprite>;
	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	override function create(){
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		if (FlxG.sound.music != null)
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		persistentUpdate = persistentDraw = true;
		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("Highman.ttf", 32);
		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("Highman.ttf", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;
		var ui_tex = Paths.getSparrowAtlas('StoryShit/campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, StateImage.StoryBGColor);
		#if desktop
		DiscordClient.changePresence("In StoryMode Menu", '\nSelected Week: ' + 0); // Updating Discord Rich Presence
		#end
		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);
		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);
		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();
		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);
		for (i in 0...weekData.length){ // Week Data Shit :D
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);
			weekThing.screenCenter(X);
			weekThing.antialiasing = Client.Antialiasing;
			if (!weekUnlocked[i]){
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = Client.Antialiasing;
				grpLocks.add(lock);
			}
		}
		for (char in 0...3){
			var weekCharShit:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, weekCharacters[curDickStory][char]);
			weekCharShit.y += 70;
			weekCharShit.antialiasing = Client.Antialiasing;
			switch (weekCharShit.character){
				case 'dad':
					SetSuckThis(weekCharShit, 0.5);
				case 'bf':
					SetSuckThis(weekCharShit, 0.8);
					weekCharShit.x -= 70; // old 80
				case 'gf':
					SetSuckThis(weekCharShit, 0.5);
				case 'parents':
					SetSuckThis(weekCharShit, 0.9);
			}
			grpWeekCharacters.add(weekCharShit);
		}
		difficultySelectors = new FlxGroup();
		add(difficultySelectors);
		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10); // Left Arrow Difficulty Switch
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);
		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y); // Difficulty Sprites
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		changeDifficulty();
		difficultySelectors.add(sprDifficulty);
		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y); // Right Arrow Difficulty Switch
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);
		add(yellowBG);
		add(grpWeekCharacters);
		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks:", 32); // TrackList Song Names
		txtTracklist.alignment = CENTER;
		txtTracklist.setFormat(Paths.font("Highman.ttf"), 32);
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		add(scoreText);
		add(txtWeekTitle);
		updateText();
		super.create();
	}
	override function update(elapsed:Float){
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));
		scoreText.text = "Week Score:" + lerpScore;
		txtWeekTitle.text = weekNames[curDickStory].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);
		difficultySelectors.visible = weekUnlocked[curDickStory];
		grpLocks.forEach(function(lock:FlxSprite){
			lock.y = grpWeekText.members[lock.ID].y;
		});
		if (!movedBack){
			if (!selectedWeek){
				if (controls.UP_P)
					changeWeek(-1);
				if (controls.DOWN_P)
					changeWeek(1);
				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');
				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');
				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}
			if (controls.ACCEPT)
				selectWeek();
		}
		if (controls.BACK && !movedBack && !selectedWeek){
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;
	function selectWeek(){
		if (weekUnlocked[curDickStory]){
			if (stopspamming == false){
				FlxG.sound.play(Paths.sound('confirmMenu'));
				grpWeekText.members[curDickStory].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}
			PlayState.storyPlaylist = weekData[curDickStory];
			PlayState.isStoryMode = true;
			selectedWeek = true;
			PlayState.stateShit = 'StoryMode';
			PlayState.mainDifficulty = curDiffcultyWeek;
			trace("Selected Week: " + curDickStory + " \nTrack: " + PlayState.storyPlaylist[0].toLowerCase() + CoolUtil.checkDifficultyData(curDiffcultyWeek));
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + CoolUtil.checkDifficultyData(curDiffcultyWeek), PlayState.storyPlaylist[0].toLowerCase());
			storyWeek = curDickStory;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer){
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}
	function cum(pussy:Dynamic){
		if (curDiffcultyWeek < 0)
			curDiffcultyWeek = pussy;
		if (curDiffcultyWeek > pussy)
			curDiffcultyWeek = 0;
	}
	function changeDifficulty(change:Int = 0):Void{
		curDiffcultyWeek += change;
		if (FlxG.save.data.mode == 3){ // HybridMode
			cum(CoolUtil.difficultyArray.length);
		}else if (FlxG.save.data.mode == 2){ // HellMode
			cum(7);
		}else if (FlxG.save.data.mode == 1){ // HardMode
			cum(5);
		}else{ // NormalMode
			cum(3);
		}

		difficultySpriteSet(curDiffcultyWeek);
		intendedScore = Highscore.getWeekScore(curDickStory, curDiffcultyWeek);
		#if !switch
		intendedScore = Highscore.getWeekScore(curDickStory, curDiffcultyWeek);
		#end
	}
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	function changeWeek(change:Int = 0):Void{
		curDickStory += change;
		if (curDickStory >= weekData.length)
			curDickStory = 0;
		if (curDickStory < 0)
			curDickStory = weekData.length - 1;
		#if desktop
		DiscordClient.changePresence("In StoryMode Menu", '\nSelected Week: ' + curDickStory); // Updating Discord Rich Presence
		#end
		var bullShit:Int = 0;
		for (item in grpWeekText.members){
			item.targetY = bullShit - curDickStory;
			if (item.targetY == Std.int(0) && weekUnlocked[curDickStory])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
		updateText();
	}
	function updateText(){
		grpWeekCharacters.members[0].animation.play(weekCharacters[curDickStory][0]);
		grpWeekCharacters.members[1].animation.play(weekCharacters[curDickStory][1]);
		grpWeekCharacters.members[2].animation.play(weekCharacters[curDickStory][2]);
		txtTracklist.text = "Tracks\n";
		SetMainOffset();
		var stringThing:Array<String> = weekData[curDickStory];
		for (i in stringThing)
			txtTracklist.text += "\n" + i;
		txtTracklist.text = txtTracklist.text.toUpperCase();
		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;
		#if !switch
		intendedScore = Highscore.getWeekScore(curDickStory, curDiffcultyWeek);
		#end
	}
	function SetMainOffset(){
		switch (grpWeekCharacters.members[0].animation.curAnim.name){
			default:
				SetCharOffset();
				SetCharSize();
				GetFlip('X');
			case 'dad':
				SetCharSize();
				SetCharOffset(150, 200);
				GetFlip('X');
			case 'spooky':
				SetCharSize(1.2);
				SetCharOffset(200);
				GetFlip('X');
			case 'pico':
				SetCharSize(1.2);
				SetCharOffset(180, 67);
				GetFlip('X', true);
			case 'mom':
				SetCharSize();
				SetCharOffset(150, 200);
				GetFlip('X');
			case 'parents':
				SetCharSize(1.8);
				SetCharOffset(260, 185);
				GetFlip('X');
			case 'senpai-pixel':
				SetCharSize(1.4);
				SetCharOffset(130, 0);
				GetFlip('X');
		}
	}
	function difficultySpriteSet(curDiffcultyWeek:Int){
		setDifSpriteOffset(0, null); // test
		switch (curDiffcultyWeek){
			case 0:
				sprDifficulty.animation.play('easy');
				setDifSpriteOffset(20, null);
			case 1:
				sprDifficulty.animation.play('normal');
				setDifSpriteOffset(70, null);
			case 2:
				sprDifficulty.animation.play('hard');
				setDifSpriteOffset(20, null);
			case 3:
				sprDifficulty.animation.play('hard');
				setDifSpriteOffset(20, null);
		}
		sprDifficulty.alpha = 0;
		sprDifficulty.y = leftArrow.y - 15;
		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}
	function setDifSpriteOffset(Xpos:Null<Float>, Ypos:Null<Float>){
		sprDifficulty.offset.x = Xpos;
		sprDifficulty.offset.y = Ypos;
	}
	function SetCharOffset(offsetX:Int = 100, offsetY:Int = 100, ?memberNumShit = 0){
		grpWeekCharacters.members[memberNumShit].offset.set(offsetX, offsetY);
	}
	function SetCharSize(suck:Float = 1, ?memberNumShit = 0){
		grpWeekCharacters.members[memberNumShit].setGraphicSize(Std.int(grpWeekCharacters.members[memberNumShit].width * suck));
	}
	function GetFlip(anyFlip:String, shitForce:Bool = false, ?memberNumShit:Int = 0){
		if (anyFlip == 'X')
			grpWeekCharacters.members[memberNumShit].flipX = shitForce;
		if (anyFlip == 'Y')
			grpWeekCharacters.members[memberNumShit].flipY = shitForce;
	}
	function SetSuckThis(spriteShit:FlxSprite, bruh:Float = 1){
		spriteShit.setGraphicSize(Std.int(spriteShit.width * bruh));
		spriteShit.updateHitbox();
	}
}
package;
import Discord.DiscordClient;
import flixel.FlxCamera;
import flixel.FlxSubState;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
class OptionCata extends FlxSprite{
	public var title:String;
	public var options:Array<Option>;
	public var optionObjects:FlxTypedGroup<FlxText>;
	public var titleObject:FlxText;
	public var middle:Bool = false;
	public function new(x:Float, y:Float, _title:String, _options:Array<Option>, middleType:Bool = false){
		super(x, y);
		title = _title;
		middle = middleType;
		if (!middleType)
			makeGraphic(295, 64, FlxColor.BLACK);
		alpha = 0.5;
		options = _options;
		optionObjects = new FlxTypedGroup();
		titleObject = new FlxText((middleType ? 1180 / 2 : x), y + (middleType ? 0 : 16), 0, title);
		titleObject.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleObject.borderSize = 3;
		if (middleType)
			titleObject.x = 50 + ((1180 / 2) - (titleObject.fieldWidth / 2));
		else
			titleObject.x += (width / 2) - (titleObject.fieldWidth / 2);
		titleObject.scrollFactor.set();
		scrollFactor.set();
		for (i in 0...options.length){
			var opt = options[i];
			var text:FlxText = new FlxText((middleType ? 1180 / 2 : 72), titleObject.y + 54 + (46 * i), 0, opt.getValue());
			if (middleType)
				text.screenCenter(X);
			text.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.borderSize = 3;
			text.borderQuality = 1;
			text.scrollFactor.set();
			optionObjects.add(text);
		}
	}
	public function changeColor(color:FlxColor){
		makeGraphic(295, 64, color);
	}
}
class OptionsMenu extends FlxSubState{
	public static var instance:OptionsMenu;
	public var background:FlxSprite;
	public var selectedCat:OptionCata;
	public var selectedOption:Option;
	public var selectedCatIndex = 0;
	public var selectedOptionIndex = 0;
	public var isInCat:Bool = false;
	public var options:Array<OptionCata>;
	public static var isInPause = false;
	public var shownStuff:FlxTypedGroup<FlxText>;
	public static var visibleRange = [114, 640];
	public function new(pauseMenu:Bool = false){
		super();
		isInPause = pauseMenu;
	}
	public var menu:FlxTypedGroup<FlxSprite>;
	public var descText:FlxText;
	public var descBack:FlxSprite;
	override function create(){
		#if desktop
		DiscordClient.changePresence("In Settings", null, null, true); // Updating Discord Rich Presence
		#end
		options = [
			new OptionCata(50, 40, "Gameplay", [
				new MidScrollOption("You Strum in The Center of Game."),
				new DownscrollOption("Toggle making the notes scroll down rather than up."),
				new EndlessShitOption("Endless-Mode Only in Freeplay :D"),
				new CamMoveOption("Enable or Disable Camera Move on Diretion Hit Notes. :D"),
				new CamZoomOption("Enable or Disable Camera Zoom on Beat of Track."),
				new FPSCamOption("FPS camera, The Higher it Gets the Faster."),
				//new ScrollSpeedOption("Change your scroll speed. (1 = Chart dependent)"),
				//new OffsetThing("Change the note audio offset (how many milliseconds a note is offset in a chart)"),
				new NewInput("Toggle New Imput, You Can Press Any Arrow or Old Imput You Can't Press Any Arrow no Notes Passing."),
				new BotPlay("i no Like This But is Suck, Bot Play you Game ;-;"),
				new ResetBindOption("Toggle to Press R to Die."),
				new InstantRespawn("Toggle if you instantly respawn after dying."),
				// new OffsetMenu("Get a note offset based off of your inputs!"),
				new ModesOption(""),
				new HUDOption(),
				new DFJKOption(),
			]),
			new OptionCata(345, 40, "Appearance", [
				new MapOption("Enable or Disable for Show ou Hide Map for More FPS or Effects."),
				//new NoteskinOption("Change your current noteskin"), new EditorRes("Not showing the editor grid will greatly increase editor performance"),
				new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay."),
				//new HealthBarOption("Toggles health bar visibility"),
				new JudgementCounter("Show your judgements that you've gotten in the song"),
				new SongPositionOption("Show the song's current position as a scrolling bar."),
				new ColourBarIconCharOption("Set Health Colors of Char Icons. (example Tankman = black)"),
				//new NPSDisplayOption("Shows your current Notes Per Second on the info bar."),
				//new RainbowFPSOption("Make the FPS Counter flicker through rainbow colors."),
				new OpponentStrumNoteHit("Toggle Opponent Hit Glown Notes."),
			]),
			new OptionCata(640, 40, "Misc", [
				new FPSOption("Show You Current FPS."),
				new FlashingLightsOption("Toggle flashing lights that can cause epileptic seizures and strain."),
				new EngineMarkOption("Enable and disable Engine Watermarks."),
				new AntialiasingOption("Toggle antialiasing, improving graphics quality at a slight performance penalty."),
				new MissSoundsOption("Toggle miss sounds playing when you don't hit a note."),
				//new ScoreScreen("Show the score screen after the end of a song"),
				//new ShowInput("Display every single input on the score screen."),
			]),
			new OptionCata(935, 40, "Saves", [
				//new ResetScoreOption("Reset your score on all songs and weeks. This is irreversible!"),
				new LockWeeksOption("Reset your story mode progress. This is irreversible!"),
				new ResetSettings("Reset ALL your settings. This is irreversible!")
			]),
			new OptionCata(1000, 40, "Pussy", [ // Is Here to Fix Bug Shit :l
			]),
			new OptionCata(-1, 125, "Keybinds Editing", [
				new LeftKeybind("Left Note's Keybind"), 
				new DownKeybind("Down Note's Keybind"), 
				new UpKeybind("Up Note's Keybind"),
				new RightKeybind("Right Note's Keybind"),
				new DodgeKeybind("Dodge KeyBind."),
				new PauseKeybind("Keybind Used to Pause the Game."),
				new ResetBind("keybind Kill to Die."), 
				new MuteBind("Keybind Use to Mute Audio."),
			], true),
			new OptionCata(-1, 125, "HUD Editing", [
				new IconHUDOption("Show or Hide Player Icons."),
				new RatingHUDOption("Rating in Strum you Hit Note, Rating Show in Strum you Hited, Defualt is Default in Center."),
			], true)
		];
		instance = this;
		menu = new FlxTypedGroup<FlxSprite>();
		shownStuff = new FlxTypedGroup<FlxText>();

		background = new FlxSprite(50, 40).makeGraphic(1180, 640, FlxColor.BLACK);
		background.alpha = 0.5;
		background.scrollFactor.set();
		menu.add(background);

		descBack = new FlxSprite(50, 640).makeGraphic(1180, 38, FlxColor.BLACK);
		descBack.alpha = 0.3;
		descBack.scrollFactor.set();
		menu.add(descBack);

		if (isInPause){
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.alpha = 0;
			bg.scrollFactor.set();
			menu.add(bg);
			background.alpha = 0.5;
			bg.alpha = 0.625;
			cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		}
		selectedCat = options[0];
		selectedOption = selectedCat.options[0];
		add(menu);
		add(shownStuff);

		for (i in 0...options.length - 1){
			if (i >= 4)
				continue;
			var cat = options[i];
			add(cat);
			add(cat.titleObject);
		}

		descText = new FlxText(62, 648);
		descText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.borderSize = 2;
		add(descBack);
		add(descText);

		isInCat = true;
		switchCat(selectedCat);
		selectedOption = selectedCat.options[0];
		super.create();
	}
	public function switchCat(cat:OptionCata, checkForOutOfBounds:Bool = true){
		try{
			visibleRange = [114, 640];
			if (cat.middle)
				visibleRange = [Std.int(cat.titleObject.y), 640];
			if (selectedOption != null){
				var object = selectedCat.optionObjects.members[selectedOptionIndex];
				object.text = selectedOption.getValue();
			}
			if (selectedCatIndex > options.length - 3 && checkForOutOfBounds)
				selectedCatIndex = 0;
			if (selectedCat.middle)
				remove(selectedCat.titleObject);
			selectedCat.changeColor(FlxColor.BLACK);
			selectedCat.alpha = 0.3;
			for (i in 0...selectedCat.options.length){
				var opt = selectedCat.optionObjects.members[i];
				opt.y = selectedCat.titleObject.y + 54 + (46 * i);
			}
			while (shownStuff.members.length != 0)
				shownStuff.members.remove(shownStuff.members[0]);
			selectedCat = cat;
			selectedCat.alpha = 0.2;
			selectedCat.changeColor(FlxColor.WHITE);
			if (selectedCat.middle)
				add(selectedCat.titleObject);
			for (i in selectedCat.optionObjects)
				shownStuff.add(i);
			selectedOption = selectedCat.options[0];
			if (selectedOptionIndex > options[selectedCatIndex].options.length - 1){
				for (i in 0...selectedCat.options.length){
					var opt = selectedCat.optionObjects.members[i];
					opt.y = selectedCat.titleObject.y + 54 + (46 * i);
				}
			}
			selectedOptionIndex = 0;
			if (!isInCat)
				selectOption(selectedOption);
			for (i in selectedCat.optionObjects.members){
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else
					i.alpha = 0.4;
			}
		}catch (e)
			selectedCatIndex = 0;
	}
	public function selectOption(option:Option){
		var object = selectedCat.optionObjects.members[selectedOptionIndex];
		selectedOption = option;
		if (!isInCat){
			object.text = "> " + option.getValue();
			descText.text = option.getDescription();
		}
	}
	public static var itIsNecessaryToRestart:Bool = true;
	override function update(elapsed:Float){
		super.update(elapsed);
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		var accept = false;
		var right = false;
		var left = false;
		var up = false;
		var down = false;
		var any = false;
		var escape = false;
		var r = false;
		accept = FlxG.keys.justPressed.ENTER || (gamepad != null ? gamepad.justPressed.A : false);
		right = FlxG.keys.justPressed.RIGHT || (gamepad != null ? gamepad.justPressed.DPAD_RIGHT : false);
		left = FlxG.keys.justPressed.LEFT || (gamepad != null ? gamepad.justPressed.DPAD_LEFT : false);
		up = FlxG.keys.justPressed.UP || (gamepad != null ? gamepad.justPressed.DPAD_UP : false);
		down = FlxG.keys.justPressed.DOWN || (gamepad != null ? gamepad.justPressed.DPAD_DOWN : false);
		r = FlxG.keys.justPressed.R || (gamepad != null ? gamepad.justPressed.START : false);
		any = FlxG.keys.justPressed.ANY || (gamepad != null ? gamepad.justPressed.ANY : false);
		escape = FlxG.keys.justPressed.ESCAPE || (gamepad != null ? gamepad.justPressed.B : false);
		if (r){
			FlxG.save.data.midScroll = false;
			//FlxG.save.data.hideScrollOpponent = false;
			FlxG.save.data.botplay = false;
		}
		if (selectedCat != null && !isInCat){
			for (i in selectedCat.optionObjects.members){
				if (selectedCat.middle)
					i.screenCenter(X);
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else{
					if (selectedCat.optionObjects.members[selectedOptionIndex].text != i.text)
						i.alpha = 0.4;
					else
						i.alpha = 1;
				}
			}
		}try{
			if (isInCat){
				descText.text = "Please select a category";
				if (right){
					FlxG.sound.play(Paths.sound('scrollMenu'));
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
					selectedCatIndex++;
					if (selectedCatIndex > options.length - 3)
						selectedCatIndex = 0;
					if (selectedCatIndex < 0)
						selectedCatIndex = options.length - 3;
					switchCat(options[selectedCatIndex]);
				}else if (left){
					FlxG.sound.play(Paths.sound('scrollMenu'));
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
					selectedCatIndex--;
					if (selectedCatIndex > options.length - 3)
						selectedCatIndex = 0;
					if (selectedCatIndex < 0)
						selectedCatIndex = options.length - 3;
					switchCat(options[selectedCatIndex]);
				}
				if (accept){
					FlxG.sound.play(Paths.sound('scrollMenu'));
					selectedOptionIndex = 0;
					isInCat = false;
					selectOption(selectedCat.options[0]);
				}
				if (escape){
					if (!isInPause)
						FlxG.switchState(new MainMenuState());
					else{
						PauseSubState.goBack = true;
						//PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed * PlayState.songMultiplier;
						if (!itIsNecessaryToRestart){
						}else{
							PlayState.loops = 0;
							PlayState.death = 0;
							FlxG.resetState();
						}
						close();
					}
				}
			}else{
				if (selectedOption != null)
					if (selectedOption.acceptType){
						if (escape && selectedOption.waitingType){
							FlxG.sound.play(Paths.sound('scrollMenu'));
							selectedOption.waitingType = false;
							var object = selectedCat.optionObjects.members[selectedOptionIndex];
							object.text = "> " + selectedOption.getValue();
							return;
						}else if (any){
							var object = selectedCat.optionObjects.members[selectedOptionIndex];
							selectedOption.onType(gamepad == null ? FlxG.keys.getIsDown()[0].ID.toString() : gamepad.firstJustPressedID());
							object.text = "> " + selectedOption.getValue();
						}
					}
				if (selectedOption.acceptType || !selectedOption.acceptType){
					if (accept){
						var prev = selectedOptionIndex;
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.press();
						if (selectedOptionIndex == prev){
							FlxG.save.flush();
							object.text = "> " + selectedOption.getValue();
						}
					}
					if (down){
						if (selectedOption.acceptType)
							selectedOption.waitingType = false;
						FlxG.sound.play(Paths.sound('scrollMenu'));
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						selectedOptionIndex++;
						if (selectedOptionIndex > options[selectedCatIndex].options.length - 1){
							for (i in 0...selectedCat.options.length){
								var opt = selectedCat.optionObjects.members[i];
								opt.y = selectedCat.titleObject.y + 54 + (46 * i);
							}
							selectedOptionIndex = 0;
						}
						if (selectedOptionIndex != 0 && selectedOptionIndex != options[selectedCatIndex].options.length - 1 && options[selectedCatIndex].options.length > 6){
							if (selectedOptionIndex >= (options[selectedCatIndex].options.length - 1) / 2)
								for (i in selectedCat.optionObjects.members)
									i.y -= 46;
						}
						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}else if (up){
						if (selectedOption.acceptType)
							selectedOption.waitingType = false;
						FlxG.sound.play(Paths.sound('scrollMenu'));
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						selectedOptionIndex--;
						if (selectedOptionIndex < 0){
							selectedOptionIndex = options[selectedCatIndex].options.length - 1;
							if (options[selectedCatIndex].options.length > 6)
								for (i in selectedCat.optionObjects.members)
									i.y -= (46 * ((options[selectedCatIndex].options.length - 1) / 2));
						}
						if (selectedOptionIndex != 0 && options[selectedCatIndex].options.length > 6){
							if (selectedOptionIndex >= (options[selectedCatIndex].options.length - 1) / 2)
								for (i in selectedCat.optionObjects.members)
									i.y += 46;
						}
						if (selectedOptionIndex < (options[selectedCatIndex].options.length - 1) / 2){
							for (i in 0...selectedCat.options.length){
								var opt = selectedCat.optionObjects.members[i];
								opt.y = selectedCat.titleObject.y + 54 + (46 * i);
							}
						}
						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}
					if (right){
						FlxG.sound.play(Paths.sound('scrollMenu'));
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.right();
						FlxG.save.flush();
						object.text = "> " + selectedOption.getValue();
					}else if (left){
						FlxG.sound.play(Paths.sound('scrollMenu'));
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.left();
						FlxG.save.flush();
						object.text = "> " + selectedOption.getValue();
					}
					if (escape){
						FlxG.sound.play(Paths.sound('scrollMenu'));
						if (selectedCatIndex >= 4)
							selectedCatIndex = 0;
						PlayerSettings.player1.controls.loadKeyBinds();
						/*Rating.timingWindows = [
							FlxG.save.data.shitMs,
							FlxG.save.data.badMs,
							FlxG.save.data.goodMs,
							FlxG.save.data.sickMs
						];*/
						for (i in 0...selectedCat.options.length){
							var opt = selectedCat.optionObjects.members[i];
							opt.y = selectedCat.titleObject.y + 54 + (46 * i);
						}
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						isInCat = true;
						if (selectedCat.optionObjects != null)
							for (i in selectedCat.optionObjects.members){
								if (i != null){
									if (i.y < visibleRange[0] - 24)
										i.alpha = 0;
									else if (i.y > visibleRange[1] - 24)
										i.alpha = 0;
									else
										i.alpha = 0.4;
								}
							}
						if (selectedCat.middle)
							switchCat(options[0]);
					}
				}
			}
		}catch (e){
			selectedCatIndex = 0;
			selectedOptionIndex = 0;
			FlxG.sound.play(Paths.sound('scrollMenu'));
			if (selectedCat != null){
				for (i in 0...selectedCat.options.length){
					var opt = selectedCat.optionObjects.members[i];
					opt.y = selectedCat.titleObject.y + 54 + (46 * i);
				}
				selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
				isInCat = true;
			}
		}
	}
}
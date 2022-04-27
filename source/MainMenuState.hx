package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState{
	public static var engineVersion:String = "0.9";
	var curSelected:Int = 0;
	var menuItems:FlxTypedGroup<FlxSprite>;
	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end
	var camFollow:FlxObject;
	var selectedSomethin:Bool = false;
	override function create(){
		#if desktop
		DiscordClient.changePresence("In the MainMenu", null); // Updating Discord Rich Presence
		#end
		/*if (Client.mid){
			FlxG.save.data.hideScrollOpponent = false;
		}else{
			FlxG.save.data.hideScrollOpponent = true;
		}*/
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		persistentUpdate = persistentDraw = true;
		StateImage.BGSMenus('MainMenu');
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		StateImage.BGSMenus('MainMenuUnder');
		for (i in StateImage.suckAdd)
			add(i);
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		for (i in 0...optionShit.length){
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = Client.Antialiasing;
		}
		FlxG.camera.follow(camFollow, null, 0.06);
		var versionShit:FlxText = new FlxText(1, FlxG.height - 25, 0, "NG'S Engine Beta v" + engineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Highman.tff", 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		changeItem();
		super.create();
	}
	override function update(elapsed:Float){
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		if (!selectedSomethin){
			if (controls.UP_P){
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}
			if (controls.DOWN_P){
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}
			if (controls.BACK)
				FlxG.switchState(new TitleState());
			if (controls.ACCEPT){
				if (optionShit[curSelected] == 'donate'){
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}else{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(StateImage.magenta, 1.1, 0.15, false);
					menuItems.forEach(function(spr:FlxSprite){
						if (curSelected != spr.ID){
							FlxTween.tween(spr, {alpha: 0}, 0.4,{
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween){
									spr.kill();
								}
							});
						}else{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker){
								var daChoice:String = optionShit[curSelected];
								switch (daChoice){
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("StoryMode Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());
										trace("Freeplay Selected");
									case 'options':
										FlxG.switchState(new OptionsDirect());
										trace("Options Selected");
								}
							});
						}
					});
				}
			}
		}
		super.update(elapsed);
		menuItems.forEach(function(spr:FlxSprite){
			spr.screenCenter(X);
		});
	}
	function changeItem(huh:Int = 0)
	{
		curSelected += huh;
		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		menuItems.forEach(function(spr:FlxSprite){
			spr.animation.play('idle');
			if (spr.ID == curSelected){
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}
			spr.updateHitbox();
		});
	}
}
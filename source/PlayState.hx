package;
import flixel.addons.plugin.screengrab.FlxScreenGrab;
import flixel.addons.plugin.taskManager.FlxTask;
import haxe.macro.Expr.Case;
#if desktop
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import openfl.ui.KeyLocation;
import openfl.events.Event;
import haxe.EnumTools;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;
import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.util.FlxAxes;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
using StringTools;
class PlayState extends MusicBeatState{
	public static var instance:PlayState = null;
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyPlaylist:Array<String> = [];
	public static var mainDifficulty:Int = 2;
	public static var death:Int = 0;
	public static var numDifficulty = CoolUtil.difficultyFromInt(mainDifficulty);

	// HUD Scores
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public static var misses:Int = 0;
	public static var loops:Int = 0;

	// in brain
	//var arrowMax:Array<Int> = [4];
	//var numArrow:Int = 0;

	// Accuracy
	public var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	var notesHit:Float = 0;
	var notesPassing:Float = 0;

	private var ss:Bool = false;
	public static var stepOfLast = 0;
	private var vocals:FlxSound;

	// Camera Move Items
	public  var camFollowMove:Bool = true;
	public  var cameramove:Bool = false;
	public  var camX:Int = 0;
	public  var camY:Int = 0;
	public  var bfcamX:Int = 0;
	public  var bfcamY:Int = 0;

	// Chars 
	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Boyfriend;

	// Shit Chars
	var pico:Character;
	var mom:Character;

	public static var endTrack:Bool = false;
	var canDie:Bool = true;


	// Bool Chars
	public var isPlayerMain:Bool = false;
	public var isOpponentMain:Bool = false;
	public var isPicoPlayer:Bool = false;
	public var ismom:Bool = false;

	public  var iconColorSwitch:Bool = false;

	private var notes:FlxTypedGroup<Note>;

	public var dick:FlxTypedGroup<Note>;


	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private var triggeredAlready:Bool = false;
	private var allowedToHeadbang:Bool = false;

	public static var theFunne:Bool = true;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var opponentStrums:FlxTypedGroup<FlxSprite> = null;

	private var camZooming:Bool = false;
	public var curTrack:String = "";

	public var gfSpeed:Int = 1;

	// Health
	public var health:Float = 1;
	public var healthPercent:Int = 50;

	// Combo
	public var combo:Int = 0;

	public var healthBarBG:FlxSprite;
	public var healthBar:FlxBar;

	var bfDodging:Bool = false;
	var bfCanDodge:Bool = false;
	var bfDodgeTiming:Float = 0.22625;
	var bfDodgeCooldown:Float = 0.1135;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public static var iconP1:HealthIcon;
	public static var iconP2:HealthIcon;

	// Cams
	public static var camMidBG:FlxCamera;
	public static var camCutcene:FlxCamera;
	public static var camNOTE:FlxCamera;
	public static var camHUD:FlxCamera;
	public static var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var trackScoreDefault:Int = 0;
	public var chartScore:Int = 0;

	// HudTexts
	public var scoreTxt:FlxText;
	public var missTxt:FlxText;
	public var accuracyTxt:FlxText;

	// Diretions Shits
	public var diretionSing:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	public var diretionDodge:Array<String> = ['DODGE', 'DODGE', 'DODGE', 'DODGE'];
	public var diretionShoot:Array<String> = ['Shoot', 'Shoot', 'Shoot', 'Shoot'];
	//public var diretionSing:Array<String> = [];
	//public var diretionDodge:Array<String> = [];
	//public var diretionShoot:Array<String> = [];

	public static var campaignScore:Int = 0;

	public var inCutscene:Bool = false;
	public static var stateShit:String = 'StoryMode';
	#if desktop // Discord RPC variables
	public var mainDifficultyText:String = "";
	public var iconRPC:String = "";
	public var songLength:Float = 0;
	public var detailsText:String = "";
	public var detailsPausedText:String = "";
	#end

	var iconOffset:Int = 26;

	//Trails
	public var bfThornsTrail:FlxTrail; 
	override public function create(){
		instance = this;
		endTrack = false;
		HealthIcon.onPlayState = true;
		ClientPush.pushData();
		FlxG.mouse.visible = false;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		if (!Client.endless && !Client.bot){
			sicks = 0;
			bads = 0;
			shits = 0;
			goods = 0;
			combo = 0;
			misses = 0;
		}

		// Cams
		camGame = new FlxCamera();
		camMidBG = new FlxCamera();
		camMidBG.bgColor.alpha = 0;
		camCutcene = new FlxCamera();
		camCutcene.bgColor.alpha = 0;
		camNOTE = new FlxCamera();
		camNOTE.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camMidBG);
		FlxG.cameras.add(camCutcene);
		FlxG.cameras.add(camNOTE);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];
		persistentUpdate = true;
		persistentDraw = true;
		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');
		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);
		if (Paths.txtExistiShi(Paths.txtAny('data/dialogueTracks/${SONG.song.toLowerCase()}/dialogue', 'shared'))) // Dialogue Dick
			dialogue = CoolUtil.coolTextFile(Paths.txtAny('data/dialogueTracks/${SONG.song.toLowerCase()}/dialogue', 'shared'));
		#if desktop // Making difficulty text for Discord Rich Presence.
		mainDifficultyText = CoolUtil.difficultyFromInt(mainDifficulty);
		iconRPC = SONG.player2;
		switch (iconRPC){
			case 'mom-car':
				iconRPC = 'mom';
			case 'parents':
				iconRPC = 'parents-christmas';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'senpai-angry-pixel':
				iconRPC = 'senpai';
		}
		if (isStoryMode){
			detailsText = "Story-Mode: Week " + StoryMenuState.storyWeek;
			stateShit = 'StoryMode';
		}else{
			if (Client.endless){
				detailsText = "Endless-Mode";
				stateShit = 'Endless';
			}else{
				detailsText = "Freeplay";
				stateShit = 'Freeplay';
			}
		}
		detailsPausedText = "Paused - " + detailsText; // String for when the game is paused
		DiscordClient.changePresence(detailsText, SONG.song + " (" + mainDifficultyText + ")", iconRPC); // Updating Discord Rich Presence.
		#end
		switch (SONG.song.toLowerCase()){ // Push Tracks Maps of TrackMao.hx, Just Make You Map :D
			default:
				TrackMap.LoadMap();
				TrackMap.LoadGFType();
            case 'spookeez' | 'south' | 'monster':
				TrackMap.LoadMap('spooky');
				TrackMap.LoadGFType();
		    case 'pico' | 'blammed' | 'philly':
				TrackMap.LoadMap('philly');
				TrackMap.LoadGFType();
		    case 'milf' | 'satin-panties' | 'high':
				TrackMap.LoadMap('limo');
				TrackMap.LoadGFType('gf-car');
		    case 'cocoa' | 'eggnog':
				TrackMap.LoadMap('mall');
				TrackMap.LoadGFType('gf-christmas');
		    case 'winter-horrorland':
				TrackMap.LoadMap('mallEvil');
		    case 'senpai' | 'roses':
				TrackMap.LoadMap('pixSchool');
				TrackMap.LoadGFType('gf-pixel');
		    case 'thorns':
		        TrackMap.LoadMap('pixSchoolEvil');
				TrackMap.LoadGFType('gf-pixel');
        }
		if (Client.Map)
			for (i in TrackMap.fackAdd)
				add(i);
		gf = new Character(400, 130, TrackMap.gfVersion);
		gf.scrollFactor.set(0.95, 0.95);
		dad = new Character(100, 100, SONG.player2);
		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
		switch (SONG.player2){ // Set Opponents Positions
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode){
					camPos.x += 600;
					tweenCamIn('Opponent', 1.5);
				}
			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				dad.y += 300;
			case 'parents':
				dad.x -= 500;
			case 'senpai-pixel':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry-pixel':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit-pixel':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1); // Player Main Char

		// Shit Chars
		pico = new Character(300, 100, 'pico');
		mom = new Character(-300, 100, 'mom');

		switch (TrackMap.curMap){ // Set Chars Positions
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				TrackMap.resetFastCar();
				add(TrackMap.fastCar);
			case 'mall':
				boyfriend.x += 200;
			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'pixSchool':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'pixSchoolEvil':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				add(evilTrail);
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}
		if (Client.Map){
			if (!(TrackMap.curMap == 'mallEvil'))
				add(gf);
			if (TrackMap.curMap == 'limo')
				add(TrackMap.limo);
			add(dad);
			add(boyfriend);
		}
		var logShit:DialogueBox = new DialogueBox(false, dialogue);
		logShit.scrollFactor.set();
		logShit.finishThing = startCountdown;
		Conductor.songPosition = -5000;
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		if (Client.isDownscroll)
			strumLine.y = FlxG.height - 165;
		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		playerStrums = new FlxTypedGroup<FlxSprite>();
		opponentStrums = new FlxTypedGroup<FlxSprite>();
		generateSong(SONG.song);
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);
		if (prevCamFollow != null){
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		add(camFollow);
		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (Client.fpsCam / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		FlxG.camera.zoom = TrackMap.camZoom;
		FlxG.camera.focusOn(camFollow.getPosition());
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
		FlxG.fixedTimestep = false;

		// Health BackGround of Healthbar Colors
		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (Client.isDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		//healthBarBG.visible = Client.;
		add(healthBarBG);

		// Health Bar Colors
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'health', 0, 2);
		healthBar.scrollFactor.set();
		if (Client.iconColour)
			healthBar.createFilledBar(dad.healthBarColor, boyfriend.healthBarColor);
		else
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		//healthBar.visible = Client.;
		add(healthBar);

		// Score Text
		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 330, healthBarBG.y + 50, 0, "", 20);
		scoreTxt.setFormat(Paths.font("Highman.ttf"), 20, 0xFFFFFFFF, CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		scoreTxt.scrollFactor.set();
		//scoreTxt.visible = Client.;
		add(scoreTxt);

		// Misses Text
		missTxt = new FlxText(healthBarBG.x + healthBarBG.width - 75, healthBarBG.y + 50, 0, "", 20);
		missTxt.setFormat(Paths.font("Highman.ttf"), 20, 0xFFFFFFFF, CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		missTxt.scrollFactor.set();
		//missTxt.visible = Client.;
		add(missTxt);

		// Accuracy Text
		accuracyTxt = new FlxText(healthBarBG.x + healthBarBG.width - 602, healthBarBG.y + 50, 0, "", 20);
		accuracyTxt.setFormat(Paths.font("Highman.ttf"), 20, 0xFFFFFFFF, CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		accuracyTxt.scrollFactor.set();
		//accuracyTxt.visible = Client.;
		add(accuracyTxt);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		iconP1.visible = Client.icHUD;
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		iconP2.visible = Client.icHUD;
		add(iconP2);

		strumLineNotes.cameras = [camNOTE];
		notes.cameras = [camNOTE];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		missTxt.cameras = [camHUD];
		accuracyTxt.cameras = [camHUD];
		logShit.cameras = [camCutcene];

		startingSong = true;

		if (isStoryMode){
			switch (curTrack.toLowerCase()){
				case "winter-horrorland":
					CutcenePlayCene('winterShitLandStart');
				case 'senpai':
					logIntro(logShit);
				case 'roses':
					FlxG.sound.play(Paths.sound('school/AngryShit', 'maps'));
					logIntro(logShit);
				case 'thorns':
					logIntro(logShit);
				default:
					startCountdown();
			}
		}else{
			switch (curTrack.toLowerCase()){
				default:
					startCountdown();
			}
		}
		super.create();
	}
	function logIntro(?logBox:DialogueBox):Void{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
		black.scrollFactor.set();
		add(black);
		CutceneShit(black);
		new FlxTimer().start(0.3, function(tmr:FlxTimer){
			camNOTE.alpha = 0;
			camHUD.alpha = 0;
			//if (Client.midBG)
				//camMidBG.alpha = 0;
			black.alpha -= 0.15;
			if (black.alpha > 0){
				tmr.reset(0.3);
			}else{
				if (logBox != null){
					inCutscene = true;
					if (SONG.song.toLowerCase() == 'thorns')
						CutcenePlayCene('thornsCutcene' ,logBox);
					else{
						FlxG.mouse.visible = true;
						add(logBox);
					}
				}else
					startCountdown();
				remove(black);
			}
		});
	}
	function CutceneShit(black:FlxSprite){
		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns'){
			remove(black);
			if (SONG.song.toLowerCase() == 'thorns')
				CutcenePlayCene('thornShit');
		}
	}
	var redShit:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
	function CutcenePlayCene(F:String, ?logBox:DialogueBox){
		if (F == 'winterShitLandEnd'){
			var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
				-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			blackShit.scrollFactor.set();
			add(blackShit);
			camHUD.visible = false;
			FlxG.sound.play(Paths.sound('mallEvil/lightsShutOff', 'maps'));
		}
		if (F == 'winterShitLandStart'){
			var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			add(blackScreen);
			blackScreen.scrollFactor.set();
			camHUD.visible = false;
			new FlxTimer().start(0.1, function(tmr:FlxTimer){
			remove(blackScreen);
			FlxG.sound.play(Paths.sound('mallEvil/lightsTurnOn', 'maps'));
			camFollow.y = -2050;
			camFollow.x += 200;
			FlxG.camera.focusOn(camFollow.getPosition());
			FlxG.camera.zoom = 1.5;
			new FlxTimer().start(0.8, function(tmr:FlxTimer){
				camHUD.visible = true;
				remove(blackScreen);
				FlxTween.tween(FlxG.camera, {zoom: TrackMap.camZoom}, 2.5,{
					ease: FlxEase.quadInOut,
						onComplete: function(twn:FlxTween){
							startCountdown();
						}
					});
				});
			});
		}
		if (F == 'thornShit'){
			redShit.scrollFactor.set();
			add(redShit);
		}
		if (F == 'thornsCutcene'){
			var senpaiEvil:FlxSprite = new FlxSprite();
			senpaiEvil.frames = Paths.getSparrowAtlas('cutcene/pixel/week6cene/senpaiCrazy');
			senpaiEvil.animation.addByPrefix('transform', 'Senpai Pre Explosion', 24, false);
			senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
			senpaiEvil.scrollFactor.set();
			senpaiEvil.updateHitbox();
			senpaiEvil.screenCenter();
			add(senpaiEvil);
			senpaiEvil.alpha = 0;
			new FlxTimer().start(0.3, function(swagTimer:FlxTimer){
				senpaiEvil.alpha += 0.15;
				if (senpaiEvil.alpha < 1){
					swagTimer.reset();
				}else{
					senpaiEvil.animation.play('transform');
					FlxG.sound.play(Paths.sound('school/senpai_Exploded', 'maps'), 1, false, null, true, function(){
						remove(senpaiEvil);
						remove(redShit);
						FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function(){
							FlxG.mouse.visible = true;
							add(logBox);
						}, true);
					});
					new FlxTimer().start(3.2, function(deadTime:FlxTimer){
						FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
					});
				}
			});
		}
	}
	function SpriteGrab(spriteSussy:FlxSprite){ // Sprite Health Grab
		switch (curTrack){
			case 'Senpai' | 'Roses':
				if (Client.isDownscroll){
					spriteSussy.flipY = true;
					spriteSussy.y -= 15;
				} 
				if (playerTurn){
					spriteSussy.x = iconP1.x;
					spriteSussy.y = healthBarBG.y;
					spriteSussy.flipX = false;
				}else{
					spriteSussy.x = iconP2.x;
					spriteSussy.y = healthBarBG.y;
					spriteSussy.flipX = true;
				}
				spriteSussy.cameras = [camHUD];
				spriteSussy.frames = Paths.getSparrowAtlas('school/BG_Girls_HandLovePushingv2', 'maps');
				spriteSussy.setGraphicSize(Std.int(spriteSussy.width * 2));
				spriteSussy.animation.addByIndices('come','Appear',[0,1,2,3,4,5,6,7,8,9], "", 24, false);
				spriteSussy.animation.addByIndices('grab','Grab',[0,1,2,3,4,5], "", 24, false);
				spriteSussy.animation.addByIndices('hold','Pushing',[0,1,2,3],"",24);
				spriteSussy.animation.addByIndices('release','Release',[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"",24,false);
				spriteSussy.antialiasing = Client.Antialiasing;
		}
	}
	public var addsDamageHealthSpriteTake:Float = 0;
	public var interuptgrabbedPlayerIconHealth = false;
	var interuptgrabbedOpponentHealth = false;
	var playerTurn:Bool = true;
	var isFackingGrabCoondownPlayer:Bool = false;
	var isFackingGrabCoondownOpponent:Bool= false;
	function grabHealth(turnGrab:String, healthCaculate:Int, duration:Int, lockedSprite:Bool = false){
		if (playerTurn){
			//isFackingGrabCoondownPlayer = true;
			grabbedPlayerIcon = true;
			interuptgrabbedPlayerIconHealth = false;
		}else{
			isFackingGrabCoondownOpponent = true;
			grabbediconP2 = true;
			interuptgrabbedOpponentHealth = false;
		}
		addsDamageHealthSpriteTake = 0;
		var spriteFackGrab:FlxSprite = new FlxSprite(0,0);
		SpriteGrab(spriteFackGrab);
		add(spriteFackGrab);
		spriteFackGrab.animation.play('come');
		switch (turnGrab){
			case 'Player':
				GrabPlayerHealth(spriteFackGrab, healthCaculate, duration, lockedSprite);
			case 'Opponent':
				GrabOpponentHealth(spriteFackGrab, healthCaculate, duration, lockedSprite);
		}
	}
	function GrabPlayerHealth(spriteThis:FlxSprite, healthCaculate:Int, duration:Int, lockedSprite:Bool){
		playerTurn = true;
		var spriteSpeed:Float = 0.014425;
		var offSetStart:Int = 75;
		var currentStartHealthGrab = health;
		var thisFackPush = (healthCaculate / 100) * currentStartHealthGrab;
		var susHP = thisFackPush / 2 * 100;
		var goFackYouSelf:Bool = false;
		var spriteOffsetMove:Int = 5;
		new FlxTimer().start(0.14, function(tmr:FlxTimer){
			spriteThis.animation.play('grab');
			FlxTween.tween(spriteThis,{x: iconP1.x}, 1,{ease: FlxEase.elasticIn, onComplete: function(tween:FlxTween){
				spriteThis.animation.play('hold');
				FlxTween.tween(spriteThis,{
					x: (healthBar.x + 
					(healthBar.width * (FlxMath.remapToRange(susHP, 0, 100, 100, 0) * spriteSpeed) 
					- 26)) - offSetStart}, duration,{
					onUpdate: function(tween:FlxTween){
						if (interuptgrabbedPlayerIconHealth && !goFackYouSelf && !lockedSprite){
							goFackYouSelf = true;
							spriteThis.animation.play('release');
							spriteThis.animation.finishCallback = function(pog:String){
								spriteThis.alpha = 0;
							}
						}else if (!interuptgrabbedPlayerIconHealth || lockedSprite){
							var pp = FlxMath.lerp(currentStartHealthGrab, thisFackPush, tween.percent);
							if (pp <= 0)
								pp = 0.1;
							health = pp;
						}
					},
					onComplete: function(tween:FlxTween){
						if (interuptgrabbedPlayerIconHealth && !lockedSprite){
							remove(spriteThis);
							grabbedPlayerIcon = false;
							isFackingGrabCoondownPlayer = false;
						}else{
							spriteThis.animation.play('release');
							if (lockedSprite && addsDamageHealthSpriteTake >= 0.7)
								health -= addsDamageHealthSpriteTake;
							spriteThis.animation.finishCallback = function(pog:String){
								remove(spriteThis);
							}
							grabbedPlayerIcon = false;
							isFackingGrabCoondownPlayer = false;
						}
					}
				});
			}});
		});
	}
	function GrabOpponentHealth(spriteThis:FlxSprite, healthCaculate:Int, duration:Int, lockedSprite:Bool){
		playerTurn = false;
		var offSetStart:Int = 75;
		var currentStartHealthGrab = health;
		var thisFackPush = (healthCaculate / 100) * currentStartHealthGrab;
		var susHP = thisFackPush / 2 * 100;
		var goFackYouSelf:Bool = false;
		var spriteOffsetMove:Int = 5;
		new FlxTimer().start(0.14, function(tmr:FlxTimer){
			spriteThis.animation.play('grab');
			FlxTween.tween(spriteThis,{x: iconP2.x + 20}, 1,{ease: FlxEase.elasticIn, onComplete: function(tween:FlxTween){
				spriteThis.animation.play('hold');
				FlxTween.tween(spriteThis,{
					x: (healthBar.x + 
					(healthBar.width * (FlxMath.remapToRange(susHP, 0, -0.0001, -0.0001, 0) * 0.01) 
					- 26)) - offSetStart}, duration,{
					onUpdate: function(tween:FlxTween){
						if (interuptgrabbedOpponentHealth && !goFackYouSelf && !lockedSprite){
							goFackYouSelf = true;
							spriteThis.animation.play('release');
							spriteThis.animation.finishCallback = function(pog:String){
								spriteThis.alpha = 0;
							}
						}else if (!interuptgrabbedOpponentHealth || lockedSprite){
							var pp = FlxMath.lerp(currentStartHealthGrab, thisFackPush, -tween.percent);
							if (pp <= 0)
								pp = 0.1;
							health = pp;
						}
					},
					onComplete: function(tween:FlxTween){
						if (interuptgrabbedOpponentHealth && !lockedSprite){
							remove(spriteThis);
							grabbediconP2 = false;
							isFackingGrabCoondownOpponent = false;
						}else{
							spriteThis.animation.play('release');
							if (lockedSprite && addsDamageHealthSpriteTake >= 0.7)
								health += addsDamageHealthSpriteTake;
							spriteThis.animation.finishCallback = function(pog:String){
								remove(spriteThis);
							}
							grabbediconP2 = false;
							isFackingGrabCoondownOpponent = false;
						}
					}
				});
			}});
		});
	}
	var startTimer:FlxTimer;
	var grabbedPlayerIcon = false;
	var grabbediconP2 = false;
	function startCountdown():Void{
		switch (curTrack){
			case 'Thorns':
				bfThornsTrail = new FlxTrail(boyfriend, null, 4, 24, 0.3, 0.069);
		}

		if (loops == 0){
			#if windows
			DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + mainDifficultyText + ")", null, iconRPC); // Updating Discord Rich Presence
			#end
			trace(detailsText + " " + SONG.song + " (" + mainDifficultyText + ")");
		}else if (Client.endless && loops >= 1 && !isStoryMode){
			#if windows
			DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + mainDifficultyText + ")", 'Loop ' + loops, iconRPC); // Updating Discord Rich Presence
			#end
			trace(detailsText + " " + SONG.song + " (" + mainDifficultyText + ")" + '\nLoop ' + loops);
		}

		inCutscene = false;
		var fackTween:Bool = true;
		if (loops == 0){
			generateScrolls(0, fackTween);
			generateScrolls(1, fackTween);
		}

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;
		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer){
			switch (swagCounter){
				case 0:
					TrackMap.counterEvent('CounterStart');
				case 1:
					TrackMap.counterEvent('Ready');
				case 2:
					TrackMap.counterEvent('Set');
				case 3:
					TrackMap.counterEvent('Go');
				case 4:
					TrackMap.counterEvent('CounterEnd');
			}
			for (i in TrackMap.counterAdd){
				add(i);
			}
			swagCounter += 1;
		}, 5);
		if (mainDifficulty >= 4){
			switch (SONG.song.toLowerCase()){
				case 'senpai':
					if (curStep < 688)
						startGrabHealth('Player', 3, 1.2, 25, 6);
				case 'roses':
					if (curStep < 688)
						startGrabHealth('Player', 10, 1.4, 40, 3);
			}
		}
	}
	function CheckRandomGrab(){ // Is Beta
		switch (SONG.song.toLowerCase()){
			case 'senpai':
				if (FlxG.random.bool(1))
					playerTurn = true;
				if (FlxG.random.bool(0.5))
					playerTurn = false;
			case 'roses':
				if (FlxG.random.bool(8))
					playerTurn = true;
				if (FlxG.random.bool(4))
					playerTurn = false;
		}
		if (!playerTurn && !isFackingGrabCoondownOpponent){
			isFackingGrabCoondownPlayer = false;
			switch (SONG.song.toLowerCase()){
				case 'senpai':
					startGrabHealth2('Opponent', 1.5, 50, 5);
				case 'roses':
					startGrabHealth2('Opponent', 1.4, 35, 4);
			}
		}else if (!isFackingGrabCoondownPlayer){
			isFackingGrabCoondownOpponent = false;
			switch (SONG.song.toLowerCase()){
				case 'senpai':
					startGrabHealth2('Player', 1.5, 50, 5);
				case 'roses':
					startGrabHealth2('Player', 1.4, 35, 4);
			}
		}
	}
	function startGrabHealth(player:String , timer:Float = 20, healthFloat:Float = 1.5, takeHealth:Int = 100, duration:Int = 4, ?spriteLock:Bool = false){
		new FlxTimer().start(timer, function(tmr:FlxTimer){
			if (playerTurn){
				if (canPause && !paused && health >= healthFloat && !grabbedPlayerIcon)
					grabHealth(player, takeHealth, duration, spriteLock);
			}else
				if (canPause && !paused && healthBar.percent > healthFloat && !grabbediconP2)
					grabHealth(player, takeHealth, duration, spriteLock);
			tmr.reset(timer);
		});
	}
	function startGrabHealth2(player:String, healthFloat:Float = 1.5, takeHealth:Int = 100, duration:Int = 5, ?spriteLock:Bool = false){
		if (playerTurn){
			if (canPause && !paused && health >= healthFloat && !grabbedPlayerIcon)
				grabHealth(player, takeHealth, duration, spriteLock);
		}else
			if (canPause && !paused && healthBar.percent > healthFloat && !grabbediconP2)
				grabHealth(player, takeHealth, duration, spriteLock);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;
	function startSong():Void{
		switch (curTrack){
			default:
				isPlayerMain = true;
				isOpponentMain = true;
			case 'Tutorial':
				bfCanDodge = true;
				isPlayerMain = true;
				isOpponentMain = true;
		}
		startingSong = false;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;
		if (!paused){
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}
		FlxG.sound.music.onComplete = endChart;
		vocals.play();
		switch (curTrack){
			case 'Bopeebo' | 'Philly' | 'Blammed' | 'Cocoa' | 'Eggnog': 
				allowedToHeadbang = true;
			default: 
				allowedToHeadbang = false;
		}
	}

	var debugNum:Int = 0;
	private function generateSong(dataPath:String):Void{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curTrack = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		if (loops == 0){
			notes = new FlxTypedGroup<Note>();
			add(notes);
		}

		var noteData:Array<SwagSection>;

		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0;for (section in noteData){
			var coolSection:Int = Std.int(section.lengthInSteps / 4);
			for (songNotes in section.sectionNotes){
				//var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				var daStrumTime:Float = songNotes[0];
				if (daStrumTime < 0)
					daStrumTime = 0;
				//var daNoteData:Int = Std.int(songNotes[1] % arrowMax[numArrow]);
				var daNoteData:Int = Std.int(songNotes[1] % 4);		
				var gottaHitNote:Bool = section.mustHitSection;
				//if (songNotes[1] >= arrowMax[numArrow]){
				if (songNotes[1] > 3){
					gottaHitNote = !section.mustHitSection;
				}
	
				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;
					
				var daType = songNotes[3];
				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
				swagNote.sustainLength = songNotes[2];	
				swagNote.scrollFactor.set(0, 0);	
				var susLength:Float = swagNote.sustainLength;
				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength)){
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);
					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress){
						sustainNote.x += FlxG.width / 2;
					}
				}
				swagNote.mustPress = gottaHitNote;
				if (swagNote.mustPress){
					swagNote.x += FlxG.width / 2;
				}else{
				}
			}
			daBeats += 1;
		}
		unspawnNotes.sort(sortByShit);
		generatedMusic = true;
	}
	function sortByShit(Obj1:Note, Obj2:Note):Int{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}
	function removeStaticsStrums(nameItem:String){
		if (nameItem == 'Player'){
			playerStrums.forEach(function(todel:FlxSprite){
				playerStrums.remove(todel);
				todel.destroy();
			});
			new FlxTimer().start(0, function(tmr:FlxTimer){
				playerStrums.forEach(function(todel:FlxSprite){
					playerStrums.remove(todel);
					todel.destroy();
				});
			});
		}
		if (nameItem == 'Opponent'){
			opponentStrums.forEach(function(todel:FlxSprite){
				opponentStrums.remove(todel);
				todel.destroy();
			});
		}
		if (nameItem == 'Notes'){
			strumLineNotes.forEach(function(todel:FlxSprite){
				strumLineNotes.remove(todel);
				todel.destroy();
			});
		}
	}
	private function generateScrolls(player:Int, tweenScroll:Bool):Void{
		//for (i in 0...arrowMax[numArrow]){
		for (i in 0...4){
			var strumArrow:FlxSprite = new FlxSprite(0, strumLine.y);
			if (TrackMap.curMap.startsWith('pix')){
				StrumNote.LoadAnimArrow('pixel', strumArrow, i);
			}else{
				StrumNote.LoadAnimArrow('default', strumArrow, i);
			}

			strumArrow.ID = i;
			strumArrow.x += ((FlxG.width / 2) * player);

			if (Client.mid){
				if (player == 1){
					StrumNote.TweenNote(strumArrow, tweenScroll, i);
					strumArrow.x -= 276; // old -275
					playerShit = 1;
				}else{
					strumArrow.visible = false;
					strumArrow.alpha = 0;
				}
			}else{
				StrumNote.TweenNote(strumArrow, tweenScroll, i);
			}

			StrumNote.LoadExtraCodeArrow(strumArrow);

			switch (player){
				case 0:
					opponentStrums.add(strumArrow);
				case 1:
					playerStrums.add(strumArrow);
			}
			strumLineNotes.add(strumArrow);
		}
	}

	function tweenCamIn(nmP:String,toAlpha:Float):Void{
		switch (nmP){
			case 'Player':
				FlxTween.tween(FlxG.camera, {zoom: toAlpha}, (Conductor.stepCrochet * 5 / 1000), {ease: FlxEase.elasticInOut});
			case 'Opponent':
				FlxTween.tween(FlxG.camera, {zoom: toAlpha}, (Conductor.stepCrochet * 5 / 1000), {ease: FlxEase.elasticInOut});
		}
	}

	override function openSubState(SubState:FlxSubState){
		if (paused){
			if (FlxG.sound.music != null){
				FlxG.sound.music.pause();
				vocals.pause();
			}
			if (loops == 0){
				#if windows
				DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + mainDifficultyText + ")", iconRPC, true);
				#end
			}else if (Client.endless && loops >= 1 && !isStoryMode){
				#if windows
				DiscordClient.changePresence(detailsPausedText + " " + SONG.song + " (" + mainDifficultyText + ")", "\nLoops " + loops, iconRPC, true);
				#end
			}
			if (!startTimer.finished)
				startTimer.active = false;
		}
		super.openSubState(SubState);
	}

	override function closeSubState(){
		if (PauseSubState.goToOptions){
			if (PauseSubState.goBack){
				PauseSubState.goToOptions = false;
				PauseSubState.goBack = false;
				openSubState(new PauseSubState());
			}else
				openSubState(new OptionsMenu(true));
		}else if (paused){
			if (FlxG.sound.music != null && !startingSong){
				resyncVocals();
			}
			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;
			#if desktop
			if (startTimer.finished){
				DiscordClient.changePresence(detailsText, SONG.song + " (" + mainDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}else{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + mainDifficultyText + ")", iconRPC);
			}
			#end
		}
		super.closeSubState();
	}
	function resyncVocals():Void{
		vocals.pause();
		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}
	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	function PresetCam(Player:String, num:Int, note:Note){
		var i = note.noteType;
		switch (i){
			case 0:
				switch (Player){
					case 'BF':
						switch (note.noteData){
							case 0:
								bfcamX = -num;
								bfcamY = 0;
							case 1:
								bfcamY = num;
								bfcamX = 0;
							case 2:
								bfcamY = -num;
								bfcamX = 0;
							case 3:
								bfcamX = num;
								bfcamY = 0;
						}
					case 'Opponent':
						switch (Math.abs(note.noteData)){
							case 0:
								camX = -num;
								camY = 0;
							case 1:
								camY = num;
								camX = 0;
							case 2:
								camY = -num;
								camX = 0;
							case 3:
								camX = num;
								camY = 0;
						}
				}
		}
	}
	var noMoreRagenSuckDude:Bool = false;
	function dodgeTimingOverride(newValue:Float = 0.22625):Void{
		bfDodgeTiming = newValue;
	}
	function dodgeCooldownOverride(newValue:Float = 0.1135):Void{
		bfDodgeCooldown = newValue;
	}
	var playerShit:Int = 0;
	override public function update(elapsed:Float){
		if ((FlxG.keys.anyJustPressed([FlxKey.fromString(FlxG.save.data.dodgeBind)])) && !bfDodging && bfCanDodge){ // Dodge Start
			bfDodging = true;
			bfCanDodge = false;
			boyfriend.playAnim('singDODGE', true);
			new FlxTimer().start(bfDodgeTiming, function(tmr:FlxTimer){ // Dodge Stop
				bfDodging = false;
				boyfriend.playAnim('idle');
				new FlxTimer().start(bfDodgeCooldown, function(tmr:FlxTimer){ // Reset Dodge
					bfCanDodge = true;
				});
			});
		}
		switch (TrackMap.curMap){ // Maps Events
			case 'philly':
				if (TrackMap.trainMoving){
					TrackMap.trainFrameTiming += elapsed;
					if (TrackMap.trainFrameTiming >= 1 / 24){
						TrackMap.updateTrainPos();
						TrackMap.trainFrameTiming = 0;
					}
				}
			//case 'pixSchool':
				//CheckRandomGrab();
		}
		super.update(elapsed);
		scoreTxt.text = 'Score: $chartScore'; // Score Show
		missTxt.text = 'Misses: $misses'; // Misses Show
		accuracyTxt.text = "Accuracy:" + FloatNumber.numFloat(accuracy, 2) + "%"; // Acuracy Show
		if (health >= 0){ // Health 
			healthPercent = Math.round(health * 50);
		}else{
			healthPercent = 0; 
		}
		switch (curTrack){
			case 'Bopeebo':
				switch (curBeat){
					case 128, 129, 130:
						vocals.volume = 0;
				}
			case 'Fresh':
				switch (curBeat){
					case 16:
						camZooming = true;
						gfSpeed = 2;
					case 48:
						gfSpeed = 1;
					case 80:
						gfSpeed = 2;
					case 112:
						gfSpeed = 1;
				}
			case 'Spookeez':
				switch (curStep){
					case 188:
						boyfriend.playAnim('hey', true);
					case 444:
						boyfriend.playAnim('hey', true);
				}
		}
		if ((FlxG.keys.anyJustPressed([FlxKey.fromString(FlxG.save.data.pauseBind)])) && startedCountdown && canPause && !endTrack){ // Paused Shit
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;
			openSubState(new PauseSubState());
		}
		if (FlxG.keys.justPressed.SEVEN){ // Going to The ChartingState
			canDie = false;
			persistentUpdate = false;
			paused = true;
			FlxG.switchState(new ChartingState());
		}
		//if (Client.DevTools){ // Dev Tools Shit (Acess Only Use Code in CodeState)
			//if (FlxG.keys.justPressed.NUMLOCK) // NUMLOCK Does Not Exist in Your API (Download From Ngs Engine on Github, Custom API and Replace Yours)
			if (FlxG.keys.justPressed.DELETE)
				endChart();
			if (FlxG.keys.justPressed.PAGEUP) // BF OFFSETS
				FlxG.switchState(new AnimationDebug(SONG.player1));
			if (FlxG.keys.justPressed.PAGEDOWN) // OPPONENT OFFSETS
				FlxG.switchState(new AnimationDebug(SONG.player2));
			if (FlxG.keys.justPressed.HOME) // GF OFFSETS
				FlxG.switchState(new AnimationDebug(TrackMap.gfVersion));
		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		switch (SONG.song.toLowerCase()){ // Set Health Chart's 
			default:
				HealthType(); // 100% HP
		}
		if (healthBar.percent < 20) // PlayerIcon
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80) // OpponentIcon
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (startingSong){
			if (startedCountdown){
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}else{
			Conductor.songPosition += FlxG.elapsed * 1000;
			if (!paused){
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;
				if (Conductor.lastSongPos != Conductor.songPosition){
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}
		}
		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null){
			if (camFollowMove){
				if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection){
					camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					switch (dad.curCharacter){ // Place You Char Here to Work CamMove :D
						case 'gf':
						case 'dad':
						case 'spooky':
						case 'monster':
						case 'pico':
							camFollow.x = dad.getMidpoint().x + 300;
							camFollow.y = dad.getMidpoint().y - 50;
						case 'mom':
							camFollow.y = dad.getMidpoint().y;
						case 'parents':
						case 'monster-christmas':
						case 'senpai-pixel':
							camFollow.x = dad.getMidpoint().x - 100;
							camFollow.y = dad.getMidpoint().y - 430;
						case 'senpai-angry-pixel':
							camFollow.x = dad.getMidpoint().x - 100;
							camFollow.y = dad.getMidpoint().y - 430;
						case 'spirit-pixel':
					}
					if (dad.curCharacter == 'mom')
						vocals.volume = 1;
					if (SONG.song.toLowerCase() == 'tutorial')
						tweenCamIn('Opponent', 1.5);
					if (cameramove){
						camFollow.y += camY;
						camFollow.x += camX;
					}
				}
				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection){
					camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
					switch (TrackMap.curMap){
						case 'spooky':
							camFollow.y = boyfriend.getMidpoint().y - 125;
						case 'limo':
							camFollow.x = boyfriend.getMidpoint().x - 300;
						case 'mall':
							camFollow.y = boyfriend.getMidpoint().y - 200;
						case 'pixSchool':
							camFollow.x = boyfriend.getMidpoint().x - 200;
							camFollow.y = boyfriend.getMidpoint().y - 200;
						case 'pixSchoolEvil':
							camFollow.x = boyfriend.getMidpoint().x - 200;
							camFollow.y = boyfriend.getMidpoint().y - 230;
					}
					if (boyfriend.curCharacter.startsWith('bf')){} // Here They Are Automatic :D
					if (SONG.song.toLowerCase() == 'tutorial')
						tweenCamIn('Player', 1.05);
					if (cameramove){
						camFollow.x += bfcamX;
						camFollow.y += bfcamY;
					}
				}
			}
		}

		if (camZooming){
			FlxG.camera.zoom = FlxMath.lerp(TrackMap.camZoom, FlxG.camera.zoom, 0.95);
			camNOTE.zoom = FlxMath.lerp(1, camNOTE.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (health <= 0 && !endTrack){
			canDie = true;
			death++;
			loops = 0;
			boyfriend.stunned = true;
			persistentUpdate = false;
			persistentDraw = false;
			paused = true;
			vocals.stop();
			FlxG.sound.music.stop();
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			#if desktop
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + mainDifficultyText + ")", iconRPC);
			#end
		}
		if (FlxG.save.data.resetButton){
			if ((FlxG.keys.anyJustPressed([FlxKey.fromString(FlxG.save.data.resetBind)])) && !endTrack){
				canDie = true;
				death++;
				loops = 0;
				boyfriend.stunned = true;	
				persistentUpdate = false;
				persistentDraw = false;
				paused = true;
				vocals.stop();
				FlxG.sound.music.stop();
				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				#if desktop
				DiscordClient.changePresence("Bind Kill - " + detailsText, SONG.song + " (" + mainDifficultyText + ")", iconRPC);
				#end
			}
		}

		if (unspawnNotes[0] != null){
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500){
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);
				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic){
			notes.forEachAlive(function(daNote:Note){
				if (daNote.tooLate){
					daNote.active = false;
					daNote.visible = false;
				}else{
					daNote.visible = true;
					daNote.active = true;
				}
				if (!daNote.modifiedByLua){
					if (Client.isDownscroll){
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(Client.noteSpeed == 1 ? SONG.speed : Client.noteSpeed, 2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(Client.noteSpeed == 1 ? SONG.speed : Client.noteSpeed, 2));
						if (daNote.isSustainNote){
							if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
								daNote.y += daNote.prevNote.height + 38;
							else
								daNote.y += daNote.height / 2;
							if (!Client.bot){
								if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2)){
									var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
									swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;
									daNote.clipRect = swagRect;
								}
							}else{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
								swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;
								daNote.clipRect = swagRect;
							}
						}
					}else{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(Client.noteSpeed == 1 ? SONG.speed : Client.noteSpeed, 2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(Client.noteSpeed == 1 ? SONG.speed : Client.noteSpeed, 2));
						if (daNote.isSustainNote){
							if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
								daNote.y -= daNote.prevNote.height - 84;
							else
								daNote.y -= daNote.height / 2;
							if (!Client.bot){
								if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2)){
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;
									daNote.clipRect = swagRect;
								}
							}else{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;
								daNote.clipRect = swagRect;
							}
						}
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit) // Opoonent Note Hit
					opponentNoteHit(daNote);
			
				if (daNote.mustPress && !daNote.modifiedByLua){
					daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
					daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
				}else if (!daNote.wasGoodHit && !daNote.modifiedByLua){
					daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
					daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
					if (!daNote.isSustainNote)
						daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
					daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
				}

				if (daNote.isSustainNote){
					if (TrackMap.curMap.startsWith('pix'))
						daNote.x += daNote.width / 1.375;
					else
						daNote.x += daNote.width / 1;
					daNote.alpha = 0.5;
				}

				if ((daNote.mustPress && daNote.tooLate && !Client.isDownscroll || daNote.mustPress && daNote.tooLate && Client.isDownscroll) && daNote.mustPress){
					if (daNote.isSustainNote && daNote.wasGoodHit){
						daNote.kill();
						notes.remove(daNote, true);
					}else{
						daNote.visible = false;
						daNote.kill();
						notes.remove(daNote, true);
						passNotes(daNote);
					}
				}
			});
		}
		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			soundPlayAnimsShit();
		if (!inCutscene)
			keyShit();
	}
	var numDifShit:Int;
	function endChart():Void{
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.stop();
		vocals.stop();
		if (!(stateShit == 'Endless')){
			canPause = false;
			canDie = false;
			endTrack = true;
			death = 0;
			if (SONG.validScore && !Client.bot){
				#if !switch
				Highscore.saveScore(SONG.song, chartScore, mainDifficulty);
				#end
			}
		}else{
			canPause = true;
			canDie = true;
			endTrack = false;
			startingSong = true;
		}
		switch (stateShit){
			case 'StoryMode':
				campaignScore += Math.round(chartScore);
				storyPlaylist.remove(storyPlaylist[0]);
				if (storyPlaylist.length <= 0){
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					FlxG.switchState(new StoryMenuState());
					StoryMenuState.weekUnlocked[Std.int(Math.min(StoryMenuState.storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
					if (SONG.validScore)
						Highscore.saveWeekScore(StoryMenuState.storyWeek, campaignScore, mainDifficulty);
					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}else{
					if (SONG.song.toLowerCase() == 'eggnog')
						CutcenePlayCene('winterShiLandEnd');
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					trace('Loading Next Chart: ' + PlayState.storyPlaylist[0].toLowerCase() + CoolUtil.checkDifficultyData(mainDifficulty));
					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + CoolUtil.checkDifficultyData(mainDifficulty), PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();
					LoadingState.loadAndSwitchState(new PlayState());
				}
			case 'Freeplay':
				trace('Back to Freeplay');
				FlxG.switchState(new FreeplayState());
			case 'Endless':
				if (!isStoryMode){
					loops++;
					if (SONG.speed < 10){ // Future Shit
						/*if (Client.mode == 3) // HybridMode
							SONG.speed += 0.265;
						else if (Client.mode == 2) // HellMode
							SONG.speed += 0.175
						else if (Client.mode == 1) // HardMode
							SONG.speed += 0.125;
						else*/ // Default
							SONG.speed += 0.075;
					}
					FlxG.sound.music.volume = 1;
					vocals.volume = 1;
					//mainDifficulty = numDifShit;
					/*if (loops % 3 == 0 && loops > 0){ // Preset For Future
						if (Client.mode == 3) // HybridMode
							numDifShit = CoolUtil.difficultyArray.length;
						else if (Client.mode == 2) // HellMode
							numDifShit = 7;
						else if (Client.mode == 1) // HardMode
							numDifShit = 5;
						else // Default
							numDifShit = 2;
						if (mainDifficulty < numDifShit){
							mainDifficulty++;
							trace('Adding More Difficulty: ' + SONG.song.toLowerCase().toLowerCase() + CoolUtil.checkDifficultyData(null, mainDifficulty));
							PlayState.SONG = Song.loadFromJson(SONG.song.toLowerCase().toLowerCase() + CoolUtil.checkDifficultyData(null, mainDifficulty), SONG.song.toLowerCase());
						}
					}*/
					Conductor.songPosition = -5000;
					generateSong(SONG.song);
					startCountdown();
				}
		}
	}
	var endingSong:Bool = false;
	var timeShown = 0;
	var hits:Array<Float> = [];
	var currentTimingShown:FlxText = null;
	function PressingPlaySound(note:Note){
		switch (note.noteType){
			case 2:
				FlxG.sound.play(Paths.soundAny('sounds/shoots/picoUzi/uziSussy', 'maps'), VolumeShoot);
				Shake(camGame, 0.02, 0.0225, null, true);
				//Flash(FlxColor.WHITE, 0.2, true);
		}
	}
	private function popSoundsNote(note:Note){
		vocals.volume = 1;
		var isSuckRaing = note.rating;
		switch (isSuckRaing){
			case 'shit':
				PressingPlaySound(note);
			case 'bad':
				PressingPlaySound(note);
			case 'good':
				PressingPlaySound(note);
			case 'sick':
				PressingPlaySound(note);
		}
	}
	private function popUpScore(note:Note){
		var score:Int = 0;
		var ratingShitExtra = note.rating;
		if (!Client.bot && note.noteType == 0){
			switch(ratingShitExtra){
				case 'shit':
					totalNotesHit -= 1;
					score = -300;
					ss = false;
					combo = 0;
					misses++;
					shits++;
				case 'bad':
					totalNotesHit += 0.50;
					ss = false;
					score = 0;
					bads++;
				case 'good':
					totalNotesHit += 0.75;
					score = 200;
					ss = false;
					goods++;
				case 'sick':
					totalNotesHit += 1;
					score = 350;
					sicks++;
			}
		}
		if (ratingShitExtra != 'shit' || ratingShitExtra != 'bad')
			chartScore += Math.round(score);
	}
	private function popUpHealth(note:Note){
		var ratingHealth = note.rating;
		if (note.noteType == 0){
			switch(ratingHealth){
				case 'shit':
					health -= 0.2;
					addsDamageHealthSpriteTake += 0.1;
					interuptgrabbedPlayerIconHealth = true;
				case 'bad':
					health -= 0.06;
					addsDamageHealthSpriteTake += 0.04;
					interuptgrabbedPlayerIconHealth = true;
				case 'good':
					if (health < 2 && !grabbedPlayerIcon && !noMoreRagenSuckDude)
						health += 0.04;
				case 'sick':
					if (health < 2 && !grabbedPlayerIcon && !noMoreRagenSuckDude)
						health += 0.1;
			}
		}
	}
	private function popUpRating(note:Note):Void{
		var strum = playerStrums.members[note.noteData];
		var coolShit:FlxText = new FlxText(0, 0, 0, "", 32);
		coolShit.screenCenter();
		coolShit.x = FlxG.width * 0.55;
		var ratingSprite:FlxSprite = new FlxSprite();
		var ratingShit = note.rating;
		if (note.noteType == 0){
			switch(ratingShit){
				case 'shit':
				case 'bad':
					ratingShit = 'bad';
				case 'good':
					ratingShit = 'good';
				case 'sick':
			}
		}
		if (ratingShit != 'shit' || ratingShit != 'bad'){
			var diretoryPixShit:String = "UI/";
			var complementName:String = '';
			if (TrackMap.curMap.startsWith('pix')){
				diretoryPixShit = 'UI/pixelUI/';
				complementName = '-pixel';
			}
			ratingSprite.loadGraphic(Paths.image(diretoryPixShit + ratingShit + complementName));
			ratingSprite.screenCenter();
			if (Client.ratingShit == 0){
				ratingSprite.x = coolShit.x - 40;
				ratingSprite.y -= 60;
			}
			if (Client.ratingShit == 1){
				ratingSprite.cameras = [camNOTE];
				if (FlxG.save.data.middlescroll){
					if (FlxG.save.data.downscroll){
						ratingSprite.x = 160;
						ratingSprite.y = strum.y - 205;
					}else{
						ratingSprite.x = 160;
						ratingSprite.y = strum.y + 15;
					}
				}else{
					if (FlxG.save.data.downscroll){
						ratingSprite.x = 510;
						ratingSprite.y = strum.y - 205;
					}else{
						ratingSprite.x = 510;
						ratingSprite.y = strum.y + 15;
					}
				}
			}
			if (Client.ratingShit == 2){
				ratingSprite.cameras = [camNOTE];
				if (Client.isDownscroll){
					ratingSprite.x = strum.x;
					ratingSprite.y = strum.y - 140;
				}else{
					ratingSprite.x = strum.x;
					ratingSprite.y = strum.y - 36;
				}
			}
			ratingSprite.acceleration.y = 550;
			ratingSprite.velocity.y -= FlxG.random.int(160, 200);
			ratingSprite.velocity.x -= FlxG.random.int(0, 15);
			if (!TrackMap.curMap.startsWith('pix')){
				ratingSprite.antialiasing = Client.Antialiasing;
				if (Client.ratingShit == 1 || Client.ratingShit == 2)
					ratingSprite.setGraphicSize(Std.int(ratingSprite.width * 0.4325));
				if (Client.ratingShit == 0)
					ratingSprite.setGraphicSize(Std.int(ratingSprite.width * 0.7));
			}else{
				if (Client.ratingShit == 1 || Client.ratingShit == 2)
					ratingSprite.setGraphicSize(Std.int(ratingSprite.width * TrackMap.daPixelZoom * 0.4325));
				if (Client.ratingShit == 0)
					ratingSprite.setGraphicSize(Std.int(ratingSprite.width * TrackMap.daPixelZoom * 0.7));
			}
			ratingSprite.updateHitbox();
			add(ratingSprite);
			FlxTween.tween(ratingSprite, {alpha: 0}, 0.2,{
				startDelay: Conductor.crochet * 0.001
			});
			FlxTween.tween(coolShit, {alpha: 0}, 0.2,{
				onComplete: function(tween:FlxTween){
					coolShit.destroy();
					ratingSprite.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
			curSection += 1;
		}
	}
	private function keyShit():Void{
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		var releaseArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];
		if (Client.bot){
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
			releaseArray = [false, false, false, false];
		} 
		if (holdArray.contains(true) && generatedMusic && !endTrack){
			notes.forEachAlive(function(daNote:Note){
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
					playerNoteHit(daNote);
			});
		}
		if (pressArray.contains(true) && generatedMusic && !endTrack){
			boyfriend.holdTimer = 0;
			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later
			notes.forEachAlive(function(daNote:Note){
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit){
					if (directionList.contains(daNote.noteData)){
						for (coolNote in possibleNotes){
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10){
								dumbNotes.push(daNote);
								break;
							}else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime){
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}else{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});
			for (note in dumbNotes){
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			var dontCheck = false;
			for (i in 0...pressArray.length){
				if (pressArray[i] && !directionList.contains(i))
					dontCheck = true;
			}
			if (possibleNotes.length > 0 && !dontCheck){
				if (!FlxG.save.data.newInput){
					for (shit in 0...pressArray.length){
						if (pressArray[shit] && !directionList.contains(shit))
							TrackMap.oldInput(shit);
					}
				}
				for (coolNote in possibleNotes){
					if (pressArray[coolNote.noteData]){
						if (mashViolations != 0)
							mashViolations--;
						scoreTxt.color = FlxColor.WHITE;
						playerNoteHit(coolNote);
					}
				}
			}else if (!FlxG.save.data.newInput){
				for (shit in 0...pressArray.length)
					if (pressArray[shit])
						TrackMap.oldInput(shit);
			}
			if (dontCheck && possibleNotes.length > 0 && FlxG.save.data.newInput && !FlxG.save.data.botplay){
				if (mashViolations > 8){
					scoreTxt.color = FlxColor.RED;
					TrackMap.oldInput(0);
				}else
					mashViolations++;
			}
		}
		
		playerStrums.forEach(function(spr:FlxSprite){
			if (Client.bot)
				StrumNote.GlowHitNote('PlayerIdle', spr);
			else
				StrumNote.GlowHitNote('PlayerIdle', spr, pressArray, holdArray);
		});
		
		if (Client.p2GlowHit){
			opponentStrums.forEach(function(spr:FlxSprite){
				StrumNote.GlowHitNote('OpponentIdle', spr);
			});
		}

		notes.forEachAlive(function(daNote:Note){
			if (Client.isDownscroll && daNote.y > strumLine.y || !Client.isDownscroll && daNote.y < strumLine.y){
				if (Client.bot && daNote.canBeHit && daNote.mustPress || Client.bot && daNote.tooLate && daNote.mustPress){
					playerNoteHit(daNote);
					boyfriend.holdTimer = daNote.sustainLength;
				}
			}
		});

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || Client.bot)){
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && !bfDodging)
				boyfriend.playAnim('idle');
				removeTrail('Player');
				bfcamX = 0;
				bfcamY = 0;
		}
	}
	
	function getKeyPresses(note:Note):Int{
		var possibleNotes:Array<Note> = [];
		notes.forEachAlive(function(daNote:Note){
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate){
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	var mashing:Int = 0;
	var mashViolations:Int = 0;
	function noteCheck(controlArray:Array<Bool>, note:Note):Void{
		var noteDiff:Float = -(note.strumTime - Conductor.songPosition);
		note.rating = Rating.CalculateRating(noteDiff, Math.floor((Conductor.safeFrames / 60) * 1000));
		if (controlArray[note.noteData]){
			playerNoteHit(note, (mashing > getKeyPresses(note)));
		}
	}
	function missNote(direction:Int = 1, daNoteShit:Note):Void{
		if (!boyfriend.stunned){
			if (combo > 5 && gf.animOffsets.exists('cry')){ gf.playAnim('cry'); }
			if (FlxG.save.data.missSounds){FlxG.sound.play(Paths.soundRandom('missSound/missnote', 1, 3, 'character'), FlxG.random.float(0.1, 0.2));}
			switch (daNoteShit.noteType){
				case 0 | 1:
					interuptgrabbedPlayerIconHealth = true;
					bruhShit('spriteThief');
					bruhShit('health');
					bruhShit('score');
					bruhShit('miss');
					bruhShit('cb');
					if (isPlayerMain)
						SingDiretions('BFMiss', direction, daNoteShit);
			}
			updateAccuracy();
		}
	}
	function bruhShit(fack:String){
		if (fack == 'spriteThief')
			addsDamageHealthSpriteTake += 0.04;
		if (fack == 'cb')
			combo = 0;
		if (fack == 'score')
			chartScore -= 10;
		if (fack == 'miss')
			misses++;
		if (fack == 'health'){
			health -= 0.04;
		}
	}
	function passNotes(noteShit:Note){
		switch (noteShit.noteType){
			case 0 | 1:
				addsDamageHealthSpriteTake += 0.07;
				interuptgrabbedPlayerIconHealth = true;
				health -= 0.07;
				vocals.volume = 0;
				if (theFunne)
					missNote(noteShit.noteData, noteShit);
			case 2:
				switch (SONG.song.toLowerCase()){
					case 'blammed':
						health -= 1;
						Shake(camNOTE, 0.325, 0.05, null, true);
						Shake(camGame, 0.325, 0.05, null, true);
						Shake(camHUD, 0.325, 0.05, null, true);
						switch (TrackMap.curMap){
							case 'philly':
								FlxG.sound.play(Paths.soundAny('sounds/shoots/picoUzi/uziSussy', 'maps'), VolumeShoot);
								//Flash(FlxColor.WHITE, 0.2, true);
								gf.playAnim('cry');
								dad.playAnim('UziShoot');
								dad.playAnim('UziShoot');
								new FlxTimer().start(0.001, function(tmr:FlxTimer){
									dad.playAnim('UziShoot', true);
								});
						}
				}
			case 3:
				vocals.volume = 1;
		}
	}
	public function updateAccuracy(){
		totalPlayed += 1;
		accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
		accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
	}
	function SetCamMove(player:String, num:Int, note:Note){
		if (Client.camMovehitingNote){ // camMoveOnHitedNOTES
            cameramove = true;
			PresetCam(player, num, note);
		}
	}
	function AddTrail(player:String){
		switch (curTrack){
			case 'Thorns':
				if (player == 'Player')
					add(bfThornsTrail);
		}
	}
	public var VolumeShoot:Float = 0.65; // old 0.05
	public function SingDiretionPush(susName:String, note:Note, i:Int, ?altAnim:String){
		i = note.noteData;
		var iPe = note.noteType;
		for (sing in 0...4){
			if (susName == 'P1'){
				switch (iPe){
					case 0:
						boyfriend.playAnim('sing' + diretionSing[i], true);
					case 1:

					case 2:
						boyfriend.playAnim('sing' + diretionDodge[i], true);
						switch (SONG.song.toLowerCase()){
							case 'blammed':
								dad.playAnim('sing-' + 'Uzi' + diretionShoot[i], true);
								gf.playAnim('cheer');
						}
					case 3:

				}
			}
			if (susName == 'P2'){
				switch (iPe){
					case 0:
						dad.playAnim('sing' + diretionSing[i] + altAnim, true);
					case 1:

					case 2:
						switch (SONG.song.toLowerCase()){
							case 'blammed':
								dad.playAnim('sing-' + 'Uzi' + diretionShoot[i], true);
								gf.playAnim('cheer');
						}
				}
			}
			if (susName == 'MISS')
				boyfriend.playAnim('sing' + diretionSing[i] + "miss", true);
		}
	}
	function SingNewChars(isPlayerONE:Bool = true, i:Int, note:Note){ // Beta
		i = note.noteData;
		var iPe = note.noteType;
		var shitDiretion:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
		for (sing in 0...4){
			if (isPlayerONE){
				if (isPicoPlayer){
					pico.playAnim('sing' + shitDiretion[i], true);
					pico.holdTimer = 0;
				}
			}
		}
	}
	public function SingDiretions(?player:String,?numMove:Int = 0, ?direction:Int = 1, ?altAnim:String, note:Note){
		if (player == 'BF'){
			SetCamMove('BF', numMove, note);
			for (i in 0...4)
				SingDiretionPush('P1', note, i);
		}
		if (player == 'BFMiss'){
			for (direction in 0...4)
				SingDiretionPush('MISS', note, direction);
		}
		if (player == 'Opponent'){
			SetCamMove('Opponent', numMove, note);
			for (i in 0...4)
				SingDiretionPush('P2', note, i, altAnim);
		}
	}
	public var fackS:Int = 0;
	function playerNoteHit(note:Note, resetMashViolation = true):Void{ // Player Note Hit
		if (mashing != 0)
			mashing = 0;
		var noteDiff:Float = -(note.strumTime - Conductor.songPosition);
		note.rating = Rating.CalculateRating(noteDiff);
		if (note.rating == "miss")
			return;	
		if (!resetMashViolation && mashViolations >= 1)
			mashViolations--;
		if (mashViolations < 0)
			mashViolations = 0;
		if (!note.wasGoodHit){
			if (!note.isSustainNote){
				popSoundsNote(note);
				popUpRating(note);
				popUpHealth(note);
				popUpScore(note);
				combo++;
			}
			else
				if (!Client.bot)
					totalNotesHit += 1; // + 0.01 Accuracy of Hold Notes
			if (!grabbedPlayerIcon && !noMoreRagenSuckDude)
				health += 0.015; // +0.015 Health of Hold Notes
			if (!Client.bot)
				chartScore += 1; // +1 Score of Hold Notes
			StrumNote.LoadActionsNotes(note); // Set Custom Notes Mechanics
			AddTrail('Player'); // Player Set Trail
			if (isPlayerMain)
				SingDiretions('BF', 15, note); // Player Sing Diretions
			playerStrums.forEach(function(spr:FlxSprite){
				StrumNote.GlowHitNote('PlayerHit', spr, note); // on Hit Note Glown Note
			});
			note.wasGoodHit = true;
			vocals.volume = 1;
			if (!note.isSustainNote){
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
			updateAccuracy();
		}
	}
	function opponentNoteHit(daNote:Note){ // Opponent Note Hit
		var opponentHitedCounter:Int = 0;
		if (SONG.song != 'Tutorial')
			camZooming = true;
		var altAnim:String = "";
		if (SONG.notes[Math.floor(curStep / 16)] != null){
			if (SONG.notes[Math.floor(curStep / 16)].altAnim)
				altAnim = '-alt';
		}
		ShakingSingChars('OpponentSing');
		if (grabbediconP2)
			opponentHitedCounter++;
		else{
			switch (curTrack){
				case 'Roses':
					if (mainDifficulty == 4)
						if (curStep >= 64)	
							HealthAction('HealthDrain', 0.0325);
			}
		}
		if (!playerTurn){
			if (opponentHitedCounter % 125 == 0)
				interuptgrabbedOpponentHealth = true;
		}
		if (isOpponentMain)
			SingDiretions('Opponent', 15, altAnim, daNote); // Opponent Sings Diretions
		if (Client.p2GlowHit){
			opponentStrums.forEach(function(spr:FlxSprite){
				StrumNote.GlowHitNote('OpponentHit', spr, daNote); // on Hit Note Glown Note
			});
		}
		dad.holdTimer = 0;
		if (SONG.needsVoices)
			vocals.volume = 1;
		daNote.kill();
		notes.remove(daNote, true);
		daNote.destroy();
	}
	override function stepHit(){
		super.stepHit();
		stepOfLast = curStep;
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20){
			resyncVocals();
		}
		#if windows
		songLength = FlxG.sound.music.length;
		#end
		var secondsTrackShit = Std.int(Conductor.songPosition / 1000);
		if (loops == 0){
			#if windows
			DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + mainDifficultyText + ")", null, iconRPC, true, songLength - Conductor.songPosition); // Updating Discord Rich Presence (with Time Left)
			#end
			trace(detailsText + " " + SONG.song + " (" + mainDifficultyText + ")" + '\nLoop ' + loops + '\n' + secondsTrackShit);
		}else if (Client.endless && loops >= 1 && !isStoryMode){
			#if windows
			DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + mainDifficultyText + ")", 'Loop ' + loops, iconRPC, true, songLength - Conductor.songPosition); // Updating Discord Rich Presence (with Time Left)
			#end
			trace(detailsText + " " + SONG.song + " (" + mainDifficultyText + ")" + '\nLoop ' + loops + '\n' + secondsTrackShit);
		}
		switch (curTrack){
			case 'Cocoa':
				if (dad.curCharacter == 'parents')
					switch (curStep){
						case 130 | 385 | 576:
							healthBar.createFilledBar(0xFFd8558e, boyfriend.healthBarColor); // Mom Turn
						case 260 | 512:
							healthBar.createFilledBar(0xFFaf66ce, boyfriend.healthBarColor); // Dad Turn
					}
			case 'Eggnog':
				if (dad.curCharacter == 'parents')
					switch (curStep){
						case 160 | 416 | 608 | 864:
							healthBar.createFilledBar(0xFFd8558e, boyfriend.healthBarColor); // Mom Turn
						case 290 | 482 | 738:
							healthBar.createFilledBar(0xFFaf66ce, boyfriend.healthBarColor); // Dad Turn
					}
		}
	}
	function removeTrail(player:String){ // Remove Trail on Idle Anim
		switch (player){
			case 'Player': // Player Trails
				switch (curTrack){
					case 'Thorns':
						remove(bfThornsTrail);
				}
			//case 'Opponent': // Opponent Trails
		}
	}
	override function beatHit(){
		super.beatHit();
		if (generatedMusic)
			notes.sort(FlxSort.byY, (Client.isDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		if (SONG.notes[Math.floor(curStep / 16)] != null){
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM){
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection){
				dad.dance();
				camX = 0;
				camY = 0;
			}
		}

		wiggleShit.update(Conductor.crochet);

		if (Client.camBeatZoom && camZooming && FlxG.camera.zoom < 1.35 && camNOTE.zoom < 1.35 && curBeat % 4 == 0){ // is Cam Zooming Lol
			FlxG.camera.zoom += 0.015;
			camNOTE.zoom += 0.05;
			camHUD.zoom += 0.05;
		}

		if (curBeat % gfSpeed == 0){gf.dance();}

		if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')){ // BoyFrind is Sing, Icon Beating Turn and No Missed
			iconPlayersBeat('Player', 1.365);
		}
		if (dad.animation.curAnim.name.startsWith("sing")){ // Opponent is Sing, Icon Beating Turn
			iconPlayersBeat('Opponent', 1.365);
		}
		if (!boyfriend.animation.curAnim.name.startsWith("sing") && !bfDodging){ // BoyFrined Stop Sing Animations, Back to Idle
			boyfriend.playAnim('idle');
			removeTrail('Player');
		}

		switch (curTrack){ // Tracks/Songs Events
			case 'Spookeez':
				switch (curStep){
					case 16 | 576 | 640 | 704 | 768 | 832 | 896: // Just LightStrike of Spookeez (is Hard to Listen)
						TrackMap.lightningStrikeShit();
				}
			case 'Tutorial':
				if (curBeat % 16 == 15 && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48){ // Bruh is Default of FNF
					boyfriend.playAnim('hey', true);
					dad.playAnim('cheer', true);
				}
			case 'Bopeebo':
				if (curBeat % 8 == 7) // Again XP DEFAULT Bro
					boyfriend.playAnim('hey', true);
			case 'Milf':
				if (Client.camBeatZoom && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35 && camNOTE.zoom < 1.35){ // This Facking Beating Super Zooming of FACKING MILF, I Love This Song XP
					FlxG.camera.zoom += 0.016;
					camNOTE.zoom += 0.1;
					camHUD.zoom += 0.1;
				}else if (Client.camBeatZoom && curBeat >= 8 && curBeat < 328){ // Normal Beating :O
					FlxG.camera.zoom += 0.015;
					camNOTE.zoom += 0.0435;
					camHUD.zoom += 0.0435;
				}
		}

		switch (TrackMap.curMap){ // Maps Events
			case 'spooky':
				if (TrackMap.isHalloween && FlxG.random.bool(25) && curBeat > TrackMap.lightningStrikeBeat + TrackMap.lightningOffset){ // Spooky LightStirke
					TrackMap.lightningStrikeBeat = curBeat;
					TrackMap.lightningStrikeShit();
				}
			case "philly":
				if (!TrackMap.trainMoving)
					TrackMap.trainCooldown += 1; // Train is no Moving, 1 beat + 1 countdown
				if (curBeat % 4 == 0){
					TrackMap.phillyCityLights.forEach(function(light:FlxSprite){ // Lights Random Change
						light.visible = false;
					});
					TrackMap.curLight = FlxG.random.int(0, TrackMap.phillyCityLights.length - 1);
					TrackMap.phillyCityLights.members[TrackMap.curLight].visible = true;
					switch (curTrack){
						case 'Philly':
							//if (Client.VisualEffects){
								if (curBeat >= 168 && curBeat < 230){
									var timerShit:Float = .35;
									var ass:Bool = true;
									var lightCam:Array<Int> = [
										0xFF31a2fd, // Blue
										0xFF31fd8c, // Green
										0xFFfb33f5, // Purple
										0xFFfd4531, // Orange
										0xFFfba633 // Yellow
									];
									switch (TrackMap.curLight){
										case 0:
											Flash(lightCam[0], timerShit, ass);
											healthBar.createFilledBar(lightCam[0], lightCam[0]);
										case 1:
											Flash(lightCam[1], timerShit, ass);
											healthBar.createFilledBar(lightCam[1], lightCam[1]);
										case 2:
											Flash(lightCam[2], timerShit, ass);
											healthBar.createFilledBar(lightCam[2], lightCam[2]);
										case 3:
											Flash(lightCam[3], timerShit, ass);
											healthBar.createFilledBar(lightCam[3], lightCam[3]);
										case 4:
											Flash(lightCam[4], timerShit, ass);
											healthBar.createFilledBar(lightCam[4], lightCam[4]);
									}
								}
								if (curBeat == 232)
									healthBar.createFilledBar(0xFF31b0d1, 0xFFb7d855);
					}
				}
				if (curBeat % 8 == 4 && FlxG.random.bool(35) && !TrackMap.trainMoving && TrackMap.trainCooldown > 8){ // Train Moving Random on Contdown Timer 8 for up
					TrackMap.trainCooldown = FlxG.random.int(-4, 0);
					TrackMap.trainStart();
				}
			case 'limo':
				TrackMap.grpLimoDancers.forEach(function(dancer:BackgroundDancer){ // Dancers in Limo Beat Dance Anim
					dancer.dance();
				});
				if (FlxG.random.bool(12) && TrackMap.fastCarCanDrive) // Ultra Fest Car Passing
					TrackMap.fastCarDrive();
			case 'mall': // Just Idle of BGS 
				TrackMap.upperBoppers.animation.play('bop', true);
				TrackMap.bottomBoppers.animation.play('bop', true);
				TrackMap.santa.animation.play('idle', true);
			case 'pixSchool':
				TrackMap.bgGirls.dance(); // The Sucks Girl Dance
		}
	}
	function PlayShitAnim(char:Character, playAnimShit:String, Force:Bool):Void{
		char.playAnim(playAnimShit, Force); // Character Play Animation
	}
	public static function Flash(Color:Int, ?Duration:Float, Force:Bool):Void{
		FlxG.camera.flash(Color, Duration, Force); // Set Flash Color
	}
	public static function Shake(nameFack:FlxCamera ,Intensity:Float = 0.01, Duration:Float = 0.02, ?OnComplete:Void->Void, Force:Bool = true, ?Axes:FlxAxes):Void{
		nameFack.shake(Intensity, Duration, OnComplete, Force, Axes); // Just Facking Shaking Bro
	}
	function SetActionObject(Object:Dynamic, Values:Dynamic, ?Duration:Float, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(Object, Values, Duration, Options); // Make Action Object, Example Any Action Object :P
	}
	function SetAlphaObject(Object:Dynamic, ToAlpha:Float, ?Duration:Float, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(Object, {alpha: ToAlpha}, Duration, Options); // Make Action Object, Example Place Alpha Object :P
	}
	function SetAngleObject(?Sprite:FlxSprite, ?FromAngle:Float, ToAngle:Float, ?Duration:Float, ?Options:Null<TweenOptions>):Void{
		FlxTween.angle(Sprite, FromAngle, ToAngle, Duration, Options); // Make Action Object, Example Rotation Object
	}
	function SetPosObject(Object:Dynamic, IsXPos:Int, IsYPos:Int, ?Duration:Float, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(Object, {x: IsXPos, y: IsYPos}, Duration, Options); // Make Action, Move Position Object
	}
	public static function SetXObject(Object:Dynamic, IsXPos:Int, ?Duration:Float, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(Object, {x: IsXPos}, Duration, Options); // Make Action X Object
	}
	public static function SetYObject(Object:Dynamic, IsYPos:Int, ?Duration:Float, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(Object, {y: IsYPos}, Duration, Options); // Make Action Y Object
	}
	function AddShitOffset(newAction:Bool = true, diretionChoice:String, playNewAnim:String, offsetX:Int, offsetY:Int){ // AddNewOffset of Char in Chart
		if (newAction){
			dad.playAnim ('playNewAnim', true);
			dad.addOffset("diretionChoice", offsetX, offsetY);
			dad.animation.getByName('diretionChoice').frames = dad.animation.getByName('playNewAnim').frames;
		}else{
			dad.addOffset("diretionChoice", offsetX, offsetY);
			dad.animation.getByName('diretionChoice').frames = dad.animation.getByName('playNewAnim').frames;
		}
	}
	function SetZoom(zoomType:String, cam:FlxCamera, zoomValue:Float, ?steping:Int = 0, ?resetStep:Int = 0, ?beating:Int = 0, ?resetBeat:Int = 0){ // Choice You CamZoom Types :D
		if (zoomType == 'Zoom')
			cam.zoom += zoomValue;
		if (zoomType == 'StaticZoom')
			cam.zoom = zoomValue;
		if (zoomType == 'StepZoom'){
			if (curStep % steping == resetStep)
				cam.zoom += zoomValue;
		}
		if (zoomType == 'BeatZoom'){
			if (curBeat % beating == resetBeat)
				cam.zoom += zoomValue;
		}
	}
	function ResetTurn():Void{
		isPlayerMain = false;
		isOpponentMain = false;
		isPicoPlayer = false;
		ismom = false;
	}
	function PassthePlayerTurn(char:String):Void{
		switch(char){
			case 'BF-P1':
				isPlayerMain = true;
			case 'dad':
				isOpponentMain = true;
			case 'PICO-P1':
				isPicoPlayer = true;
			case 'mom':
				ismom = true;
		}
	}
	function ChangeChar(player:String, ?idChar:String, ?offsetX:Int = 0, ?offsetY:Int = 0){
		if (player == 'Player'){
			if (offsetX == 0 && offsetY == 0){
				var oldBFX = boyfriend.x;
				var oldBFY = boyfriend.y;
				remove(boyfriend);
				boyfriend = new Boyfriend(oldBFX, oldBFY, idChar);
				add(boyfriend);
			}else{
				remove(boyfriend);
				boyfriend = new Boyfriend(offsetX, offsetY, idChar);
				add(boyfriend);
			}
			iconP1.animation.play(idChar);
		}
		if (player == 'Opponent'){
			if (offsetX == 0 && offsetY == 0){
				var oldDADX = dad.x;
				var oldDADY = dad.y;
				remove(dad);
				dad = new Character(oldDADX, oldDADY, idChar);
				add(dad);
			}else{
				remove(dad);
				dad = new Character(offsetX, offsetY, idChar);
				add(dad);
			}
			iconP2.animation.play(idChar);
		}
		if (player == 'GirlFriend'){
			if (offsetX == 0 && offsetY == 0){
				var oldGFX = gf.x;
				var oldGFY = gf.y;
				remove(gf);
				gf = new Character(oldGFX, oldGFY, idChar);
				add(gf);
			}else{
				remove(gf);
				gf = new Character(offsetX, offsetY, idChar);
				add(gf);
			}
		}
	}
	function ShakingSingChars(player:String){
		if (player == 'OpponentSing'){
			switch (dad.curCharacter){
				case 'pico':
					switch (curTrack){
						case 'Philly':
							if (curBeat >= 168 && curBeat < 216){
								Shake(camNOTE, 0.0125, 0.02, null, true, FlxAxes.X);
								Shake(camGame, 0.0125, 0.02, null, true, FlxAxes.X);
								Shake(camHUD, 0.0125, 0.02, null, true, FlxAxes.X);
							}
					}
			}
		}
		if (player == 'PlayerSing'){
			switch (boyfriend.curCharacter){
			}
		}
	}
	function Alert(typeAlert:Int = 0):Void{
		trace('Danger Incoming');
		switch (typeAlert){
			case 0:
				//kb_attack_alert.animation.play('alert');
				//FlxG.sound.play(Paths.sound('alert','qt'), 1);
		}
	}
	function AttackShit(Attacked:Bool = false):Void{
		if (Attacked){ // Attack Anim
			//FlxG.sound.play(Paths.sound('attack','qt'),0.75);
			//Play saw attack animation
			//kb_attack_saw.animation.play('fire');
			//kb_attack_saw.offset.set(1600,0);
			switch (TrackMap.curMap){
				case 'philly':
					dad.playAnim('UziShot');
					//Flash(FlxColor.WHITE, 0.2, true);
			}
			new FlxTimer().start(0.09, function(tmr:FlxTimer){
				if(!bfDodging){
					//deathBySawBlade = true;
					//health -= 999999999999;
					health = 0;
				}
			});
		}else{ // Prepare to Attack (Anim)
			//kb_attack_saw.animation.play('prepare');
			//kb_attack_saw.offset.set(-333,0);
		}
	}
	function Teleport(nameLocation:String, ?currentCharNameInTrack:String, ?customXPlayer:Int, ?customYPlayer:Int, ?customXOpponent:Int, ?customYOpponent:Int, ?offsetFlipedX:Bool){
		var olddadx = dad.x;
		var olddady = dad.y;
		var oldbfdx = boyfriend.x;
		var oldbfdy = boyfriend.y;
		if (nameLocation == 'NewLocation'){
			if (boyfriend.curCharacter.startsWith('bf')){ // Is Fliped Offsets Fixed XP
				remove(boyfriend);
				boyfriend = new Boyfriend(olddadx, olddady);
				add(boyfriend);
				boyfriend.flipX = true;
				boyfriend.addOffset("singUP", -9, 28);
				boyfriend.addOffset("singRIGHT", -40, -5);
				boyfriend.addOffset("singLEFT", -38, -5);
				boyfriend.addOffset("singRIGHT", -38, -7);
				boyfriend.addOffset("singDOWN", -26, -52);
				boyfriend.addOffset("singUPmiss", -8, 27);
				boyfriend.addOffset("singRIGHTmiss", 37, 16);
				boyfriend.addOffset("singLEFTmiss", -30, 18);
				boyfriend.addOffset("singDOWNmiss", -35, -22);
				boyfriend.addOffset('scared', -4);
				boyfriend.addOffset('singDODGE', -27, -8);
			}
			if (dad.curCharacter == currentCharNameInTrack){
				remove(dad);
				dad = new Character(oldbfdx, oldbfdy, currentCharNameInTrack);
				add(dad);
				iconP2.animation.play(currentCharNameInTrack);
				dad.flipX = true;
				// Offset Dad is Broken? Place Here You Fixed Opponent Offset
			}
			ChangeScrollPosition('TeleportScroll', true);
		}
		if (nameLocation == 'OldLocation'){ // Just Use This Before Use NewLocation
			if (boyfriend.curCharacter.startsWith('bf')){ // Is Fliped Offsets Fixed XP
				remove(boyfriend);
				boyfriend = new Boyfriend(olddadx, olddady);
				add(boyfriend);
				boyfriend.flipX = false;
				boyfriend.addOffset("singUP", -29, 27);
				boyfriend.addOffset("singRIGHT", -38, -7);
				boyfriend.addOffset("singLEFT", 12, -6);
				boyfriend.addOffset("singRIGHT", -38, -7);
				boyfriend.addOffset("singDOWN", -10, -50);
				boyfriend.addOffset("singUPmiss", -29, 27);
				boyfriend.addOffset("singRIGHTmiss", -30, 21);
				boyfriend.addOffset("singLEFTmiss", 12, 24);
				boyfriend.addOffset("singDOWNmiss", -11, -19);
				boyfriend.addOffset('scared', -4);
				boyfriend.addOffset('singDODGE', -5, -6);
			}
			if (dad.curCharacter == currentCharNameInTrack){
				remove(dad);
				dad = new Character(oldbfdx, oldbfdy, currentCharNameInTrack);
				add(dad);
				iconP2.animation.play(currentCharNameInTrack);
				dad.flipX = false;
				// Offset Dad is Broken? Place Here You Fixed Opponent Offset
			}
			ChangeScrollPosition('TeleportScroll', false);
		}
		if (nameLocation == 'Custom'){
			if (offsetFlipedX){
				ChangeScrollPosition('TeleportScroll', true);
			}else{
				ChangeScrollPosition('TeleportScroll', false);
			}
			if (boyfriend.curCharacter.startsWith('bf')){ // Is Fliped Offsets Fixed XP
				boyfriend.x = customXPlayer;
				boyfriend.y = customYPlayer;
				if (offsetFlipedX){ // Fliped Bro
					boyfriend.flipX = true;
					boyfriend.addOffset("singUP", -9, 28);
					boyfriend.addOffset("singRIGHT", -40, -5);
					boyfriend.addOffset("singLEFT", -38, -5);
					boyfriend.addOffset("singRIGHT", -38, -7);
					boyfriend.addOffset("singDOWN", -26, -52);
					boyfriend.addOffset("singUPmiss", -8, 27);
					boyfriend.addOffset("singRIGHTmiss", 37, 16);
					boyfriend.addOffset("singLEFTmiss", -30, 18);
					boyfriend.addOffset("singDOWNmiss", -35, -22);
					boyfriend.addOffset('scared', -4);
					boyfriend.addOffset('singDODGE', -27, -8);
				}else{ // Default Flip
					boyfriend.flipX = false;
					boyfriend.addOffset("singUP", -29, 27);
					boyfriend.addOffset("singRIGHT", -38, -7);
					boyfriend.addOffset("singLEFT", 12, -6);
					boyfriend.addOffset("singRIGHT", -38, -7);
					boyfriend.addOffset("singDOWN", -10, -50);
					boyfriend.addOffset("singUPmiss", -29, 27);
					boyfriend.addOffset("singRIGHTmiss", -30, 21);
					boyfriend.addOffset("singLEFTmiss", 12, 24);
					boyfriend.addOffset("singDOWNmiss", -11, -19);
					boyfriend.addOffset('scared', -4);
					boyfriend.addOffset('singDODGE', -5, -6);
				}
			}
			if (dad.curCharacter == currentCharNameInTrack){
				dad.x = customXOpponent;
				dad.y = customYOpponent;
				if (offsetFlipedX){ // Fliped Bro
					dad.flipX = false;
					// Offset Dad is Broken? Place Here You Fixed Opponent Offset
				}else{ // Default Flip
					dad.flipX = true;
				}
			}
		}
	}
	function ChangeScrollPosition(whatPreset:String, ?Fliped:Bool, ?scrollX:Int, ?scrollY:Int, ?suckTimer:Float, ?isPlayer:Bool){
		if (whatPreset == 'TeleportScroll'){
			if (Fliped){
				opponentStrums.forEach(function(spr:FlxSprite){
					if (!Client.mid)
						FlxTween.tween(spr, {x: spr.x += 642, y: spr.y}, 5, {ease: FlxEase.quartOut});
				});
				playerStrums.forEach(function(spr:FlxSprite){
					if (!Client.mid)
						FlxTween.tween(spr, {x: spr.x -= 642, y: spr.y}, 5, {ease: FlxEase.quartOut});
				});
			}else{
				opponentStrums.forEach(function(spr:FlxSprite){
					if (!Client.mid)
						FlxTween.tween(spr, {x: spr.x -= 642, y: spr.y}, 5, {ease: FlxEase.quartOut});
				});
				playerStrums.forEach(function(spr:FlxSprite){
					if (!Client.mid)
						FlxTween.tween(spr, {x: spr.x += 642, y: spr.y}, 5, {ease: FlxEase.quartOut});
				});
			}
		}
		if (whatPreset == 'Custom'){
			if (isPlayer){
				playerStrums.forEach(function(spr:FlxSprite){
					if (!Client.mid)
						FlxTween.tween(spr, {x: spr.x += scrollX, y: spr.y += scrollY}, suckTimer, {ease: FlxEase.quartOut});
				});
			}else{
				opponentStrums.forEach(function(spr:FlxSprite){
					if (!Client.mid)
						FlxTween.tween(spr, {x: spr.x += scrollX, y: spr.y += scrollY}, suckTimer, {ease: FlxEase.quartOut});
				});
			}
		}
	}
	public static function HealthAction(nameItem:String, Action:Float){ // Just Modchart for Source Code :D
		switch (nameItem){
			case 'SetHealth': // Set Value Static Health Example 2 (FULL HEALTH IMMEDIATE)
				PlayState.instance.health = Action;
			case 'HealthHeal': // Set Value to Healing
				PlayState.instance.health += Action;
			case 'HealthDrain': // Set Value to Drain
				PlayState.instance.health -= Action;
		}
	}
	public static function iconPlayersBeat(namePlayer:String, ?_scale:Float = 1.25, ?_time:Float = 0.2):Void{
		if (namePlayer == 'Player'){
			iconP1.iconScale = iconP1.defaultIconScale * _scale;
			FlxTween.tween(iconP1, {iconScale: iconP1.defaultIconScale}, _time, {ease: FlxEase.quintOut});
		}
		if (namePlayer == 'Opponent'){
			iconP2.iconScale = iconP2.defaultIconScale * _scale;
			FlxTween.tween(iconP2, {iconScale: iconP2.defaultIconScale}, _time, {ease: FlxEase.quintOut});
		}
	}
	function HealthType(?ForceHealth:Bool = false, ?amouthHealth:Float):Void{ // Defines How Much Maximum Health You Will Have.
		if (ForceHealth){
			var opponentToUse:Float = healthBar.x + (healthBar.width * (FlxMath.remapToRange((health / 2 * 100), 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
			if (iconP2.x - iconP2.width / 2 < healthBar.x && iconP2.x > opponentToUse){
				healthBarBG.offset.x = iconP2.x - opponentToUse;
				healthBar.offset.x = iconP2.x - opponentToUse;
			}else{
				healthBarBG.offset.x = 0;
				healthBar.offset.x = 0;
			}
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange((health / 2 * 100), 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = opponentToUse;
			if (health > amouthHealth)
				health = amouthHealth;
		}else{
			if (health > 2)
				health = 2;
		}
	}
	function PoisonHealth(scoreShit:Int = 300, timerShit:Float = 0.0001, healthDrainShit:Float = 0.0005):Void{
		misses++;
		combo = 0;
		chartScore -= scoreShit;
		healthBar.createFilledBar(dad.healthBarColor, 0xFF5400FF);
		var healthDrained:Float = 0;
		new FlxTimer().start(timerShit, function(swagTimer:FlxTimer){
			healthDrained += healthDrainShit;
			health -= healthDrainShit;
			if (healthDrained < 0.5){
				swagTimer.reset();
			}else{
				healthDrained = 0;
				healthBar.createFilledBar(dad.healthBarColor, boyfriend.healthBarColor);
			}
		});
	}
	function RegenerationHealth(scoreShit:Int = 325, timerShit:Float = 0.0001, healthGainedShit:Float = 0.0005):Void{ // Ragen You Healtn 
		misses++;
		combo = 0;
		chartScore += scoreShit;
		healthBar.createFilledBar(dad.healthBarColor, 0xFFFF00D2);
		var healthGained:Float = 0;
		new FlxTimer().start(timerShit, function(swagTimer:FlxTimer){
			healthGained += healthGainedShit;
			health += healthGained;
			if (healthGained < 0.5){
				swagTimer.reset();
			}else{
				healthGained = 0;
				healthBar.createFilledBar(dad.healthBarColor, boyfriend.healthBarColor);
			}
		});
	}
	function CrashShit(){ // This Game Crash, Is Nice :D
		trace('Staring Crashing');
		var thisF:FlxSprite = new FlxSprite();
		thisF.frames = Paths.getSparrowAtlas('crashp/GameError', 'TankmansRevengeWeek');
		thisF.setGraphicSize(FlxG.width, FlxG.height);
		thisF.width = 1280;
		thisF.height = 720;
		thisF.x = 0;
		thisF.y = 0;
		thisF.screenCenter(X);
		thisF.cameras = [camNOTE, camHUD];
		add(thisF);
		new FlxTimer().start(0.125, function(tmr:FlxTimer){
			trace('Push More Bug for Crash');
			FlxG.sound.play(Paths.sound('crashp/Fatalerror','shared'), 1); // no fix this, this is good to crash
			new FlxTimer().start(0.25, function(tmr:FlxTimer){
				//resyncingVocals = false;
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
				if (FlxG.sound.music != null){
					FlxG.sound.music.pause();
					vocals.pause();
				}
				notes.clear();
				var wtfthiscrap = new FlxSprite(0, 0, FlxScreenGrab.grab().bitmapData);
				wtfthiscrap.cameras = [camNOTE, camHUD];
				add(wtfthiscrap);
				new FlxTimer().start(0.4, function(tmr:FlxTimer){
					trace('I Crash You :D');
					LoadingState.loadAndSwitchState(new ForceCrash());
				});
			});

		});
	}
	function FlashNoteHit(isPlayer:Bool, scoreShit:Int = 200):Void{
		if (isPlayer){
			misses++;
			combo = 0;
			chartScore -= scoreShit;
		}else{}
		Flash(0xFFFFFFFF, 2.469, true);
		FlxG.sound.play(Paths.sound('FlashBangNoteEffectSound'), 1);
		SetAlphaObject(camHUD, 0, {ease: FlxEase.cubeOut});
		SetAlphaObject(camNOTE, 0, {ease: FlxEase.cubeOut});
		new FlxTimer().start(0.925, function(tmr:FlxTimer){
			SetAlphaObject(camHUD, 1, {ease: FlxEase.sineInOut});
			SetAlphaObject(camNOTE, 1, {ease: FlxEase.sineInOut});
		});
	}
	function soundPlayAnimsShit(){
		if (allowedToHeadbang){
			if (gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle'){
				switch (curTrack){
					case 'Philly':{
						if (curBeat < 250){
							if (curBeat != 184 && curBeat != 216){
								if (curBeat % 16 == 8){
									if (!triggeredAlready){
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
					case 'Bopeebo':{
						if (curBeat > 5 && curBeat < 130){
							if (curBeat % 8 == 7){
								if (!triggeredAlready){
									gf.playAnim('cheer');
									triggeredAlready = true;
								}
							}else triggeredAlready = false;
						}
					}
					case 'Blammed':{
						if (curBeat > 30 && curBeat < 190){
							if (curBeat < 90 || curBeat > 128){
								if (curBeat % 4 == 2){
									if (!triggeredAlready){
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
					case 'Cocoa':{
						if (curBeat < 170){
							if (curBeat < 65 || curBeat > 130 && curBeat < 145){
								if (curBeat % 16 == 15){
									if (!triggeredAlready){
										gf.playAnim('cheer');
										TrackMap.bottomBoppers.animation.play('bopHey!!');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
					case 'Eggnog':{
						if (curBeat > 10 && curBeat != 111 && curBeat < 220){
							if (curBeat % 8 == 7){
								if (!triggeredAlready){
									gf.playAnim('cheer');
									TrackMap.bottomBoppers.animation.play('bopHey!!');
									triggeredAlready = true;
								}
							}else triggeredAlready = false;
						}
					}
				}
			}
		}
	}
}
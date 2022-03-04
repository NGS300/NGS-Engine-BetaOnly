package;

import flixel.util.FlxAxes;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class TrackMap extends MusicBeatState{
    public static var fackAdd:Array<Dynamic> = [];
	public static var counterAdd:Array<Dynamic> = [];
	public static var gfVersion:String = 'gf';
	public static var curMap:String = '';
	public static var camZoom:Float = 1.05;
	public static var daPixelZoom:Float = 6;
	public static var halloweenBG:FlxSprite;
	public static var halloweenLevel:Bool = false;
	public static var isHalloween:Bool = false;
	public static var phillyCityLights:FlxTypedGroup<FlxSprite>;
	public static var phillyTrain:FlxSprite;
	public static var trainSound:FlxSound;
	public static var limo:FlxSprite;
	public static var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	public static var fastCar:FlxSprite;
	public static var upperBoppers:FlxSprite;
	public static var bottomBoppers:FlxSprite;
	public static var santa:FlxSprite;
	public static var bgGirls:BackgroundGirls;
	public static var lightningStrikeBeat:Int = 0;
	public static var lightningOffset:Int = 8;
	public static var trainMoving:Bool = false;
	public static var trainFrameTiming:Float = 0;
	public static var trainCars:Int = 8;
	public static var trainFinishing:Bool = false;
	public static var trainCooldown:Int = 0;
	public static var curLight:Int = 0;
	public static var startedMoving:Bool = false;
	public static var fastCarCanDrive:Bool = true;

    public static function LoadMap(NameMap:String = 'stage'){
        switch (NameMap){
            case 'stage':
                camZoom = 0.9;
				curMap = 'stage';

		        var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stage/stageback', 'maps'));
		        bg.antialiasing = Client.Antialiasing;
		        bg.scrollFactor.set(0.9, 0.9);
		        bg.active = false;
				fackAdd.push(bg);

		        var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stage/stagefront', 'maps'));
		        stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		        stageFront.updateHitbox();
		        stageFront.antialiasing = Client.Antialiasing;
		        stageFront.scrollFactor.set(0.9, 0.9);
		        stageFront.active = false;
				fackAdd.push(stageFront);

		        var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stage/stagecurtains', 'maps'));
		        stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		        stageCurtains.updateHitbox();
		        stageCurtains.antialiasing = Client.Antialiasing;
		        stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
				fackAdd.push(stageCurtains);

			case 'spooky':
				camZoom = 1.05;
				curMap = 'spooky';

				isHalloween = true;
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('spooky/halloween_bg', 'maps');
				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = Client.Antialiasing;
				fackAdd.push(halloweenBG);

			case 'philly':
				camZoom = 1.05;
				curMap = 'philly';

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'maps'));
				bg.scrollFactor.set(0.1, 0.1);
				fackAdd.push(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'maps'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				fackAdd.push(city);

				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				fackAdd.push(phillyCityLights);

				for (i in 0...5){
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'maps'));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = Client.Antialiasing;
					phillyCityLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain', 'maps'));
				fackAdd.push(streetBehind);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train', 'maps'));
				fackAdd.push(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('philly/train_passes', 'maps'));
				FlxG.sound.list.add(trainSound);

			  	var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street', 'maps'));
			  	fackAdd.push(street);

			case 'limo':
				camZoom = .9;
				curMap = 'limo';

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset', 'maps'));
				skyBG.scrollFactor.set(0.1, 0.1);
				fackAdd.push(skyBG);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo', 'maps');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				fackAdd.push(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				fackAdd.push(grpLimoDancers);

				for (i in 0...5){
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}

				var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay', 'maps'));
				overlayShit.alpha = 0.5;

				var limoTex = Paths.getSparrowAtlas('limo/limoDrive', 'maps');
				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = Client.Antialiasing;

				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol', 'maps'));

			case 'mall':
				camZoom = .8;
				curMap = 'mall';

				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('mall/bgWalls', 'maps'));
				bg.antialiasing = Client.Antialiasing;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				fackAdd.push(bg);

				upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('mall/upperBop', 'maps');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = Client.Antialiasing;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				fackAdd.push(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('mall/bgEscalator', 'maps'));
				bgEscalator.antialiasing = Client.Antialiasing;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				fackAdd.push(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('mall/christmasTree', 'maps'));
				tree.antialiasing = Client.Antialiasing;
				tree.scrollFactor.set(0.40, 0.40);
				fackAdd.push(tree);

			  	bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('mall/bottomBop', 'maps');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers Idle', 24, false);
				bottomBoppers.animation.addByPrefix('bopHey!!', 'Bottom Level Boppers HEY!!', 24, false);
			  	bottomBoppers.antialiasing = Client.Antialiasing;
			  	bottomBoppers.scrollFactor.set(0.9, 0.9);
			  	bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
			  	bottomBoppers.updateHitbox();
			  	fackAdd.push(bottomBoppers);

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('mall/fgSnow', 'maps'));
				fgSnow.active = false;
				fgSnow.antialiasing = Client.Antialiasing;
				fackAdd.push(fgSnow);

				santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('mall/santa', 'maps');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = Client.Antialiasing;
				fackAdd.push(santa);
			
			case 'mallEvil':
				camZoom = 1.05;
				curMap = 'mallEvil';

				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('mallEvil/evilBG', 'maps'));
				bg.antialiasing = Client.Antialiasing;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				fackAdd.push(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('mallEvil/evilTree', 'maps'));
				evilTree.antialiasing = Client.Antialiasing;
				evilTree.scrollFactor.set(0.2, 0.2);
				fackAdd.push(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image('mallEvil/evilSnow', 'maps'));
				evilSnow.antialiasing = Client.Antialiasing;
				fackAdd.push(evilSnow);

			case 'pixSchool':
				camZoom = 1.05;
				curMap = 'pixSchool';

				var bgSky = new FlxSprite().loadGraphic(Paths.image('school/weebSky', 'maps'));
				bgSky.scrollFactor.set(0.1, 0.1);
				fackAdd.push(bgSky);

				var repositionShit = -200;
				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('school/weebSchool', 'maps'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				fackAdd.push(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('school/weebStreet', 'maps'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				fackAdd.push(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('school/weebTreesBack', 'maps'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				fackAdd.push(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('school/weebTrees', 'maps');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				fackAdd.push(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('school/petals', 'maps');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				fackAdd.push(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);
				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);
				if (PlayState.SONG.song.toLowerCase() == 'roses'){
					bgGirls.getScared();
				}
				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				fackAdd.push(bgGirls);

			case 'pixSchoolEvil':
				camZoom = 1.05;
				curMap = 'pixSchoolEvil';

		        var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
		    	var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
		    	var posX = 400;
	            var posY = 200;

		        var bg:FlxSprite = new FlxSprite(posX, posY);
		        bg.frames = Paths.getSparrowAtlas('schoolEvil/animatedEvilSchool', 'maps');
		        bg.animation.addByPrefix('idle', 'background 2', 24);
		        bg.animation.play('idle');
		        bg.scrollFactor.set(0.8, 0.9);
		        bg.scale.set(6, 6);
		        fackAdd.push(bg);
        }
    }
	public static function counterEvent(SecEvents:String){
		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', ['UI/ready', "UI/set", "UI/go"]);
		introAssets.set('pix', ['UI/pixelUI/ready-pixel', 'UI/pixelUI/set-pixel', 'UI/pixelUI/date-pixel']);

		var introAlts:Array<String> = introAssets.get('default');
		var altSuffix:String = "";
		if (curMap.startsWith('pix')){
			introAlts = introAssets.get('pix');
			altSuffix = '-pixel';
		}
		switch (SecEvents){
			case 'CounterStart':
				PlayStartIdles(0);
			case 'Ready':
				var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
				ready.scrollFactor.set();
				ready.updateHitbox();
				if (curMap.startsWith('pix'))
					ready.setGraphicSize(Std.int(ready.width * daPixelZoom));
				ready.screenCenter();
				counterAdd.push(ready);
				FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000,{
					ease: FlxEase.cubeInOut,
					onComplete: function(twn:FlxTween){
						ready.destroy();
					}
				});
				PlayStartIdles(1);
			case 'Set':
				var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
				set.scrollFactor.set();
				if (curMap.startsWith('pix'))
					set.setGraphicSize(Std.int(set.width * daPixelZoom));
				set.screenCenter();
				counterAdd.push(set);
				FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000,{
					ease: FlxEase.cubeInOut,
					onComplete: function(twn:FlxTween){
						set.destroy();
					}
				});
				PlayStartIdles(2);
			case 'Go':
				var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
				go.scrollFactor.set();
				if (curMap.startsWith('pix'))
					go.setGraphicSize(Std.int(go.width * daPixelZoom));
				go.updateHitbox();
				go.screenCenter();
				counterAdd.push(go);
				FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000,{
					ease: FlxEase.cubeInOut,
					onComplete: function(twn:FlxTween){
						go.destroy();
					}
				});
				PlayStartIdles(3);
			case 'CounterEnd':
				PlayStartIdles(4);
		}
	}
	public static var volumeIntroSounds:Float = 0.7; // default 0.6
	public static function PlayStartIdles(SecItems:Int):Void{
		if (SecItems >= 0 && SecItems < 3){
			PlayState.iconPlayersBeat('Opponent', 1.435);
			PlayState.iconPlayersBeat('Player', 1.435);
		}
		PlayState.instance.boyfriend.playAnim('idle');
		PlayState.instance.dad.dance();
		PlayState.instance.gf.dance();
		switch (SecItems){
			case 0:
				FlxG.sound.play(Paths.sound('UISounds/intro3', 'shared'), volumeIntroSounds);
			case 1:
				FlxG.sound.play(Paths.sound('UISounds/intro2', 'shared'), volumeIntroSounds);
			case 2:
				FlxG.sound.play(Paths.sound('UISounds/intro1', 'shared'), volumeIntroSounds);
			case 3:
				FlxG.sound.play(Paths.sound('UISounds/introGo', 'shared'), volumeIntroSounds);
		}
		switch (curMap){
			case 'spooky':
				if (SecItems == 3)
					lightningStrikeStartShit();
			case "philly":
				if (!trainMoving){
					trainCooldown += 1;
				}
				phillyCityLights.forEach(function(light:FlxSprite){
					light.visible = false;
				});
				SecItems = FlxG.random.int(0, phillyCityLights.length - 1);
				phillyCityLights.members[SecItems].visible = true;
				if (SecItems == 1){
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer){
					dancer.dance();
				});
				if (FlxG.random.bool(55) && fastCarCanDrive)
					fastCarDrive();
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);
			case 'pixSchool':
				bgGirls.dance();
			//case 'pixschoolEvil':
		}
	}

	public static function LoadGFType(gfType:String = 'gf'){
		gfVersion = gfType;
		switch (gfType){
			case 'gf':
				gfVersion = 'gf';
			case 'gf-car':
				gfVersion = 'gf-car';
			case 'gf-christmas':
				gfVersion = 'gf-christmas';
			case 'gf-pixel':
				gfVersion = 'gf-pixel';
		}
	}
	
	public static function trainStart():Void{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	public static function updateTrainPos():Void{
		if (trainSound.time >= 4700){
			startedMoving = true;
			PlayState.Shake(PlayState.camNOTE, 0.015805, 0.016, null, true, FlxAxes.X);
			PlayState.Shake(PlayState.camGame, 0.015805, 0.016, null, true, FlxAxes.X);
			PlayState.Shake(PlayState.camHUD, 0.015805, 0.016, null, true, FlxAxes.X);
			PlayState.instance.gf.playAnim('hairBlow');
		}
		if (startedMoving){
			phillyTrain.x -= 400;
			if (phillyTrain.x < -2000 && !trainFinishing){
				phillyTrain.x = -1150;
				trainCars -= 1;
				if (trainCars <= 0)
					trainFinishing = true;
			}
			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	public static function trainReset():Void{
		PlayState.instance.gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	public static function fastCarDrive(){
		FlxG.sound.play(Paths.soundRandom('limo/carPass', 0, 1, 'maps'), 0.7);
		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer){
			resetFastCar();
		});
	}

	public static function resetFastCar():Void{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	public static function strike1():Void{
		lightningStrikeSoundShit();
	}
	public static function strike2():Void{
		lightningStrikeSoundShit();
		strike1();
	}
	public static function strike3():Void{
		lightningStrikeSoundShit();
		strike2();
	}

	public static function lightningStrikeSoundShit():Void{
		FlxG.sound.play(Paths.soundRandom('spooky/thunder', 1, 2, 'maps'));
	}

	public static function lightningStrikeStartShit():Void{
		lightningStrikeSoundShit();
		halloweenBG.animation.play('lightning');
		PlayState.Flash(0xFFFFFFFF, 0.3, true);
		lightningOffset = FlxG.random.int(8, 24);
		PlayState.instance.boyfriend.playAnim('scared', true);
		PlayState.instance.gf.playAnim('scared', true);
	}

	public static function lightningStrikeShit():Void{
		lightningStrikeSoundShit();
		halloweenBG.animation.play('lightning');
		PlayState.Flash(0xFFFFFFFF, 0.3, true);
		lightningOffset = FlxG.random.int(8, 24);
		PlayState.instance.boyfriend.playAnim('scared', true);
		PlayState.instance.gf.playAnim('scared', true);
		if (PlayState.mainDifficulty >= 4)
			strike3();
		if (PlayState.mainDifficulty >= 3)
			PlayState.instance.health -= 0.275;
	}
	public static function oldInput(direction:Int = 1):Void{ // This is Ghost Taping PLZ NO TOUTCH!
		var copyofBF = PlayState.instance.boyfriend;
		if (!copyofBF.stunned){
			PlayState.instance.health -= 0.04;
			PlayState.instance.addsDamageHealthSpriteTake += 0.04;
			PlayState.instance.interuptgrabbedPlayerIconHealth = true;
			if (PlayState.instance.combo > 5 && PlayState.instance.gf.animOffsets.exists('cry')){ PlayState.instance.gf.playAnim('cry'); }
			PlayState.misses++;
			PlayState.instance.combo = 0;
			PlayState.instance.chartScore -= 10;
			if (FlxG.save.data.missSounds){FlxG.sound.play(Paths.soundRandom('missSound/missnote', 1, 3, 'character'), FlxG.random.float(0.1, 0.2));}
			if (PlayState.instance.isPlayerMain){
				switch (direction){case 0: copyofBF.playAnim('singLEFTmiss', true); case 1: copyofBF.playAnim('singDOWNmiss', true); case 2: copyofBF.playAnim('singUPmiss', true); case 3: copyofBF.playAnim('singRIGHTmiss', true);}
			}
			PlayState.instance.updateAccuracy();
		}
	}
}
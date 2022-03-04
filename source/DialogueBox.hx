package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup{
	var box:FlxSprite;
	var curCharacter:String = '';
	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];
	var swagDialogue:FlxTypeText;
	var dropText:FlxText;
	public var finishThing:Void->Void;
	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var handSelect:FlxSprite;
	var face:FlxSprite;
	var bgFade:FlxSprite;
	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>){
		super();
		switch (PlayState.SONG.song.toLowerCase()){
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('pixel/school/Lunchbox', 'maps'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('pixel/school/LunchboxScary', 'maps'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}
		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);
		new FlxTimer().start(0.8325, function(tmr:FlxTimer){
			//FlxTween.tween(bgFade, {alpha: (1 / 5) * 0.7}, 0.625, {ease: FlxEase.cubeOut});
			FlxTween.tween(bgFade, {alpha: (1 / 5)}, 0.65, {ease: FlxEase.cubeOut});
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);
		box = new FlxSprite(-20, 45);
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase()){
			default:
			case 'senpai':
				hasDialog = true;
				boxSprite('senpai-pixel');
			case 'roses':
				hasDialog = true;
				boxSprite('senpai-angry-pixel');
			case 'thorns':
				hasDialog = true;
				boxSprite('spirit-pixel');
		}
		this.dialogueList = dialogueList;
		if (!hasDialog)
			return;

		switch (PlayState.SONG.song.toLowerCase()){
			default:
			case 'senpai' | 'roses' | 'thorns':
				portraitDialogue('senpai-pixel', -20, 40);
				portraitDialogue('bf-pixel', 0, 40);
		}
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * TrackMap.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);
		box.screenCenter(X);
		
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
			portraitLeft.screenCenter(X);

		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns'){
			handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('dialogueShits/talkingSprites/pixel/week6Talking/handTextBox', 'shared'));
			add(handSelect);
		}

		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns'){
			dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
			dropText.font = 'Pixel Arial 11 Bold';
			dropText.color = 0xFFD89494;
			add(dropText);
			swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
			swagDialogue.font = 'Pixel Arial 11 Bold';
			swagDialogue.color = 0xFF3F2021;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('school/pixelTextSound', 'maps'), 0.6)];
			add(swagDialogue);
		}else{
			dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 33);
			dropText.font = 'Highman.ttf';
			dropText.color = 0xFFD89494;
			add(dropText);
			swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 33);
			swagDialogue.font = 'Highman.ttf';
			swagDialogue.color = 0xFF3F2021;
			//swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
			add(swagDialogue);
		}
		dialogue = new Alphabet(0, 80, "", false, true);
	}
	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	override function update(elapsed:Float){
		if (PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns'){
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}
		dropText.text = swagDialogue.text;
		if (box.animation.curAnim != null){
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished){
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}
		if (dialogueOpened && !dialogueStarted){
			startDialogue();
			dialogueStarted = true;
		}
		var alphaShit:Float = 1.405;
		if (FlxG.mouse.justPressed && dialogueStarted == true){
			remove(dialogue);
			FlxG.sound.play(Paths.sound('clickText'), 0.8);
			if (dialogueList[1] == null && dialogueList[0] != null){
				if (!isEnding){
					isEnding = true;
					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);
					new FlxTimer().start(0.4, function(tmr:FlxTimer){
						FlxTween.tween(box, {alpha: 0}, alphaShit, {ease: FlxEase.cubeOut});
						FlxTween.tween(bgFade, {alpha: 0}, alphaShit, {ease: FlxEase.cubeOut});
						if (PlayState.SONG.song.toLowerCase() == 'thorns')
							FlxTween.tween(face, {alpha: 0}, alphaShit, {ease: FlxEase.cubeOut});
						else{
							FlxTween.tween(portraitRight, {alpha: 0}, alphaShit, {ease: FlxEase.cubeOut});
							FlxTween.tween(portraitLeft, {alpha: 0}, alphaShit, {ease: FlxEase.cubeOut});
						}
						FlxTween.tween(swagDialogue, {alpha: 0}, alphaShit, {ease: FlxEase.cubeOut});
						dropText.alpha = swagDialogue.alpha;
					}, 5);
					new FlxTimer().start(1.475, function(tmr:FlxTimer){
						finishThing();
						kill();
						FlxG.mouse.visible = false;
						FlxTween.tween(PlayState.camNOTE, {alpha: 1}, 0.825, {ease: FlxEase.cubeIn});
						FlxTween.tween(PlayState.camHUD, {alpha: 1}, 0.825, {ease: FlxEase.cubeIn});
						//if (Client.midBG)
							//FlxTween.tween(PlayState.camMidBG, {alpha: 1}, 0.825, {ease: FlxEase.cubeIn});
					});
				}
			}else{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		if (FlxG.keys.justPressed.SPACE){ // Space to skip dialogue
			finishThing();
			kill();
			FlxG.mouse.visible = false;
			new FlxTimer().start(1.05, function(tmr:FlxTimer){
				FlxTween.tween(PlayState.camNOTE, {alpha: 1}, 0.8, {ease: FlxEase.cubeIn});
				FlxTween.tween(PlayState.camHUD, {alpha: 1}, 0.8, {ease: FlxEase.cubeIn});
				//if (Client.midBG)
					//FlxTween.tween(PlayState.camMidBG, {alpha: 1}, 0.8, {ease: FlxEase.cubeIn});
			});
		}
		super.update(elapsed);
	}
	var isEnding:Bool = false;
	function startDialogue():Void{
		cleanDialog();
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		switch (curCharacter){
			case 'bf':
				tweenPortrait('bf');
			case 'dad':
				tweenPortrait('dad');
		}
	}
	function cleanDialog():Void{
		var splitName:Array<String> = dialogueList[0].split("|");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
	function tweenPortrait(chart:String, ?showAlpha:Float = 0.315, ?hideAlpha:Float = 0.425){
		switch (chart){
			case 'bf':
				FlxTween.tween(portraitLeft, {alpha: 0}, hideAlpha, {ease: FlxEase.cubeOut});
				if (portraitRight.alpha == 0){
					FlxTween.tween(portraitRight, {alpha: 1}, showAlpha, {ease: FlxEase.cubeIn});
					portraitRight.animation.play('enter');
				}
			case 'dad':
				FlxTween.tween(portraitRight, {alpha: 0}, hideAlpha, {ease: FlxEase.cubeOut});
				if (portraitLeft.alpha == 0){
					FlxTween.tween(portraitLeft, {alpha: 1}, showAlpha, {ease: FlxEase.cubeIn});
					portraitLeft.animation.play('enter');
				}
		}
	}
	function portraitDialogue(charPortrait:String, Xpos:Int, Ypos:Int){
		switch (charPortrait){
			case 'senpai-pixel':
				portraitLeft = new FlxSprite(Xpos, Ypos);
				portraitLeft.frames = Paths.getSparrowAtlas('dialogueShits/portraits/pixel/week6Port/senpaiPortrait', 'shared');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * TrackMap.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				//portraitLeft.visible = false;
				portraitLeft.alpha = 0;
			case 'bf-pixel':
				portraitRight = new FlxSprite(Xpos, Ypos);
				portraitRight.frames = Paths.getSparrowAtlas('dialogueShits/portraits/pixel/week6Port/bfPortrait', 'shared');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * TrackMap.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				//portraitRight.visible = false;
				portraitRight.alpha = 0;
		}
	}
	function boxSprite(spriteShit:String = 'default'){
		switch (spriteShit){
			case 'default':
				box.frames = Paths.getSparrowAtlas('dialogueShits/talkingSprites/speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);
				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
			case 'senpai-pixel':
				box.frames = Paths.getSparrowAtlas('dialogueShits/talkingSprites/pixel/week6Talking/dialogueBox-pixel', 'shared');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'senpai-angry-pixel':
				FlxG.sound.play(Paths.sound('school/AngryShit_Text_Box', 'maps'));
				if (PlayState.mainDifficulty == 4)
					PlayState.HealthAction('HealthDrain', 0.5);
				box.frames = Paths.getSparrowAtlas('dialogueShits/talkingSprites/pixel/week6Talking/dialogueBox-senpaiMad', 'shared');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);
			case 'spirit-pixel':
				box.frames = Paths.getSparrowAtlas('dialogueShits/talkingSprites/pixel/week6Talking/dialogueBox-evil', 'shared');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
				face = new FlxSprite(320, 170).loadGraphic(Paths.image('dialogueShits/portraits/pixel/week6Port/spiritFaceForward', 'shared'));
				face.setGraphicSize(Std.int(face.width * 6));
				face.alpha = 1;
				add(face);
		}
	}
}

package;

import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class StrumNote extends FlxSprite{
    public static function TweenNote(skin:FlxSprite, tweenShit:Bool, numStrum:Int){ // Tween Alpha and Y post Basic of Gen Static Arrow
        var floatTimer:Float = 0;
        var fackDelay:Float = 0;
        var theHELLTIMER:Float = 0;
        if (tweenShit){
            skin.y -= 10;
            skin.alpha = 0;
            switch (PlayState.instance.curTrack){
                case 'Tutorial':
                    floatTimer = 0.55;
                    fackDelay = 0.6;
                    theHELLTIMER = 2.5;
                case 'Dadbattle' | 'Thorns':
                    floatTimer = 0.1985;
                    fackDelay = 0.5;
                    theHELLTIMER = 0.095;
                default:
                    floatTimer = 0.2;
                    fackDelay = 0.5;
                    theHELLTIMER = 1;
            }
            FlxTween.tween(skin, {y: skin.y + 10, alpha: 1}, theHELLTIMER, {ease: FlxEase.circOut, startDelay: fackDelay + (floatTimer * numStrum)});
        }
	}
    public static function LoadExtraCodeArrow(skin:FlxSprite):Void{ // Just Load Bruh Code
        skin.updateHitbox();
		skin.scrollFactor.set();
        skin.animation.play('static');
		skin.x += 50;
    }
    public static function GlowHitNote(playerNameAction:String, spr:FlxSprite, ?note:Note, ?pressArray:Array<Bool>, ?holdArray:Array<Bool>){ // Load Hit,Press Animations
		if (playerNameAction == 'PlayerHit'){
            if (Client.bot){
                if (Math.abs(note.noteData) == spr.ID)
                    if (!note.isSustainNote)
                        spr.animation.play('glown', true);
                if (spr.animation.curAnim.name == 'glown' && !TrackMap.curMap.startsWith('pix')){
                    spr.centerOffsets();
                    spr.offset.x -= 13;
                    spr.offset.y -= 13;
                }else
                    spr.centerOffsets();
            }else{
                if (Math.abs(note.noteData) == spr.ID){
                    if (!note.isSustainNote)
                        spr.animation.play('glown', true);
                }
            }
		}
        if (playerNameAction == 'PlayerIdle'){
            if (Client.bot){
                if (spr.animation.finished){
                    spr.animation.play('static');
                    spr.centerOffsets();
                }
            }else{
                if (pressArray[spr.ID] && spr.animation.curAnim.name != 'glown')
                    spr.animation.play('pressed');
                if (!holdArray[spr.ID])
                    spr.animation.play('static');
                if (spr.animation.curAnim.name == 'glown' && !TrackMap.curMap.startsWith('pix')){
                    spr.centerOffsets();
                    spr.offset.x -= 13;
                    spr.offset.y -= 13;
                }else
                    spr.centerOffsets();
            }
        }
        if (playerNameAction == 'OpponentIdle'){
            if (spr.animation.finished){
                spr.animation.play('static');
                spr.centerOffsets();
            }
        }
		if (playerNameAction == 'OpponentHit'){
			if (Math.abs(note.noteData) == spr.ID)
                if (!note.isSustainNote)
				    spr.animation.play('glown', true);
			if (spr.animation.curAnim.name == 'glown' && !TrackMap.curMap.startsWith('pix')){
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}else
				spr.centerOffsets();
		}
	}
    public static function LoadImageArrow(nameArrowImageTOPush:String, skin:FlxSprite):Void{ // Load Sprite of Strums of Name IFS
        if (nameArrowImageTOPush == 'pixel'){
            skin.loadGraphic(Paths.image('NoteSkins/pix/arrows-pixels', 'shared'), true, 17, 17);
            skin.animation.add('green', [6]);
            skin.animation.add('red', [7]);
            skin.animation.add('blue', [5]);
            skin.animation.add('purplel', [4]);
            skin.setGraphicSize(Std.int(skin.width * TrackMap.daPixelZoom));
            skin.updateHitbox();
            skin.antialiasing = false;
        }
        if (nameArrowImageTOPush == 'default'){
            skin.frames = Paths.getSparrowAtlas('NoteSkins/NOTE_assets', 'shared');
            skin.animation.addByPrefix('green', 'arrowUP');
            skin.animation.addByPrefix('blue', 'arrowDOWN');
            skin.animation.addByPrefix('purple', 'arrowLEFT');
            skin.animation.addByPrefix('red', 'arrowRIGHT');
            skin.antialiasing = Client.Antialiasing;
            skin.setGraphicSize(Std.int(skin.width * 0.7));
        }
    }
    public static function LoadAnimArrow(nameArrowTOLoad:String, skin:FlxSprite, ?i:Int):Void{ // Load Diretion Arrow
        trace('Skin Selected ' + "[" + nameArrowTOLoad + "]");
        skin.x += Note.swagWidth * i;
        if (nameArrowTOLoad == 'pixel'){
            LoadImageArrow('pixel', skin);
            switch (i){
                case 0:
                    skin.animation.add('static', [0]);
                    skin.animation.add('pressed', [4, 8], 12, false);
                    skin.animation.add('glown', [12, 16], 24, false);
                case 1:
                    skin.animation.add('static', [1]);
                    skin.animation.add('pressed', [5, 9], 12, false);
                    skin.animation.add('glown', [13, 17], 24, false);
                case 2:
                    skin.animation.add('static', [2]);
                    skin.animation.add('pressed', [6, 10], 12, false);
                    skin.animation.add('glown', [14, 18], 12, false);
                case 3:
                    skin.animation.add('static', [3]);
                    skin.animation.add('pressed', [7, 11], 12, false);
                    skin.animation.add('glown', [15, 19], 24, false);
            }
        }
        if (nameArrowTOLoad == 'default'){
            LoadImageArrow('default', skin);
            switch (i){
                case 0:
                    skin.animation.addByPrefix('static', 'arrowLEFT');
                    skin.animation.addByPrefix('pressed', 'left pressed', 24, false);
                    skin.animation.addByPrefix('glown', 'left hited', 24, false);
                case 1:
                    skin.animation.addByPrefix('static', 'arrowDOWN');
                    skin.animation.addByPrefix('pressed', 'down pressed', 24, false);
                    skin.animation.addByPrefix('glown', 'down hited', 24, false);
                case 2:
                    skin.animation.addByPrefix('static', 'arrowUP');
                    skin.animation.addByPrefix('pressed', 'up pressed', 24, false);
                    skin.animation.addByPrefix('glown', 'up hited', 24, false);
                case 3:
                    skin.animation.addByPrefix('static', 'arrowRIGHT');
                    skin.animation.addByPrefix('pressed', 'right pressed', 24, false);
                    skin.animation.addByPrefix('glown', 'right hited', 24, false);
            }
        }
    }
    public static function LoadActionsNotes(note:Note){ // Load Mechanics of Custom Fack Notes :D I Love This
        switch (note.noteType){
            case 3:
                PlayState.instance.health -= 10;
        }
    }
}
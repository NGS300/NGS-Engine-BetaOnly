package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
using StringTools;
class Note extends FlxSprite{
	public static var instance:Note = null;
	public var strumTime:Float = 0;
	public var mustPress:Bool = false;
	public  var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var noteType:Int = 0;
	public var noteScore:Float = 1;
	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public var rating:String = "shit";
	public var modifiedByLua:Bool = false;
	public var pushColorName:Array<String> = ['purple', 'blue', 'green', 'red'];
	public var pushNoteName:Array<String> = [];
	public var sustainColorName:Int = 0;
	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?noteType:Int = 0){
		super();
		instance = this;
		if (prevNote == null)
			prevNote = this;
		this.noteType = noteType;
		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		x += 50;
		y -= 2000;
		this.strumTime = strumTime;
		if (this.strumTime < 0)
			this.strumTime = 0;
		this.noteData = noteData;
		if (TrackMap.curMap.startsWith('pix'))
			LoadSkin('pixel');
		else
			LoadSkin();
		x += swagWidth * noteData;
		animation.play(pushColorName[noteData] + 'Scroll');
		sustainColorName = noteData;
		if (Client.isDownscroll && sustainNote) 
			flipY = true;
		if (isSustainNote && prevNote != null){
			noteScore * 0.2;
			alpha = 0.6;
			x += width / 2;
			sustainColorName = prevNote.sustainColorName;
			animation.play(pushColorName[sustainColorName] + 'holdend');
			updateHitbox();
			x -= width / 2;
			if (TrackMap.curMap.startsWith('pix'))
				x += 30;
			if (prevNote.isSustainNote){
				prevNote.animation.play(pushColorName[prevNote.sustainColorName] + 'hold');
				if (Client.noteSpeed != 1)
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * Client.noteSpeed;
				else
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
			}
		}
	}
	override function update(elapsed:Float){
		super.update(elapsed);
		if (mustPress){
			switch (noteType){
				default:
					if (isSustainNote){
						if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
							&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
							canBeHit = true;
						else
							canBeHit = false;
					}else{
						if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
							&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
							canBeHit = true;
						else
							canBeHit = false;
					}
				case 1:
					if (isSustainNote){
						if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
							&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
							canBeHit = true;
						else
							canBeHit = false;
					}else{
						if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
							&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
							canBeHit = true;
						else
							canBeHit = false;
					}
				case 2 | 3:
					if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
						&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
						canBeHit = true;
					else
						canBeHit = false;
			}
			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset * Conductor.timeScale && !wasGoodHit)
				tooLate = true;
		}else{
			canBeHit = false;
			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}
		if (tooLate){
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
	public function LoadSkin(nameSkin:String = 'default'){ // LoadSkin Notes
		animation.play(pushColorName[noteData] + 'Scroll');
		if (nameSkin == 'pixel'){
			loadGraphic(Paths.image('NoteSkins/pix/arrows-pixels', 'shared'), true, 17, 17);
			if (isSustainNote)
				loadGraphic(Paths.image('NoteSkins/pix/arrowEnds', 'shared'), true, 7, 6);
			switch (noteType){
				default:
					LoadNoteType('pixel', 0 | 1);
				case 2:
					LoadNoteType('pixel', 2);
			}
			setGraphicSize(Std.int(width * TrackMap.daPixelZoom));
			updateHitbox();
		}
		if (nameSkin == 'default'){
			frames = Paths.getSparrowAtlas('NoteSkins/NOTE_assets', 'shared');
			var fackPushPussy = Paths.getSparrowAtlas('NoteTypesSkins/Skins/Spin_NOTE');
			for(pussy in fackPushPussy.frames){
				this.frames.pushFrame(pussy);
			}
			switch(noteType){
				default:
					LoadNoteType(0 | 1);
					setGraphicSize(Std.int(width * 0.7));
				case 2:
					LoadNoteType(2);
					setGraphicSize(Std.int(width * 0.7));
				case 3:
					LoadNoteType(3);
					setGraphicSize(Std.int(width * 0.42));
			}
			updateHitbox();
			antialiasing = Client.Antialiasing;
		}
	}
	public function LoadNoteType(arrowInNoteType:String = 'default', type:Int = 0){ // Load Mechanics NotesTypes
		switch (arrowInNoteType){
			case 'pixel':
				switch (type){
					case 0 | 1:
						for (i in 0...4){
							animation.add(pushColorName[i] + 'Scroll', [i + 4]); // Normal Notes
							animation.add(pushColorName[i] + 'hold', [i]); // Holds Notes
							animation.add(pushColorName[i] + 'holdend', [i + 4]); // End Holds Notes
						}
					case 2:
						for (i in 0...4)
							animation.add(pushColorName[i] + 'Scroll', [i + 22]);
				}
			case 'default':
				switch (type){
					case 0 | 1:
						frames = Paths.getSparrowAtlas('NoteSkins/NOTE_assets', 'shared');
						for (i in 0...4){
							animation.addByPrefix(pushColorName[i] + 'Scroll', pushColorName[i] + ' note'); // Normal notes
							animation.addByPrefix(pushColorName[i] + 'hold', pushColorName[i] + ' holdTail'); // Holding Note
							animation.addByPrefix(pushColorName[i] + 'holdend', pushColorName[i] + ' tailEnd'); // End Hold Trail
						}
					case 2:
						frames = Paths.getSparrowAtlas('NoteTypesSkins/Skins/Alert_NOTE');
						pushNoteName = ['Alert', 'Alert', 'Alert', 'Alert'];
						for (i in 0...4)
							animation.addByPrefix(pushColorName[i] + 'Scroll', pushNoteName[i] + ' Note'); // Normal notes
					case 3:
						frames = Paths.getSparrowAtlas('NoteTypesSkins/Skins/Spin_NOTE');
						pushNoteName = ['Spin', 'Spin', 'Spin', 'Spin'];
						for (i in 0...4)
							animation.addByPrefix(pushColorName[i] + 'Scroll', pushNoteName[i] + 'Whell'); // Normal notes
				}
		}
	}
}
package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;
	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var healthBarColor:FlxColor;
	public var holdTimer:Float = 0;
	public static var instance:Character;
	var fackThisGF:Bool = false;
	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false){
		super(x, y);
		instance = this;
		healthBarColor = isPlayer ? 0xFF66FF33 : 0xFFFF0000;
		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		var tex:FlxAtlasFrames;
		antialiasing = Client.Antialiasing;
		switch (curCharacter){
			case 'bf':
				var tex = Paths.getSparrowAtlas('bfChars/BOYFRIEND', 'character');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('singDODGE', 'boyfriend dodge', 24, false);
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singRIGHT", -38, -7);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset('scared', -4);
				addOffset('dodge', -5, -6);
				addOffset('singDODGE', -5, -6);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				playAnim('idle');
				healthBarColor = 0xFF31b0d1;
				flipX = true;

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('bfChars/christmas/bfChristmas', 'character');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				playAnim('idle');
				healthBarColor = 0xFF31b0d1;
				flipX = true;

			case 'bf-car':
				var tex = Paths.getSparrowAtlas('bfChars/bfCar', 'character');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');
				healthBarColor = 0xFF31b0d1;
				flipX = true;

			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('bfChars/pixel/bfPixel', 'character');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);
				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				playAnim('idle');
				width -= 100;
				height -= 100;
				antialiasing = false;
				healthBarColor = 0xFF31b0d1;
				flipX = true;

			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('bfChars/pixel/bfPixelsDEAD', 'character');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');
				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'gf':
				tex = Paths.getSparrowAtlas('gfChars/GF_assets', 'character');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, fackThisGF);
				animation.addByPrefix('singLEFT', 'GF left note', 24, fackThisGF);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, fackThisGF);
				animation.addByPrefix('singUP', 'GF Up Note', 24, fackThisGF);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, fackThisGF);
				animation.addByIndices('cry', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, fackThisGF);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, fackThisGF);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, fackThisGF);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, fackThisGF);
				animation.addByPrefix('scared', 'GF FEAR', 24);
				addOffset('cheer');
				addOffset('cry', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);
				addOffset('scared', -2, -17);
				playAnim('danceRight');
				healthBarColor = 0xFFA5004D;

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('gfChars/christmas/gfChristmas', 'character');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, fackThisGF);
				animation.addByPrefix('singLEFT', 'GF left note', 24, fackThisGF);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, fackThisGF);
				animation.addByPrefix('singUP', 'GF Up Note', 24, fackThisGF);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, fackThisGF);
				animation.addByIndices('cry', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, fackThisGF);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, fackThisGF);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, fackThisGF);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, fackThisGF);
				animation.addByPrefix('scared', 'GF FEAR', 24);
				addOffset('cheer');
				addOffset('cry', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);
				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairFall', 0, -9);
				addOffset('scared', -2, -17);
				playAnim('danceRight');
				healthBarColor = 0xFFA5004D;

			case 'gf-car':
				tex = Paths.getSparrowAtlas('gfChars/gfCar', 'character');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, fackThisGF);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, fackThisGF);
				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
				playAnim('danceRight');
				healthBarColor = 0xFFA5004D;

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('gfChars/pixel/gfPixel', 'character');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, fackThisGF);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, fackThisGF);
				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);
				playAnim('danceRight');
				setGraphicSize(Std.int(width * TrackMap.daPixelZoom));
				updateHitbox();
				antialiasing = false;
				healthBarColor = 0xFFA5004D;

			case 'dad':
				tex = Paths.getSparrowAtlas('charWeeks/1/Dad_Assets', 'character');
				frames = tex;
				animation.addByPrefix('idle', 'Dad Dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing UP NOTE', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing LEFT Note', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing RIGHT Note', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing DOWN NOTE', 24);

				addOffset('idle');
				addOffset("singUP", -3, 50);
				addOffset("singRIGHT", -3, 26);
				addOffset("singLEFT", -3, 9);
				addOffset("singDOWN", -3, -30);

				playAnim('idle');

				healthBarColor = 0xFFaf66ce;

			case 'spooky':
				tex = Paths.getSparrowAtlas('charWeeks/2/spooky_kids_assets', 'character');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');

				healthBarColor = 0xFFd57e00;

			case 'monster':
				tex = Paths.getSparrowAtlas('charWeeks/2/Monster_Assets', 'character');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);

				playAnim('idle');

				healthBarColor = 0xFFf3ff6e;

			case 'pico':
				tex = Paths.getSparrowAtlas('charWeeks/3/Pico_Assets', 'character');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				//if (isPlayer){
					animation.addByPrefix('singLEFT', 'Pico Note LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE RIGHT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE Right miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note LEFT Miss', 24, false);
				//}else{
					//animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					//animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					//animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					//animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				//}
				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);
				animation.addByPrefix('sing-UziShoot', 'Pico Shoot', 24);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -107, -8);
				addOffset("singLEFT", 41, 5);
				addOffset("singDOWN", -27, -76);
				if (isPlayer){
					addOffset("singUPmiss", -18, 67);
					addOffset("singRIGHTmiss", -85, 31);
					addOffset("singLEFTmiss", 62, 54);
					addOffset("singDOWNmiss", -49 -36);
				}
				addOffset("sing-UziShoot", -35, 38);

				playAnim('idle');

				healthBarColor = 0xFFb7d855;

			case 'mom':
				tex = Paths.getSparrowAtlas('charWeeks/4/Mom_Assets', 'character');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

				healthBarColor = 0xFFd8558e;

			case 'mom-car':
				tex = Paths.getSparrowAtlas('charWeeks/4/momCar', 'character');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				playAnim('idle');

				healthBarColor = 0xFFd8558e;

			case 'parents':
				frames = Paths.getSparrowAtlas('charWeeks/5/mom_dad_christmas_assets', 'character');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');

				healthBarColor = 0xFFaf66ce;

			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('charWeeks/5/monsterChristmas', 'character');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);

				playAnim('idle');

				healthBarColor = 0xFFf3ff6e;

			case 'senpai-pixel':
				frames = Paths.getSparrowAtlas('charWeeks/6/senpai', 'character');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

				healthBarColor = 0xFFffaa6f;

			case 'senpai-angry-pixel':
				frames = Paths.getSparrowAtlas('charWeeks/6/senpai', 'character');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

				healthBarColor = 0xFFffaa6f;

			case 'spirit-pixel':
				frames = Paths.getPackerAtlas('charWeeks/6/spirit', 'character');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

				healthBarColor = 0xFFff3c6e;
		}

		dance();

		if (isPlayer){
			flipX = !flipX;
			if (!curCharacter.startsWith('bf')){
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;
				if (animation.getByName('singRIGHTmiss') != null){
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float){
		if (!curCharacter.startsWith('bf')){
			if (animation.curAnim.name.startsWith('sing')){
				holdTimer += elapsed;
			}
			var dadVar:Float = 4;
			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001){
				dance();
				holdTimer = 0;
			}
		}
		switch (curCharacter){
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}
		super.update(elapsed);
	}
	private var danced:Bool = false;
	public function dance(){
		if (!debugMode){
			switch (curCharacter){
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair')){
						danced = !danced;
						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair')){
						danced = !danced;
						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair')){
						danced = !danced;
						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair')){
						danced = !danced;
						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'spooky':
					danced = !danced;
					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle');
			}
		}
	}
	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void{
		animation.play(AnimName, Force, Reversed, Frame);
		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName)){
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
		if (curCharacter == 'gf'){
			if (AnimName == 'singLEFT'){
				danced = true;
			}else if (AnimName == 'singRIGHT'){
				danced = false;
			}
			if (AnimName == 'singUP' || AnimName == 'singDOWN'){
				danced = !danced;
			}
		}
	}
	public function addOffset(name:String, x:Float = 0, y:Float = 0){
		animOffsets[name] = [x, y];
	}
}
/*package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;*/
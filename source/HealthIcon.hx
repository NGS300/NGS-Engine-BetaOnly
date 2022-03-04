package;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
class HealthIcon extends FlxSprite{
	public var sprTracker:FlxSprite;
	var complementName:String = "-icon";
	var complementPixel:String = "-pixel";
	public var iconScale:Float = 1;
	public var iconSize:Float;
	public var defaultIconScale:Float = 1;
	public static var onPlayState:Bool = false;
	public function new(char:String = 'bf', isPlayer:Bool = false){
		super();
		switch (char){
			case 'gf':
				loadGraphic(Paths.image('icons/gf' + complementName, 'character'), true, 150, 150);
				animation.add('gf', [0, 1], 0, false, isPlayer);
			case 'bf' | 'bf-car' | 'bf-christmas':
				loadGraphic(Paths.image('icons/bf' + complementName, 'character'), true, 150, 150);
				animation.add('bf', [0, 1], 0, false, isPlayer);
				animation.add('bf-car', [0, 1], 0, false, isPlayer);
				animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
			case 'dad':
				loadGraphic(Paths.image('icons/dad' + complementName, 'character'), true, 150, 150);
				animation.add('dad', [0, 1], 0, false, isPlayer);
			case 'spooky':
				loadGraphic(Paths.image('icons/spooky' + complementName, 'character'), true, 150, 150);
				animation.add('spooky', [0, 1], 0, false, isPlayer);
			case 'monster' | 'monster-christmas':
				loadGraphic(Paths.image('icons/monster' + complementName, 'character'), true, 150, 150);
				animation.add('monster', [0, 1], 0, false, isPlayer);
				animation.add('monster-christmas', [0, 1], 0, false, isPlayer);
			case 'pico':
				loadGraphic(Paths.image('icons/pico' + complementName, 'character'), true, 150, 150);
				animation.add('pico', [0, 1], 0, false, isPlayer);
			case 'mom' | 'mom-car':
				loadGraphic(Paths.image('icons/mom' + complementName, 'character'), true, 150, 150);
				animation.add('mom', [0, 1], 0, false, isPlayer);
				animation.add('mom-car', [0, 1], 0, false, isPlayer);
			case 'parents':
				loadGraphic(Paths.image('icons/parents' + complementName, 'character'), true, 150, 150);
				animation.add('parents', [0, 1], 0, false, isPlayer);
			case 'bf-pixel':
				loadGraphic(Paths.image('icons/bf' + complementPixel + complementName, 'character'), true, 150, 150);
				animation.add('bf-pixel', [0, 1], 0, false, isPlayer);
				antialiasing = false;
			case 'senpai-pixel' | 'senpai-angry-pixel':
				loadGraphic(Paths.image('icons/senpai' + complementPixel + complementName, 'character'), true, 150, 150);
				animation.add('senpai-pixel', [0, 1], 0, false, isPlayer);
				animation.add('senpai-angry-pixel', [0, 1], 0, false, isPlayer);
				antialiasing = false;
			case 'spirit-pixel':
				loadGraphic(Paths.image('icons/spirit' + complementPixel + complementName, 'character'), true, 150, 150);
				animation.add('spirit-pixel', [0, 1], 0, false, isPlayer);
				antialiasing = false;
			case 'tankman':
				loadGraphic(Paths.image('icons/tankman' + complementName, 'character'), true, 150, 150);
				animation.add('tankman', [0, 1], 0, false, isPlayer);
		}
		animation.play(char);
		antialiasing = Client.Antialiasing;
		scrollFactor.set();
		iconScale = defaultIconScale;
		iconSize = width;
	}
	override function update(elapsed:Float){
		super.update(elapsed);
		if (onPlayState){
			setGraphicSize(Std.int(iconSize * iconScale));
			updateHitbox();
		}else{}
		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
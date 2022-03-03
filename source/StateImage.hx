package;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
class StateImage{
    public static var suckAdd:Array<Dynamic> = [];
    public static var magenta:FlxSprite;
    public static var StoryBGColor:Int = 0xFFF9CF51; // Yellow Color BG StoryMode
    public static var scrollFactorYShit:Float = 0.15;
    public static var FreeplayBG:FlxSprite;
    public static var changeIcon:String = 'bf';
    public static function FreeplayBGColor(spriteShit:FlxSprite, placeYouColor:Int = 0xFF8a2be2){ // Change Color BG Effect
        if (placeYouColor != FreeplayState.instance.curColor){
            if (FreeplayState.instance.colorTween != null)
                FreeplayState.instance.colorTween.cancel();
            FreeplayState.instance.curColor = placeYouColor;
            FreeplayState.instance.colorTween = FlxTween.color(spriteShit, 1, spriteShit.color, placeYouColor,{
                onComplete: function(twn:FlxTween){
                    FreeplayState.instance.colorTween = null;
                }
            });
        }
    }
    public static function BGSMenus(nameHX:String){ // BG = BackGround
        if (nameHX == 'Tittle'){ // Title State BG
            var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
            suckAdd.push(bg);
        }
        if (nameHX == 'MainMenu'){ // This MainMenu BG
            var bgMainMenu:FlxSprite;
            bgMainMenu = new FlxSprite(-80).loadGraphic(Paths.image('BGMenus/menuBG'));
            bgMainMenu.scrollFactor.x = 0;
            bgMainMenu.scrollFactor.y = scrollFactorYShit;
            bgMainMenu.setGraphicSize(Std.int(bgMainMenu.width * 1.1));
            bgMainMenu.updateHitbox();
            bgMainMenu.screenCenter();
            bgMainMenu.antialiasing = Client.Antialiasing;
            suckAdd.push(bgMainMenu);
        }
        if (nameHX == 'MainMenuUnder'){ // Is Imagem Show on Play Any Buttom (Example, Story Mode, Freeplay & etc)
            magenta = new FlxSprite(-80).loadGraphic(Paths.image('BGMenus/menuDesat'));
            magenta.scrollFactor.x = 0;
            magenta.scrollFactor.y = scrollFactorYShit;
            magenta.setGraphicSize(Std.int(magenta.width * 1.1));
            magenta.updateHitbox();
            magenta.screenCenter();
            magenta.visible = false;
            magenta.antialiasing = Client.Antialiasing;
            magenta.color = 0xFFfd719b;
            suckAdd.push(magenta);
        }
        if (nameHX == 'Freeplay'){ // Freeplay BG
            FreeplayBG = new FlxSprite().loadGraphic(Paths.image('BGMenus/menuDesat'));
		    suckAdd.push(FreeplayBG);
        }
        if (nameHX == 'FreeplayFackShit'){ // Freeplay BG Colors :D
            switch ((FreeplayState.instance.songs[FreeplayState.instance.curSelected].songName.toLowerCase())){
                default:
                    FreeplayBGColor(FreeplayBG, 0xFF010101);
                case 'tutorial':
                    changeIcon = 'gf';
                    FreeplayBGColor(FreeplayBG, 0xFFa5004d);
                case 'bopeebo' | 'fresh' | 'dadbattle':
                    changeIcon = 'dad';
                    FreeplayBGColor(FreeplayBG, 0xFFaf66ce);
                case 'spookeez' | 'south':
                    changeIcon = 'spooky';
                    FreeplayBGColor(FreeplayBG, 0xFF32325a);
                case 'monster':
                    changeIcon = 'monster';
                    FreeplayBGColor(FreeplayBG, 0xFF32325a);
                case 'pico' | 'philly' | 'blammed':
                    changeIcon = 'pico';
                    FreeplayBGColor(FreeplayBG, 0xFF160c27);
                case 'satin-panties' | 'high' | 'milf':
                    changeIcon = 'mom';
                    FreeplayBGColor(FreeplayBG, 0xFFfc6c70);
                case 'cocoa' | 'eggnog':
                    changeIcon = 'parents-christmas';
                    FreeplayBGColor(FreeplayBG, 0xFF5456ba);
                case 'winter-horrorland':
                    changeIcon = 'monster';
                    FreeplayBGColor(FreeplayBG, 0xFF601447);
                case 'senpai' | 'roses':
                    changeIcon = 'senpai';
                    FreeplayBGColor(FreeplayBG, 0xFFbb98ab);
                case 'thorns':
                    changeIcon = 'spirit';
                    FreeplayBGColor(FreeplayBG, 0xFF18048b);
            }
        }
        if (nameHX == 'Options'){ // BG Options Menu Bro
            var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("BGMenus/menuDesat"));
            menuBG.color = 0xFFea71fd;
            menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
            menuBG.updateHitbox();
            menuBG.screenCenter();
            menuBG.antialiasing = FlxG.save.data.antialiasing;
            suckAdd.push(menuBG);
        }
        if (nameHX == 'Charting'){ // Charting BG and BG Colors
            var bgCharting:FlxSprite = new FlxSprite().loadGraphic(Paths.image('BGMenus/menuDesat'));
            bgCharting.scrollFactor.set();
            suckAdd.push(bgCharting);
            switch (TrackMap.curMap){
                default:
                    bgCharting.color = 0xFF010101;
                case 'stage':
                    bgCharting.color = 0xFF957967;
                case 'spooky':
                    bgCharting.color = 0xFF32325a;
                case 'philly':
                    bgCharting.color = 0xFF160c27;
                case 'limo':
                    bgCharting.color = 0xFFfc6c70;
                case 'mall':
                    bgCharting.color = 0xFF5456ba;
                case 'mallEvil':
                    bgCharting.color = 0xFF601447;
                case 'pixSchool':
                    bgCharting.color = 0xFFbb98ab;
                case 'pixSchoolEvil':
                    bgCharting.color = 0xFF18048b;
            }
        }
    }
}
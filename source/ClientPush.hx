import flixel.FlxG;
class ClientPush{
    public static function pushData(){
        Client.hide = FlxG.save.data.hideScrollOpponent;
        Client.mid = FlxG.save.data.midScroll;
        Client.isDownscroll = FlxG.save.data.downscroll;
        Client.noteSpeed = FlxG.save.data.scrollSpeed;
        Client.camBeatZoom = FlxG.save.data.camerazoom;
        Client.camMovehitingNote = FlxG.save.data.cameramovehitnote;
        Client.bot = FlxG.save.data.botplay;
        Client.Map = FlxG.save.data.map;
        Client.p2GlowHit = FlxG.save.data.opponentGlownHit;
        Client.iconColour = FlxG.save.data.colourCharIcon;
        Client.Antialiasing = FlxG.save.data.antialiasing;
        Client.input = FlxG.save.data.newInput;
        Client.ratingShit = FlxG.save.data.ratingHUD;
        Client.endless = FlxG.save.data.endless;
        Client.flash = FlxG.save.data.flashing;
        Client.fpsCam = FlxG.save.data.cameraFPS;
        Client.mode = FlxG.save.data.mode;
        Client.icHUD = FlxG.save.data.iconHUD;
    }
}
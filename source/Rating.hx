import flixel.FlxG;
class Rating{ 
    public static function CalculateRating(noteDifficulty:Float, ?customSafeZone:Float):String{ // Generate a judgement through some timing shit
        var customTimeScale = Conductor.timeScale;
        if (customSafeZone != null)
            customTimeScale = customSafeZone / 166;
        if (Client.bot)
            return "sick";
        var rating = CheckRatingMS(noteDifficulty,customTimeScale);
        return rating;
    }
    public static function CheckRatingMS(ms:Float, ts:Float){
        var rating = "sick";
        if (ms <= 166 * ts && ms >= 135 * ts)
            rating = "shit";
        if (ms < 135 * ts && ms >= 90 * ts) 
            rating = "bad";
        if (ms < 90 * ts && ms >= 45 * ts)
            rating = "good";
        if (ms < 45 * ts && ms >= -45 * ts)
            rating = "sick";
        if (ms > -90 * ts && ms <= -45 * ts)
            rating = "good";
        if (ms > -135 * ts && ms <= -90 * ts)
            rating = "bad";
        if (ms > -166 * ts && ms <= -135 * ts)
            rating = "shit";
        return rating;
    }
}

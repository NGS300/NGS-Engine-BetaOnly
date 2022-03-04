class ConvertScore
{
    public static function convertScore(noteDifficulty:Float):Int{
        var daRating:String = Rating.CalculateRating(noteDifficulty, 166);
        switch(daRating){
			case 'shit':
				return -300;
			case 'bad':
				return 0;
			case 'good':
				return 200;
			case 'sick':
				return 350;
        }
        return 0;
    }

}
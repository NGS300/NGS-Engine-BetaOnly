package;
import lime.utils.Assets;
using StringTools;
class CoolUtil{
	public static var difficultyArray:Array<String> = ['easy', "normal", "hard", "very-hard", "extra-hard"];
	public static var checkDataName:Array<String> = ['-easy', "", "-hard", "-very-hard", "-extra-hard"];
	public static function difficultyFromInt(difficulty:Int):String{
		return difficultyArray[difficulty];
	}
	public static function difficultyData(difficulty:Int){
		return checkDataName[difficulty];
	}
	public static function checkDifficultyData(typeDif:Int){
		if (typeDif == typeDif)
			checkDataName[typeDif];
		return checkDataName[typeDif];
	}
	public static function coolTextFile(path:String):Array<String>{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');
		for (i in 0...daList.length)
			daList[i] = daList[i].trim();
		return daList;
	}
	public static function numberArray(max:Int, ?min = 0):Array<Int>{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
			dumbArray.push(i);
		return dumbArray;
	}
}
package utils
{
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public final class Config
	{
		public static const NOT_LETTER:String = 'not_letter';
		public static const STAGE_WIDTH:Number = 650;
		public static const STAGE_HEIGHT:Number = 600;
		public static const EASY_CODE:int = 1;
		public static const MEDIUM_CODE:int = 2;
		public static const HARD_CODE:int = 3;
		public static const INIT_LIVES:int = 3;
		
		public static function getLetterFromKey($keyCode:int):String
		{
			var letter:String;
			switch ($keyCode)
			{
				case 65: 
					letter = 'A';
					break;
				case 66: 
					letter = 'B';
					break;
				case 67: 
					letter = 'C';
					break;
				case 68: 
					letter = 'D';
					break;
				case 69: 
					letter = 'E';
					break;
				case 70: 
					letter = 'F';
					break;
				case 71: 
					letter = 'G';
					break;
				case 72: 
					letter = 'H';
					break;
				case 73: 
					letter = 'I';
					break;
				case 74: 
					letter = 'J';
					break;
				case 75: 
					letter = 'K';
					break;
				case 76: 
					letter = 'L';
					break;
				case 77: 
					letter = 'M';
					break;
				case 78: 
					letter = 'N';
					break;
				case 79: 
					letter = 'O';
					break;
				case 80: 
					letter = 'P';
					break;
				case 81: 
					letter = 'Q';
					break;
				case 82: 
					letter = 'R';
					break;
				case 83: 
					letter = 'S';
					break;
				case 84: 
					letter = 'T';
					break;
				case 85: 
					letter = 'U';
					break;
				case 86: 
					letter = 'V';
					break;
				case 87: 
					letter = 'W';
					break;
				case 88: 
					letter = 'X';
					break;
				case 89: 
					letter = 'Y';
					break;
				case 90: 
					letter = 'Z';
					break;
				default: 
					letter = NOT_LETTER;
					break;
			}
			
			return letter;
		}
	}

}
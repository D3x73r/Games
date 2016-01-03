package utils
{
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	public final class Verification
	{
		public static const PATTERN_NICK:RegExp = /^[a-z0-9_-]{3,10}$/;
		public static const PATTERN_FIRST_NAME:RegExp = /^[a-zA-Z ]{3,16}$/;
		public static const PATTERN_LAST_NAME:RegExp = /^[a-zA-Z ]{3,16}$/;
		
		public static const HINT_NICK:String = 'You nick may contain between 3 and 10 small letters dashes and numbers.';
		public static const HINT_FIRST_NAME:String = 'You first name may contain between 3 and 16 small and large letters.';
		public static const HINT_LAST_NAME:String = 'You last name may contain between 3 and 16 small and large letters.';
	}

}
package utils
{
	import flash.text.Font;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	public final class LettersFormat
	{
		public static const MAIN_FONT:Font = new Font_SpaceTypers_ArialBold();
		public static const TEXT_FORMAT_NORMAL:TextFormat = new TextFormat(MAIN_FONT.fontName, 12, 0xFFFFFF);
		public static const TEXT_FORMAT_ACTIVE:TextFormat = new TextFormat(MAIN_FONT.fontName, 12, 0xFF9900);
		;
		public static const TEXT_FORMAT_ERROR:TextFormat = new TextFormat(MAIN_FONT.fontName, 12, 0xFF0000);
		;
	}

}
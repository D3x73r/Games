package components.asteroid
{
	import components.BaseComponent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import utils.LettersFormat;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	public class CodeNameLetter extends BaseComponent
	{
		
		private var _txt:TextField;
		private var _value:String = '';
		
		public function CodeNameLetter($value:String)
		{
			
			super();
			
			_value = $value;
			
			_txt = new TextField();
			_txt.defaultTextFormat = LettersFormat.TEXT_FORMAT_NORMAL;
			_txt.embedFonts = true;
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.text = _value;
			_txt.condenseWhite = true;
			
			addChild(_txt);
		}
		
		public function get txt():TextField
		{
			return _txt;
		}
	
	}

}
package components.asteroid
{
	import components.BaseComponent;
	import events.GameResultEvent;
	import flash.events.Event;
	import flash.text.TextFormat;
	import utils.LettersFormat;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	public class CodeName extends BaseComponent
	{
		private var _nameLength:int;
		private var _value:String = '';
		private var _size:Number = 0;
		private var _letter:CodeNameLetter;
		private var _marginX:Number;
		private var _marginY:Number;
		private var _textStyle:String;
		private var _currentLetter:String;
		private var _difficulty:Number;
		private var _accuracy:Number = 1;
		private var _win:int = 0;
		private var _mistakes:int = 0;
		
		public const TEXT_STYLE_NORMAL:String = 'style_normal';
		public const TEXT_STYLE_ACTIVE:String = 'style_active';
		public const TEXT_STYLE_ERROR:String = 'style_error';
		
		public const EVENT_DESTROY_ASTEROID:String = 'destroy_asteroid';
		
		private const SPACE_FACTOR = 3;
		
		public function CodeName($value:String, $marginX:Number = 0, $marginY:Number = 0, $difficulty:Number = 1)
		{
			
			super();
			
			value = $value.toUpperCase();
			
			_nameLength = $value.length;
			_marginX = $marginX;
			_marginY = $marginY;
			
			x = _marginX;
			y = _marginY;
			
			_difficulty = $difficulty;
			_win = $difficulty * 10;
		}
		
		public function get value():String
		{
			return _value;
		}
		
		public function set value($value:String):void
		{
			_value = $value;
			
			_currentLetter = _value.substr(0, 1);
			
			for (var i:int = 0; i < _value.length; i++)
			{
				_letter = new CodeNameLetter(_value.substr(i, 1));
				
				_letter.x = _size;
				
				addChild(_letter);
				
				_size += _letter.width - SPACE_FACTOR;
				
			}
		
		}
		
		public function get marginX():Number
		{
			return _marginX;
		}
		
		public function get textStyle():String
		{
			return _textStyle;
		}
		
		public function set textStyle($value:String):void
		{
			if (_textStyle == $value)
			{
				return;
			}
			
			var textFormat:TextFormat;
			
			_textStyle = $value;
			
			switch (_textStyle)
			{
				case TEXT_STYLE_NORMAL: 
					textFormat = LettersFormat.TEXT_FORMAT_NORMAL;
					break;
				case TEXT_STYLE_ACTIVE: 
					textFormat = LettersFormat.TEXT_FORMAT_ACTIVE;
					break;
				case TEXT_STYLE_ERROR: 
					mistakes++;
					trace('mistakes: ', mistakes, 'nameLength:', nameLength);
					textFormat = LettersFormat.TEXT_FORMAT_ERROR;
					break;
			}
			
			applyStyle(textFormat);
		}
		
		private function applyStyle($style:TextFormat):void
		{
			var cLetter:CodeNameLetter;
			for (var i:int = 0; i < numChildren; i++)
			{
				cLetter = getChildAt(i) as CodeNameLetter;
				
				if (cLetter)
				{
					cLetter.txt.setTextFormat($style);
				}
			}
		}
		
		public function removeLetter():void
		{
			if (numChildren == 0)
				return;
			
			var letter:CodeNameLetter = getChildAt(0) as CodeNameLetter;
			
			if (letter)
			{
				removeChild(letter);
				
				if (numChildren > 0)
				{
					letter = getChildAt(0) as CodeNameLetter;
					
					_currentLetter = letter.txt.text;
				}
				else
				{
					callcWin();
					dispatchEvent(new Event(EVENT_DESTROY_ASTEROID));
				}
			}
		}
		
		private function get accuracy():Number
		{
			_accuracy = Math.round(((nameLength - mistakes) / nameLength) * 10000) / 10000;
			
			return _accuracy;
		}
		
		private function callcWin($timeBonus:Boolean = true):void
		{
			dispatchEvent(new GameResultEvent(accuracy, _win * accuracy));
		}
		
		public function get currentLetter():String
		{
			return _currentLetter;
		}
		
		public function get mistakes():int 
		{
			return _mistakes;
		}
		
		public function set mistakes($value:int):void 
		{
			_mistakes = $value;
		}
		
		public function get nameLength():int 
		{
			return _nameLength;
		}
	}
}
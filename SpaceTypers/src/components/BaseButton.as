package components
{
	import components.BaseComponent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	public class BaseButton extends BaseComponent
	{
		public const STATE_OVER:String = 'over';
		public const STATE_UP:String = 'up';
		public const STATE_DOWN:String = 'down';
		
		private var _labelTxt:String;
		private var _callback:Function;
		
		public var lbl:MovieClip;
		
		public function BaseButton()
		{
			super();
			
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(Event.REMOVED_FROM_STAGE, cleanUpButton);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			addEventListener(MouseEvent.CLICK, mouseHandler);
		}
		
		private function mouseHandler($e:MouseEvent):void
		{
			switch ($e.type)
			{
				case MouseEvent.MOUSE_DOWN: 
					state = STATE_DOWN;
					break;
				
				case MouseEvent.ROLL_OVER: 
					state = STATE_OVER;
					break;
				
				case MouseEvent.ROLL_OUT: 
					state = STATE_UP;
					break;
				
				case MouseEvent.CLICK: 
					if (_callback != null)
					{
						_callback();
					}
					break;
			}
		}
		
		public function set callback($value:Function):void
		{
			_callback = $value;
		}
		
		public function get labelTxt():String
		{
			return _labelTxt;
		}
		
		public function set labelTxt($value:String):void
		{
			_labelTxt = $value;
			if (lbl)
			{
				lbl.txt.text = _labelTxt;
			}
		}
		
		private function cleanUpButton($e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpButton);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			removeEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			removeEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			removeEventListener(MouseEvent.CLICK, mouseHandler);
		}
	}
}
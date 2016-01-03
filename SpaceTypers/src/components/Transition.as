package components 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author F43841 Hristo Dimitrov
	 */
	
	public class Transition extends MovieClip 
	{
		public const TEVENT_SHOWN:String = 'shown';
		public const TEVENT_HIDDEN:String = 'hidden';
		
		public const STATE_SHOW:String = 'show';
		public const STATE_HIDE:String = 'hide';
		
		private var _callbackOnShown:Function;
		private var _callbackOnHidden:Function;
		
		public function Transition() 
		{
			super();
			addEventListener(TEVENT_SHOWN, onShown)
			addEventListener(TEVENT_HIDDEN, onHidden)
		}
		
		private function onShown($e:Event):void 
		{
			if (_callbackOnShown != null)
			{
				_callbackOnShown();
				_callbackOnShown = null;
			}
		}
		
		private function onHidden($e:Event):void 
		{
			if (_callbackOnHidden != null)
			{
				_callbackOnHidden();
				_callbackOnHidden = null;
			}
		}
		
		public function show($callback:Function = null)
		{
			_callbackOnShown = $callback;
			gotoAndPlay(STATE_SHOW);
		}
		
		public function hide($callback:Function = null)
		{
			_callbackOnHidden = $callback;
			gotoAndPlay(STATE_HIDE);
		}
	}

}
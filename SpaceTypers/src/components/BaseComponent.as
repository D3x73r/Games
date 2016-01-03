package components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class BaseComponent extends MovieClip
	{
		private var _state:String = '';
		protected const _STATE_CHANGED:String = 'state_changed';
		
		public function BaseComponent()
		{
			
			super();
		
		}
		
		public function get state():String
		{
			
			return _state;
		
		}
		
		public function set state($value:String):void
		{
			if (_state != $value)
			{
				
				_state = $value;
				
				gotoAndPlay(_state);
				
				//trace(_state, $value, currentLabel, currentFrame);
				
				setTimeout(function()
					{
						if (hasEventListener(_STATE_CHANGED))
						{
							dispatchEvent(new Event(_STATE_CHANGED));
						}
					}, 1);
				
			}
		
		}
	
	}
}
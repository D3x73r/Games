package events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class GameResultEvent extends Event
	{
		public static const GAME_RESULT:String = 'game_result';
		
		private var _accuracy:Number;
		private var _win:Number;
		
		public function GameResultEvent($accuracy:Number, $win:Number, $bubbles:Boolean = true)
		{
			super(GAME_RESULT, $bubbles);
			
			_accuracy = $accuracy;
			_win = $win;
		}
		
		public function get accuracy():Number
		{
			return _accuracy;
		}
		
		public function get win():Number
		{
			return _win;
		}
		
		override public function clone():Event
		{
			return new GameResultEvent(_accuracy, _win);
		}
	
	}

}
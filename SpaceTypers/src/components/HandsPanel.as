package components 
{
	/**
	 * ...
	 * @author F43841 Hristo Dimitrov
	 */
	
	public class HandsPanel extends BaseComponent 
	{
		public const NO_FINGER:int = -1;
		public const STATE_NORMAL:String = 'normal';
		public const FINGER_PREFIX:String = 'finger_';
		
		private var _finger:int;
		
		public function HandsPanel() 
		{
			super();
			
		}
		
		public function get finger():int 
		{
			return _finger;
		}
		
		public function set finger($value:int):void 
		{
			_finger = $value;
			
			if (_finger == -1)
			{
				state = STATE_NORMAL;
			}
			else
			{
				state = FINGER_PREFIX + finger;
			}
		}
		
	}

}
package components.header 
{
	import components.BaseComponent;
	
	/**
	 * ...
	 * @author F43841 Hristo Dimitrov
	 */
	
	public class LivesPanel extends BaseComponent 
	{
		public const LIVES_PREFIX:String = 'lives_';
		
		private var _lives:int;
		public function LivesPanel() 
		{
			super();
			
		}
		
		public function get lives():int 
		{
			return _lives;
		}
		
		public function set lives($value:int):void 
		{
			_lives = $value;
			state = LIVES_PREFIX + lives;
		}
		
	}

}
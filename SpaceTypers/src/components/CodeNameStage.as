package components
{
	import components.asteroid.CodeName;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class CodeNameStage extends MovieClip
	{
		public const EVENT_ASTEROID_REMOVED:String = 'asteroid_removed';
		
		public var codeNameToRemove:CodeName;
		
		public function CodeNameStage()
		{
			addEventListener(EVENT_ASTEROID_REMOVED, cleanUpAsteroidCodeName);
		}
		
		private function cleanUpAsteroidCodeName($e:Event):void
		{
			if (codeNameToRemove)
			{
				removeChild(codeNameToRemove);
			}
		}
	
	}

}
package components
{
	import components.asteroid.Asteroid;
	import events.GameResultEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class AsteroidStage extends MovieClip
	{
		private var _codeNameStage:CodeNameStage;
		
		public function AsteroidStage()
		{
			super();
			
			addEventListener(Asteroid.EVENT_ASTEROID_DESTROYED, removeAsteroid);
			addEventListener(Asteroid.EVENT_ASTEROID_OUT_OF_RANGE, removeAsteroid);
			addEventListener(Event.REMOVED_FROM_STAGE, cleanUp);
		}
		
		public function removeAllAsteroids():void
		{
			var asteroid:Asteroid;
			
			for (var i:int = 0; i < numChildren; i++)
			{
				asteroid = getChildAt(i) as Asteroid;
				
				if (asteroid)
				{
					_codeNameStage.codeNameToRemove = asteroid.codeNameTxt;
					
					removeChild(asteroid);
					
					_codeNameStage.dispatchEvent(new Event(_codeNameStage.EVENT_ASTEROID_REMOVED));
				}
			}
		}
		
		private function removeAsteroid($e:Event):void
		{
			var asteroid:Asteroid = $e.target as Asteroid;
			
			asteroid.removeEventListener(Asteroid.EVENT_ASTEROID_DESTROYED, removeAsteroid);
			asteroid.removeEventListener(Asteroid.EVENT_ASTEROID_OUT_OF_RANGE, removeAsteroid);
			
			_codeNameStage.codeNameToRemove = asteroid.codeNameTxt;
			
			trace('asteroid removed!')
			removeChild(asteroid);
			
			_codeNameStage.dispatchEvent(new Event(_codeNameStage.EVENT_ASTEROID_REMOVED));
		}
		
		private function cleanUp($e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, cleanUp);
			removeEventListener(Asteroid.EVENT_ASTEROID_DESTROYED, removeAsteroid);
			removeEventListener(Asteroid.EVENT_ASTEROID_OUT_OF_RANGE, removeAsteroid);
		}
		
		public function set codeNameStage($value:CodeNameStage):void
		{
			_codeNameStage = $value;
		}
	
	}

}
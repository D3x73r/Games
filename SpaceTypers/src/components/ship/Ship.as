package components.ship {
	import components.asteroid.Asteroid;
	import components.BaseComponent;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	public class Ship extends MovieClip {
		private var asteroidToFollow:Asteroid;
		private var _following:Boolean = false;
		public function Ship() {
			
		}
		
		public function follow($asteroid:Asteroid):void {
			_following = true;
			
			asteroidToFollow = $asteroid;
			
			updateRotation();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame($e:Event = null):void {
			updateRotation();
		}
		
		private function updateRotation():void {
			var coordy1 : Number = asteroidToFollow.y - y;
		    var coordx1 : Number  = asteroidToFollow.x - x;
			
		    var angleRadians1 : Number  = Math.atan2(coordy1,coordx1);
		    var angleDegrees1 : Number  = angleRadians1 * 180 / Math.PI;
			
			rotation = angleDegrees1 + 90;
		}
		
		public function stopFollow():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			asteroidToFollow = null;
			_following = false;
		}
		
		public function get following():Boolean {
			return _following;
		}
		
	}

}
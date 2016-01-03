package components.particles
{
	import components.BaseComponent;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class Particle extends BaseComponent
	{
		public const STATE_NORMAL:String = 'normal';
		public const STATE_FALLING:String = 'falling';
		
		private var _size:Number;
		private var _isFalling:Boolean;
		
		public function Particle()
		{
			
		}
		
		public function get size():Number 
		{
			return _size;
		}
		
		public function set size($value:Number):void 
		{
			_size = $value;
		}
		
		public function get isFalling():Boolean 
		{
			return _isFalling;
		}
		
		public function set isFalling(value:Boolean):void 
		{
			_isFalling = value;
		}
	
	}

}
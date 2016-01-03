package components.asteroid
{
	import components.BaseComponent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import utils.Config;
	import utils.random;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class Asteroid extends BaseComponent
	{
		private const NAME_PREFIX:String = 'ast_';
		
		public static const EVENT_ASTEROID_DESTROYED:String = 'asteroid_destroyed';
		public static const EVENT_ASTEROID_OUT_OF_RANGE:String = 'asteroid_out_of_range';
		
		private const EVENT_EXPLODE_ANIM_END:String = 'explode_anim_end';
		
		private const STATE_EXPLODE:String = 'explode';
		
		private var _speed:Number;
		private var _codeName:String;
		private var _codeNameTxt:CodeName;
		private var _type:int;
		
		public var marker:MovieClip;
		
		public function Asteroid($codeNameTxt:CodeName, $speed:Number)
		{
			super();
			
			_type = random(1, totalFrames);
			_codeNameTxt = $codeNameTxt
			_codeName = _codeNameTxt.value;
			_speed = $speed;
			
			gotoAndStop(_type);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			_codeNameTxt.addEventListener(_codeNameTxt.EVENT_DESTROY_ASTEROID, destroy);
		}
		
		private function init($e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, moveAsteroid);
		}
		
		private function moveAsteroid($e:Event):void
		{
			y += speed;
			
			_codeNameTxt.y += speed;
			
			if (y > Config.STAGE_HEIGHT)
			{
				dispatchEvent(new Event(EVENT_ASTEROID_OUT_OF_RANGE, true));
			}
		}
		
		private function destroy($e:Event):void
		{
			var body:MovieClip = getChildByName(NAME_PREFIX + _type) as MovieClip;
			
			body.addEventListener(EVENT_EXPLODE_ANIM_END, onExplodeAnimEnd);
			body.gotoAndPlay(STATE_EXPLODE);
			
			removeEventListener(Event.ENTER_FRAME, moveAsteroid);
		}
		
		private function onExplodeAnimEnd($e:Event):void
		{
			var body:MovieClip = ($e.target as MovieClip);
			body.removeEventListener(EVENT_EXPLODE_ANIM_END, onExplodeAnimEnd);
			
			dispatchEvent(new Event(EVENT_ASTEROID_DESTROYED, true));
		}
		
		public function get codeName():String
		{
			return _codeName;
		}
		
		public function get speed():Number
		{
			return _speed;
		}
		
		public function get codeNameTxt():CodeName
		{
			return _codeNameTxt;
		}
	
	}

}
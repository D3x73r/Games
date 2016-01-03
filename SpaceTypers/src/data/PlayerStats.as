package data
{
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class PlayerStats
	{
		private var _playerId:int;
		private var _score:int = 0;
		private var _wpm:int = 0;
		private var _accuracy:Number = 0;
		private var _accuracyCount:int = 0;
		private var _leftHandErrCount:int = 0;
		private var _rightHandErrCount:int = 0;
		private var _weakHand:String = '';
		private var _indexFingerErrCount:int = 0;
		private var _middleFingerErrCount:int = 0;
		private var _ringFingerErrCount:int = 0;
		private var _pinkyFingerErrCount:int = 0;
		private var _maxFingerErrCount:int = 0
		private var _weakFinger:String = 'none';
		private var _date:uint;
		private var _timeMain:Number = 0;
		private var _completedWords:int = 0;
		
		
		public function PlayerStats($playerId:int)
		{
			var date:Date = new Date();
			 
			_date = date.getTime();
			_playerId = $playerId;
			
		}
		
		private function calcWeakFinger($errCount:int, $finger:String):void
		{
			if ($errCount > _maxFingerErrCount)
			{
				_maxFingerErrCount = $errCount;
				_weakFinger = $finger; 
			}
		}
		
		//Getters and Setters
		public function get playerId():int 
		{
			return _playerId;
		}
		
		public function get score():int 
		{
			return _score;
		}
		
		public function set score($value:int):void 
		{
			_score = $value;
		}
		
		public function get wpm():int 
		{
			_wpm = completedWords / _timeMain;
			trace('wpm: ', _wpm);
			return _wpm;
		}
		
		public function get accuracy():Number 
		{
			return _accuracy / _accuracyCount;
		}
		
		public function set accuracy($value:Number):void 
		{
			_accuracyCount++;
			_accuracy += $value;
		}
		
		public function get leftHandErrCount():int 
		{
			return _leftHandErrCount;
		}
		
		public function set leftHandErrCount($value:int):void 
		{
			_leftHandErrCount = $value;
		}
		
		public function get rightHandErrCount():int 
		{
			return _rightHandErrCount;
		}
		
		public function set rightHandErrCount($value:int):void 
		{
			_rightHandErrCount = $value;
		}
		
		public function get weakHand():String 
		{
			_weakHand = leftHandErrCount > rightHandErrCount ? 'left' : 'right';
			return _weakHand;
		}
		
		public function get indexFingerErrCount():int 
		{
			return _indexFingerErrCount;
		}
		
		public function set indexFingerErrCount($value:int):void 
		{
			_indexFingerErrCount = $value;
			calcWeakFinger(_indexFingerErrCount, 'index');
		}
		
		public function get middleFingerErrCount():int 
		{
			return _middleFingerErrCount;
		}
		
		public function set middleFingerErrCount($value:int):void 
		{
			_middleFingerErrCount = $value;
			calcWeakFinger(_middleFingerErrCount, 'middle');
		}
		
		public function get ringFingerErrCount():int 
		{
			return _ringFingerErrCount;
		}
		
		public function set ringFingerErrCount($value:int):void 
		{
			_ringFingerErrCount = $value;
			calcWeakFinger(_ringFingerErrCount, 'ring');
		}
		
		public function get pinkyFingerErrCount():int 
		{
			return _pinkyFingerErrCount;
		}
		
		public function set pinkyFingerErrCount($value:int):void 
		{
			_pinkyFingerErrCount = $value;
			calcWeakFinger(_pinkyFingerErrCount, 'pinky');
		}
		
		public function get weakFinger():String 
		{
			return _weakFinger;
		}
		
		
		public function get completedWords():int 
		{
			return _completedWords;
		}
		
		public function set completedWords($value:int):void 
		{
			_completedWords = $value;
		}
		
		public function get timeMain():Number 
		{
			return _timeMain;
		}
		
		public function set timeMain($value:Number):void 
		{
			_timeMain = $value;
		}
	
	}

}
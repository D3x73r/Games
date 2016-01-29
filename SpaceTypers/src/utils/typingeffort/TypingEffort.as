package utils.typingeffort
{
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public final class TypingEffort 
	{
		private static var _typingEffort:Number;
		private static var _triadEffort:Number;
		private static var _currentTriad:String;
		
		private static var _base:Number;
		
		private static var _l1:LetterMap;
		private static var _l2:LetterMap;
		private static var _l3:LetterMap;
		private static var _cache:Array = [];
		private static var _triadObj:Object;
		private static var _cacheTriadEffort:Number;
		
		//Effort component weights 
		private static var _effBaseFactor:Number = Config.EFFORT_BASE_FACTOR;
		private static var _effPenaltyFactor:Number = Config.EFFORT_PENALTY_FACTOR;
		private static var _effStrokeFactor:Number = Config.EFFORT_STROKE_FACTOR;
		
		//Penalty weights
		private static var _wHand:Number = Config.W_HAND;
		private static var _wRow:Number = Config.W_ROW;
		private static var _wFinger:Number = Config.W_FINGER;
		
		//Finger / Hand pealties
		private static var _indexFingerPenalty:Number = Config.INDEX_FINGER_PANALTY;
		private static var _middleFingerPenalty:Number = Config.MIDDLE_FINGER_PANALTY;
		private static var _ringFingerPenalty:Number = Config.RING_FINGER_PANALTY;
		private static var _pinkyFingerPenalty:Number = Config.PINKY_FINGER_PANALTY;
		
		private static var _lhandAdditionalPenalty:Number = Config.LHAND_FINGER_ADDITIONAL_PENALTY;
		private static var _rhandAdditionalPenalty:Number = Config.RHAND_FINGER_ADDITIONAL_PENALTY;
		
		//triad interaction parameters
		private static var _triadK1:Number = Config.TRIAD_K_1;
		private static var _triadK2:Number = Config.TRIAD_K_2;
		private static var _triadK3:Number = Config.TRIAD_K_3;
		
		//Stroke contributor params
		private static var _fHand:Number = Config.F_HAND;
		private static var _fRow:Number = Config.F_ROW;
		private static var _fFinger:Number = Config.F_FINGER;
		
		
		public static function calc($word:String, $keyBoardId:int):Number {
			_typingEffort = 0.0;
			_currentTriad = '';
			
			for (var i:int = 0; i <= $word.length - 3; i++ ) {
				_currentTriad = $word.substr(i, 3);
				_l1 = Letters.getMap(_currentTriad.substr(0, 1), $keyBoardId);
				_l2 = Letters.getMap(_currentTriad.substr(1, 1), $keyBoardId);
				_l3 = Letters.getMap(_currentTriad.substr(2, 1), $keyBoardId);
				_triadEffort = 0.0;
				
				_typingEffort += (_effBaseFactor * calcBase() 
										+ _effPenaltyFactor * calcPenalty() 
											+ _effStrokeFactor * calcStroke());
			}	
			
			return _typingEffort;
		}
		
		//Base calcs
		private static function calcBase():Number {			
			_base = _triadK1 * _l1.baseline 
					* (1 + _triadK2 * _l2.baseline 
						* (1 + _triadK3 * _l3.baseline));
			
			return _base;
		}
		
		//Penalty calcs
		private static function calcPenalty():Number {
			return _triadK1 * calcPenaltyComponent(_l1) + _triadK2 * calcPenaltyComponent(_l2) + _triadK3 * calcPenaltyComponent(_l3);
		}
		
		private static function calcPenaltyComponent($lMap:LetterMap):Number {			 
			return _wHand * ($lMap.hand == 'L' ? _lhandAdditionalPenalty : _rhandAdditionalPenalty) + _wRow * $lMap.rowPenalty + _wFinger * $lMap.fingerPenalty;
		}
		
		//Stroke calcs
		private static function calcStroke():Number {
			return _fHand * calcStrokeHandPenalty() + _fRow * calcStrokeRowPenalty() + _fFinger * calcStrokeFingerPenalty();
		}
		
		private static function calcStrokeHandPenalty():Number {
			if (_l1.hand == _l2.hand || _l2.hand == _l3.hand) { //Both used, not alternating
				return 0.0;
			} else if (_l1.hand == _l3.hand && _l1.hand != _l2.hand) { //Alternating
				return 1.0;
			} else { //Same
				return 2.0;
			}
		}
		
		private static function calcStrokeRowPenalty():Number {
			if (_l1.row == _l2.row && _l2.row == _l3.row) { //same
				return 0.0;
			} 
			else if ((_l1.row == _l2.row && _l2.row < _l3.row) || (_l2.row == _l3.row && _l3.row < _l1.row)) { //downward progression, with repetition
				return 1.0;
			}
			else if ((_l1.row == _l2.row && _l2.row > _l3.row) || (_l2.row == _l3.row && _l3.row < _l1.row)) { //upward progression, with repetition
				return 2.0;
			}
			else if (_l1.row == _l3.row && Math.abs(_l3.row - _l2.row) == 1) { // some different, not monotonic, max row change 1
				return 3.0;
			}
			else if (_l1.row < _l2.row && _l2.row < _l3.row) { // downward progression
				return 4.0;
			}
			else if (_l1.row > _l2.row && _l2.row < _l3.row && _l3.row - _l2.row > 1) { // some different, not monotonic, max row change downward >1
				return 5.0;
			}
			else if (_l1.row > _l2.row && _l2.row > _l3.row) { // upward progression
				return 6.0;
			}
			else { // some different, not monotonic, max row change upward >1
				return 7.0;
			}
		}
		
		private static function calcStrokeFingerPenalty():Number {
			if (_l1.finger > _l2.finger && _l2.finger > _l3.finger) { // all different, monotonic progression
				return 0.0;
			}
			else if ((_l1 == _l2 && _l2.finger != _l3.finger) || (_l2 == _l3 && _l1.finger != _l3.finger)) { // some different, key repeat, monotonic progression
				return 1.0;
			}
			else if (_l1.fingerType == _l2.fingerType && _l1.fingerType != _l2.fingerType) { // rolling
				return 2.0;
			}
			else if (_l1.fingerType != _l2.fingerType && _l1.fingerType != _l3.fingerType && _l2.fingerType != _l3.fingerType ) { // all different, not monotonic
				return 3.0;
			}	
			else if (_l1.finger == _l3.finger && (_l1.finger > _l2.finger || _l1.finger < _l2.finger) ) { //some different, not monotonic progression
				return 4.0;
			}
			else if ((_l1.finger == _l2.finger && _l1.finger == _l3.finger) && (_l1 == _l2 || _l2 == _l3 || _l1 == _l3)) { //same, key repeat
				return 5.0;
			}
			else if ((_l1.finger == _l2.finger || _l2.finger == _l3.finger || _l1.finger == _l3.finger) && _l1.finger < _l2.finger && _l2.finger <= _l3.finger) {
				return 6.0;
			} 
			else { //if ((_l1.finger == _l2.finger && _l1.finger == _l3.finger) && (_l1 != _l2 && _l2 != _l3 && _l1 != _l3)) {
				return 7.0;
			}
		}
	}
}
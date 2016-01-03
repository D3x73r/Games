package utils.typingeffort
{
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class LetterMap
	{
		public static const PINKY:String = 'pinky';
		public static const RING:String = 'ring';
		public static const MIDDLE:String = 'middle';
		public static const INDEX:String = 'index';
		public static const THUMB:String = 'thumb';
		
		private var _name:String;
		private var _finger:int;
		private var _fingerType:String = '';
		private var _hand:String;
		private var _baseline:Number;
		private var _row:int;
		private var _rowPenalty:Number = 0;
		private var _fingerPenalty:Number = 0;
		
		public function LetterMap($name:String, $finger:int, $hand:String, $baseline:Number, $row:int)
		{
			_name = $name;
			_finger = $finger;
			_hand = $hand;
			_baseline = $baseline;
			_row = $row;
		}
		
		public function get finger():int
		{
			return _finger;
		}
		
		public function get fingerType():String
		{
			switch (_finger)
			{
				case 0: 
				case 9: 
					_fingerType = PINKY;
					break;
				case 1: 
				case 8: 
					_fingerType = RING;
					break;
				case 2: 
				case 7: 
					_fingerType = MIDDLE;
					break;
				case 3: 
				case 6: 
					_fingerType = INDEX;
					break;
			}
			return _fingerType;
		}
		
		public function get hand():String
		{
			return _hand;
		}
		
		public function get baseline():Number
		{
			return _baseline;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get row():int
		{
			return _row;
		}
		
		public function get rowPenalty():Number
		{
			switch (row)
			{
				case 0: 
					_rowPenalty = 0.5;
					break;
				case 1: 
					_rowPenalty = 0;
					break;
				case 2: 
					_rowPenalty = 1;
					break;
			}
			return _rowPenalty;
		}
		
		public function get fingerPenalty():Number
		{
			switch (_finger)
			{ //TODO Optimize!!
				case 3: 
					_fingerPenalty = ConfigEffort.INDEX_FINGER_PANALTY + ConfigEffort.LHAND_FINGER_ADDITIONAL_PENALTY;
					break;
				case 6: 
					_fingerPenalty = ConfigEffort.INDEX_FINGER_PANALTY + ConfigEffort.RHAND_FINGER_ADDITIONAL_PENALTY;
					break;
				case 2: 
					_fingerPenalty = ConfigEffort.MIDDLE_FINGER_PANALTY + ConfigEffort.LHAND_FINGER_ADDITIONAL_PENALTY;
					break;
				case 7: 
					_fingerPenalty = ConfigEffort.MIDDLE_FINGER_PANALTY + ConfigEffort.RHAND_FINGER_ADDITIONAL_PENALTY;
					break;
				case 1: 
					_fingerPenalty = ConfigEffort.RING_FINGER_PANALTY + ConfigEffort.LHAND_FINGER_ADDITIONAL_PENALTY;
					break
				case 8: 
					_fingerPenalty = ConfigEffort.RING_FINGER_PANALTY + ConfigEffort.RHAND_FINGER_ADDITIONAL_PENALTY;
					break;
				case 0: 
					_fingerPenalty = ConfigEffort.PINKY_FINGER_PANALTY + ConfigEffort.LHAND_FINGER_ADDITIONAL_PENALTY;
					break;
				case 9: 
					_fingerPenalty = ConfigEffort.PINKY_FINGER_PANALTY + ConfigEffort.RHAND_FINGER_ADDITIONAL_PENALTY;
					break;
			}
			return _fingerPenalty;
		}
	
	}

}
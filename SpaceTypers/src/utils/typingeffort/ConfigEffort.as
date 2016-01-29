package  utils.typingeffort
{
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public final class ConfigEffort
	{
		//Effort component weights 
		public static var EFFORT_BASE_FACTOR:Number = 0.3555;
		public static var EFFORT_PENALTY_FACTOR:Number = 0.6423;
		public static var EFFORT_STROKE_FACTOR:Number = 0.4268;
		
		//Row penalties
		public static var ROW_PENALTIES:Vector.<Number> = new <Number>[1.5, 0.5, 0, 1];
		
		//Penalty weights
		public static var W_HAND:Number = 1;
		public static var W_ROW:Number = 1.3088;
		public static var W_FINGER:Number = 2.5948;
		
		//Finger / Hand pealties
		public static var INDEX_FINGER_PANALTY:Number = 0;
		public static var MIDDLE_FINGER_PANALTY:Number = 0.5;
		public static var RING_FINGER_PANALTY:Number = 1;
		public static var PINKY_FINGER_PANALTY:Number = 1.5;
		
		public static var LHAND_FINGER_ADDITIONAL_PENALTY:Number = 0;
		public static var RHAND_FINGER_ADDITIONAL_PENALTY:Number = 0;
		
		//triad interaction parameters
		public static var TRIAD_K_1:Number = 1;
		public static var TRIAD_K_2:Number = 0.367;
		public static var TRIAD_K_3:Number = 0.367;
		
		
		//Stroke contributor params
		public static var F_HAND:Number = 1;
		public static var F_ROW:Number = 0.3;
		public static var F_FINGER:Number = 0.3;
	}

}
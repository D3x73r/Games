package  utils.typingeffort
{
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public final class ConfigEffort
	{
		//Effort component weights 
		public static const EFFORT_BASE_FACTOR:Number = 0.3555;
		public static const EFFORT_PENALTY_FACTOR:Number = 0.6423;
		public static const EFFORT_STROKE_FACTOR:Number = 0.4268;
		
		//Penalty weights
		public static const W_HAND:Number = 1;
		public static const W_ROW:Number = 1.3088;
		public static const W_FINGER:Number = 2.5948;
		
		//Finger / Hand pealties
		public static const INDEX_FINGER_PANALTY:Number = 0;
		public static const MIDDLE_FINGER_PANALTY:Number = 0.5;
		public static const RING_FINGER_PANALTY:Number = 1;
		public static const PINKY_FINGER_PANALTY:Number = 1.5;
		
		public static const LHAND_FINGER_ADDITIONAL_PENALTY:Number = 0;
		public static const RHAND_FINGER_ADDITIONAL_PENALTY:Number = 0;
		
		//triad interaction parameters
		public static const TRIAD_K_1:Number = 1;
		public static const TRIAD_K_2:Number = 0.367;
		public static const TRIAD_K_3:Number = 0.367;
		
		//Stroke contributor params
		public static const F_HAND:Number = 1;
		public static const F_ROW:Number = 0.3;
		public static const F_FINGER:Number = 0.3;
	}

}
package utils
{
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public function randomNumber(min:Number, max:Number):Number
	{
		return Math.random() * (1 + max - min) + min;
	}

}
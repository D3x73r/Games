package utils
{
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public function random(min:int, max:int):int
	{
		return Math.round(Math.random() * (max - min) + min);
	}

}
package data
{
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class Player
	{
		private var _playerId:int;
		private var _nick:String;
		private var _name:String;
		private var _lastName:String;
		private var _stats:PlayerStats;
		
		public function Player($nick:String, $name:String, $lastName:String, $id:int)
		{
			_playerId = $id;
			_nick = $nick;
			_name = $name;
			_lastName = $lastName;
		}
		
		public function get nick():String
		{
			return _nick;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get lastName():String
		{
			return _lastName;
		}
		
		public function get stats():PlayerStats
		{
			return _stats;
		}
		
		public function get playerId():int 
		{
			return _playerId;
		}
		
		public function set stats($value:PlayerStats):void 
		{
			_stats = $value;
		}
	
	}

}
package data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.data.*;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.net.Responder;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class DBConnect extends EventDispatcher
	{
		public const EVENT_DATA_LOADED:String = 'data_loaded';
		public const EVENT_SCORES_LOADED:String = 'data_loaded';
		public const EVENT_MAIN_DB_CREATED:String = 'event_main_db_created';
		public const EVENT_PLAYER_REGSTERED:String = 'player_registered';
		
		public const MAIN_DB_NAME:String = 'STypers.db';
		public const STATS_DB_NAME:String = 'STypersStats.db';
		
		private var _scores:Array;
		private var _hasRegisteredPlayers:Boolean = false;
		private var _hasScores:Boolean = false;
		
		//Main DB
		private var _connMainDB:SQLConnection;
		private var _dataLoadedMainDB:Boolean = false;
		private var _allPlayers:Vector.<Player>;
		
		//Stats
		private var _playerId:int = -1;
		private var _score:int = -1;
		
		public function DBConnect()
		{
			connectToMainDB();
		}
		
		
		public function savePlayerScore($player:Player):void
		{
			var q:SQLStatement = new SQLStatement();
			//var qText:String = 'INSERT  INTO 'Stats' VALUES( NULL, ';
			//q.sqlConnection = _connMainDB;
			//q.clearParameters();
			//
			//q.text = "INSERT  INTO 'Stats' VALUES( NULL, :playerId, :score )";
			//q.parameters[':playerId'] = $playerId;
			//q.parameters[':score'] = $score;
			//q.addEventListener(SQLErrorEvent.ERROR, onDBError);
			//q.execute();
		}
		
		public function getPlayerScore($playerId:int):void
		{
			var q:SQLStatement = new SQLStatement();
			q.sqlConnection = _connMainDB;
			q.text = "SELECT * FROM 'Stats' WHERE playerId=" + $playerId;
			q.addEventListener(SQLEvent.RESULT, onScoreRecieved);
			q.addEventListener(SQLErrorEvent.ERROR, onDBError);
			q.execute();
		}
		
		private function onScoreRecieved($e:SQLEvent):void {
			var q:SQLStatement = $e.target as SQLStatement;
			var res:SQLResult = q.getResult();
			
			_hasScores = res.data != null;
			
			if (_hasScores)
			{
				parseScoreData(res.data);
			}
			else
			{
				dispatchEvent(new Event(EVENT_SCORES_LOADED));
			}
		}
		
		private function parseScoreData($data:Object):void
		{
			_scores = [];
			
			for each (var sData:Object in $data)
			{
				_scores.push(sData.score);
			}
			
			dispatchEvent(new Event(EVENT_SCORES_LOADED));
		}
		
		
		private function connectToMainDB():void
		{
			var dir:File = File.documentsDirectory.resolvePath("SpaceTypers/");
			
			if (dir.exists)
			{
				openMainDB(dir);
			}
			else
			{
				dir.createDirectory();
				openMainDB(dir);
			}
		
		}
		
		private function openMainDB($dbDir:File):void
		{
			var dbFile:File = $dbDir.resolvePath(MAIN_DB_NAME);
			
			_connMainDB = new SQLConnection();
			_connMainDB.addEventListener(SQLEvent.OPEN, onMainDBOpen);
			_connMainDB.addEventListener(SQLErrorEvent.ERROR, onDBError);
			_connMainDB.openAsync(dbFile);
		}
		
		private function onMainDBOpen($e:SQLEvent):void
		{
			var stat:SQLStatement = new SQLStatement();
			stat.sqlConnection = _connMainDB;
			stat.text = "CREATE TABLE IF NOT EXISTS Players (id INTEGER PRIMARY KEY AUTOINCREMENT, nick TEXT, name TEXT, lname TEXT)";
			stat.execute(-1, new Responder(selectAllPlayers));
		}
		
		private function onDBError($e:SQLErrorEvent):void
		{
			trace($e.error);
		}
		
		public function selectAllPlayers($e:SQLResult = null):void
		{
			var q:SQLStatement = new SQLStatement();
			q.sqlConnection = _connMainDB;
			q.text = "SELECT * FROM 'Players'";
			q.addEventListener(SQLEvent.RESULT, onPlayersSelected);
			q.addEventListener(SQLErrorEvent.ERROR, onDBError);
			q.execute();
			
			if(hasEventListener(EVENT_MAIN_DB_CREATED)) dispatchEvent(new Event(EVENT_MAIN_DB_CREATED));
		}
		
		private function onPlayersSelected($e:SQLEvent):void
		{
			var q:SQLStatement = $e.target as SQLStatement;
			var res:SQLResult = q.getResult();
			
			_hasRegisteredPlayers = res.data != null;
			
			if (_hasRegisteredPlayers)
			{
				parsePlayerData(res.data);
			}
			else
			{
				_dataLoadedMainDB = true;
				dispatchEvent(new Event(EVENT_DATA_LOADED));
			}
			
			var stat:SQLStatement = new SQLStatement();
			stat.sqlConnection = _connMainDB;
			stat.text = "CREATE TABLE IF NOT EXISTS Stats (id INTEGER PRIMARY KEY AUTOINCREMENT, " + "playerId INTEGER, score INTEGER, wpm INTEGER, accuracy REAL, weakHand TEXT, weakFinger TEXT, " + "date INTEGER, indexErrCount INTEGER, middleErrCount INTEGER, ringErrCount INTEGER, " + "pinkyErrCount INTEGER, lHandErrCount INTEGER, rHandErrCount INTEGER)";
			stat.execute();
		
		}
		
		private function parsePlayerData($data:Object):void
		{
			_dataLoadedMainDB = true;
			_allPlayers = new <Player>[];
			
			for each (var pData:Object in $data)
			{
				_allPlayers.push(new Player(pData.nick, pData.name, pData.lname, pData.id));
			}
			
			dispatchEvent(new Event(EVENT_DATA_LOADED));
		}
		
		public function registerPlayer($player:Player):void
		{
			var q:SQLStatement = new SQLStatement();
			q.sqlConnection = _connMainDB;
			q.clearParameters();
			q.text = "INSERT  INTO 'Players' VALUES( :id, :nick, :name, :lname )";
			q.parameters[':id'] = $player.stats.playerId;
			q.parameters[':nick'] = $player.nick;
			q.parameters[':name'] = $player.name;
			q.parameters[':lname'] = $player.lastName;
			q.addEventListener(SQLEvent.RESULT, onPlayerRegistered);
			q.addEventListener(SQLErrorEvent.ERROR, onDBError);
			q.execute();
		}
		
		private function onPlayerRegistered($e:SQLEvent):void
		{
			var res = SQLStatement($e.target);
			res.removeEventListener(SQLEvent.RESULT, onPlayerRegistered);
			
			dispatchEvent(new Event(EVENT_PLAYER_REGSTERED));
		}
		
		public function test():void
		{
			trace('testing!!')
			var q:SQLStatement = new SQLStatement();
			q.sqlConnection = _connMainDB;
			q.clearParameters();
			q.text = "SELECT * FROM Stats ORDER BY id DESC LIMIT 2";
			q.addEventListener(SQLEvent.RESULT, onTestResult);
			q.addEventListener(SQLErrorEvent.ERROR, onDBError);
			q.execute();
		}
		
		private function onTestResult($e:SQLEvent):void
		{
			var statement:SQLStatement = SQLStatement($e.target);
			var res:SQLResult = statement.getResult();
			var dataDB:Object = res.data;
			
			statement.removeEventListener(SQLEvent.RESULT, onPlayerRegistered);
			
			for each (var d:Object in dataDB)
			{
				trace(d.id, d.playerId, d.score);
			}
		}
		
		public function getPlayerInfo($nick:String):Player
		{
			var playerInfo:Player;
			
			for each (var player:Player in allPlayers)
			{
				if (player.nick == $nick)
				{
					playerInfo = player;
					
					break;
				}
			}
			
			return playerInfo;
		}
		
		public function syncPlayerProgress($playerInfo:Player):void
		{
		
		}
		
		public function get allPlayers():Vector.<Player>
		{
			return _allPlayers;
		}
		
		public function get hasRegisteredPlayers():Boolean
		{
			return _hasRegisteredPlayers;
		}
		
		public function get dataLoadedMainDB():Boolean
		{
			return _dataLoadedMainDB;
		}
		
		public function get hasScores():Boolean 
		{
			return _hasScores;
		}
		
		public function get scores():Array 
		{
			return _scores;
		}
	}

}
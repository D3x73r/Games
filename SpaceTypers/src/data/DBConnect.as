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
		public const EVENT_DATA_LOADED:String = 'event_data_loaded';
		public const EVENT_STATS_LOADED:String = 'event_stats_loaded';
		public const EVENT_MAIN_DB_CREATED:String = 'event_main_db_created';
		public const EVENT_PLAYER_REGSTERED:String = 'event_player_regstered';
		public const EVENT_STATS_INSERTED:String = 'event_stats_inserted';
		public const EVENT_START_WORDS_REORDEREDING:String = 'event_start_words_reordereding';
		
		public const MAIN_DB_NAME:String = 'STypers.db';
		public const STATS_DB_NAME:String = 'STypersStats.db';
		
		private var _hasRegisteredPlayers:Boolean = false;
		private var _hasScores:Boolean = false;
		
		//Main DB
		private var _connMainDB:SQLConnection;
		private var _dataLoadedMainDB:Boolean = false;
		private var _allPlayers:Vector.<Player>;
		
		//Stats
		private var _allStats:Array;
		private var _scores:Array;
		
		private var _indexErrCount:int;
		private var _middleErrCount:int;
		private var _ringErrCount:int;
		private var _pinkyErrCount:int;
		private var _lHandErrCount:int;
		private var _rHandErrCount:int;
		private var _row1ErrCount:int;
		private var _row2ErrCount:int;
		private var _row3ErrCount:int;
		
		public function DBConnect()
		{
			connectToMainDB();
		}
		
		
		public function savePlayerScore($player:Player):void
		{
			
			addEventListener(EVENT_STATS_LOADED, function onLoaded($e:Event) {
					removeEventListener(EVENT_STATS_LOADED, onLoaded);
					
					doSavePlayerScore($player)
				});
			
			getPlayerStats($player);
		}
		
		private function doSavePlayerScore($player:Player):void
		{
			var counter:int = 0;
			var currentDate:Date = new Date();
			var weakFinger:String;
			var weakHand:String;
			var maxErrCount:int;
			
			_indexErrCount = $player.stats.indexFingerErrCount;
			_middleErrCount = $player.stats.middleFingerErrCount;
			_ringErrCount = $player.stats.ringFingerErrCount;
			_pinkyErrCount = $player.stats.pinkyFingerErrCount;
			
			_lHandErrCount = $player.stats.leftHandErrCount;
			_rHandErrCount = $player.stats.rightHandErrCount;
			
			_row1ErrCount = $player.stats.row1ErrCount;
			_row2ErrCount = $player.stats.row2ErrCount;
			_row3ErrCount = $player.stats.row3ErrCount;
			
			
			if (_allStats != null && _allStats.length > 0)
			{
				var lastStat:Object = _allStats[_allStats.length - 1]; 
				var days:int = int(((((currentDate.getTime() - lastStat.date) / 1000) / 60) / 60) / 24);
				
				if (days < 30)
				{
					counter = lastStat.counter + 1;
					
					_indexErrCount += lastStat.indexErrCount;
					_middleErrCount +=  lastStat.middleErrCount;
					_ringErrCount += lastStat.ringErrCount;
					_pinkyErrCount += lastStat.pinkyErrCount;
					
					_lHandErrCount += lastStat.lHandErrCount;
					_rHandErrCount += lastStat.rHandErrCount;
					
					_row1ErrCount += lastStat.row1ErrCount;
					_row2ErrCount += lastStat.row2ErrCount;
					_row3ErrCount += lastStat.row3ErrCount;
					
					if (lastStat.counter > 1)
					{
						dispatchEvent(new Event(EVENT_START_WORDS_REORDEREDING));
					}
				}
				
			}
			
			maxErrCount = _indexErrCount;
			weakFinger = 'index';
			if (_middleErrCount > maxErrCount) 
			{
				maxErrCount = _middleErrCount;
				weakFinger = 'middle';
			}
			if (_ringErrCount > maxErrCount) 
			{
				maxErrCount = _ringErrCount;
				weakFinger = 'ring';
			}
			if (_pinkyErrCount > maxErrCount) 
			{
				maxErrCount = _pinkyErrCount;
				weakFinger = 'pinky';
			}
			
			if (_indexErrCount == 0 && _middleErrCount == 0 && _ringErrCount == 0 && _pinkyErrCount == 0) weakFinger = 'none';
			
			if (_lHandErrCount > _rHandErrCount) weakHand = 'left';
			else weakHand = 'right';
			
			if (_lHandErrCount == 0 && _rHandErrCount == 0) weakHand = 'none';
			
			var q:SQLStatement = new SQLStatement();
			var qText:String = "INSERT  INTO 'Stats' VALUES( NULL, :playerId, :score, :wpm, :accuracy, :weakHand, :weakFinger, :date, :indexErrCount, :middleErrCount, :ringErrCount, :pinkyErrCount, :lHandErrCount, :rHandErrCount, :counter, :keyBoardId, :row1ErrCount, :row2ErrCount, :row3ErrCount)";
			
			q.sqlConnection = _connMainDB;
			q.clearParameters();
			q.text = qText;
			q.parameters[':playerId'] = $player.stats.playerId;
			q.parameters[':score'] = $player.stats.score;
			q.parameters[':wpm'] = $player.stats.wpm;
			q.parameters[':accuracy'] = $player.stats.accuracy;
			q.parameters[':weakHand'] = weakHand;
			q.parameters[':weakFinger'] = weakFinger;
			q.parameters[':date'] = new Date().getTime();
			q.parameters[':indexErrCount'] = _indexErrCount;
			q.parameters[':middleErrCount'] = _middleErrCount;
			q.parameters[':ringErrCount'] = _ringErrCount;
			q.parameters[':pinkyErrCount'] = _pinkyErrCount;
			q.parameters[':lHandErrCount'] = _lHandErrCount;
			q.parameters[':rHandErrCount'] = _rHandErrCount;
			q.parameters[':counter'] = counter;
			q.parameters[':keyBoardId'] = $player.stats.keyboardId;
			q.parameters[':row1ErrCount'] = _row1ErrCount;
			q.parameters[':row2ErrCount'] = _row2ErrCount;
			q.parameters[':row3ErrCount'] = _row3ErrCount;
			
			q.addEventListener(SQLEvent.RESULT, onStatsInsert);
			q.addEventListener(SQLErrorEvent.ERROR, onDBError);
			q.execute();
		}
		
		private function onStatsInsert($e:SQLEvent):void
		{
			var q:SQLStatement = $e.target as SQLStatement;
			q.removeEventListener(SQLEvent.RESULT, onStatsInsert);
			
			dispatchEvent(new Event(EVENT_STATS_INSERTED));
		}
		
		public function getPlayerStats($player:Player):void
		{
			var q:SQLStatement = new SQLStatement();
			q.sqlConnection = _connMainDB;
			q.text = "SELECT * FROM 'Stats' WHERE playerId=" + $player.playerId + " AND keyBoardId=" + $player.stats.keyboardId;
			q.addEventListener(SQLEvent.RESULT, onStatsLoaded);
			q.addEventListener(SQLErrorEvent.ERROR, onDBError);
			q.execute();
		}
		
		private function onStatsLoaded($e:SQLEvent):void {
			var q:SQLStatement = $e.target as SQLStatement;
			var res:SQLResult = q.getResult();
			
			q.removeEventListener(SQLEvent.RESULT, onStatsLoaded);
			
			_hasScores = res.data != null;
			
			if (_hasScores)
			{
				parseStatsData(res.data);
			}
			else
			{
				dispatchEvent(new Event(EVENT_STATS_LOADED));
			}
		}
		
		private function parseStatsData($stats:Array):void
		{
			_scores = [];
			_allStats = $stats;
			
			for each (var stat:Object in _allStats)
			{
				_scores.push(stat.score);
			}
			
			dispatchEvent(new Event(EVENT_STATS_LOADED));
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
			stat.text = "CREATE TABLE IF NOT EXISTS Stats (id INTEGER PRIMARY KEY AUTOINCREMENT, " + "playerId INTEGER, score INTEGER, wpm INTEGER, accuracy REAL, weakHand TEXT, weakFinger TEXT, " + "date REAL, indexErrCount INTEGER, middleErrCount INTEGER, ringErrCount INTEGER, " + "pinkyErrCount INTEGER, lHandErrCount INTEGER, rHandErrCount INTEGER, counter INTEGER, keyBoardId INTEGER, row1ErrCount INTEGER, row2ErrCount INTEGER, row3ErrCount INTEGER)";
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
			trace($player)
			var q:SQLStatement = new SQLStatement();
			q.sqlConnection = _connMainDB;
			q.clearParameters();
			q.text = "INSERT  INTO 'Players' VALUES( :id, :nick, :name, :lname )";
			q.parameters[':id'] = $player.playerId;
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
		
		public function get indexErrCount():int 
		{
			return _indexErrCount;
		}
		
		public function get middleErrCount():int 
		{
			return _middleErrCount;
		}
		
		public function get ringErrCount():int 
		{
			return _ringErrCount;
		}
		
		public function get pinkyErrCount():int 
		{
			return _pinkyErrCount;
		}
		
		public function get lHandErrCount():int 
		{
			return _lHandErrCount;
		}
		
		public function get rHandErrCount():int 
		{
			return _rHandErrCount;
		}
		
		public function get row1ErrCount():int 
		{
			return _row1ErrCount;
		}
		
		public function get row2ErrCount():int 
		{
			return _row2ErrCount;
		}
		
		public function get row3ErrCount():int 
		{
			return _row3ErrCount;
		}
	}

}
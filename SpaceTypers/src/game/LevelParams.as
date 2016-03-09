package game
{
	import data.Player;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import utils.Config;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class LevelParams extends EventDispatcher
	{
		public static const EVENT_LEVEL_PARAMS_SET:String = 'event_level_params_set';
		public static var wordsLoaded:Boolean;
		
		private const _KEYBOARDS:Vector.<String> = new <String>['_qwerty', '_dvorak', '_colemak'];
		
		private var _codeNames:Array;
		private var _allCodeNames:Array;
		private var _config:Object;
		private var _level:int;
		private var _keyBoardId:int;
		private var _playerId:int;
		private var _asteroidMinSpeed:Number = 2;
		private var _asteroidMaxSpeed:Number = 5;
		private var _wordsObjDb:Object;
		
		public function LevelParams()
		{
			
		}
		
		public function init($level:int, $keyBoardId:int, $currentPlayer:Player):void
		{
			_level = $level;
			trace('words loaded!!', wordsLoaded);
			if (wordsLoaded && _keyBoardId == $keyBoardId && _playerId == $currentPlayer.playerId)
			{
				//trace('first', _allCodeNames.length)
				var startId:int = _level < 10 ? 0 : _level - 10;
				var endId:int = int( ( ( _allCodeNames.length - 1 )  * _level) / 100);
				_codeNames = [];
				_codeNames = _allCodeNames.slice(startId, endId);
				//trace('daljinata e:', _codeNames.length, "start", startId, "end", endId);
				
				for (var i:int = 0;  i < _codeNames.length; i++ )
				{
					//trace('CODE NAME WORD:', _codeNames[i].word);
				}
				
				dispatchEvent(new Event(EVENT_LEVEL_PARAMS_SET));
			}
			else
			{
				//trace('SECOND')
				_keyBoardId = $keyBoardId;
				_playerId = $currentPlayer.playerId;
				loadWords();
			}
		}
		
		private function loadWords():void
		{
			var wordsFile:File = File.documentsDirectory.resolvePath('SpaceTypers/' + _playerId + '/words' + _KEYBOARDS[keyBoardId] + '.st');
			var request:URLRequest = new URLRequest(wordsFile.url);
			var loader:URLLoader = new URLLoader(request);
			
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, fileLoadedHandler);
		}
		
		private function fileLoadedHandler($e:Event):void
		{
			var loader:URLLoader = $e.target as URLLoader;
			var dataObj:ByteArray = loader.data as ByteArray;
			var obj:Object = dataObj.readObject();
			
			_allCodeNames = obj.words;
			_config = obj.config;
			//trace('axa', _config);
			
			var startId:int = _level < 10 ? 0 : _level - 10;
			var endId:int = int( ( ( _allCodeNames.length - 1 )  * _level) / 100);
			
			wordsLoaded = true;
			
			_codeNames = _allCodeNames.slice(startId, endId);
			
			//for (var i:int = 0;  i < _codeNames.length; i++ )
			//{
				//trace(_codeNames[i].word);
			//}
			
			dispatchEvent(new Event(EVENT_LEVEL_PARAMS_SET));
		}
		
		public function get codeNames():Array
		{
			return _codeNames;
		}
		
		public function get keyBoardId():int 
		{
			return _keyBoardId;
		}
		
		public function get allCodeNames():Array 
		{
			return _allCodeNames;
		}
		
		
		public function reorderNeeded($config:Object):Boolean
		{
			
			
			var rowErrors:Array = [	{ errCount : $config.row1ErrCount , id : 1 }, 
									{ errCount : $config.row2ErrCount , id : 2 }, 
									{ errCount : $config.row3ErrCount , id : 3 }
									];
									
			for (var i:int = 0; i < rowErrors.length; i++ )
			{
				trace("errCount:", rowErrors[i].errCount, "id:", rowErrors[i].id);
			}
			
			rowErrors.sortOn('errCount', Array.NUMERIC, Array.DESCENDING);
			trace('done');
			for (i = 0; i < rowErrors.length; i++ )
			{
				trace("errCount:", rowErrors[i].errCount, "id:", rowErrors[i].id);
			}
			
			trace('before sort:', _config.rowPenalties);
			
			var rowPenalties:Array = [_config.rowPenalties[0]];
			
			for (i = 0; i < rowErrors.length; i++ )
			{
				rowPenalties.push(_config.rowPenalties[rowErrors[i].id]);
			}
			
			//trace(_config.rowPenalties, _config.indexFingerPenalty, _config.rowPenalties, _config.indexFingerPenalty, _config.middleFingerPenalty, _config.ringFingerPenalty, _config.pinkyFingerPenalty, _config.lHandPen, _config.rHandPen);
			trace('after sort:', rowPenalties);
			return true;
		}
	}
}
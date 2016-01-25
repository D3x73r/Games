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
		
		private const _KEYBOARDS:Vector.<String> = new <String>['_qwerty', '_dvorak', '_colemak'];
		
		private var _codeNames:Array;
		private var _level:int;
		private var _keyBoardId:int;
		private var _playerId:int;
		private var _asteroidMinSpeed:Number = 2;
		private var _asteroidMaxSpeed:Number = 5;
		private var _wordsObjDb:Object;
		private var _wordsLoaded:Boolean;
		
		public function LevelParams()
		{
			
		}
		
		public function init($level:int, $keyBoardId:int, $currentPlayer:Player):void
		{
			_level = $level;
			
			if (_wordsLoaded && _keyBoardId == $keyBoardId && _playerId == $currentPlayer.playerId)
			{
				var startId:int = _level < 10 ? 0 : _level - 10;
				var endId:int = int( ( ( _codeNames.length - 1 )  * _level) / 100);
				
				_codeNames = _codeNames.slice(startId, endId);
				
				//
				//for (var i:int = 0;  i < _codeNames.length; i++ )
				//{
					//trace(_codeNames[i].word);
				//}
				
				dispatchEvent(new Event(EVENT_LEVEL_PARAMS_SET));
			}
			else
			{
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
			var tmpArr:Array = obj.words;
			var startId:int = _level < 10 ? 0 : _level - 10;
			var endId:int = int( ( ( tmpArr.length - 1 )  * _level) / 100);
			
			_wordsLoaded = true;
			
			_codeNames = tmpArr.slice(startId, endId);
			
			for (var i:int = 0;  i < _codeNames.length; i++ )
			{
				trace(_codeNames[i].word);
			}
			
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
	}
}
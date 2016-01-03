package game
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
		private var _asteroidMinSpeed:Number = 2;
		private var _asteroidMaxSpeed:Number = 5;
		private var _wordsObjDb:Object;
		
		public function LevelParams()
		{
			
		}
		
		public function init($level:int, $keyBoardId:int):void
		{
			_level = $level;
			_keyBoardId = $keyBoardId;
			
			loadWords();
		}
		
		private function loadWords():void
		{
			var request:URLRequest = new URLRequest('words' + _KEYBOARDS[keyBoardId] + '.st');
			var loader:URLLoader = new URLLoader(request);
			
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, fileLoadedHandler);
		}
		
		private function fileLoadedHandler($e:Event):void
		{
			// Retrieve the event target, cast as the URLLoader we just created
			var loader:URLLoader = $e.target as URLLoader;
			
			// Retrieve the loaded data. We know it's a ByteArray, so let's cast it as well.
			var data:ByteArray = loader.data as ByteArray;
			
			// Use the ByteArray.readObject method to reconstruct the object.
			var obj:Object = data.readObject();
			
			_codeNames = obj.words;
			//
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
	}
}
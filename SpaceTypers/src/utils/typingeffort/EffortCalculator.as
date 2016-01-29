package utils.typingeffort 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	public class EffortCalculator extends Sprite 
	{
		private var _memory:ByteArray = new ByteArray();
		private var _backToMain:MessageChannel;
		private var _mainToBack:MessageChannel;
		
		private var _words:Array;
		private var _config:Object;
		
		public function EffortCalculator() 
		{
			super();
			
			_memory.shareable = true;
			
			_backToMain = Worker.current.getSharedProperty('btm');
			_mainToBack = Worker.current.getSharedProperty('mtb');
			
			_mainToBack.addEventListener(Event.CHANNEL_MESSAGE, onMainToBack);
			
			_backToMain.send(_memory);
		}
		
		private function onMainToBack($e:Event):void
		{
			var wordsObj:ByteArray;
			_memory.position = 0; //To start at the beginning;
			
			var obj:Object = _memory.readObject();
			_words = obj.words;
			_config = obj.config;
			_backToMain.send(obj.x + obj.y);
		}
		
	}

}
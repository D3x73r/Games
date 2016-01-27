package utils.workers 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author F43841 Hristo Dimitrov
	 */
	
	public class TypingEffortWorker extends Sprite
	{
		[Embed(source="../../../EffortCalculator.swf", mimeType="application/octet-stream")]
		private var WorkerSWF:Class;
		
		private var _worker:Worker;
		private var _backToMainCh:MessageChannel;
		private var _mainToBackCh:MessageChannel;
		private var _memory:ByteArray;
		private var _calculating:Boolean;
		
		public function TypingEffortWorker() 
		{
			super();
			
			_worker = WorkerDomain.current.createWorker(new WorkerSWF());
			_backToMainCh = _worker.createMessageChannel(Worker.current);
			_mainToBackCh = Worker.current.createMessageChannel(_worker);
			
			_backToMainCh.addEventListener(Event.CHANNEL_MESSAGE, onBackToMain);
			
			_worker.setSharedProperty('btm', _backToMainCh);
			_worker.setSharedProperty('mtb', _mainToBackCh);
			
			_worker.start();
			_memory = _backToMainCh.receive(true);
		}
		
		private function onBackToMain($e:Event):void 
		{
			if (_backToMainCh.messageAvailable)
			{
				_calculating = false;
				
				trace(_backToMainCh.receive());
			}
		}
		
		public function sendData($byteArray:ByteArray):void
		{	
			_calculating = true;
			_memory.length = 0;
			_memory.writeBytes($byteArray);
			
			_mainToBackCh.send('INCOMMING_DATA');	
		}
		
		public function get calculating():Boolean 
		{
			return _calculating;
		}
		
	}

}
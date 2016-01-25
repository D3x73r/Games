package utils.workers 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	
	/**
	 * ...
	 * @author F43841 Hristo Dimitrov
	 */
	
	public class TypingEffortWorker extends EventDispatcher 
	{
		public var WorkerSWF:Class;
		private var _worker:Worker;
		private var _backToMainCh:MessageChannel;
		private var _mainToBackCh:MessageChannel;
		
		public function TypingEffortWorker(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			
			_worker = WorkerDomain.current.createWorker(new WorkerSWF());
			_backToMainCh = _worker.createMessageChannel(Worker.current);
			_mainToBackCh = Worker.current.createMessageChannel(_worker);
			
			_backToMainCh.addEventListener(Event.CHANNEL_MESSAGE, onBackToMain);
			
			_worker.start();
		}
		
		private function onBackToMain($e:Event):void 
		{
			
		}
		
	}

}
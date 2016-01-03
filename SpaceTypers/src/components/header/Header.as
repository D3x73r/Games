package components.header 
{
	import components.BaseComponent;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author F43841 Hristo Dimitrov
	 */
	
	public class Header extends BaseComponent 
	{
		private var _txtScore:TextField;
		private var _livesPanel:LivesPanel;
		
		public function Header() 
		{
			super();
			
		}
		
		public function get txtScore():TextField 
		{
			if (!_txtScore)
			{
				_txtScore = getChildByName('txt_score') as TextField;
				
				if (_txtScore)
				{
					_txtScore.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtScore);
				}
				
			}
			
			return _txtScore;
		}
		
		private function cleanUpTxtScore($e:Event):void 
		{
			_txtScore.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpTxtScore);
			_txtScore = null;
		}
		
		public function get livesPanel():LivesPanel 
		{
			if (!_livesPanel)
			{
				_livesPanel = getChildByName('lives_panel') as LivesPanel;
				
				if (_livesPanel)
				{
					_livesPanel.addEventListener(Event.REMOVED_FROM_STAGE, cleanUpLivesPanel);
				}
				
			}
			
			return _livesPanel;
		}
		
		private function cleanUpLivesPanel($e:Event):void 
		{
			_livesPanel.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUpLivesPanel);
			_livesPanel = null;
		}
		
	}

}
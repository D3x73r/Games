package utils.chart
{
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	//import Sprite class
	import flash.display.Sprite;
	
	public class ChartPoint extends Sprite
	{
		//index of the serie of the point
		private var indexSerie:uint;
		//index of the period of the point
		private var indexPeriod:uint;
		//radius of the point
		private var radius:Number;
		//border color for the point
		private var bcolor:uint;
		//interior color for the point
		private var icolor:uint;
		
		//main function
		public function ChartPoint(s:uint, p:uint, r:Number, ic:uint, bc:uint)
		{
			//loading variables
			this.indexSerie = s;
			this.indexPeriod = p;
			this.radius = r;
			this.bcolor = bc;
			this.icolor = ic;
			
			drawPoint();
		}
		
		//drawing the point
		private function drawPoint():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, this.bcolor);
			this.graphics.beginFill(this.icolor);
			this.graphics.drawCircle(0, 0, this.radius);
		}
		
		//return the index of the series (read-only)
		public function get serie():uint
		{
			return indexSerie;
		}
		
		//return the index of the period (read-only)
		public function get period():uint
		{
			return indexPeriod;
		}
	
	}
}
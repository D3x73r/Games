package utils.chart
{
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	//Import common functions
	import utils.chart.CommonFunctions;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.display.SpreadMethod;
	import flash.display.GradientType;
	
	import flash.geom.Matrix;
	
	public class ChartLegend extends Sprite
	{
		
		//Declaring variables for the legend
		//Serie index
		private var indexSerie:uint;
		//format for legends
		private var fmLegend:TextFormat;
		//Width of legend, height is calculated automatically
		private var wLegend:Number;
		//wide of the square of legend 
		private var wSquare:Number;
		//border color
		private var bColor:uint;
		//light color
		private var lColor:uint;
		//dark color
		private var dColor:uint;
		//over legend color
		private var eColor:uint;
		//text for legend
		private var stLegend:String;
		//textfield of legend
		private var txLegend:TextField;
		
		//shapes and sprites of the legend
		private var spButton:Sprite;
		private var shBack:Shape;
		private var shLegend:Shape;
		private var shBorder:Shape;
		
		//boolean to inform if the legend is selected to draw or not 
		private var selected:Boolean;
		
		//main function
		public function ChartLegend(s:uint, FORMAT:TextFormat, WLEGEND:Number, WSQUARE:Number, BCOLOR:uint, LCOLOR:uint, DCOLOR:uint, EMPCOLOR:uint = 0xEEEEEE, SELECTED:Boolean = true)
		{
			
			//loading variables
			this.indexSerie = s;
			this.fmLegend = FORMAT;
			this.wLegend = WLEGEND;
			this.wSquare = WSQUARE;
			this.bColor = BCOLOR;
			this.lColor = LCOLOR;
			this.dColor = DCOLOR;
			this.eColor = EMPCOLOR;
			this.stLegend = "";
			this.selected = SELECTED;
			
			//this is used to have hand cursor
			this.buttonMode = true;
			
			//instantiating the objects
			this.txLegend = new TextField();
			this.spButton = new Sprite();
			this.shBack = new Shape();
			this.shLegend = new Shape();
			this.shBorder = new Shape();
			
			//By default the legend is selected
			this.shLegend.visible = this.selected;
			
			//adding objects to the ChartLegend
			this.addChild(shBack);
			this.addChild(shBorder);
			this.addChild(shLegend);
			this.addChild(txLegend);
			this.addChild(spButton);
		
		}
		
		//this function draw the current legend
		private function drawLegend():void
		{
			//var cm:CommonFunctions = new CommonFunctions();
			CommonFunctions.fillText(txLegend, "tt", fmLegend);
			var h:Number = (txLegend.height - wSquare) / 2;
			
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [this.lColor, this.dColor];
			var alphas:Array = [1, 1];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(this.wSquare, this.wSquare, Math.PI / 2, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			
			shBorder.graphics.clear();
			shBorder.graphics.lineStyle(1, this.bColor);
			shBorder.graphics.beginFill(0xFFFFFF);
			shBorder.graphics.drawRect(0, 0, wSquare, wSquare);
			
			shLegend.graphics.clear();
			shLegend.graphics.lineStyle(1, this.bColor);
			shLegend.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			shLegend.graphics.drawRect(0, 0, wSquare, wSquare);
			
			shBorder.x = shLegend.x = 4;
			shBorder.y = shLegend.y = h //+ yLPosition;
			
			CommonFunctions.fillText(txLegend, stLegend, fmLegend, wLegend - wSquare - 8, true, true);
			txLegend.x = 8 + wSquare;
			
			shBack.graphics.clear();
			shBack.graphics.beginFill(this.eColor);
			shBack.graphics.drawRect(0, 0, wLegend, txLegend.height);
			shBack.alpha = 0;
			
			spButton.graphics.clear();
			spButton.graphics.beginFill(this.lColor, 0);
			spButton.graphics.drawRect(0, 0, wLegend, txLegend.height);
		
		}
		
		//return the serie, notice read-only
		public function get serie():uint
		{
			return indexSerie;
		}
		
		//return the text of legend
		public function get txt():String
		{
			return this.stLegend;
		}
		
		//update the text of legend
		public function set txt(st:String)
		{
			this.stLegend = st;
			drawLegend();
		}
		
		//return if the legend is selected
		public function get isSelected():Boolean
		{
			return this.selected;
		}
		
		//update the selected of legend
		public function set isSelected(bb:Boolean)
		{
			this.selected = bb;
			this.shLegend.visible = this.selected;
		}
		
		//function used for MOUSE_OVER event
		public function over(bb:Boolean):void
		{
			if (bb)
			{
				this.shBack.alpha = 1;
			}
			else
			{
				this.shBack.alpha = 0;
			}
		
		}
	
	}
}
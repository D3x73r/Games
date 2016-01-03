package utils.chart
{
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	//importing personalized charts
	import utils.chart.ChartPoint;
	import utils.chart.ChartLegend;
	import utils.chart.CommonFunctions;
	//import display objects
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	//import clases for events
	import flash.events.Event;
	import flash.events.MouseEvent;
	//import clases to use textfields and texformats
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	//class to use dropshadow filter
	import flash.filters.DropShadowFilter;
	//import classes to load external files
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class LinesChart extends Sprite
	{	
		//declaring the display object variables
		private var spContainer:Sprite;
		private var spChartArea:Sprite;
		private var mcLinesChart:MovieClip;
		private var spChartMask:Sprite;
		private var spLegends:Sprite;
		private var spTexts:Sprite;
		private var spTooltip:Sprite;
		private var shTooltip:Shape;
		
		//declaring the textformats used in the chart
		private var fmTagY:TextFormat;
		private var fmTagX:TextFormat;
		private var fmLegends:TextFormat;
		private var fmParagraph:TextFormat;
		private var fmTooltip:TextFormat;
		
		//declaring counters
		private var i:uint;
		private var t:uint;
		private var nbT:uint;
		private var s:uint;
		private var nbS:uint;
		private var p:uint;
		private var nbP:uint;
		private var nbStarted:uint;
		
		//stores the time for opeing animation 
		private var tOpen:Number;
		//stores the step for opening animation 
		private var sOpen:Number;
		//stores if an opening animation is finished
		private var bOpened:Boolean;
		//stores the time for moving animation 
		private var tMove:Number;
		//stores the step for moving animation 
		private var sMove:Number;
		//stores if an move animation is finished
		private var bMoved:Boolean;
		
		//stores the info about series
		private var arSeries:Array;
		//stores the info about periods
		private var arPeriods:Array;
		//stores the info about points
		private var arPoints:Array;
		//stores the info about extra texts
		private var arTexts:Array;
		//stores the info about lines
		private var arLines:Array;
		//stores the info about legends
		private var arLegends:Array;
		
		//textfield for tooltip
		private var txTooltip:TextField;
		
		//shadow for tooltip text
		private var fShadow:DropShadowFilter;
		
		//variables used to load the XML
		private var xmlLoader:URLLoader;
		private var xmlRequest:URLRequest;
		//variable to manage the XML content
		private var xmlContent:XML;
		
		//Objects to store info about chart parts
		private var objChartArea:Object;
		private var objYAxis:Object;
		private var objXAxis:Object;
		private var objGridLines:Object;
		private var objLegends:Object;
		private var objPoints:Object;
		private var objTooltip:Object;
		private var objAnimation:Object;
		
		//main function
		public function LinesChart($xmlData:XML)
		{
			//instantiating the display objects variables
			spContainer = new Sprite();
			spChartArea = new Sprite();
			mcLinesChart = new MovieClip();
			spChartMask = new Sprite();
			spLegends = new Sprite();
			spTexts = new Sprite();
			spTooltip = new Sprite();
			shTooltip = new Shape();
			
			//instantiating the text formats
			fmTagY = new TextFormat();
			fmTagX = new TextFormat();
			fmLegends = new TextFormat();
			fmParagraph = new TextFormat();
			fmTooltip = new TextFormat();
			
			//I set Arial, but it can be changed for another font
			fmTagY.font = "Arial";
			fmTagX.font = "Arial";
			fmLegends.font = "Arial";
			fmParagraph.font = "Arial";
			fmTooltip.font = "Arial";
			
			//instantiating the arrays
			arSeries = new Array();
			arPeriods = new Array();
			arTexts = new Array();
			arLines = new Array();
			arPoints = new Array();
			arLegends = new Array();
			
			//instantiating tooltip textfield
			txTooltip = new TextField();
			
			//instantiating tooltip drop shadow filter
			fShadow = new DropShadowFilter(1);
			
			//instantiating all objects
			objChartArea = new Object();
			objYAxis = new Object();
			objXAxis = new Object();
			objGridLines = new Object();
			objLegends = new Object();
			objPoints = new Object();
			objTooltip = new Object();
			objAnimation = new Object();
			
			//applying drop shadow to the tooltip container
			spTooltip.filters = new Array(fShadow);
		
			addEventListener(Event.ADDED_TO_STAGE, function() {
					parseXmlFile($xmlData);
				});
		}
		
		//function to create the chart area environment
		private function drawChartArea():void
		{
			//positioning the chart area
			spContainer.x = objChartArea.x;
			spContainer.y = objChartArea.y;
			
			//value of interval
			objChartArea.intervalValue = (objYAxis.max - objYAxis.min) / objYAxis.intervals;
			
			//drawing gridlines
			var shGridLines:Shape = new Shape();
			fmTagY.size = objYAxis.tagSize;
			fmTagY.color = objYAxis.tagColor;
			for (i = 0; i <= objYAxis.intervals; i++)
			{
				var yDif:Number = i * objChartArea.height / objYAxis.intervals
				//tags for Y axis
				var txTagY:TextField = new TextField();
				var stTagY:String = Number(objYAxis.max - i * objChartArea.intervalValue).toFixed(objYAxis.decimals);
				CommonFunctions.fillText(txTagY, stTagY, fmTagY);
				txTagY.x = -txTagY.width - objYAxis.tagMargin
				txTagY.y = yDif - txTagY.height / 2;
				//adding tag to the chart area
				spChartArea.addChild(txTagY);
				//filling the chart area background
				if (i < objYAxis.intervals)
				{
					if (i % 2 == 0)
					{
						objChartArea.backColor = objChartArea.backColor1
					}
					else
					{
						objChartArea.backColor = objChartArea.backColor2
					}
					shGridLines.graphics.lineStyle(0, 0, 0);
					shGridLines.graphics.beginFill(objChartArea.backColor, 1);
					shGridLines.graphics.drawRect(0, yDif, objChartArea.width, objChartArea.height / objYAxis.intervals);
				}
				//lines
				if (i > 0 && i < objYAxis.intervals)
				{
					shGridLines.graphics.lineStyle(objGridLines.thick, objGridLines.color, objGridLines.alpha);
					shGridLines.graphics.moveTo(0, yDif);
					shGridLines.graphics.lineTo(objChartArea.width, yDif);
				}
				//border of chart area
				shGridLines.graphics.beginFill(0, 0);
				shGridLines.graphics.lineStyle(objChartArea.borderThick, objChartArea.borderColor, objChartArea.borderAlpha);
				shGridLines.graphics.drawRect(0, 0, objChartArea.width, objChartArea.height);
			}
			
			//adding gridlines to the chart area
			spChartArea.addChild(shGridLines);
			
			//calculating the ratio for Y axis
			objChartArea.ratioY = objChartArea.height / (objYAxis.max - objYAxis.min);
			
			//calculating the ratio for X axis
			objChartArea.netWidth = objChartArea.width - 2 * objChartArea.xMargin
			objChartArea.ratioX = objChartArea.netWidth / Math.max(1, nbP - 1);
			
			//Drawing Tags for X axis
			fmTagX.size = objXAxis.tagSize;
			fmTagX.color = objXAxis.tagColor;
			for (p = 0; p < nbP; p++)
			{
				var txTagX:TextField = new TextField();
				CommonFunctions.fillText(txTagX, arPeriods[p].name, fmTagX)
				txTagX.x = objChartArea.xMargin + p * objChartArea.ratioX - txTagX.width / 2;
				txTagX.y = objChartArea.height + objXAxis.tagMargin;
				
				spChartArea.addChild(txTagX);
			}
			
			//drawing the mask
			spChartMask.graphics.beginFill(0);
			spChartMask.graphics.drawRect(0, 0, objChartArea.width, objChartArea.height);
			
			//applying mask
			mcLinesChart.mask = spChartMask;
			
			//adding objects to the chart container
			spContainer.addChild(spChartArea);
			spContainer.addChild(mcLinesChart);
			spContainer.addChild(spChartMask);
			
			//adding the chart container
			addChild(spContainer);
		}
		
		//function to draw legends
		private function drawLegends():void
		{
			//position of legend
			spLegends.x = objLegends.x;
			spLegends.y = objLegends.y;
			//modifying color and size of the format of legends
			fmLegends.color = objLegends.textColor;
			fmLegends.size = objLegends.textSize;
			//filling shapes for legend container
			var shBackLegend:Shape = new Shape();
			var shBorderLegend:Shape = new Shape();
			shBorderLegend.graphics.lineStyle(objLegends.borderThick, objLegends.borderColor, objLegends.borderAlpha);
			shBackLegend.graphics.beginFill(objLegends.backColor, objLegends.backAlpha);
			spLegends.addChild(shBackLegend);
			//creating legends and adding to legends container
			var yLPosition:Number = 0;
			for (s = 0; s < nbS; s++)
			{
				var spLegend:ChartLegend = new ChartLegend(s, fmLegends, objLegends.width, objLegends.square, arSeries[s].pointBorderColor, arSeries[s].pointInteriorColor, arSeries[s].pointInteriorColor, objLegends.legendBackColor);
				spLegend.y = yLPosition;
				spLegends.addChild(spLegend);
				spLegend.txt = arSeries[s].name
				arLegends[s] = spLegend;
				yLPosition += spLegend.height;
			}
			
			//adding border legend and back shape
			spLegends.addChild(shBorderLegend);
			shBorderLegend.graphics.drawRect(0, 0, objLegends.width, yLPosition);
			shBackLegend.graphics.drawRect(0, 0, objLegends.width, yLPosition);
			
			//add legend to the chart
			addChild(spLegends);
		
		}
		
		//adding listeners to animate legends
		private function animLegends():void
		{
			for (s = 0; s < nbS; s++)
			{
				arLegends[s].addEventListener(MouseEvent.CLICK, legendClick);
				arLegends[s].addEventListener(MouseEvent.MOUSE_OVER, legendOver);
				arLegends[s].addEventListener(MouseEvent.MOUSE_OUT, legendOut);
			}
		}
		
		//function used when a legend is clicked
		private function legendClick(e:Event):void
		{
			var ss:uint = e.target.parent.serie;
			
			if (arLegends[ss].isSelected)
			{
				arLegends[ss].isSelected = false;
			}
			else
			{
				arLegends[ss].isSelected = true;
			}
			
			arLines[ss].visible = arLegends[ss].isSelected;
			arPoints[ss].visible = arLegends[ss].isSelected;
		}
		
		//function for a mouse over event on legends
		private function legendOver(e:Event):void
		{
			var ss:uint = e.target.parent.serie;
			arLegends[ss].over(true)
			for (s = 0; s < nbS; s++)
			{
				if (s == ss)
				{
					arLines[s].alpha = 1;
					arPoints[s].alpha = 1;
				}
				else
				{
					arLines[s].alpha = 0.2;
					arPoints[s].alpha = 0.2;
				}
			}
		
		}
		
		//function for a mouse out event on legends
		private function legendOut(e:Event):void
		{
			var ss:uint = e.target.parent.serie;
			
			arLegends[ss].over(false)
			
			for (s = 0; s < nbS; s++)
			{
				arLines[s].alpha = 1;
				arPoints[s].alpha = 1;
			}
		}
		
		//function to draw texts
		private function drawTexts():void
		{
			for (t = 0; t < nbT; t++)
			{
				
				var txParagraph:TextField = new TextField();
				
				fmParagraph.size = arTexts[t].size;
				fmParagraph.bold = arTexts[t].bold;
				fmParagraph.color = arTexts[t].color;
				
				CommonFunctions.fillText(txParagraph, arTexts[t].text, fmParagraph, arTexts[t].width, true, false, arTexts[t].align);
				
				txParagraph.x = arTexts[t].x;
				txParagraph.y = arTexts[t].y;
				
				spTexts.addChild(txParagraph);
				
			}
			
			addChild(spTexts);
		
		}
		
		//function to draw the lines chart
		private function drawLines():void
		{
			mcLinesChart.x = objChartArea.xMargin;
			
			//creating points cointainers
			for (s = 0; s < nbS; s++)
			{
				var spLine:Sprite = new Sprite();
				
				arLines[s] = spLine;
				
				mcLinesChart.addChild(spLine);
			}
			
			//creating points cointainers
			for (s = 0; s < nbS; s++)
			{
				var spPointCont:Sprite = new Sprite();
				
				arPoints[s] = spPointCont;
				
				mcLinesChart.addChild(spPointCont);
			}
			
			//adding tooltip container
			spTooltip.addChild(shTooltip);
			spTooltip.addChild(txTooltip);
			
			addChild(spTooltip);
			
			fmTooltip.size = objTooltip.size;
			
			//add listeners to legends if they are visible
			if (objLegends.visible)
			{
				animLegends();
			}
			
			//setting initial values for bar animations
			nbStarted = 0;
			tOpen = 0;
			tMove = 0;
			sOpen = 1 / (objAnimation.openTime * stage.frameRate);
			sMove = 1 / (objAnimation.moveTime * stage.frameRate);
			bOpened = false;
			bMoved = false;
			
			//manage the synchronized way
			if (objAnimation.synchronized)
			{
				this.addEventListener(Event.ENTER_FRAME, startSynchronized);
			}
			else
			{
				this.addEventListener(Event.ENTER_FRAME, startNoSynchronized);
			}
		
		}
		
		//animating the opening no synchronized
		private function startNoSynchronized(e:Event):void
		{
			if (nbStarted < nbS)
			{
				if (!bOpened)
				{
					tOpen += sOpen;
					
					if (tOpen >= 1)
					{
						tOpen = 1;
						bOpened = true;
					}
					
					var xInitLine:Number = objChartArea.netWidth / 2 - tOpen * (objChartArea.netWidth / 2)
					var xEndLine:Number = objChartArea.netWidth / 2 + tOpen * (objChartArea.netWidth / 2)
					
					arLines[nbStarted].graphics.clear();
					arLines[nbStarted].graphics.lineStyle(arSeries[nbStarted].thick, arSeries[nbStarted].lineColor);
					arLines[nbStarted].graphics.moveTo(xInitLine, (objYAxis.max - arSeries[nbStarted].average) * objChartArea.ratioY)
					arLines[nbStarted].graphics.lineTo(xEndLine, (objYAxis.max - arSeries[nbStarted].average) * objChartArea.ratioY)
					
				}
				else if (!bMoved)
				{
					tMove += sMove;
					
					if (tMove >= 1)
					{
						tMove = 1;
						bMoved = true;
					}
					
					arLines[nbStarted].graphics.clear();
					arLines[nbStarted].graphics.lineStyle(arSeries[nbStarted].thick, arSeries[nbStarted].lineColor);
					
					var yMidLine:Number = (objYAxis.max - arSeries[nbStarted].values[0] * tMove - arSeries[nbStarted].average * (1 - tMove)) * objChartArea.ratioY;
					
					arLines[nbStarted].graphics.moveTo(0, yMidLine)
					
					for (p = 1; p < nbP; p++)
					{
						var yMidLine1:Number = (objYAxis.max - arSeries[nbStarted].values[p] * tMove - arSeries[nbStarted].average * (1 - tMove)) * objChartArea.ratioY;
						
						arLines[nbStarted].graphics.lineTo(p * objChartArea.ratioX, yMidLine1)
						
						arSeries[nbStarted].values[p] = Number(xmlContent.periods.period[p].v[nbStarted]);
					}
					
				}
				else
				{
					drawPoints(nbStarted)
					tOpen = 0;
					tMove = 0;
					bOpened = false;
					bMoved = false;
					nbStarted++;
				}
				
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, startNoSynchronized);
			}
		
		}
		
		//animating the opening synchronized
		private function startSynchronized(e:Event):void
		{
			if (!bOpened)
			{
				tOpen += sOpen;
				
				if (tOpen >= 1)
				{
					tOpen = 1;
					bOpened = true;
				}
				
				var xInitLine:Number = objChartArea.netWidth / 2 - tOpen * (objChartArea.netWidth / 2)
				var xEndLine:Number = objChartArea.netWidth / 2 + tOpen * (objChartArea.netWidth / 2)
				
				for (s = 0; s < nbS; s++)
				{
					arLines[s].graphics.clear();
					arLines[s].graphics.lineStyle(arSeries[s].thick, arSeries[s].lineColor);
					arLines[s].graphics.moveTo(xInitLine, (objYAxis.max - arSeries[s].average) * objChartArea.ratioY)
					arLines[s].graphics.lineTo(xEndLine, (objYAxis.max - arSeries[s].average) * objChartArea.ratioY)
				}
				
			}
			else if (!bMoved)
			{
				tMove += sMove;
				
				if (tMove >= 1)
				{
					tMove = 1;
					bMoved = true;
				}
				
				for (s = 0; s < nbS; s++)
				{
					arLines[s].graphics.clear();
					arLines[s].graphics.lineStyle(arSeries[s].thick, arSeries[s].lineColor);
					
					var yMidLine:Number = (objYAxis.max - arSeries[s].values[0] * tMove - arSeries[s].average * (1 - tMove)) * objChartArea.ratioY;
					
					arLines[s].graphics.moveTo(0, yMidLine)
					
					for (p = 1; p < nbP; p++)
					{
						var yMidLine1:Number = (objYAxis.max - arSeries[s].values[p] * tMove - arSeries[s].average * (1 - tMove)) * objChartArea.ratioY;
						arLines[s].graphics.lineTo(p * objChartArea.ratioX, yMidLine1)
						arSeries[s].values[p] = Number(xmlContent.periods.period[p].v[s]);
					}
					
				}
				
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, startSynchronized);
				for (s = 0; s < nbS; s++)
				{
					drawPoints(s)
				}
			}
		}
		
		//drawing the points
		private function drawPoints(nb:uint):void
		{
			
			for (p = 0; p < nbP; p++)
			{
				var spPoint:ChartPoint = new ChartPoint(nb, p, objPoints.radius, arSeries[nb].pointInteriorColor, arSeries[nb].pointBorderColor);
				spPoint.x = p * objChartArea.ratioX;
				spPoint.y = (objYAxis.max - arSeries[nb].values[p]) * objChartArea.ratioY;
				
				spPoint.addEventListener(MouseEvent.MOUSE_OVER, showTip)
				spPoint.addEventListener(MouseEvent.MOUSE_OUT, hideTip)
				spPoint.addEventListener(MouseEvent.MOUSE_MOVE, moveTip)
				
				arPoints[nb].addChild(spPoint)
			}
		}
		
		//function for tooltip tool
		private function showTip(e:Event):void
		{
			//loading the index serie and index period
			var ss:uint = e.target.serie;
			var pp:uint = e.target.period;
			
			//loading the color of the text
			fmTooltip.color = arSeries[ss].tooltipTextColor;
			fmTooltip.align = TextFormatAlign.CENTER;
			
			//filling th textfield
			txTooltip.text = Number(arSeries[ss].values[pp]).toFixed(objYAxis.decimals);
			txTooltip.antiAliasType = "advanced";
			txTooltip.setTextFormat(fmTooltip);
			txTooltip.autoSize = TextFieldAutoSize.LEFT;
			
			//calculating width and height of the tooltip textfield
			var w:Number = txTooltip.width;
			var h:Number = txTooltip.height;
			
			//filling the background of tooltip
			shTooltip.graphics.clear();
			shTooltip.graphics.beginFill(arSeries[ss].tooltipBackColor);
			shTooltip.graphics.moveTo(w / 2 - 3, h + objTooltip.ymargin);
			shTooltip.graphics.lineTo(w / 2 + 3, h + objTooltip.ymargin);
			shTooltip.graphics.lineTo(w / 2, h + objTooltip.ymargin + 3);
			shTooltip.graphics.lineTo(w / 2 - 3, h + objTooltip.ymargin);
			shTooltip.graphics.drawRect( -objTooltip.xmargin, -objTooltip.ymargin, w + 2 * objTooltip.xmargin, h + 2 * objTooltip.ymargin);
			
			//positioning the tooltip textfield
			txTooltip.x = shTooltip.x = -w / 2;
			txTooltip.y = shTooltip.y = -h - 5 - objTooltip.ymargin;
			
			//setting the position of the tooltip
			spTooltip.x = this.mouseX
			spTooltip.y = this.mouseY
			
			//showing th tooltip text
			spTooltip.visible = true;
		
		}
		
		//hiding tooltip
		private function hideTip(e:Event):void
		{
			spTooltip.visible = false;
		}
		
		//moving tooltip
		private function moveTip(e:Event):void
		{
			spTooltip.x = this.mouseX
			spTooltip.y = this.mouseY
		}
		
		//parse the XML after loading
		private function parseXmlFile($xmlData:XML):void
		{
			XML.ignoreWhitespace = true;
			xmlContent = $xmlData;
			
			//loading config variables
			objChartArea.x = Number(xmlContent.config.chartarea.attribute("x"));
			objChartArea.y = Number(xmlContent.config.chartarea.attribute("y"));
			objChartArea.width = Number(xmlContent.config.chartarea.attribute("width"));
			objChartArea.height = Number(xmlContent.config.chartarea.attribute("height"));
			objChartArea.backColor1 = uint(xmlContent.config.chartarea.attribute("backColor1"));
			objChartArea.backColor2 = uint(xmlContent.config.chartarea.attribute("backColor2"));
			objChartArea.xMargin = Number(xmlContent.config.chartarea.attribute("xMargin"));
			objChartArea.borderColor = uint(xmlContent.config.chartarea.attribute("borderColor"));
			objChartArea.borderThick = Number(xmlContent.config.chartarea.attribute("borderThick"));
			objChartArea.borderAlpha = Number(xmlContent.config.chartarea.attribute("borderAlpha"));
			
			objYAxis.tagSize = uint(xmlContent.config.yaxis.attribute("tagSize"));
			objYAxis.tagColor = uint(xmlContent.config.yaxis.attribute("tagColor"));
			objYAxis.tagMargin = Number(xmlContent.config.yaxis.attribute("tagMargin"));
			objYAxis.min = Number(xmlContent.config.yaxis.attribute("min"));
			objYAxis.max = Number(xmlContent.config.yaxis.attribute("max"));
			objYAxis.intervals = uint(xmlContent.config.yaxis.attribute("intervals"));
			objYAxis.decimals = uint(xmlContent.config.yaxis.attribute("decimals"));
			
			objXAxis.tagSize = uint(xmlContent.config.xaxis.attribute("tagSize"));
			objXAxis.tagColor = uint(xmlContent.config.xaxis.attribute("tagColor"));
			objXAxis.tagMargin = Number(xmlContent.config.xaxis.attribute("tagMargin"));
			
			objGridLines.thick = Number(xmlContent.config.gridlines.attribute("thick"));
			objGridLines.color = uint(xmlContent.config.gridlines.attribute("color"));
			objGridLines.alpha = Number(xmlContent.config.gridlines.attribute("alpha"));
			
			objLegends.visible = Boolean(String(xmlContent.config.legends.attribute("visible")) != "false");
			objLegends.x = Number(xmlContent.config.legends.attribute("x"));
			objLegends.y = Number(xmlContent.config.legends.attribute("y"));
			objLegends.width = Number(xmlContent.config.legends.attribute("width"));
			objLegends.square = Number(xmlContent.config.legends.attribute("square"));
			objLegends.textSize = uint(xmlContent.config.legends.attribute("textSize"));
			objLegends.textColor = uint(xmlContent.config.legends.attribute("textColor"));
			objLegends.backColor = uint(xmlContent.config.legends.attribute("backColor"));
			objLegends.backAlpha = Number(xmlContent.config.legends.attribute("backAlpha"));
			objLegends.borderColor = uint(xmlContent.config.legends.attribute("borderColor"));
			objLegends.borderThick = Number(xmlContent.config.legends.attribute("borderThick"));
			objLegends.borderAlpha = Number(xmlContent.config.legends.attribute("borderAlpha"));
			objLegends.legendBackColor = uint(xmlContent.config.legends.attribute("legendBackColor"));
			
			objPoints.radius = Number(xmlContent.config.points.attribute("radius"));
			
			objTooltip.size = uint(xmlContent.config.tooltip.attribute("size"));
			objTooltip.xmargin = Number(xmlContent.config.tooltip.attribute("xmargin"));
			objTooltip.ymargin = Number(xmlContent.config.tooltip.attribute("ymargin"));
			
			objAnimation.openTime = Number(xmlContent.config.animation.attribute("openTime"));
			objAnimation.moveTime = Number(xmlContent.config.animation.attribute("moveTime"));
			objAnimation.synchronized = Boolean(String(xmlContent.config.animation.attribute("synchronized")) != "false");
			
			//loading texts variables
			nbT = xmlContent.texts.paragraph.length();
			for (t = 0; t < nbT; t++)
			{
				var obtText:Object = new Object();
				obtText.align = String(xmlContent.texts.paragraph[t].attribute("align"));
				obtText.bold = Boolean(String(xmlContent.texts.paragraph[t].attribute("bold")) != "false");
				obtText.size = uint(xmlContent.texts.paragraph[t].attribute("size"));
				obtText.color = uint(xmlContent.texts.paragraph[t].attribute("color"));
				obtText.x = Number(xmlContent.texts.paragraph[t].attribute("x"));
				obtText.y = Number(xmlContent.texts.paragraph[t].attribute("y"));
				obtText.width = Number(xmlContent.texts.paragraph[t].attribute("width"));
				obtText.text = String(xmlContent.texts.paragraph[t].attribute("text"));
				
				arTexts[t] = obtText;
			}
			
			//loading periods variables
			nbP = xmlContent.periods.period.length();
			
			for (p = 0; p < nbP; p++)
			{
				var objPeriod:Object = new Object();
				objPeriod.name = String(xmlContent.periods.period[p].attribute("name"));
				arPeriods[p] = objPeriod;
			}
			
			//loading series variables
			nbS = xmlContent.series.serie.length();
			
			for (s = 0; s < nbS; s++)
			{
				var objSeries:Object = new Object();
				objSeries.name = String(xmlContent.series.serie[s].attribute("name"));
				objSeries.lineColor = uint(xmlContent.series.serie[s].attribute("lineColor"));
				objSeries.pointInteriorColor = uint(xmlContent.series.serie[s].attribute("pointInteriorColor"));
				objSeries.pointBorderColor = uint(xmlContent.series.serie[s].attribute("pointBorderColor"));
				objSeries.thick = uint(xmlContent.series.serie[s].attribute("thick"));
				objSeries.tooltipBackColor = uint(xmlContent.series.serie[s].attribute("tooltipBackColor"));
				objSeries.tooltipTextColor = uint(xmlContent.series.serie[s].attribute("tooltipTextColor"));
				objSeries.values = new Array();
				
				for (p = 0; p < nbP; p++)
				{
					objSeries.values[p] = Number(xmlContent.periods.period[p].v[s]);
				}
				
				objSeries.average = CommonFunctions.avgArray(objSeries.values);
				
				arSeries[s] = objSeries;
			}
			
			//draw the chart area
			drawChartArea();
			
			//draw legends
			if (objLegends.visible)
			{
				drawLegends();
			}
			//draw texts
			drawTexts();
			
			//draw areas
			drawLines();
		
		}
	
	}
}
package xml 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileReference;
	
	/**
	 * ...
	 * @author F43841 Hristo Dimitrov
	 */
	
	public class ChartData extends EventDispatcher
	{
		//Chart Area
		private const _CA_POS_X:Number = 50; 
		private const _CA_POS_Y:Number = 50; 
		private const _CA_WIDTH:int = 400; 
		private const _CA_HEIGHT:int = 200;           
		private const _CA_BACK_COLOR_1:String = "0xfafafa";
		private const _CA_BACK_COLOR_2:String = "0xf1f1f1";
		private const _CA_X_MARGIN:int = 20;          
		private const _CA_BORDER_COLOR:String = "0xbdbdbd";
		private const _CA_BORDER_THICK:int = 2;       
		private const _CA_BORDER_ALPHA:int = 1;       
		
		//Y Axis                                     
		private const _YA_TAG_SIZE:int = 10;          
		private const _YA_TAG_COLOR:String = "0x587b8c";   
		private const _YA_TAG_MARGIN:int = 3;         
		private const _YA_DECIMALS:int = 1;           
		
		//X Axis                                     
		private const _XA_TAG_SIZE:int = 10;          
		private const _XA_TAG_COLOR:String = "0x587b8c";   
		private const _XA_TAG_MARGIN:int = 1;         
		
		//Gridlines                                  
		private const _G_THICK:int = 1;               
		private const _G_COLOR:String = "0xcdcdcd";        
		private const _G_ALPHA:Number = 0.8;
		
		//Legends
		private const _LGD_POS_X:Number = 480;
		private const _LGD_POS_Y:Number = 50;
		private const _LGD_WIDTH:Number = 100;
		private const _LGD_SQUARE:int = 10;
		private const _LGD_TEXT_SIZE:int = 12;
		private const _LGD_TEXT_COLOR:String = "0x5e7086";
		private const _LGD_BACK_COLOR:String = "0xFFFFFF";
		private const _LGD_BACK_ALPHA:int = 1;
		private const _LGD_BORDER_COLOR:String = "0x587b8c";
		private const _LGD_BORDER_THICK:int = 1;
		private const _LGD_BORDER_ALPHA:Number = 1;
		private const _LGD_LEGEND_BACK_COLOR:String = "0xf2f2f2";
		
		//Points
		private const _P_RADIUS:Number = 3;
		
		//Tooltip
		private const _T_SIZE:Number = 10;
		private const _T_X_MARGIN:Number = 2;
		private const _T_Y_MARGIN:Number = 0;
		
		//Animation
		private const _A_OPEN_TIME:Number = 0.5;
		private const _A_MOVE_TIME:Number = 0.5;
		private const _A_SYNCHRONIZED:Boolean = false;
		
		//Lines
		private const _LN_COLORS:Vector.<String> = new <String>["0xDD0000", "0xf99d39", "0x00AA00", "0x000099"];
		private const _LN_THICKS:Vector.<int> = new <int>[1, 1, 1, 1];
		private const _LN_POINT_INTERIOR_COLORS:Vector.<String> = new <String>["0xFF3333", "0xfbc891", "0x55FF55", "0x5555FF"];
		private const _LN_POINT_BORDER_COLORS:Vector.<String> = new <String>["0xDD0000", "0xf99d39", "0x00AA00", "0x000099"];
		private const _LN_TOOLTIP_BACK_COLORS:Vector.<String> = new <String>["0xFF3333", "0xfbc891", "0x55FF55", "0x5555FF"];
		private const _LN_TOOLTIP_TEXT_COLORS:Vector.<String> = new <String>["0xFFFFFF", "0x000000", "0x000000", "0xFFFFFF"];
		
		
		//Nodes, tags & Attributes 
		private const _LINE_CHART:String = 'lineChart';
		private const _CONFIG:String = 'config';
		private const _CHARTAREA:String = 'chartarea';
		private const _Y_AXIS:String = 'yaxis';
		private const _X_AXIS:String = 'xaxis';
		private const _GRIDLINES:String = 'gridlines';
		private const _LEGENDS:String = 'legends';
		private const _POINTS:String = 'points';
		private const _TOOLTIP:String = 'tooltip';
		private const _ANIMATION:String = 'animation';
		private const _SERIES:String = 'series';
		private const _SERIE:String = 'serie';
		private const _PERIODS:String = 'periods';
		private const _PERIOD:String = 'period';
		
		private var _chartData:XML;
		
		public const EVENT_DATA_LOADED:String = 'event_data_loaded';
		
		public function ChartData()
		{
			
		}
		
		public function createData(...rest):void
		{
			//Main node
			_chartData = new XML(< {_LINE_CHART} />);
			
			var max:Number = getMax(rest);
			var intervals:Number = max / rest[0].length;
			
			//config
			var config:XML = new XML(< {_CONFIG} />);
		
									 
			var chartArea:XML = new XML(< { _CHARTAREA} />);
			chartArea.@x = _CA_POS_X;
			chartArea.@y = _CA_POS_Y;
			chartArea.@width = _CA_WIDTH;
			chartArea.@height = _CA_HEIGHT;
			chartArea.@backColor1 = _CA_BACK_COLOR_1;
			chartArea.@backColor2 = _CA_BACK_COLOR_2;
			chartArea.@xMargin = _CA_X_MARGIN;
			chartArea.@borderColor = _CA_BORDER_COLOR;
			chartArea.@borderThick = _CA_BORDER_THICK;
			chartArea.@borderAlpha = _CA_BORDER_ALPHA;
			//yAxis
			var yAxis:XML = new XML(< {_Y_AXIS} />); 
			yAxis.@tagSize = _YA_TAG_SIZE;
			yAxis.@tagColor = _YA_TAG_COLOR;
			yAxis.@tagMargin = _YA_TAG_MARGIN;
			yAxis.@min = 0;
			yAxis.@max = max;
			yAxis.@intervals = intervals;
			yAxis.@decimals = _YA_DECIMALS;
			//xAxis
			var xAxis:XML = new XML(< {_X_AXIS} />);
			xAxis.@tagSize = _XA_TAG_SIZE;
			xAxis.@tagColor = _XA_TAG_COLOR;
			xAxis.@tagMargin = _XA_TAG_MARGIN;
			//gridLines
			var gridLines:XML = new XML(< {_GRIDLINES} />);
			gridLines.@thick = _G_THICK;
			gridLines.@color = _G_COLOR;
			gridLines.@alpha = _G_ALPHA;
			//legends
			var legends:XML = new XML(< {_LEGENDS} />);
			legends.@visible = 'true';
			legends.@x = _LGD_POS_X;
			legends.@y = _LGD_POS_Y;
			legends.@width = _LGD_WIDTH;
			legends.@square = _LGD_SQUARE;
			legends.@textSize = _LGD_TEXT_SIZE;
			legends.@textColor = _LGD_TEXT_COLOR;
			legends.@backColor = _LGD_BACK_COLOR;
			legends.@backAlpha = _LGD_BACK_ALPHA;
			legends.@borderColor = _LGD_BORDER_COLOR;
			legends.@borderThick = _LGD_BORDER_THICK;
			legends.@borderAlpha = _LGD_BORDER_ALPHA;
			legends.@legendBackColor = _LGD_LEGEND_BACK_COLOR;
			//points
			var points:XML = new XML(< {_POINTS} />);
			points.@radius = _P_RADIUS;
			//tooltip
			var tooltip:XML = new XML(< {_TOOLTIP} />);
			tooltip.@size = _T_SIZE;
			tooltip.@xmargin = _T_X_MARGIN;
			tooltip.@ymargin = _T_Y_MARGIN;
			//animation						 
			var animation:XML = new XML(< {_ANIMATION} />);
			animation.@openTime = _A_OPEN_TIME;
			animation.@moveTime = _A_MOVE_TIME;
			animation.@synchronized = _A_SYNCHRONIZED;
			
			config.appendChild(chartArea);
			config.appendChild(yAxis);
			config.appendChild(xAxis);
			config.appendChild(gridLines);
			config.appendChild(legends);
			config.appendChild(points);
			config.appendChild(tooltip);
			config.appendChild(animation);
			
			_chartData.appendChild(config);
									 
			//series
			var series:XML = new XML(< {_SERIES} />);
			var serie:XML;
			for (var i:int = 0; i < rest.length; i++ )
			{
				serie = new XML(< {_SERIE} />);
				serie.@lineColor = _LN_COLORS[i];
				serie.@thick = _LN_THICKS[i];
				serie.@pointInteriorColor = _LN_POINT_INTERIOR_COLORS[i];
				serie.@pointBorderColor = _LN_POINT_BORDER_COLORS[i];
				serie.@tooltipBackColor = _LN_TOOLTIP_BACK_COLORS[i];
				serie.@tooltipTextColor = _LN_TOOLTIP_TEXT_COLORS[i];
				serie.@name = rest[i][0][0];
				
				series.appendChild(serie);
			}
			_chartData.appendChild(series);
			
			//periods
			var periods:XML = new XML(< {_PERIODS} />);
			var period:XML;
			var val:XML;
			
			for (var k:int = 0; k < rest[0].length - 1; k++ )
			{
				
				period = new XML(< {_PERIOD} />);
				
				
				for (var j:int = 1; j <= rest.length; j++ )
				{
					period.@name = rest[k][j][0];
					//trace('xaxaxaxaxaxax: ', rest[k])
					//trace('xaxaxaxaxaxax: ', rest[k][j])
					//trace('xaxaxaxaxaxax: ', rest[k][j][1])
					val = new XML(<v>{rest[k][j][1]}</v>);
					period.appendChild(val);
				}
				
				trace("/n")
				
				periods.appendChild(period);
			}
			
			_chartData.appendChild(periods);
			
			// saving out a file
			var f:FileReference = new FileReference;
			f.addEventListener(Event.COMPLETE, onFileSaved);
			f.save( _chartData, "line-charta.xml" );
		}
		
		private function getMax($arr:Array):Number
		{
			var max:Number = 0;
			var countOut:int = 0;
			var countIn:int = 0;
			
			for (var i:int = 0; i < $arr.length * $arr[0].length; i++)
			{
				countIn = i % $arr[0].length; 
				
				if ($arr[countOut][countIn][1] > max) max = $arr[countOut][countIn][1];
				
				if (countIn == $arr[0].length - 1)
				{
					countOut++; 
				}
				
			}
			
			return Math.round(max + 30 * max / 100);
		}
		
		private function onFileSaved($e:Event):void 
		{
			var target:FileReference = $e.target as FileReference;
			target.removeEventListener(Event.COMPLETE, onFileSaved);
			
			dispatchEvent(new Event(EVENT_DATA_LOADED));
		}
		
	}

}
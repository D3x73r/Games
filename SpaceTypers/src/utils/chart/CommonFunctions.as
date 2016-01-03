package utils.chart
{
	
	/**
	 * ...
	 * @author Hristo Dimitrov F43841
	 */
	
	//import classes used in the common functions
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	
	public class CommonFunctions
	{
		
		public function CommonFunctions()
		{
		
		}
		
		//function to fill a textfield
		public static function fillText(tf:TextField, tt:String, tm:TextFormat, tw:Number = 100, bM:Boolean = false, bAutoSize:Boolean = true, align:String = "left"):void
		{
			tf.selectable = false;
			if (bM)
			{
				tf.wordWrap = true;
				tf.multiline = true;
			}
			
			tf.width = tw;
			tf.text = tt;
			
			tf.antiAliasType = "advanced";
			switch (align)
			{
				case "center": 
					tm.align = TextFormatAlign.CENTER;
					break;
				case "right": 
					tm.align = TextFormatAlign.RIGHT;
					break;
				default: 
					tm.align = TextFormatAlign.LEFT;
					break;
			}
			tf.setTextFormat(tm);
			
			switch (align)
			{
				case "center": 
					tf.autoSize = TextFieldAutoSize.CENTER;
					break;
				case "right": 
					tf.autoSize = TextFieldAutoSize.RIGHT;
					break;
				default: 
					tf.autoSize = TextFieldAutoSize.LEFT;
					break;
			}
		}
		
		//function to calculate the sum of an array
		public static function sumArray(ar:Array):Number
		{
			var sum:Number = 0;
			var a:uint = 0;
			while (a < ar.length)
			{
				sum += ar[a];
				a++;
			}
			return sum;
		}
		
		//function to calculate the average of an array
		public static function avgArray(ar:Array):Number
		{
			var avg:Number = sumArray(ar) / ar.length;
			return avg;
		}
	}

}
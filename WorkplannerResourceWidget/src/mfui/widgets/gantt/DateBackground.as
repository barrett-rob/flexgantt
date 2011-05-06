package mfui.widgets.gantt
{
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	public class DateBackground extends UIComponent
	{
		
		private const WEEKEND_COLOUR:Number = 0xaaaaee;
		
		public function DateBackground()
		{
			super();
		}
		
		public function set date(d:Date):void
		{
			if (d.getDay() == 0 /* sunday */) 
			{
				paintSunday(d);
			}
			else if (d.getDay() == 6 /* saturday */)
			{
				paintSaturday(d);
			}
			else 
			{
				paintDefault(d);
			}
		}
		
		private function paintSunday(d:Date):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xff0000);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(this.width, this.height);
			this.graphics.beginGradientFill(GradientType.LINEAR, [ WEEKEND_COLOUR, WEEKEND_COLOUR ], [ 0.45, 0.8], [ 0, 255 ], matrix, SpreadMethod.PAD);
			this.graphics.drawRect(0, 0, this.width, this.height);
			
			paintLabel(d);
		}
		
		private function paintSaturday(d:Date):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xff0000);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(this.width, this.height);
			this.graphics.beginGradientFill(GradientType.LINEAR, [ WEEKEND_COLOUR , WEEKEND_COLOUR ], [ 0.1, 0.45], [ 0, 255 ], matrix, SpreadMethod.PAD);
			this.graphics.drawRect(0, 0, this.width, this.height);
			
			paintLabel(d);
		}
		
		private function paintDefault(d:Date):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(0.25, 0, 0.25);
			this.graphics.lineTo(0, this.height);
			
			paintLabel(d);
		}
		
		private function paintLabel(d:Date):void
		{
			var label:Label = new Label();
			label.setStyle("fontFamily", "Helvetica, _sans");
			label.setStyle("fontSize", "10px");
			label.alpha = 0.33;
			label.text = d.toLocaleDateString();
			label.x = this.x + 12;
			label.y = 10;
			label.rotation = 90;
		}
	}
}
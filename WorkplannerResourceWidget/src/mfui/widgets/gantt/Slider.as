package mfui.widgets.gantt
{
	
	import spark.components.Button;
	import spark.effects.Move;
	
	public class Slider extends Button
	{
		
		private var _item:XML;
		public var start:Date;
		public var finish:Date;
		
		public function Slider()
		{
			super();
			this.height = 18;
			this.width = 20;
		}        
		
		public function set item(item:XML):void
		{
			this._item = item;
			this.start = new Date(Date.parse(item.start));
			this.finish = new Date(Date.parse(item.finish));
			toolTip = getToolTip(item);
		}
		
		private function getToolTip(item:XML):String
		{
			return "Work order: " + item.workOrder 
				+ "\nTask: " + item.workOrderTaskNo
				+ "\nStart: " + this.start
				+ "\nFinish: " + this.finish;
		}
	}
}
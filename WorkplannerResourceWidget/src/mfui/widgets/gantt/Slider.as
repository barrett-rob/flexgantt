package mfui.widgets.gantt
{
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import spark.components.Button;
	import spark.effects.Move;
	
	public class Slider extends Button
	{
		
		private var _item:XML;
		public var start:Date;
		public var finish:Date;
		
		private var isMouseDown:Boolean = false;
		private var moveRelativeTo:Point;
		
		public function Slider()
		{
			super();
			this.height = 18;
			this.width = 20;
			this.setStyle("skinClass", SliderSkin);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, mousedown);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseup);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mousemove);
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
			return "Work Order: " + item.workOrder 
				+ "\nTask: " + item.workOrderTaskNo
				+ "\nStart: " + this.start
				+ "\nFinish: " + this.finish;
		}
		
		private function mousedown(event:MouseEvent):void
		{
			if (event.target == this)
			{
				this.isMouseDown = true;
				this.moveRelativeTo = localToGlobal(new Point(event.localX, event.localY));
			}
		}
		
		private function mouseup(event:MouseEvent):void
		{
			if (event.target == this)
			{
				this.isMouseDown = false;
				this.moveRelativeTo = null;
			}
		}
		
		private function mousemove(event:MouseEvent):void
		{
			if (!isMouseDown)
				return;
			var mouseAt:Point = localToGlobal(new Point(event.localX, event.localY));
			var delta:int = mouseAt.x - moveRelativeTo.x;
			this.x += delta;
			this.moveRelativeTo = mouseAt;
		}
	}
}
package mfui.widgets.gantt
{
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.mx_internal;
	
	import spark.components.Button;
	import spark.effects.Move;
	
	public class Slider extends Button
	{
		
		private var _item:XML;
		private var _start:Date;
		private var _finish:Date;
		
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
		}
		
		public function get item():XML
		{
			return this._item;
		}
		
		public function set start(d:Date):void
		{
			this._item.start = d.toString();
			setupToolTip();
		}
		
		public function get start():Date
		{
			return this._item == null ? null : new Date(Date.parse(this._item.start));		
		}
		
		public function set finish(d:Date):void
		{
			this._item.finish = d.toString();
			setupToolTip();
		}
		
		public function get finish():Date
		{
			return this._item == null ? null : new Date(Date.parse(this._item.finish)); 
		}
		
		private function setupToolTip():void
		{
			this.toolTip = "Work Order: " + _item.workOrder 
				+ "\nTask: " + _item.workOrderTaskNo
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
				this.dispatchEvent(new SliderEvent(SliderEvent.MOVE, this));
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
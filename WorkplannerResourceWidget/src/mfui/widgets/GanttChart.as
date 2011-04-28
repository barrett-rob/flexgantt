package mfui.widgets
{
	import flash.display.Sprite;
	
	import mfui.widgets.gantt.Slider;
	
	import mx.collections.GroupingCollection2;
	import mx.collections.IViewCursor;
	import mx.containers.Canvas;
	import mx.containers.HDividedBox;
	import mx.containers.VDividedBox;
	import mx.controls.AdvancedDataGrid;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;

	public class GanttChart extends Canvas
	{
		
		private var _ganttData:GanttData;
		private var _rowHeight:Number;
		
		public function GanttChart()
		{
		}
		
		internal function set ganttData(ganttData:GanttData):void
		{
			this._ganttData = ganttData;
			this._rowHeight = this._ganttData.rowHeight;
		}
		
		internal function paintRows():void
		{
			this.removeAllChildren();
			
			paintScaleLinesAndLabels();
			
			var i:int = 0;
			var cursor:IViewCursor = this._ganttData.dataProvider.createCursor();
			while (!cursor.afterLast)
			{
				paintRow(i++, cursor.current);
				cursor.moveNext();
			}
			/* TODO: only paint visible rows */
		}
		
		internal function paintScaleLinesAndLabels():void
		{
			paintRowLines();
			
			var first:Date;
			var last:Date;

			/* iterate through data, get min start and max finish */
			for each (var workItem:XML in this._ganttData.rawData) 
			{
				var start:Date = new Date(Date.parse(workItem.start));
				if (!first || start.getTime() < first.getTime())
				{
					first = start;
				}
				var finish:Date = new Date(Date.parse(workItem.finish));
				if (!last || finish.getTime() > last.getTime())
				{
					last = finish;
				}
			}
			trace('first:', first);
			trace('last:', last);
		}
		
		private function paintRowLines():void
		{
			var i:int = 0;
			var cursor:IViewCursor = this._ganttData.dataProvider.createCursor();
			while (!cursor.afterLast)
			{
				var line:UIComponent = new UIComponent();
				line.x = 0;
				line.y = getRowY(i++);
				line.graphics.lineStyle(0.25, 0, 0.25);
				line.graphics.lineTo(this.width - 10, 0);
				this.addChild(line);
				cursor.moveNext();
			}
		}
		
		private function getRowY(i:int):Number
		{
			return ((this._rowHeight + /* padding */ 4) * (i + 1)) + this._ganttData.headerHeight;
		}
		
		private function paintRow(i:int, item:Object):void
		{
			if (item is XML)
			{
				paintDetailRow(i, XML(item));
			}
			else
			{
				paintSummaryRow(i, item);
			}
		}
		
		private function paintDetailRow(i:int, item:XML):void
		{
			var slider:Slider = new Slider();
			slider.y = getRowY(i);
			slider.x = 100;
			// this.addElement(slider);
		}
		
		private function paintSummaryRow(i:int, item:Object):void
		{
		}
	}
}
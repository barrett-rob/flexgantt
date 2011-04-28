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
	import mx.events.ResizeEvent;

	public class GanttChart extends Canvas
	{
		
		private const MS_PER_DAY:Number = 1000 * 60 * 60 * 24;
		
		private var _ganttData:GanttData;
		private var _rowHeight:Number;
		private var _first:Date;
		private var _last:Date;
		
		public function GanttChart()
		{
			this.addEventListener(ResizeEvent.RESIZE, resize);
		}
		
		internal function set ganttData(ganttData:GanttData):void
		{
			this._ganttData = ganttData;
			this._rowHeight = this._ganttData.rowHeight;
		}
		
		private function resize(event:ResizeEvent):void
		{
			paintChart();
		}
		
		internal function paintChart():void
		{
			
			if (!this._ganttData || !this._ganttData.dataProvider || !this._ganttData.rawData)
				return; /* no data yet */
			
			this.removeAllChildren();
			paintLinesAndLabels();
			var i:int = 0;
			var cursor:IViewCursor = this._ganttData.dataProvider.createCursor();
			while (!cursor.afterLast)
			{
				paintRow(i++, cursor.current);
				cursor.moveNext();
			}
		}
		
		private function paintLinesAndLabels():void
		{
			paintHorizontalLines();
			paintScaleLines();
		}
		
		private function paintHorizontalLines():void
		{
			var i:int = 0;
			var cursor:IViewCursor = this._ganttData.dataProvider.createCursor();
			while (!cursor.afterLast)
			{
				paintHorizontalLine(i++);
				cursor.moveNext();
			}
		}
		
		private function paintHorizontalLine(i:int):void
		{
			var line:UIComponent = new UIComponent();
			line.x = 0;
			line.y = getRowY(i);
			line.graphics.lineStyle(0.25, 0, 0.25);
			line.graphics.lineTo(this.width - 10, 0);
			this.addChild(line);
		}
		
		private function paintScaleLines():void
		{
			if (!this._first || !this._last)
				getScaleFromData();

			var msdiff:Number = this._last.getTime() - this._first.getTime();
			var days:int = Math.round(msdiff / MS_PER_DAY) + 1;
			
			var pxstart:int = 15;
			var pxfinish:int = this.width - 15;
			var pxoffset:Number = (pxfinish - pxstart) / days;
			var pxindex:int = pxstart;
			
			var d:Date = new Date(this._first.getTime());
			while (d.getTime() < this._last.getTime() + MS_PER_DAY)
			{
				d = new Date(d.getTime() + MS_PER_DAY);
				paintScaleLine(pxindex, d);
				pxindex = pxindex + pxoffset;
			}
		}
		
		private function paintScaleLine(x:int, d:Date):void
		{
			var line:UIComponent = new UIComponent();
			line.x = x;
			line.y = this._ganttData.headerHeight + 5;
			line.graphics.lineStyle(0.25, 0, 0.25);
			line.graphics.lineTo(0, this.height);
			this.addChild(line);
		}
		
		private function getScaleFromData():void
		{
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
			setScale(first, last);
		}
		
		private function setScale(first:Date, last:Date):void
		{
			this._first = first;
			this._last = last;
		}
		
		private function getRowY(i:int):Number
		{
			return ((this._rowHeight + /* padding */ 4) * (i + 1)) + this._ganttData.headerHeight;
		}
		
		private function paintRow(i:int, item:Object):void
		{
			/* TODO: only paint visible rows */
			if (item is XML)
			{
				paintDetailRow(i, XML(item));
			}
			else
			{
				paintGroupingRow(i, item);
			}
		}
		
		private function paintDetailRow(i:int, item:XML):void
		{
			var slider:Slider = new Slider();
			slider.y = getRowY(i);
			slider.x = 100;
			// this.addElement(slider);
		}
		
		private function paintGroupingRow(i:int, item:Object):void
		{
		}
	}
}
package mfui.widgets
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.FontWeight;
	
	import mfui.widgets.gantt.DateBackground;
	import mfui.widgets.gantt.Slider;
	import mfui.widgets.gantt.SliderEvent;
	
	import mx.collections.GroupingCollection2;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.containers.Canvas;
	import mx.containers.HDividedBox;
	import mx.containers.VDividedBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Label;
	import spark.effects.Move;
	import spark.effects.Resize;

	public class GanttChart extends Canvas
	{
		
		private const MS_PER_DAY:Number = 1000 * 60 * 60 * 24;
		private const HORIZONTAL_PADDING:Number = 10;
		private const VERTICAL_PADDING:Number = 40;
		private const ZOOM_FACTOR:Number = 1.5;
		private const ROW_PADDING:int = 3;
		
		private var _ganttData:GanttData;
		private var _scaledWidth:Number;
		private var _first:Date;
		private var _last:Date;
		
		public function GanttChart()
		{
			this.addEventListener(ResizeEvent.RESIZE, resize);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, mousewheel);
			this.addEventListener(SliderEvent.MOVE, slidermove);
		}
		
		internal function set ganttData(ganttData:GanttData):void
		{
			this._ganttData = ganttData;
		}
		
		private function resize(event:ResizeEvent):void
		{
			paintChart();
		}
		
		internal function paintChart():void
		{
			
			if (!this._scaledWidth || this._scaledWidth < 1)
				this._scaledWidth = this.width;
			
			paintBorder();
			
			if (!this._ganttData || !this._ganttData.dataProvider || !this._ganttData.rawData)
				return; /* no data yet */
			
			this.removeAllChildren();
			paintLinesAndLabels();
			paintRows();
		}
		
		private function paintBorder():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(0.5, 0, 0.5);
			this.graphics.drawRect(HORIZONTAL_PADDING, VERTICAL_PADDING, this._scaledWidth - (HORIZONTAL_PADDING * 2), this.height - (VERTICAL_PADDING * 2));
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
				if (cursor.current is XML)
				{
					paintHorizontalLine(i);
				}
				i++
				cursor.moveNext();
			}
		}
		
		private function paintHorizontalLine(i:int):void
		{
			var xx:int = HORIZONTAL_PADDING;
			var yy:int = getYForRow(i);
			if (yy < 0)
			{
				return;
			}
			yy += (this._ganttData.rowHeight / 2)
			this.graphics.lineStyle(0.25, 0, 0.25);
			this.graphics.moveTo(xx, yy);
			this.graphics.lineTo(this._scaledWidth - HORIZONTAL_PADDING, yy);
		}
		
		private function getYForRow(i:int):Number
		{
			var renderer:IListItemRenderer = this._ganttData.indexToItemRenderer(i);
			if (!renderer) {
				/* only paint visible rows */
				return -1;
			}
			var p:Point = this._ganttData.localToGlobal(new Point(0, renderer.y));
			return this.globalToLocal(p).y;
		}
		

		
		private function paintScaleLines():void
		{
			if (!this._first || !this._last)
				getScaleFromData();

			var d:Date = new Date(this._first.getTime());
			while (d.getTime() < this._last.getTime() + MS_PER_DAY)
			{
				dateBackgrounds(getXForDate(d), d);
				d = new Date(d.getTime() + MS_PER_DAY);
			}
		}
		
		private function getXForDate(d:Date):int
		{
			var pxstart:int = HORIZONTAL_PADDING;
			var pxfinish:int = this._scaledWidth - HORIZONTAL_PADDING;
			var pxdiff:int = pxfinish - pxstart;
			
			var msdiff:Number = this._last.getTime() - this._first.getTime();
			var factor:Number = pxdiff / msdiff;
			var x:int = ((d.getTime() - this._first.getTime()) * factor) + HORIZONTAL_PADDING;
			return x;
		}
		
		private function dateBackgrounds(xoffset:int, d:Date):void
		{
			var yoffset:int = VERTICAL_PADDING + 1;
			var dateBackground:DateBackground = new DateBackground();
			dateBackground.x = xoffset;
			dateBackground.y = yoffset;
			dateBackground.width = getXForDate(new Date(d.getTime() + MS_PER_DAY)) - xoffset;
			dateBackground.height = this.height - (yoffset * 2);
			dateBackground.date = d;
			this.addChild(dateBackground);
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
			
			/* start a week before earliest date */
			first = new Date(new Date(first.getFullYear(), first.getMonth(), first.getDate()).getTime() - (7 * MS_PER_DAY));
			
			/* end a week after last date*/
			last = new Date(new Date(last.getFullYear(), last.getMonth(), last.getDate()).getTime() + (7 * MS_PER_DAY));
			
			setScale(first, last);
		}
		
		private function setScale(first:Date, last:Date):void
		{
			this._first = first;
			this._last = last;
		}
		
		private function paintRows():void
		{
			var i:int = 0;
			var cursor:IViewCursor = this._ganttData.dataProvider.createCursor();
			while (!cursor.afterLast)
			{
				paintRow(i++, cursor.current);
				cursor.moveNext();
			}
		}
		
		private function paintRow(i:int, item:Object):void
		{
			/* TODO: only paint visible rows */
			if (item is XML)
			{
				paintSlider(i, XML(item));
			}
			else
			{
				paintGroupingRow(i, item);
			}
		}
		
		private function paintSlider(i:int, item:XML):void
		{
			var yy:int = getYForRow(i);
			if (yy < 0)
			{
				return;
			}
			var slider:Slider = new Slider();
			slider.y = yy + 2;
			slider.item = item;
			this.addElement(slider);
			
			var xTo:int = getXForDate(slider.start); 
			
			var m:Move;
			m = new Move(slider);
			m.xBy = m.yBy = 1;
			m.xFrom = slider.x;
			m.xTo = xTo;
			m.play();
			
			var r:Resize = new Resize(slider);
			r.widthFrom = slider.width;
			r.widthTo = getXForDate(slider.finish) - xTo;
			r.play();
		}
		
		private function paintGroupingRow(i:int, item:Object):void
		{
		}
		
		private function mousewheel(event:MouseEvent):void
		{
			if (event.target != this)
				return;
			
			var xoffset:Number = this.horizontalScrollPosition + event.localX;
			
			if (event.delta > 0)
			{
				this._scaledWidth = this._scaledWidth * ZOOM_FACTOR;
				this.horizontalScrollPosition = (xoffset * ZOOM_FACTOR) - event.localX;
				paintChart();
			} 
			else if (event.delta < 0)
			{
				this._scaledWidth = this._scaledWidth / ZOOM_FACTOR;
				this.horizontalScrollPosition = (xoffset / ZOOM_FACTOR) - event.localX;
				paintChart();
			}
		}
		
		private function getDateForX(x:int):Date
		{
			var pxstart:int = HORIZONTAL_PADDING;
			var pxfinish:int = this._scaledWidth - HORIZONTAL_PADDING;
			var pxdiff:int = pxfinish - pxstart;
			var factor:Number = x / pxdiff;
			
			var msdiff:Number = this._last.getTime() - this._first.getTime();
			var d:Date = new Date((msdiff * factor) + this._first.getTime());
			return d;
		}
		
		private function slidermove(event:SliderEvent):void
		{
			var slider:Slider = event.slider;
			var start:Date = getDateForX(slider.x);
			var finish:Date = getDateForX(slider.x + slider.width);
			slider.start = start;
			slider.finish = finish;
			
			if (!this._ganttData.dataProvider)
				return;
			
			var dataProvider:ICollectionView = ICollectionView(this._ganttData.dataProvider);
			dataProvider.refresh();
		}
		
	}
}
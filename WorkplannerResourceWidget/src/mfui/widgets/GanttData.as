package mfui.widgets
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.Grouping;
	import mx.collections.GroupingCollection2;
	import mx.collections.GroupingField;
	import mx.collections.IViewCursor;
	import mx.collections.XMLListCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.core.ScrollPolicy;
	import mx.events.AdvancedDataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.ScrollEvent;
	import mx.messaging.channels.HTTPChannel;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class GanttData extends AdvancedDataGrid
	{
		
		private var rawData:XMLList;
		private var dataColumns:Array;
		
		public function GanttData()
		{
			super();
			
			this.verticalScrollPolicy = this.horizontalScrollPolicy = ScrollPolicy.ON;
			
			var workOrderCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			workOrderCol.minWidth = 110;
			workOrderCol.headerText = "Work Order";
			workOrderCol.dataField = "workOrder";

			var workOrderTaskNoCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			workOrderTaskNoCol.minWidth = 40;
			workOrderTaskNoCol.headerText = "Task";
			workOrderTaskNoCol.dataField = "workOrderTaskNo";

			var descriptionCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			descriptionCol.minWidth = 300;
			descriptionCol.headerText = "Description";
			descriptionCol.dataField = "description";
			
			var startCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			startCol.minWidth = 210;
			startCol.headerText = "Start";
			startCol.dataField = "start";
			
			var finishCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			finishCol.minWidth = 210;
			finishCol.headerText = "Finish";
			finishCol.dataField = "finish";
			
			this.dataColumns = [ 
				workOrderCol, 
				workOrderTaskNoCol, 
				descriptionCol, 
				startCol, 
				finishCol  
			];
			
			this.groupedColumns = dataColumns;
			this.lockedColumnCount = dataColumns.length;
			
			addEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);
			addEventListener(ListEvent.ITEM_CLICK, click);
			addEventListener(AdvancedDataGridEvent.ITEM_OPEN, open);
			addEventListener(AdvancedDataGridEvent.ITEM_CLOSE, close);
		}
		
		private function creationComplete(event:FlexEvent):void
		{
			getData();
		}
		
		private function click(event:ListEvent):void
		{
			trace(event);
		}
		
		private function open(event:AdvancedDataGridEvent):void
		{
			trace(event);
		}
		
		private function close(event:AdvancedDataGridEvent):void
		{
			trace(event);
		}
		
		private function getData():void
		{
			var service:HTTPService = new HTTPService();
			service.url = "jobList.xml";
			service.resultFormat = "e4x";
			service.addEventListener(ResultEvent.RESULT, result);
			service.send();
		}
		
		private function result(event:ResultEvent):void
		{
			var xml:XML = XML(event.result);
			dataProvider = xml;
		}
		
		public override function set dataProvider(value:Object):void
		{
			/* TODO: more grouping levels */
			
			rawData = XML(value).elements('workItem');
			var groupingCollection:GroupingCollection2 = new GroupingCollection2();
			var groupingField:GroupingField = new GroupingField("workOrder");
			var grouping:Grouping = new Grouping();
			grouping.fields = [groupingField];
			groupingCollection.grouping = grouping;
			groupingCollection.source = rawData
			
			groupingCollection.refresh(/* important */);
			
			super.dataProvider = groupingCollection;
			
			setupDateColumns();
		}
		
		private function setupDateColumns():void
		{
			if (!rawData)
				return;
			
			var first:Date;
			var last:Date;
			
			/* iterate through data, get min start and max finish */
			for each (var workItem:XML in rawData) 
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
			
			/* set up columns accordingly */
			setupDateColumnsOver(first, last)
		}
		
		private function setupDateColumnsOver(first:Date, last:Date):void
		{
			var MS_PER_DAY:Number = 1000 * 60 * 60 * 24;
			var range:Number = Math.round((last.getTime() - first.getTime()) / MS_PER_DAY) + 1;
			trace('day range:', range);
			
			var cols:Array = this.dataColumns;
			var c:AdvancedDataGridColumn;
			var widths:Dictionary = new Dictionary();
			for each (c in dataColumns)
			{
				widths[c] = Math.min(c.width, c.minWidth);
			}
		
			var d:Date = new Date(first.getTime() - MS_PER_DAY);
			
			while (d.getTime() < last.getTime() + MS_PER_DAY)
			{
				c = new AdvancedDataGridColumn();
				c.headerText = d.toLocaleDateString();
				c.sortable = false;
				c.width = 50;
				cols.push(c);
				d = new Date(d.getTime() + MS_PER_DAY);
			}
			
			/* add one blank one */
			
			c = new AdvancedDataGridColumn();
			c.sortable = false;
			cols.push(c);
			
			this.groupedColumns = cols;
			//this.lockedColumnCount = dataColumns.length;
			
			this.validateNow();
			
			for each (c in this.columns)
			{
				if (widths[c])
				{
					c.width = widths[c];
				}
			}
			
		}
		
	}
}
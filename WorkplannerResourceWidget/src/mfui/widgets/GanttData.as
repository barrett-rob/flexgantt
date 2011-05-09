package mfui.widgets
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mfui.widgets.gantt.SliderEvent;
	
	import mx.collections.Grouping;
	import mx.collections.GroupingCollection2;
	import mx.collections.GroupingField;
	import mx.collections.IViewCursor;
	import mx.collections.XMLListCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.DateField;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.core.ScrollPolicy;
	import mx.events.AdvancedDataGridEvent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.ScrollEvent;
	import mx.messaging.channels.HTTPChannel;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class GanttData extends AdvancedDataGrid
	{
		
		private var dataColumns:Array;
		internal var rawData:XMLList;
		internal var ganttChart:GanttChart;
		
		public function GanttData()
		{
			super();
			
			this.verticalScrollPolicy = this.horizontalScrollPolicy = ScrollPolicy.ON;
			this.variableRowHeight = false;
			this.headerHeight = 40;
			this.editable = "true";
			
			var workOrderCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			workOrderCol.editable = false;
			workOrderCol.minWidth = 110;
			workOrderCol.headerText = "Work Order";
			workOrderCol.dataField = "workOrder";

			var workOrderTaskNoCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			workOrderTaskNoCol.editable = false;
			workOrderTaskNoCol.minWidth = 40;
			workOrderTaskNoCol.headerText = "Task";
			workOrderTaskNoCol.dataField = "workOrderTaskNo";

			var descriptionCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			descriptionCol.editable = false;
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
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);
			this.addEventListener(ListEvent.ITEM_CLICK, click);
			this.addEventListener(AdvancedDataGridEvent.ITEM_OPEN, open);
			this.addEventListener(AdvancedDataGridEvent.ITEM_CLOSE, close);
			this.addEventListener(AdvancedDataGridEvent.SORT, sort);
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
			this.ganttChart.paintChart();
		}
		
		private function close(event:AdvancedDataGridEvent):void
		{
			this.ganttChart.paintChart();
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
			
			groupingCollection.refresh(true);
			
			super.dataProvider = groupingCollection;
		}
		
		private function sort(event:AdvancedDataGridEvent):void
		{
			this.ganttChart.paintChart();
		}
	}
}
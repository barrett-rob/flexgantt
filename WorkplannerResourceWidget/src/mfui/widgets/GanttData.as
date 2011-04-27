package mfui.widgets
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.Grouping;
	import mx.collections.GroupingCollection2;
	import mx.collections.GroupingField;
	import mx.collections.XMLListCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.core.ScrollPolicy;
	import mx.events.AdvancedDataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.events.ScrollEvent;
	
	public class GanttData extends AdvancedDataGrid
	{
		
		public function GanttData()
		{
			super();
			
			this.verticalScrollPolicy = ScrollPolicy.ON;
			
			var workOrderCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			workOrderCol.width = 10;
			workOrderCol.headerText = "Work Order";
			workOrderCol.dataField = "workOrder";

			var workOrderTaskNoCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			workOrderTaskNoCol.width = 4;
			workOrderTaskNoCol.headerText = "Task";
			workOrderTaskNoCol.dataField = "workOrderTaskNo";

			var descriptionCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			descriptionCol.width = 30;
			descriptionCol.headerText = "Description";
			descriptionCol.dataField = "description";
			
			var startCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			startCol.width = 20;
			startCol.headerText = "Start";
			startCol.dataField = "start";
			
			var finishCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			finishCol.width = 20;
			finishCol.headerText = "Finish";
			finishCol.dataField = "finish";
			
			this.columns = [ 
				workOrderCol, 
				workOrderTaskNoCol, 
				descriptionCol, 
				startCol, 
				finishCol  
			];
			
			addEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);
			addEventListener(ListEvent.ITEM_CLICK, click);
			addEventListener(AdvancedDataGridEvent.ITEM_OPEN, open);
			addEventListener(AdvancedDataGridEvent.ITEM_CLOSE, close);
		}
		
		
		public override function set dataProvider(value:Object):void
		{
			/* TODO: more grouping levels */
			
			var data:XMLList = XML(value).elements('workItem');
			var groupingCollection:GroupingCollection2 = new GroupingCollection2();
			var groupingField:GroupingField = new GroupingField("workOrder");
			var grouping:Grouping = new Grouping();
			grouping.fields = [groupingField];
			groupingCollection.grouping = grouping;
			groupingCollection.source = data
			groupingCollection.refresh();
			
			super.dataProvider = groupingCollection;
			
		}
		
		private function creationComplete(event:FlexEvent):void
		{
			trace(event);
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
		
	}
}
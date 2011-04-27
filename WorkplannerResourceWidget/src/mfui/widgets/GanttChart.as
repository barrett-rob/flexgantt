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
	
	public class GanttChart extends AdvancedDataGrid
	{
		
		internal var ganttData:GanttData;
		
		public function GanttChart()
		{
			super();
			
			this.verticalScrollPolicy = ScrollPolicy.ON;
			
			var startCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			startCol.width = 20;
			startCol.headerText = "Start";
			startCol.dataField = "start";
			
			var finishCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			finishCol.width = 20;
			finishCol.headerText = "Finish";
			finishCol.dataField = "finish";
			
			this.columns = [ 
				startCol, 
				finishCol  
			];
			
			addEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);
			addEventListener(ListEvent.ITEM_CLICK, click);
			addEventListener(AdvancedDataGridEvent.ITEM_OPEN, open);
			addEventListener(AdvancedDataGridEvent.ITEM_CLOSE, close);
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
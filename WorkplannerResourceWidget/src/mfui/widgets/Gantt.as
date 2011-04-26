package mfui.widgets
{
	import mx.controls.AdvancedDataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	
	public class Gantt extends AdvancedDataGrid
	{
		public function Gantt()
		{
			super();
			
			var workOrderCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			workOrderCol.headerText = "Work Order";
			workOrderCol.dataField = "workOrder";
			var workOrderTaskNoCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			workOrderTaskNoCol.headerText = "Task";
			workOrderTaskNoCol.dataField = "workOrderTaskNo";
			var descriptionCol:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			descriptionCol.headerText = "Description";
			descriptionCol.dataField = "description";

			this.columns = [ workOrderCol, workOrderTaskNoCol, descriptionCol ];
		}
		
		
		public override function set dataProvider(value:Object):void
		{
			super.dataProvider = value;
		}
	}
}
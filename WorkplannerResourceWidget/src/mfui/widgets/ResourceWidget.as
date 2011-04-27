package mfui.widgets
{
	import mx.controls.AdvancedDataGrid;
	import mx.core.UIComponent;
	
	import spark.components.BorderContainer;

	public class ResourceWidget extends BorderContainer
	{
		
		private var ganttData:GanttData;
		
		public function ResourceWidget()
		{
			this.percentHeight = this.percentWidth = 100;
			this.setStyle("backgroundColor", 0xffdddd);
			
			this.ganttData = new GanttData();
			this.addElement(ganttData);
			this.ganttData.percentHeight = 90;
			this.ganttData.percentWidth = 100;
			this.validateNow();
		}
		
		
		public function set dataProvider(value:Object):void
		{
			this.ganttData.dataProvider = value;
		}
		

	}
}
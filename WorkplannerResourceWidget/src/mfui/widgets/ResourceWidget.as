package mfui.widgets
{
	import mx.containers.HDividedBox;
	import mx.containers.VDividedBox;
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
			
			var vDividedBox:VDividedBox = new VDividedBox();
			vDividedBox.percentHeight = 90;
			vDividedBox.percentWidth = 100;
			this.addElement(vDividedBox);
			
			this.ganttData = new GanttData();
			this.ganttData.percentHeight = this.ganttData.percentWidth = 100;
			vDividedBox.addElement(ganttData);
			
			this.validateNow();
		}
		
	}
}
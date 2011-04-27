package mfui.widgets
{
	import mx.containers.HDividedBox;
	import mx.controls.AdvancedDataGrid;
	import mx.core.UIComponent;
	
	import spark.components.BorderContainer;

	public class ResourceWidget extends BorderContainer
	{
		
		private var ganttData:GanttData;
		private var ganttChart:GanttChart;
		
		public function ResourceWidget()
		{
			this.percentHeight = this.percentWidth = 100;
			this.setStyle("backgroundColor", 0xffdddd);
			
			var hDividedBox:HDividedBox = new HDividedBox();
			hDividedBox.percentHeight = 90;
			hDividedBox.percentWidth = 100;
			this.addElement(hDividedBox);
			
			this.ganttData = new GanttData();
			this.ganttData.percentHeight = this.ganttData.percentWidth = 100;
			hDividedBox.addElement(ganttData);
			
			this.ganttChart = new GanttChart();
			this.ganttChart.percentHeight = this.ganttChart.percentWidth = 100;
			hDividedBox.addElement(ganttChart);
			
			this.ganttData.ganttChart = this.ganttChart;
			this.ganttChart.ganttData = this.ganttData;
			
			this.validateNow();
		}
		
		
		public function set dataProvider(value:Object):void
		{
			this.ganttData.dataProvider = value;
		}
		

	}
}
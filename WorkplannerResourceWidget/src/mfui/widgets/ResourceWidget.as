package mfui.widgets
{
	import mx.containers.HDividedBox;
	import mx.containers.VDividedBox;
	import mx.controls.AdvancedDataGrid;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	
	import spark.components.BorderContainer;

	public class ResourceWidget extends BorderContainer
	{
		
		private var ganttData:GanttData;
		private var ganttChart:GanttChart
		
		public function ResourceWidget()
		{
			this.percentHeight = this.percentWidth = 100;
			
			var vDividedBox:VDividedBox = new VDividedBox();
			vDividedBox.verticalScrollPolicy = vDividedBox.horizontalScrollPolicy = ScrollPolicy.OFF;
			vDividedBox.percentHeight = 90;
			vDividedBox.percentWidth = 100;
			
			var hDividedBox:HDividedBox = new HDividedBox();
			hDividedBox.verticalScrollPolicy = hDividedBox.horizontalScrollPolicy = ScrollPolicy.OFF;
			hDividedBox.percentHeight = hDividedBox.percentWidth = 100;
			
			this.ganttData = new GanttData();
			this.ganttData.percentHeight = this.ganttData.percentWidth = 100;
			hDividedBox.addElement(ganttData);
			
			this.ganttChart = new GanttChart();
			this.ganttChart.percentHeight = this.ganttChart.percentWidth = 100;
			this.ganttChart.ganttData = this.ganttData;
			this.ganttData.ganttChart = this.ganttChart;
			hDividedBox.addElement(ganttChart);
			
			vDividedBox.addElement(hDividedBox);
			this.addElement(vDividedBox);
			
			this.validateNow();
		}
		
	}
}
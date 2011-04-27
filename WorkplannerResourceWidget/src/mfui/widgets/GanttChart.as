package mfui.widgets
{
	import mx.containers.Canvas;
	import mx.containers.HDividedBox;
	import mx.containers.VDividedBox;
	import mx.controls.AdvancedDataGrid;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	
	import spark.components.BorderContainer;

	public class GanttChart extends Canvas
	{
		
		private var ganttData:GanttData;
		
		public function GanttChart()
		{
			this.setStyle("backgroundColor", 0xffdddd);
		}
		
	}
}
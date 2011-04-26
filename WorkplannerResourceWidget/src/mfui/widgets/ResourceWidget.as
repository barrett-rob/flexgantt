package mfui.widgets
{
	import mx.controls.AdvancedDataGrid;
	import mx.core.UIComponent;
	
	import spark.components.BorderContainer;

	public class ResourceWidget extends BorderContainer
	{
		
		private var gantt:Gantt;
		
		public function ResourceWidget()
		{
			this.percentHeight = this.percentWidth = 100;
			this.setStyle("backgroundColor", 0xffdddd);
			
			this.gantt = new Gantt();
			this.addElement(gantt);
			this.gantt.percentHeight = 90;
			this.gantt.percentWidth = 100;
			this.validateNow();
		}
		
		
		public function set dataProvider(value:Object):void
		{
			this.gantt.dataProvider = value;
		}

	}
}
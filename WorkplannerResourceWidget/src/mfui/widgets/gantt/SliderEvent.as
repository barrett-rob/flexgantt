package mfui.widgets.gantt
{
	import mx.events.FlexEvent;
	
	public class SliderEvent extends FlexEvent
	{
		public static const MOVE:String = "Slider.MOVE";
		
		public var slider:Slider; 
		
		public function SliderEvent(type:String, s:Slider)
		{
			super(type, true, false);
			this.slider = s;
		}
	}
}
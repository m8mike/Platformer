package com.touchmypixel.events 
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SyncEvent;
	
	public class ProcessEvent extends Event
	{
		public static const START = "Process.Start";
		public static const PROGRESS = "Process.Progress";
		public static const COMPLETE = "Process.Complete";
		
		public var percentage:Number = 0;
		
		public function ProcessEvent(type:String, percentage:Number=0, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			
			this.percentage = percentage;
			if (type == COMPLETE)
			{
				this.percentage = 1;
			}
			super(type, bubbles, cancelable);
		}	
	}
}
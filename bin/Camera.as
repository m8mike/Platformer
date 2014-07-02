package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class Camera extends Sprite
	{
		//private static const ZOOM_IN_AMT:Number = 7.5;//1.7//3.0//7.5true
		public var ZOOM_IN_AMT:Number;//1.7//3.0//7.5true
		public function Camera(zoom:Number) 
		{
			ZOOM_IN_AMT = zoom;
		}
		
		public function zoomTo(whatPoint:Point, zoomRatio:Number):void
		{
			this.scaleX = ZOOM_IN_AMT * zoomRatio;
			this.scaleY = ZOOM_IN_AMT * zoomRatio;
			this.x = (this.stage.stageWidth / 2) - (whatPoint.x * ZOOM_IN_AMT * zoomRatio);
			this.y = (this.stage.stageHeight / 2) - (whatPoint.y * ZOOM_IN_AMT * zoomRatio);
		}
	}
}
package  
{
	import Box2D.Dynamics.b2Body;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class Actor extends EventDispatcher
	{
		public var _body:b2Body;
		public var _costume:DisplayObject;
		
		public function Actor(myBody:b2Body, myCostume:DisplayObject) 
		{
			_body = myBody;
			_body.SetUserData(this);
			_costume = myCostume;
			
			updateMyLook();
		}
		
		public function updateNow():void
		{
			updateMyLook();
			childSpecificUpdating();
			
		}
		
		protected function childSpecificUpdating():void 
		{
			
		}
		
		//remove the actor from the world
		public function destroy():void
		{
			// Remove event listeners, misc cleanup
			cleanUpBeforeRemoving();
			
			// Remove the costume sprite from the display
			if (_costume) {
				_costume.parent.removeChild(_costume);
			}
			
			// Destroy the body
			PhysiVals.world.DestroyBody(_body);
			
		}
		
		protected function cleanUpBeforeRemoving():void 
		{
			// Will be called by children
		}
		
		public function getSpriteLoc():Point
		{
			return new Point(_costume.x, _costume.y);
		}
		
		private function updateMyLook():void 
		{
			if (_costume) {
				_costume.x = _body.GetPosition().x * PhysiVals.RATIO;
				_costume.y = _body.GetPosition().y * PhysiVals.RATIO;
				_costume.rotation = _body.GetAngle() * 180 / Math.PI;
			}
		}
	}
}
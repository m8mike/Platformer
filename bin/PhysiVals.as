package  
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class PhysiVals 
	{
		public static const RATIO:Number = 30;
		public static var fps:Number = 30.0;
		private static var _world:b2World;
		public static var gravity:b2Vec2 = new b2Vec2(0.0, 10);
		
		public function PhysiVals() 
		{
			
		}
		
		static public function get world():b2World 
		{
			return _world;
		}
		
		static public function set world(value:b2World):void 
		{
			_world = value;
		}
		
	}

}
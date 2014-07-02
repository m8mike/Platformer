package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class Cannon extends Sprite
	{
		private const CANNON_DIAMETER:Number = 50;
		private const BALL_OFFSET:Number = 300;
		private var _cannonAngle:Number;
		public static var _cannonBullets:Array;
		public static const SIMPLE = 0;
		public static const SHOTGUN = 1;//дробовик
		public static const STICKY = 2;//липучка
		private var _type:Number;
		
		public function Cannon(location:Point, typeOfCannon:Number = 0) 
		{
			Platformer.thereIsAGun = true;
			type = typeOfCannon;
			_cannonBullets = [];
			Platformer._camera.addChild(this);
			this.x = location.x;
			this.y = location.y;
			this.addEventListener(Event.ENTER_FRAME, cannonEventListener);
		}
		
		private function cannonEventListener(e:Event):void 
		{
			cannonAngle = 90 - Math.atan2(Platformer._ballActor.ballBody.GetWorldCenter().x * PhysiVals.RATIO - this.x,
										  Platformer._ballActor.ballBody.GetWorldCenter().y * PhysiVals.RATIO - this.y) * 180 / Math.PI;
			this.rotation = cannonAngle;
			if (Platformer.ShootCannon) {
				shootCannon();// Platformer._ballActor.ballBody.GetWorldCenter());
			}
		}
			
		public function shootCannon():void// location:b2Vec2):void 
		{
			var velocity: Point = new Point(BALL_OFFSET * 2 * Math.cos(this.rotation / 180 * Math.PI), 
											BALL_OFFSET * 2 * Math.sin(this.rotation / 180 * Math.PI));
			var bullet:Bullet;
			if (type != 1) {
				bullet = new Bullet(Platformer._camera, new Point(this.x, this.y), velocity, type);
				_cannonBullets.push(bullet);
			} else {
				for (var i:int = 0; i < 10; i++) {
					bullet = new Bullet(Platformer._camera, new Point(this.x + i, this.y), velocity, type);
					_cannonBullets.push(bullet);
				}
			}
		}
		
		public function get cannonAngle():Number 
		{
			return _cannonAngle;
		}
		
		public function set cannonAngle(value:Number):void 
		{
			_cannonAngle = value;
		}
		
		public function get type():Number 
		{
			return _type;
		}
		
		public function set type(value:Number):void 
		{
			_type = value;
		}
		
	}

}
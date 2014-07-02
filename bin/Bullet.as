package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Common.Math.b2Vec2;
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
	public class Bullet extends Actor
	{
		public static var _bulletsNumber:Number = 0;
		private var BULLET_DIAMETER:Number = 10;
		private var bulletSprite:Sprite;
		private var bulletBody:b2Body;
		public var numbOfThisBullet:int;
		private var _type:Number;
		public static const SIMPLE = 0;
		public static const SHOTGUN = 1;
		public static const STICKY = 2;
		
		public function Bullet(parent:DisplayObjectContainer, location:Point, initVel:Point, typeOfBullet:Number = 0) 
		{
			try {
				type = typeOfBullet;
				if (type == 1) {
					BULLET_DIAMETER = 7;
				}
				numbOfThisBullet = _bulletsNumber++;
				//create costume
				var color:uint = Math.random() * 0xFFFFFF;
				//bulletSprite = new BulletSprite();
				bulletSprite = new Sprite();
				bulletSprite.graphics.beginFill(color);
				bulletSprite.graphics.drawCircle(0, 0, BULLET_DIAMETER / 2);
				bulletSprite.graphics.endFill();
				bulletSprite.x = location.x;
				bulletSprite.y = location.y;
				
				bulletSprite.scaleX = BULLET_DIAMETER / bulletSprite.width;
				bulletSprite.scaleY = BULLET_DIAMETER / bulletSprite.height;
				parent.addChildAt(bulletSprite, 0);
				
				//shape def
				var bulletShapeDef:b2CircleDef = new b2CircleDef();
				bulletShapeDef.radius = BULLET_DIAMETER / 2 / PhysiVals.RATIO;
				
				bulletShapeDef.density = 0.1;
				if (type == STICKY){
					bulletShapeDef.friction = 300.0;
					bulletShapeDef.restitution = 0.0;
				} else {
					bulletShapeDef.friction = 0.3;
					bulletShapeDef.restitution = 1.0;
				}
				
				//body def (location here)
				var bulletBodyDef:b2BodyDef = new b2BodyDef();
				var bulletSetX:Number = (location.x) / PhysiVals.RATIO;
				//+ BALL_OFFSET.x * Math.cos(cannonAngle * Math.PI / 180)) / PhysiVals.RATIO;
				var bulletSetY:Number = (location.y) / PhysiVals.RATIO;
				//+ BALL_OFFSET.x * Math.sin(cannonAngle * Math.PI / 180)) / PhysiVals.RATIO;
				bulletBodyDef.position.Set(bulletSetX, bulletSetY);
				bulletBodyDef.linearDamping = 2.9;//0.1
				
				//trace("bulletSetX " + bulletSetX*PhysiVals.RATIO);
				//trace("bulletSetY " + bulletSetY*PhysiVals.RATIO);
				
				//body
				bulletBody = PhysiVals.world.CreateBody(bulletBodyDef);
				//bulletBody.SetBullet(true);
				
				//shape
				bulletBody.CreateShape(bulletShapeDef);
				bulletBody.SetMassFromShapes();
				
				//velocity
				var velocityVectorBullet:b2Vec2 = new b2Vec2(initVel.x / PhysiVals.RATIO , initVel.y / PhysiVals.RATIO);
				bulletBody.SetLinearVelocity(velocityVectorBullet);
				
				super(bulletBody, bulletSprite);
			} 
			catch (error:Error) {
				trace("bullet error: " + error.errorID);
			}
		}
		
		override protected function childSpecificUpdating():void 
		{
			this.bulletSprite.x = this.bulletBody.GetPosition().x * PhysiVals.RATIO;
			this.bulletSprite.y = this.bulletBody.GetPosition().y * PhysiVals.RATIO;
			super.childSpecificUpdating();
		}
		
		override protected function cleanUpBeforeRemoving():void 
		{
			Cannon._cannonBullets.splice(Platformer.deleteThisBullet, 1);
			//trace(Cannon._cannonBullets.length);
			Bullet._bulletsNumber = -1;
			for each (var bullet in Cannon._cannonBullets) {
				bullet.numbOfThisBullet = ++Bullet._bulletsNumber;
			}/*
			for (i:int = Platformer.deleteThisBullet+1; i < Cannon._cannonBullets.length; i++ ) {
				Cannon._cannonBullets[i].numbOfThisBullet--;
			}
			_bulletsNumber--;*/
			Platformer.deleteThisBullet = -1;
			super.cleanUpBeforeRemoving();
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
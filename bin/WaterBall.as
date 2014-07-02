package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class WaterBall extends Actor
	{
		public static var _waterBallsNumber:Number = 0;
		private const WATER_BALL_DIAMETER:Number = 15;
		private var waterBallSprite:Sprite;
		private var waterBallBody:b2Body;
		public var numbOfThisBall:int;
		public static var ratio1 = 1000;
		public static var ratio2 = 1000;
		public static var ratio3 = 1000;
		private var color:uint = 0x1A70FF;
		private var b:BitmapData;
		private static var bitmapDataCopy:BitmapData = new BitmapData(250, 450, false, 0xFF000000);
		private static var bitmapCopy:Bitmap = new Bitmap(bitmapDataCopy);
		private var blurFilter:BlurFilter = new BlurFilter(15, 15, BitmapFilterQuality.HIGH);
		private var bitmap:Bitmap;
		private var physicsContainer:MovieClip;
		private static var lowest:Number = 0;
		private static var highest:Number = 5000;
		private static var leftmost:Number = 0;
		private static var rightmost:Number = 0;
		
		public function WaterBall(parent:DisplayObjectContainer, location:Point, initVel:Point) 
		{
			numbOfThisBall = _waterBallsNumber++;
			//create costume
			var color:uint = 0x1A70FF;
			//waterBallSprite = new BulletSprite();
			waterBallSprite = new Sprite();
			waterBallSprite.graphics.beginFill(color);
			//waterBallSprite.alpha = 0;
			waterBallSprite.graphics.drawCircle(7.5, 7.5, WATER_BALL_DIAMETER / 2);
			waterBallSprite.graphics.endFill();
			waterBallSprite.x = location.x;
			waterBallSprite.y = location.y;
			
			waterBallSprite.scaleX = WATER_BALL_DIAMETER / waterBallSprite.width;
			waterBallSprite.scaleY = WATER_BALL_DIAMETER / waterBallSprite.height;
			//waterBallSprite.cacheAsBitmap = true;
			//b.threshold(b, b.rect, location, ">", 0XFF2b2b2b, 0x55FFFFFF, 0xFFFFFFFF, false);
			b = new BitmapData(WATER_BALL_DIAMETER, WATER_BALL_DIAMETER, true, color);
			
			bitmapDataCopy.fillRect(bitmapDataCopy.rect, 0xFF000000);
			bitmapDataCopy.draw(waterBallSprite);
			b.applyFilter(bitmapDataCopy, bitmapDataCopy.rect, location, blurFilter);
			b.draw(waterBallSprite);
			bitmap = new Bitmap(b);
			bitmap.filters = [blurFilter];
			
			//bitmap.x = location.x * PhysiVals.RATIO;
			//bitmap.y = location.y * PhysiVals.RATIO;
			Platformer._camera.addChild(bitmap);
			waterBallSprite.alpha = 0;
			//waterBallSprite.filters = [blurFilter];
			parent.addChildAt(waterBallSprite, 0);
			
			physicsContainer = new MovieClip();
			physicsContainer.x = 50;
			physicsContainer.y = 50;
			physicsContainer.scaleX = physicsContainer.scaleY = 1;
			
			//shape def
			var waterBallShapeDef:b2CircleDef = new b2CircleDef();
			waterBallShapeDef.radius = WATER_BALL_DIAMETER / 2 / PhysiVals.RATIO;
			
			waterBallShapeDef.density = 0.1;
			waterBallShapeDef.friction = 0.3;
			waterBallShapeDef.restitution = 1.0;
			//waterBallShapeDef.filter.groupIndex = 1;
			
			//body def (location here)
			var waterBallBodyDef:b2BodyDef = new b2BodyDef();
			var waterBallSetX:Number = (location.x) / PhysiVals.RATIO;
			//+ BALL_OFFSET.x * Math.cos(cannonAngle * Math.PI / 180)) / PhysiVals.RATIO;
			var waterBallSetY:Number = (location.y) / PhysiVals.RATIO;
			//+ BALL_OFFSET.x * Math.sin(cannonAngle * Math.PI / 180)) / PhysiVals.RATIO;
			waterBallBodyDef.position.Set(waterBallSetX, waterBallSetY);
			waterBallBodyDef.linearDamping = 0.1;
			
			//trace("bulletSetX " + bulletSetX*PhysiVals.RATIO);
			//trace("bulletSetY " + bulletSetY*PhysiVals.RATIO);
			
			//body
			waterBallBody = PhysiVals.world.CreateBody(waterBallBodyDef);
			//waterBallBody.SetBullet(true);
			
			//shape
			waterBallBody.CreateShape(waterBallShapeDef);
			waterBallBody.SetMassFromShapes();
			
			//velocity
			var velocityVectorBall:b2Vec2 = new b2Vec2(initVel.x / PhysiVals.RATIO , initVel.y / PhysiVals.RATIO);
			waterBallBody.SetLinearVelocity(velocityVectorBall);
			
			super(waterBallBody, waterBallSprite);
		}
		
		
		override protected function childSpecificUpdating():void 
		{
			var loc:Point = new Point(0, 0);
			//this._body.GetWorldCenter().x, this._body.GetWorldCenter().y);
			//b.fillRect(b.rect, 0x00000000);
			if (this._body.GetWorldCenter().y > lowest) {
				lowest = this.waterBallBody.GetPosition().y;
			}
			if (this._body.GetWorldCenter().y < highest) {
				highest = this._body.GetWorldCenter().y;
			}
			
			
			bitmapDataCopy.draw(physicsContainer, null, null, null, new Rectangle(0, 0, 30, 30), false);
			//b.threshold(b, b.rect, loc, ">", ratio1/1000*0xFFFFFFFF, ratio2/1000*0xFFFFFFFF, ratio3/1000*0xFFFFFFFF, false);
			//b.threshold(b, b.rect, loc, ">", 0XFF2c2c2c, 0x1A70FF, 0xFFFFFFFF, false);
			//b.threshold(b, b.rect, loc, ">", 0XFF2d2d2d, 0x1A70FF, 0xFFFFFFFF, false);
			
			loc = new Point(this._body.GetWorldCenter().x, this._body.GetWorldCenter().y);
			bitmap.x = loc.x  * PhysiVals.RATIO - 7.5;
			bitmap.y = loc.y * PhysiVals.RATIO - 7.5;
			
			this.waterBallSprite.x = this.waterBallBody.GetPosition().x * PhysiVals.RATIO;
			this.waterBallSprite.y = this.waterBallBody.GetPosition().y * PhysiVals.RATIO;
			super.childSpecificUpdating();
		}
		
		override protected function cleanUpBeforeRemoving():void 
		{
			super.cleanUpBeforeRemoving();
		}
	}
}
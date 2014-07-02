package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class CircleStaticActor extends Actor
	{
		public static var keysCount:Number = 0;
		public var keyNumber:Number = 0;
		private var velocity:b2Vec2;
		public var point1:Point;
		public var point2:Point;
		public var type:Number;
		public var icon:MovieClip;
		public var direction:int = 1;
		public var active:Boolean = true;
		public static const RIGID = 0;
		public static const ENEMY = 1;
		public static const WATER = 2;
		public static const MAGNET = 3;
		public static const KEY = 4;
		public static const CHECKPOINT = 5;
		private static const SPEED = 0.6;
		
		public function CircleStaticActor(parent:DisplayObjectContainer, location:Point, radius:Number, typeOfObject:Number = 0, pointToTravel:Point = null) 
		{
			point1 = location;
			point2 = pointToTravel;
			type = typeOfObject;
			var myBody:b2Body = createBodyToCircle(radius, location, type);
			var mySprite:Sprite = createSpriteToCircle(radius, location, parent, type);
			
			if (typeOfObject == KEY || typeOfObject == CHECKPOINT) {
				keyNumber = keysCount++;
			}
			super(myBody, mySprite);
			if (typeOfObject == CHECKPOINT) {
				Platformer._keys.push(this);
				icon = new keySprite();
				icon.x = _costume.x / 6;
				icon.y = _costume.y / 6;
				icon.scaleX = 1 / 60;
				icon.scaleY = 1 / 60;
			}
			if (typeOfObject == KEY) {
				
				// TODO: запилить ключи и кристаллы
				//_allActors.push(key);
				Platformer._keys.push(this);
				icon = new keySprite();
				icon.x = _costume.x / 6;
				icon.y = _costume.y / 6;
				icon.scaleX = 1 / 60;
				icon.scaleY = 1 / 60;
			}
		}
		
		override protected function childSpecificUpdating():void 
		{
			if (point2 != null) {
				if (_costume.x <= point1.x) {
					direction = 1;
					velocity = new b2Vec2((point2.x - _costume.x) * SPEED / 30, (point2.y - _costume.y) * SPEED / 30);
				} else if (_costume.x >= point2.x) {
					direction = -1;
					velocity = new b2Vec2((point1.x - _costume.x) * SPEED / 30, (point1.y - _costume.y) * SPEED / 30)
				}
				_body.SetLinearVelocity(velocity);
			}
			super.childSpecificUpdating();
		}
		
		private function createSpriteToCircle(radius:Number, location:Point, parent:DisplayObjectContainer, type:Number):Sprite 
		{
			var newSprite:Sprite = new Sprite();
			switch (type) {
				case RIGID :
					newSprite.graphics.lineStyle(2, Math.random() * 0x1000000); 
					break;
				case ENEMY :
					newSprite.graphics.lineStyle(2, 0xFFFF2F); 
					break;
				case WATER :
					newSprite.graphics.lineStyle(2, 0x37E7FF); 
					break;
				case MAGNET :
					newSprite.graphics.lineStyle(2, 0x000000); 
					break;
				case KEY :
					newSprite.graphics.lineStyle(2, Math.random() * 0x1000000);
					break;
				case CHECKPOINT :
					newSprite.graphics.lineStyle(2, 0x000000);
					break;
			}
			var color:uint = Math.random() * 0x1000000;
			
			switch (type) {
				case RIGID :
					newSprite.graphics.beginFill(Math.random() * 0x1000000);
					break;
				case ENEMY :
					newSprite.graphics.beginFill(0x8B8B8B);
					break;
				case WATER :
					newSprite.alpha = 0.7;
					newSprite.graphics.beginFill(0x002FBB);
					break;
				case MAGNET :
					var colors = [0x0000FF, 0xFF0000];
					var alphas = [0.5, 0.75];
					var ratios:Array = [0x00, 0xFF];
					var matr:Matrix = new Matrix();
					matr.createGradientBox(radius, radius, 0, 0, 0);
					//matrix = {a:200, b:0, c:0, d:0, e:200, f:0, g:200, h:200, i:1};
					newSprite.graphics.beginGradientFill("linear", colors, alphas, ratios, matr);
					break;
				case KEY :
					newSprite.graphics.beginFill(Math.random() * 0x1000000);
					break;
				case CHECKPOINT :
					newSprite.graphics.beginFill(0xFF0000);
					break;
			}
			
			//newSprite.graphics.beginFill(color);
			newSprite.graphics.drawCircle(0, 0, radius);
			newSprite.graphics.endFill();
			newSprite.x = location.x;
			newSprite.y = location.y;
			parent.addChild(newSprite);
			return newSprite;
		}
		
		private function createBodyToCircle(radius:Number, location:Point, type:Number):b2Body 
		{
			var ballShapeDef:b2CircleDef = new b2CircleDef();
			ballShapeDef.radius = radius / PhysiVals.RATIO;
			if (point2 == null) {
				ballShapeDef.density = 0;
			} else if (point2 != null) {
				ballShapeDef.density = 1;
			}
			ballShapeDef.friction = 10.0;
			ballShapeDef.restitution = 0.3;
			if (type > 1) ballShapeDef.isSensor = true;
			var ballBodyDef:b2BodyDef = new b2BodyDef();
			ballBodyDef.position.Set(location.x, location.y);
			if (point2 != null) {
				ballBodyDef.fixedRotation = true;
			}
			var ballBody:b2Body;
			ballBody = PhysiVals.world.CreateBody(ballBodyDef);
			ballBody.CreateShape(ballShapeDef);
			ballBody.SetMassFromShapes();
			return ballBody;
		}
		
		override protected function cleanUpBeforeRemoving():void 
		{
			if (type == KEY) {
				keysCount--;
				for each (var key:CircleStaticActor in Platformer._keys) {
					if (key != null) {
						if (key.keyNumber > this.keyNumber) {
							key.keyNumber--;
						}
					}
				}
				LevelDirector._rm.removeChild(icon);
				Platformer._keys.splice(this.keyNumber, 1);
			} else if (type == CHECKPOINT) {
				// TODO: checkpoints
				keysCount--;
				for each (key in Platformer._keys) {
					if (key != null) {
						if (key.keyNumber > this.keyNumber) {
							key.keyNumber--;
						}
					}
				}
				LevelDirector._rm.removeChild(icon);
				Platformer._keys.splice(this.keyNumber, 1);
				LevelDirector._rm.addCheckpoint();
			}
			//Platformer._allActors.splice(Platformer._allActors.indexOf(this), 1);
			super.cleanUpBeforeRemoving();
		}
	}
}
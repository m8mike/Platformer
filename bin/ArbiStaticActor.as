package  
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class ArbiStaticActor extends Actor
	{
		private var vel1:b2Vec2;
		private var vel2:b2Vec2;
		private var k:int = 2;
		/*private var changedDirection:Boolean = false;	//вспомагательная фигня
		private var changedDirection1:Boolean = false;	//для двигающихся платформ*/
		//public var cloudNumber:int;						//для облаков
		public var point1:Point;
		public var point2:Point;
		public var direction:int = 1;
		private var _type:Number;
		public var cloud:Cloud;
		public static const RIGID = 0;
		public static const ENEMY = 1;
		public static const WATER = 2;
		public static const MAGNET = 3;
		public static const CLOUD = 4;
		public static const WINK = 5;
		public static const TRANSPARENT = 6;
		public static const TREE = 7;
		public static const ELEVATOR = 8;
		public static const HAT = 9;
		public static const END_LEVEL = 10;
		private static const SPEED = 0.6;
		private var cloudSprite:Sprite;
		private var newSprite:Sprite;
		
		public function ArbiStaticActor(parent:DisplayObjectContainer, location:Point, arrayOfCoords:Array, 
										typeOfObject:Number = 0, pointToTravel:Point = null, cloudData:Cloud = null) 
		{
			cloud = cloudData;
			point1 = location;
			point2 = pointToTravel;
			type = typeOfObject;
			var myBody:b2Body = createBodyFromCoords(arrayOfCoords, location, type);
			var mySprite:Sprite = createSpriteFromCoords(arrayOfCoords, location, parent, type);
			if (pointToTravel) {
				setVelocities();
			}
			super(myBody, mySprite);
		}
		
		public function decAlpha():void
		{
			this._costume.alpha -= 0.02;
		}
		
		private function setVelocities():void 
		{
			if (point1.x == point2.x) {
				if (point1.y > point2.y) {
					vel1 = new b2Vec2(0, -k);
					vel2 = new b2Vec2(0, k);
				} else
				if (point1.y < point2.y) {
					vel1 = new b2Vec2(0, k);
					vel2 = new b2Vec2(0, -k);
				}
			} else
			if (point1.x > point2.x) {
				if (point1.y == point2.y) {
					vel1 = new b2Vec2( -k, 0);
					vel2 = new b2Vec2( k, 0);
				} else
				vel1 = new b2Vec2(k * Math.cos(Math.atan((point1.y - point2.y) / (point1.x - point2.x))),
								  k * Math.sin(Math.atan((point1.y - point2.y) / (point1.x - point2.x))));
				vel2 = new b2Vec2(-k * Math.cos(Math.atan((point1.y - point2.y) / (point1.x - point2.x))),
								  -k * Math.sin(Math.atan((point1.y - point2.y) / (point1.x - point2.x))));
				//trace(vel1.x+" x1y "+vel1.y);
				//trace(vel2.x+" x2y "+vel2.y);
			} else
			if (point1.x < point2.x) {
				if (point1.y == point2.y) {
					vel1 = new b2Vec2( k, 0);
					vel2 = new b2Vec2( -k, 0);
				} else
				vel1 = new b2Vec2(k * Math.cos(Math.atan((point2.y - point1.y) / (point2.x - point1.x))),
								  k * Math.sin(Math.atan((point2.y - point1.y) / (point2.x - point1.x))));
				vel2 = new b2Vec2(-k * Math.cos(Math.atan((point2.y - point1.y) / (point2.x - point1.x))),
								  -k * Math.sin(Math.atan((point2.y - point1.y) / (point2.x - point1.x))));
				//trace(vel1.x+" y1x "+vel1.y);
				//trace(vel2.x+" y2x "+vel2.y);
			}
		}
		
		override protected function cleanUpBeforeRemoving():void 
		{
			if (this._type == CLOUD  || this._type == WINK) {
				newSprite.parent.removeChild(newSprite);
			}
			super.cleanUpBeforeRemoving();
		}
		
		override protected function childSpecificUpdating():void 
		{
			if (point2 != null) {
				if (point1.x == point2.x) {
					if (point1.y > point2.y) {
						if (_costume.y >= point1.y) {
							direction = 1;
						} else 
						if (_costume.y <= point2.y) {
							direction = -1;
						}
					}
				} else
				if (point1.x > point2.x) {
					if (_costume.x >= point1.x) {
						direction = 1;
					} else
					if (_costume.x <= point2.x) {
						direction = -1
					}
				} else
				if (point1.x < point2.x) {
					if (_costume.x <= point1.x) {
						direction = 1;
					} else
					if (_costume.x >= point2.x) {
						direction = -1;
					}
				}
				if (direction == 1) {
					_body.SetLinearVelocity(vel1);
				} else 
				if (direction == -1) {
					_body.SetLinearVelocity(vel2);
				}
				_body.ApplyForce(new b2Vec2(0.0, -10.0 * _body.GetMass()), _body.GetWorldCenter());
			}
			super.childSpecificUpdating();
		}
		
		private function createSpriteFromCoords(arrayOfCoords:Array, location:Point, parent:DisplayObjectContainer, type:Number):Sprite
		{
			newSprite = new Sprite();
			switch (type) {
				case RIGID :
					newSprite.graphics.lineStyle(2, Math.random() * 0x1000000); 
					//newSprite.graphics.lineStyle(2, 0x000000); 
					break;
				case TRANSPARENT :
					newSprite.graphics.lineStyle(2, Math.random() * 0x1000000); 
					break;
				case TREE :
					
					break;
				case HAT :
					
					break;
				case END_LEVEL :
					
					break;
				case ELEVATOR :
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
				case CLOUD :
					newSprite.graphics.lineStyle(2, 0x5E9AFF);
					break;
				case WINK :
					newSprite.graphics.lineStyle(2, 0x9500A6);
					break;
				default: 
					trace("unknown type ArbiStaticActor:170");
			}
			for each (var listOfPoints:Array in arrayOfCoords) {
				var firstPoint:Point = listOfPoints[0];
				newSprite.graphics.moveTo(firstPoint.x, firstPoint.y);
				switch (type) {
					case RIGID :
						newSprite.graphics.beginFill(Math.random() * 0x1000000);
					break;
					case TRANSPARENT :
						newSprite.graphics.beginFill(Math.random() * 0x1000000);
					break;
					case TREE :
					
					break;
					case HAT :
					
					break;
					case END_LEVEL :
					
					break;
					case ELEVATOR :
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
						matr.createGradientBox(58 * 6, 58 * 6, 0, 0, 0);
						//matrix = {a:200, b:0, c:0, d:0, e:200, f:0, g:200, h:200, i:1};
						newSprite.graphics.beginGradientFill("linear", colors, alphas, ratios, matr);
					break;
					case CLOUD :
						newSprite.graphics.beginFill(0xC6DBFF);
					break;
					case WINK :
						newSprite.graphics.beginFill(0x2B5AFF);
					break;
					default: 
						trace("unknown type ArbiStaticActor:202");
				}
				for each (var newPoint:Point in listOfPoints) {
					newSprite.graphics.lineTo(newPoint.x, newPoint.y);
				}
				newSprite.graphics.lineTo(firstPoint.x, firstPoint.y);
				newSprite.graphics.endFill();
			}
			newSprite.x = location.x;
			newSprite.y = location.y;
			parent.addChild(newSprite);
			if ((_type == ArbiStaticActor.RIGID && point2 == null) || _type == TRANSPARENT) {
				var loc:Point = location.clone();
				var loc1:Point = new Point(0, 0);
				var row:MovieClip = new ug2();
				parent.addChildAt(row, 0);
				loc.x -= 30;
				loc.y -= 30;
				row.x = loc.x;
				row.y = loc.y;
				var k:int = 1 + newSprite.width / (row.width * 0.8);
				var l:int = 1 + newSprite.height / (row.height * 0.5);
				for (var i:int = 0; i <= l; i++) {
					for (var j:int = 0; j <= k; j++) {
						var undergr:MovieClip = new ug2();
						loc1.x = undergr.width * 0.8 * j;
						loc1.y = undergr.height * 0.5 * i;
						undergr.x = loc1.x;
						undergr.y = loc1.y;
						var underBmp:BmpFrames = BmpFrames.createBmpFramesFromMC(undergr);
						row.addChild(undergr);
						var bmp4:Bitmap = new Bitmap(underBmp.frames[0], PixelSnapping.ALWAYS, true);
						bmp4.x = underBmp.frameXs[0]+loc1.x;
						bmp4.y = underBmp.frameYs[0]+loc1.y;
						row.addChild(bmp4 as DisplayObject);
					}
				}
				row.removeChildAt(0);
				row.mask = newSprite;
			} else 
			if (_type == ArbiStaticActor.TREE || _type == ArbiStaticActor.HAT || _type == ArbiStaticActor.END_LEVEL) {
				newSprite.visible = false;
			}
			//Platformer.rasterize(newSprite);
			//
			if (type == CLOUD || type == WINK || type == ELEVATOR) {
				cloudSprite = new cloudblue();
				cloudSprite.x = newSprite.x;
				cloudSprite.y = newSprite.y;
				cloudSprite.scaleX = 0.4;
				cloudSprite.scaleY = 0.4;
				parent.addChildAt(cloudSprite, 0);
				newSprite.visible = false;
				//Platformer.rasterize(cloudSprite);
				return cloudSprite;
			} else return newSprite;
		}
		
		private function createBodyFromCoords(arrayOfCoords:Array, location:Point, type:Number):b2Body
		{
			//define shapes
			var allShapeDefs:Array = [];
			
			for each(var listOfPoints:Array in arrayOfCoords) {
				var newShapeDef:b2PolygonDef = new b2PolygonDef();
				newShapeDef.vertexCount = listOfPoints.length;
				for (var i:int = 0; i < listOfPoints.length; i++) {
					var nextPoint:Point = listOfPoints[i];
					b2Vec2(newShapeDef.vertices[i]).Set(nextPoint.x / PhysiVals.RATIO,
														nextPoint.y / PhysiVals.RATIO);
				}
				if (point2 == null) {
					newShapeDef.density = 0;
				} else if (point2 != null) {
					newShapeDef.density = 1;
				}
				newShapeDef.friction = 0.2;
				newShapeDef.filter.groupIndex = -2;
				newShapeDef.restitution = 0.3;
				if (type > 1 && type < 4) newShapeDef.isSensor = true;
				allShapeDefs.push(newShapeDef);
			}
			
			//define a body
			var arbiBodyDef:b2BodyDef = new b2BodyDef();
			arbiBodyDef.position.Set(location.x / PhysiVals.RATIO, location.y / PhysiVals.RATIO);
			if (point2 != null) {
				arbiBodyDef.fixedRotation = true;
			}
			
			//create the body
			var arbiBody:b2Body = PhysiVals.world.CreateBody(arbiBodyDef);
			//create the shapes
			for each (var newShapeDefToAdd:b2ShapeDef in allShapeDefs) {
				arbiBody.CreateShape(newShapeDefToAdd);
			}
			arbiBody.SetMassFromShapes();
			//arbiBody.SetBullet(true);
			return arbiBody;
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
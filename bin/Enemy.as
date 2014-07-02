package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import com.touchmypixel.peepee.utils.Animation;
	import com.touchmypixel.peepee.utils.AnimationCache;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class Enemy extends Actor
	{
		public static const REC_DIAMETER:int = 30;//20
		public static var _enemiesCount:int = 0;
		public var enemyBody:b2Body;
		public var enemyNumber:int;
		public var condition:Number;//состояние персонажа для анимации и т.д.
		public var point1:Point;
		public var point2:Point;
		public var jumpTimer:int = 0;
		public var invincibleTimer:int = 0;
		public var noShieldTimer:int = 0;
		public var lives:int = 1;
		public var useShield:Boolean = false;
		public var type:int;
		public var isRushing:Boolean = false;
		
		public static const SIMPLE = 0;
		public static const SHOOTING = 1;
		public static const JUMPING = 2;
		public static const WALKING = 3;
		public static const FLYING = 4;
		public static const HEAVY = 5;
		public static const GHOST = 6;
		public static const RUSHING = 7;
		public static const FROM_BELOW = 8;
		public static const PUSH_AND_SMASH = 9;
		
		private var enemySprite:Animation;
		private var vel1:b2Vec2;
		private var vel2:b2Vec2;
		private var direction:Boolean = false;
		
		public function Enemy(parent:DisplayObjectContainer, location:Point, initVel:Point, 
							  typeOfObject:int = 0, pointToTravel:Point = null) 
		{
			point1 = location;
			point2 = pointToTravel;
			if (pointToTravel) {
				setVelocities();
			}
			type = typeOfObject;
			if (type == SHOOTING) {
				Platformer.thereIsAGun = true;
			} else if (type == HEAVY || type == GHOST) {
				lives = 3;
			} else if (type == PUSH_AND_SMASH) {
				useShield = true;
			}
			enemyNumber = _enemiesCount++;
			//create costume
			var animationCache:AnimationCache = AnimationCache.getInstance();
			if (type == GHOST) {
				animationCache.cacheAnimation("ghost1");
				enemySprite = animationCache.getAnimation("ghost1");
				enemySprite.scaleX *= 0.2;
				enemySprite.scaleY *= 0.2;
			} else {
				animationCache.cacheAnimation("Zombie");
				enemySprite = animationCache.getAnimation("Zombie");
				enemySprite.scaleX *= 0.1;
				enemySprite.scaleY *= 0.1;
			}
			enemySprite.gotoAndPlay(1);
			parent.addChildAt(enemySprite, 0);
			
			//polygon
			var enemyShapeDef:b2PolygonDef = new b2PolygonDef();
			if (type == GHOST) {
				enemyShapeDef.SetAsBox(0.7 * REC_DIAMETER / 2 / PhysiVals.RATIO, REC_DIAMETER / 2 / PhysiVals.RATIO);
			} else {
				enemyShapeDef.SetAsBox(0.6 * REC_DIAMETER / 2 / PhysiVals.RATIO, REC_DIAMETER / 2 / PhysiVals.RATIO);
			}
			enemyShapeDef.density = 0.5;
			enemyShapeDef.friction = 0.3;
			enemyShapeDef.restitution = 0.7;
			
			//body def (location here)
			var enemyBodyDef:b2BodyDef = new b2BodyDef();
			enemyBodyDef.position.Set(location.x / PhysiVals.RATIO, location.y / PhysiVals.RATIO);
			enemyBodyDef.linearDamping = 0.5;//
			//enemyBodyDef.angularDamping = 1;//
			
			//one other thing...
			
			//body
			//var ballBody:b2Body;
			enemyBody = PhysiVals.world.CreateBody(enemyBodyDef);
			enemyBody.SetBullet(true);
			
			//shape
			enemyBody.CreateShape(enemyShapeDef);
			enemyBody.SetMassFromShapes();
			enemyBody.m_sweep.a = 0;
			
			//velocity
			var velocityVector:b2Vec2 = new b2Vec2(initVel.x / PhysiVals.RATIO, initVel.y / PhysiVals.RATIO);
			enemyBody.SetLinearVelocity(velocityVector);
			enemyBody.SetUserData(enemyNumber);
			
			Platformer._enemies.push(this);
			var emptySprite:Sprite = new Sprite();
			parent.addChild(emptySprite);
			super(enemyBody, emptySprite);
		}
		
		private function setVelocities():void 
		{
			//trace("set " + enemyNumber);
			var k:int = 2;
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
		
		public function shoot(location:b2Vec2):void 
		{
			var angle:Number = 90 - Math.atan2(Platformer._ballActor.ballBody.GetWorldCenter().x * PhysiVals.RATIO - enemySprite.x,
											   Platformer._ballActor.ballBody.GetWorldCenter().y * PhysiVals.RATIO - enemySprite.y) 
									* 180 / Math.PI;
			var velocity:Point = new Point(300 * 2 * Math.cos((angle) / 180 * Math.PI), 
										   300 * 2 * Math.sin((angle) / 180 * Math.PI));
			Cannon._cannonBullets.push(new Bullet(Platformer._camera, new Point(enemySprite.x + angle * enemySprite.width, 
			enemySprite.y + angle * enemySprite.height), velocity));
		}
		
		override protected function childSpecificUpdating():void 
		{
			if (type == GHOST) {
				enemySprite.x = enemyBody.GetPosition().x * PhysiVals.RATIO;
				enemySprite.y = enemyBody.GetPosition().y * PhysiVals.RATIO;
				if (enemyBody.GetWorldCenter().x > Platformer._ballActor._body.GetWorldCenter().x) {
					enemySprite.scaleX = - Math.abs(enemySprite.scaleX);
				} else {
					enemySprite.scaleX = Math.abs(enemySprite.scaleX);
				}
			} else {
				enemySprite.x = enemyBody.GetPosition().x * PhysiVals.RATIO + 0.1 * enemySprite.width;
				enemySprite.y = enemyBody.GetPosition().y * PhysiVals.RATIO + 0.3 * enemySprite.height;
				if (enemyBody.GetLinearVelocity().x > 0) {
					enemySprite.scaleX = - Math.abs(enemySprite.scaleX);
				} else {
					enemySprite.scaleX = Math.abs(enemySprite.scaleX);
				}
			}
			
			enemyBody.m_sweep.a = 0;
			if (point2) {
				if (type == FLYING || type == FROM_BELOW) {
					enemyBody.ApplyForce(new b2Vec2(0.0, -10.0 * enemyBody.GetMass()), enemyBody.GetWorldCenter());
				}
				if (point1.x == point2.x) {
					if (point1.y > point2.y) {
						if (_costume.y >= point1.y) {
							direction = true;
						} else 
						if (_costume.y <= point2.y) {
							direction = false;
						}
					}
				} else
				if (point1.x > point2.x) {
					if (_costume.x >= point1.x) {
						direction = true;
					} else
					if (_costume.x <= point2.x) {
						direction = false;
					}
				} else
				if (point1.x < point2.x) {
					if (_costume.x <= point1.x) {
						direction = true;
					} else
					if (_costume.x >= point2.x) {
						direction = false;
					}
				}
				if (direction) {
					enemyBody.SetLinearVelocity(vel1);
				} else {
					enemyBody.SetLinearVelocity(vel2);
				}
			}
			if (type == JUMPING) {
				//trace(enemyBody.GetWorldCenter().x + " " + enemyBody.GetWorldCenter().y);
				if (PhysiVals.fps < 60.0) {
					if (jumpTimer >= 50) {
						jumpTimer = 0;
						enemyBody.ApplyImpulse(new b2Vec2(0, -2.0), enemyBody.GetWorldCenter());
					} else {
						jumpTimer++;
					}
				}
			} else if (type == PUSH_AND_SMASH) {
				if (noShieldTimer > 0) {
					noShieldTimer--;
					enemySprite.alpha = 0.7;
				} else {
					enemySprite.alpha = 1.0;
				}
			} else if (type == HEAVY) {
				if (invincibleTimer > 0) {
					invincibleTimer--;
					enemySprite.alpha = 0.2;
				} else {
					enemySprite.alpha = 1.0;
				}
			} else if (type == GHOST) {
				if (invincibleTimer > 0) {
					invincibleTimer--;
					enemySprite.alpha = 0.2;
					enemyBody.GetShapeList().m_isSensor = true;
				} else {
					if (enemySprite.alpha < 1.0) {
						enemySprite.alpha = 1.0;
						enemyBody.GetShapeList().m_isSensor = false;
					}
				}
			} else if (type == RUSHING) {
				if (Math.sqrt(Math.pow(enemyBody.GetWorldCenter().x - Platformer._ballActor._body.GetWorldCenter().x, 2) + 
							  Math.pow(enemyBody.GetWorldCenter().y - Platformer._ballActor._body.GetWorldCenter().y, 2)) < 4.0) {
					rush();
				} else {
					isRushing = false;
				}
			}
			super.childSpecificUpdating();
		}
		
		private function rush():void 
		{
			if (!isRushing) {
				isRushing = true;
				var angle:int = 90 - Math.atan2(Platformer._ballActor.ballBody.GetWorldCenter().x * PhysiVals.RATIO - enemySprite.x,
												Platformer._ballActor.ballBody.GetWorldCenter().y * PhysiVals.RATIO - enemySprite.y) * 180 / Math.PI;
				var impulse:b2Vec2 = new b2Vec2(2 * Math.cos(angle / 180 * Math.PI), 
												2 * Math.sin(angle / 180 * Math.PI));
				_body.ApplyImpulse(impulse, _body.GetWorldCenter());
			}
		}
		
		override protected function cleanUpBeforeRemoving():void 
		{
			_enemiesCount--;
			for each (var e:Enemy in Platformer._enemies) {
				if (e.enemyNumber > this.enemyNumber) {
					e.enemyNumber--;
				}
			}
			enemySprite.parent.removeChild(enemySprite);
			super.cleanUpBeforeRemoving();
		}
	}
}
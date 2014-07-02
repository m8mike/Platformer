package  
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import com.touchmypixel.peepee.utils.Animation;
	import com.touchmypixel.peepee.utils.AnimationCache;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class BallActor extends Actor
	{
		public var ballBody:b2Body;
		public static var condition:int;//состояние персонажа для анимации и т.д.
		public static var carryingItem:int = 1;
		public static var hatIndex:int = 11;
		public static var stripeIndex:int = 24;
		public static var characterIndex:int = 0;
		public static var shoesIndex:int = 1;
		public static var handsIndex:int = 0;
		public static var jumpImpulse:b2Vec2 = new b2Vec2(0.0, -0.17);//-0.5);//-0.17); true
		public static var jumpImpulse2:b2Vec2 = new b2Vec2(0.0, -0.5);//test new type of jump (bigger impulse)
		public static var jumpForce:b2Vec2 = new b2Vec2(0.0, -4.0)//-0.5);//-5.26 true
		public static var leftWallJumpImpulse:b2Vec2 = new b2Vec2(-0.5/1.5, -0.6/1.5);//-0.5, -0.6); true
		public static var rightWallJumpImpulse:b2Vec2 = new b2Vec2(0.5/1.5, -0.6/1.5);//0.5, -0.6); true
		public static var jumpTime:int = 2;//10//true 2
		public static var jumpTimeLeft:int = 0;
		public static var impulseReducer:int = 0;
		
		private static var ballStatic:Animation;
		private static var ballStaticLeft:Animation;
		private static var ballStay:Animation;
		private static var ballStayLeft:Animation;
		private static var ballUp:Animation;
		private static var ballUpLeft:Animation;
		private static var ballDown:Animation;
		private static var ballDownLeft:Animation;
		private static var umbrellaRight:Animation;
		private static var umbrellaLeft:Animation;
		private static var redSplash:Animation;
		private static var symbol:MovieClip;
		private static var cameraZoomer:Number = 1;
		private static var changedCondition:Boolean = false;
		private static var currentY:Number = 0;
		private static var lastY:Number = 0;
		private static var middleY:Number = 0;
		private static var goldenY:Number = 0;
		private static var camKoef:Number = 1;
		private static var camKoef2:Number = 1;
		private static var previousVelocity0:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity1:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity2:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity3:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity4:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity5:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity6:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity7:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity8:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity9:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity10:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity11:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity12:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity13:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity14:b2Vec2 = new b2Vec2(0, 0);
		private static var previousVelocity15:b2Vec2 = new b2Vec2(0, 0);
		
		public static const BALL_DIAMETER:int = 20;//12
		
		//carryingItem
		public static const NONE:int = 0;
		public static const UMBRELLA:int = 1;
		
		// condition
		public static const STAY_RIGHT:int = 1;
		public static const STAY_LEFT:int = -1;
		public static const GO_RIGHT:int = 2;
		public static const GO_LEFT:int = -2;
		public static const RUN_RIGHT:int = 3;
		public static const RUN_LEFT:int = -3;
		public static const JUMP_UP_RIGHT:int = 4;
		public static const JUMP_DOWN_RIGHT:int = -4;
		public static const JUMP_UP_LEFT:int = 5;
		public static const JUMP_DOWN_LEFT:int = -5;
		public static const UMBRELLA_RIGHT:int = 6;
		public static const UMBRELLA_LEFT:int = -6;
		public static const RED_SPLASH:int = 7;
		
		public static var renderArea:Sprite = new Sprite(); 
		
		public function BallActor(parent:DisplayObjectContainer, location:Point, initVel:Point)
		{
			//renderArea.graphics.beginFill(0xFF0000);
			renderArea.graphics.drawRect(-960, -720, 1920, 1440);
			//renderArea.graphics.endFill();
			Platformer._cameraDynamicLayer.addChild(renderArea);
			//create costume
			var animationCache:AnimationCache = AnimationCache.getInstance();
			animationCache.replaceExisting = true;
			animationCache.cacheAnimation("go_right");
			animationCache.cacheAnimation("go_left");
			animationCache.cacheAnimation("stay_right");
			animationCache.cacheAnimation("stay_left");
			animationCache.cacheAnimation("jump_right");
			animationCache.cacheAnimation("jump_left");
			animationCache.cacheAnimation("fall_right");
			animationCache.cacheAnimation("fall_left");
			animationCache.cacheAnimation("umbrella_right");
			animationCache.cacheAnimation("umbrella_left");
			animationCache.cacheAnimation("red_splash");
			var ballSprite:Sprite = new Sprite();
			parent.addChildAt(ballSprite, 0);
			ballSprite.visible = false;//не используется
			
			ballStatic = animationCache.getAnimation("go_right");//runBun();
			ballStatic.scaleX = 1.0 * BALL_DIAMETER / ballStatic.width* 1.6;
			ballStatic.scaleY = 1.0 * BALL_DIAMETER / ballStatic.height/(2/3)* 1.6;
			ballStatic.gotoAndPlay(1);
			parent.addChild(ballStatic);
			
			ballStaticLeft = animationCache.getAnimation("go_left");//runBunLeft();
			ballStaticLeft.scaleX = -1.0 * BALL_DIAMETER / ballStaticLeft.width* 1.6;
			ballStaticLeft.scaleY = 1.0 * BALL_DIAMETER / ballStaticLeft.height/(2/3)* 1.6;
			ballStaticLeft.gotoAndStop(1);
			ballStaticLeft.visible = false;
			parent.addChild(ballStaticLeft);
			
			ballStay = animationCache.getAnimation("stay_right");//
			ballStay.scaleX = 1.3 * BALL_DIAMETER / ballStay.width/1.32  * 1.6;
			ballStay.scaleY = 1.4 * BALL_DIAMETER / ballStay.height/1.32/(2/3)* 1.6;
			ballStay.gotoAndStop(1);
			ballStay.visible = false;
			parent.addChild(ballStay);
			
			ballStayLeft = animationCache.getAnimation("stay_left");//
			ballStayLeft.scaleX = -1.3 * BALL_DIAMETER / ballStayLeft.width/1.32* 1.6;
			ballStayLeft.scaleY = 1.37 * BALL_DIAMETER / ballStayLeft.height/1.32/(2/3)* 1.6;
			ballStayLeft.gotoAndPlay(1);
			ballStayLeft.visible = false;
			parent.addChild(ballStayLeft);
			
			ballUp = animationCache.getAnimation("jump_right");//jmpUp();//
			ballUp.scaleX = 1.0 * BALL_DIAMETER / ballUp.width* 1.6;
			ballUp.scaleY = 1.0 * BALL_DIAMETER / ballUp.height /(2/3)* 1.6;
			ballUp.gotoAndPlay(1);
			ballUp.visible = false;
			parent.addChild(ballUp);
			
			ballUpLeft = animationCache.getAnimation("jump_left");//jmpUpLeft();//
			ballUpLeft.scaleX = -1.0 * BALL_DIAMETER / ballUpLeft.width* 1.6;
			ballUpLeft.scaleY = 1.0 * BALL_DIAMETER / ballUpLeft.height/(2/3)* 1.6;
			ballUpLeft.gotoAndPlay(1);
			ballUpLeft.visible = false;
			parent.addChild(ballUpLeft);
			
			ballDown = animationCache.getAnimation("fall_right");//jmpDown();//
			ballDown.scaleX = 1.2 * BALL_DIAMETER / ballDown.width / 1.2  * 1.6;
			ballDown.scaleY = 1.3 * BALL_DIAMETER / ballDown.height / 1.2/(2/3)* 1.6;
			ballDown.visible = false;
			parent.addChild(ballDown);
			
			ballDownLeft = animationCache.getAnimation("fall_left");//jmpDownLeft();//
			ballDownLeft.scaleX = -1.2 * BALL_DIAMETER / ballDownLeft.width / 1.2  * 1.6;
			ballDownLeft.scaleY = 1.3 * BALL_DIAMETER / ballDownLeft.height / 1.2/(2/3)* 1.6;//1.2
			ballDownLeft.visible = false;
			parent.addChild(ballDownLeft);
			
			umbrellaRight = animationCache.getAnimation("umbrella_right");//jmpDown();//
			umbrellaRight.scaleX = 1.2 * BALL_DIAMETER / umbrellaRight.width / 1.2  * 1.6;
			umbrellaRight.scaleY = 1.3 * BALL_DIAMETER / umbrellaRight.height / 1.2/(2/3)* 1.6;
			umbrellaRight.visible = false;
			parent.addChild(umbrellaRight);
			
			umbrellaLeft = animationCache.getAnimation("umbrella_left");//jmpDownLeft();//
			umbrellaLeft.scaleX = -1.2 * BALL_DIAMETER / umbrellaLeft.width / 1.2  * 1.6;
			umbrellaLeft.scaleY = 1.3 * BALL_DIAMETER / umbrellaLeft.height / 1.2/(2/3)* 1.6;//1.2
			umbrellaLeft.visible = false;
			parent.addChild(umbrellaLeft);
			
			redSplash = animationCache.getAnimation("red_splash");//
			redSplash.scaleX = -1.2 * BALL_DIAMETER / redSplash.width;
			redSplash.scaleY = 1.5 * BALL_DIAMETER / redSplash.height;
			redSplash.visible = false;
			parent.addChild(redSplash);
			condition = 0;
			//ballStatic.visible = false;
			//polygon
			/*
			var ballShapeDef:b2PolygonDef = new b2PolygonDef();
			ballShapeDef.SetAsBox(BALL_DIAMETER / 2 / PhysiVals.RATIO, BALL_DIAMETER / 2 / PhysiVals.RATIO);
			*/
			//
			//circle
			var ballShapeDef:b2CircleDef = new b2CircleDef();
			ballShapeDef.radius = BALL_DIAMETER / 2 / PhysiVals.RATIO;
			//
			ballShapeDef.density = 0.5;
			ballShapeDef.friction = 0.3;
			ballShapeDef.restitution = 0.3;
			ballShapeDef.filter.groupIndex = -3;
			//body def (location here)
			var ballBodyDef:b2BodyDef = new b2BodyDef();
			ballBodyDef.position.Set(location.x / PhysiVals.RATIO, location.y / PhysiVals.RATIO);
			ballBodyDef.linearDamping = 0.5;//
			ballBodyDef.angularDamping = 1;//
			
			//one other thing...
			
			//body
			//var ballBody:b2Body;
			ballBody = PhysiVals.world.CreateBody(ballBodyDef);
			//ballBody.SetBullet(true);
			
			//shape
			ballBody.CreateShape(ballShapeDef);
			ballBody.SetMassFromShapes();
			
			//velocity
			var velocityVector:b2Vec2 = new b2Vec2(initVel.x / PhysiVals.RATIO, initVel.y / PhysiVals.RATIO);
			ballBody.SetLinearVelocity(velocityVector);
			
			super(ballBody, ballSprite);
			Platformer.ballIsHere = true;
		}
		
		override protected function cleanUpBeforeRemoving():void 
		{
			ballStatic.parent.removeChild(ballStatic);
			ballStaticLeft.parent.removeChild(ballStaticLeft);
			ballStay.parent.removeChild(ballStay);
			ballStayLeft.parent.removeChild(ballStayLeft);
			ballUp.parent.removeChild(ballUp);
			ballUpLeft.parent.removeChild(ballUpLeft);
			ballDown.parent.removeChild(ballDown);
			ballDownLeft.parent.removeChild(ballDownLeft);
			umbrellaRight.parent.removeChild(umbrellaRight);
			umbrellaLeft.parent.removeChild(umbrellaLeft);
			redSplash.parent.removeChild(redSplash);
			Platformer._allActors.splice(Platformer._allActors.indexOf(this), 1);
			//Platformer._camera.removeChild(ballStatic);
			super.cleanUpBeforeRemoving();
			//trace("numChildren: " + Platformer._camera.numChildren);
			Platformer.ballIsHere = false;
		}
		
		public static function splash():void
		{
			if (condition != RED_SPLASH) {
				condition = RED_SPLASH;
				changedCondition = true;
				redSplash.currentFrame = 0;
			}
		}
		
		override protected function childSpecificUpdating():void 
		{
			if (Platformer.deleting) {
				return void;
			}
			if (condition == RED_SPLASH) {
				redSplash.visible = true;
				redSplash.x = _body.GetPosition().x * PhysiVals.RATIO;
				redSplash.y = _body.GetPosition().y * PhysiVals.RATIO;
				if (redSplash.currentFrame >= 6) {
					Platformer.safeRemoveActor(Platformer._ballActor);
					//Platformer.remakeBallTrue = true;
				}
			} else {
				if (condition < 4 && condition > -4) {
					camKoef = 1;
				} else {
					if (camKoef > 0.0001) {
						camKoef *= 0.97;
					}
				}
				//trace("numChildren: " + Platformer._camera.numChildren);
				//trace("lastChild: " + Platformer._camera.getChildAt(Platformer._camera.numChildren-1).);
				ballStay.x = _body.GetPosition().x * PhysiVals.RATIO - 19.6818;
				ballStay.y = _body.GetPosition().y * PhysiVals.RATIO - 26.37;
				ballStayLeft.x = _body.GetPosition().x * PhysiVals.RATIO + 19.6818;
				ballStayLeft.y = _body.GetPosition().y * PhysiVals.RATIO - 26.37;
				ballStatic.x = _body.GetPosition().x * PhysiVals.RATIO - 19.6818;// + 145.35/30;
				ballStatic.y = _body.GetPosition().y * PhysiVals.RATIO - 26.37;
				ballUp.x = _body.GetPosition().x * PhysiVals.RATIO - 19.6818;
				ballUp.y = _body.GetPosition().y * PhysiVals.RATIO - 26.37;
				ballDown.x = _body.GetPosition().x * PhysiVals.RATIO - 19.6818;
				ballDown.y = _body.GetPosition().y * PhysiVals.RATIO - 26.37;
				ballStaticLeft.x = _body.GetPosition().x * PhysiVals.RATIO + 19.6818;
				ballStaticLeft.y = _body.GetPosition().y * PhysiVals.RATIO - 26.37;
				ballUpLeft.x = _body.GetPosition().x * PhysiVals.RATIO + 19.6818;
				ballUpLeft.y = _body.GetPosition().y * PhysiVals.RATIO - 26.37;
				ballDownLeft.x = _body.GetPosition().x * PhysiVals.RATIO + 19.6818;
				ballDownLeft.y = _body.GetPosition().y * PhysiVals.RATIO - 26.37;
				umbrellaRight.x = ballDown.x;
				umbrellaRight.y = ballDown.y;
				umbrellaLeft.x = ballDownLeft.x;
				umbrellaLeft.y = ballDownLeft.y;
				redSplash.x = ballDownLeft.x;
				redSplash.y = ballDownLeft.y;
				if (Platformer.levelNow == 4) {
					RandomMap.playerIcon.x = _costume.x / 6;
					RandomMap.playerIcon.y = _costume.y / 6;
				}
				if (condition == JUMP_UP_RIGHT) {
					if (ballUp.currentFrame == 8) {//20
						ballUp.stop();
					}
				} else
				if (condition == JUMP_UP_LEFT) {
					if (ballUpLeft.currentFrame == 8) {//20
						ballUpLeft.stop();
					}
				} else
				if (condition == JUMP_DOWN_RIGHT) {
					if (ballDown.currentFrame == 5) {//46
						ballDown.stop();
					}
				} else
				if (condition == JUMP_DOWN_LEFT) {
					if (ballDownLeft.currentFrame == 5) {//46
						ballDownLeft.stop();
					}
				} else
				if (condition == UMBRELLA_RIGHT) {
					if (umbrellaRight.currentFrame == 5) {
						umbrellaRight.stop();
					}
				} else
				if (condition == UMBRELLA_LEFT) {
					if (umbrellaLeft.currentFrame == 5) {
						umbrellaLeft.stop();
					}
				}
				if (Platformer.Umbrella) {
					if (ballBody.GetLinearVelocity().x >= 0) {
						if (condition != UMBRELLA_RIGHT) {
							condition = UMBRELLA_RIGHT;
							changedCondition = true;
						}
					} else {
						if (condition != UMBRELLA_LEFT) {
							condition = UMBRELLA_LEFT;
							changedCondition = true;
						}
					}
				} else 
				if (Platformer.PlayerCanJump) {
					if (ballBody.GetLinearVelocity().x > 0.05) {
						if (condition != GO_RIGHT) {
							condition = GO_RIGHT;
							changedCondition = true;
						}
					} else
					if (ballBody.GetLinearVelocity().x < -0.05) {
						if (condition != GO_LEFT) {
							condition = GO_LEFT;
							changedCondition = true;
						}
					} else
					if (condition == GO_LEFT ||
						condition == RUN_LEFT ||
						condition == JUMP_UP_LEFT ||
						condition == JUMP_DOWN_LEFT
						) {
						condition = STAY_LEFT;
						changedCondition = true;
					} else
					if (condition == STAY_LEFT) {
						
					} else
					if (condition != STAY_RIGHT) {
						condition = STAY_RIGHT;
						changedCondition = true;
					}
				} else 
				if (!Platformer.PlayerCanJump) {
					if (ballBody.GetLinearVelocity().y < 0) {
						if (ballBody.GetLinearVelocity().x > 0) {
							if (condition != JUMP_UP_RIGHT) {
								condition = JUMP_UP_RIGHT;
								changedCondition = true;
							}
						} else
						if (condition != JUMP_UP_LEFT) {
							condition = JUMP_UP_LEFT;
							changedCondition = true;
						}
					} else 
					if (ballBody.GetLinearVelocity().x > 0) {
						if (condition != JUMP_DOWN_RIGHT && ballUp.currentFrame == 8) {//20
							condition = JUMP_DOWN_RIGHT;
							changedCondition = true;
						}
					} else
					if (condition != JUMP_DOWN_LEFT && ballUpLeft.currentFrame == 8) {//20
						condition = JUMP_DOWN_LEFT;
						changedCondition = true;
					}
				}
				
				
				if (ballBody.IsSleeping()) {
					if (condition != STAY_RIGHT && condition != STAY_LEFT) {
						if (condition == JUMP_DOWN_LEFT || condition == JUMP_UP_LEFT || condition == GO_LEFT) {
							condition = STAY_LEFT;
							changedCondition = true;
						} else
						if (condition == JUMP_DOWN_RIGHT || condition == JUMP_UP_RIGHT || condition == GO_RIGHT) {
							condition = STAY_RIGHT;
							changedCondition = true;
						}
					}
				}
				
				//trace(condition + " " + umbrellaRight.currentFrame);
			}
			if (changedCondition) {
				switch (condition) 
				{
				case GO_RIGHT:
					ballStatic.gotoAndPlay(16);
					ballStay.visible = false;
					ballStayLeft.visible = false;
					ballStatic.visible = true;
					ballStaticLeft.visible = false;
					ballUp.visible = false;
					ballUpLeft.visible = false;
					ballDown.visible = false;
					ballDownLeft.visible = false;
					umbrellaRight.visible = false;
					umbrellaLeft.visible = false;
					redSplash.visible = false;
				break;
				case GO_LEFT:
					ballStaticLeft.gotoAndPlay(16);
					ballStay.visible = false;
					ballStayLeft.visible = false;
					ballStatic.visible = false;
					ballStaticLeft.visible = true;
					ballUp.visible = false;
					ballUpLeft.visible = false;
					ballDown.visible = false;
					ballDownLeft.visible = false;
					umbrellaRight.visible = false;
					umbrellaLeft.visible = false;
					redSplash.visible = false;
				break;
				case JUMP_DOWN_RIGHT:
					ballDown.gotoAndPlay(1);
					ballStay.visible = false;
					ballStayLeft.visible = false;
					ballStatic.visible = false;
					ballStaticLeft.visible = false;
					ballUp.visible = false;
					ballUpLeft.visible = false;
					ballDown.visible = true;
					ballDownLeft.visible = false;
					umbrellaRight.visible = false;
					umbrellaLeft.visible = false;
					redSplash.visible = false;
				break;
				case JUMP_DOWN_LEFT:
					ballDownLeft.gotoAndPlay(1);
					ballStay.visible = false;
					ballStayLeft.visible = false;
					ballStatic.visible = false;
					ballStaticLeft.visible = false;
					ballUp.visible = false;
					ballUpLeft.visible = false;
					ballDown.visible = false;
					ballDownLeft.visible = true;
					umbrellaRight.visible = false;
					umbrellaLeft.visible = false;
					redSplash.visible = false;
				break;
				case JUMP_UP_RIGHT:
					ballUp.gotoAndPlay(1);
					ballStay.visible = false;
					ballStayLeft.visible = false;
					ballStay.visible = false;
					ballStayLeft.visible = false;
					ballStatic.visible = false;
					ballStaticLeft.visible = false;
					ballUp.visible = true;
					ballUpLeft.visible = false;
					ballDown.visible = false;
					ballDownLeft.visible = false;
					umbrellaRight.visible = false;
					umbrellaLeft.visible = false;
					redSplash.visible = false;
				break;
				case JUMP_UP_LEFT:
					ballUpLeft.gotoAndPlay(1);
					ballStay.visible = false;
					ballStayLeft.visible = false;
					ballStatic.visible = false;
					ballStaticLeft.visible = false;
					ballUp.visible = false;
					ballUpLeft.visible = true;
					ballDown.visible = false;
					ballDownLeft.visible = false;
					umbrellaRight.visible = false;
					umbrellaLeft.visible = false;
					redSplash.visible = false;
				break;
				case STAY_RIGHT:
					ballStay.visible = true;
					ballStayLeft.visible = false;
					ballStatic.visible = false;
					ballStaticLeft.visible = false;
					ballUp.visible = false;
					ballUpLeft.visible = false;
					ballDown.visible = false;
					ballDownLeft.visible = false;
					umbrellaRight.visible = false;
					umbrellaLeft.visible = false;
					redSplash.visible = false;
				break;
				case STAY_LEFT:
					ballStay.visible = false;
					ballStayLeft.visible = true;
					ballStatic.visible = false;
					ballStaticLeft.visible = false;
					ballUp.visible = false;
					ballUpLeft.visible = false;
					ballDown.visible = false;
					ballDownLeft.visible = false;
					umbrellaRight.visible = false;
					umbrellaLeft.visible = false;
					redSplash.visible = false;
				break;
				case UMBRELLA_RIGHT:
					ballStay.visible = false;
					ballStayLeft.visible = false;
					ballStatic.visible = false;
					ballStaticLeft.visible = false;
					ballUp.visible = false;
					ballUpLeft.visible = false;
					ballDown.visible = false;
					ballDownLeft.visible = false;
					umbrellaRight.gotoAndPlay(1);
					umbrellaLeft.visible = false;
					umbrellaRight.visible = true;
					redSplash.visible = false;
				break;
				case UMBRELLA_LEFT:
					ballStay.visible = false;
					ballStayLeft.visible = false;
					ballStatic.visible = false;
					ballStaticLeft.visible = false;
					ballUp.visible = false;
					ballUpLeft.visible = false;
					ballDown.visible = false;
					ballDownLeft.visible = false;
					umbrellaRight.visible = false;
					umbrellaLeft.visible = true;
					redSplash.visible = false;
					umbrellaLeft.gotoAndPlay(1);
				break;
				case RED_SPLASH:
					ballStay.visible = false;
					ballStayLeft.visible = false;
					ballStatic.visible = false;
					ballStaticLeft.visible = false;
					ballUp.visible = false;
					ballUpLeft.visible = false;
					ballDown.visible = false;
					ballDownLeft.visible = false;
					umbrellaRight.visible = false;
					umbrellaLeft.visible = false;
					redSplash.visible = true;
					redSplash.gotoAndPlay(1);
				break;
				default: trace("sh!t");
				}
			}
			changedCondition = false;
			var goldenSection:Point;
			goldenY = Platformer._ballActor.getSpriteLoc().y - 18.144;
			//trace(lastY + " " + currentY + " " + goldenY + " " + camKoef2 + " " + Platformer._camera.stage.height + " " + Platformer._ballActor.getSpriteLoc().y);
			if (condition < 4 && condition > -4) {//костыль?!
				if (currentY != goldenY) {
					lastY = goldenY;
					currentY = goldenY;
					camKoef2 = 1;
				} else {
					if (lastY < goldenY) {
						lastY += Math.abs(lastY - goldenY) * camKoef2;
						//trace(Math.abs(lastY - goldenY) * camKoef2);
					} else {
						lastY -= Math.abs(lastY - goldenY) * camKoef2;
						//trace(-Math.abs(lastY - goldenY) * camKoef2);
					}
					if (camKoef2 > 0.02) {
						camKoef2 -= 0.01;
					} else {
						camKoef2 = 0;
					}
				}
				middleY = goldenY + Math.abs(lastY - goldenY) * camKoef;
			} else {
				if (lastY < goldenY) {
					lastY += Math.abs(lastY - goldenY) * camKoef2;
					//trace(Math.abs(lastY - goldenY) * camKoef2);
				} else {
					lastY -= Math.abs(lastY - goldenY) * camKoef2;
					//trace(-Math.abs(lastY - goldenY) * camKoef2);
				}
				if (camKoef2 > 0.02) {
					camKoef2 -= 0.001;
				} else {
					camKoef2 = 0;
				}
				middleY = goldenY + Math.abs(currentY - goldenY) * camKoef;
			}
			/*if ((goldenY / Math.abs(goldenY)) > 0) {
				middleY = goldenY + (goldenY / Math.abs(goldenY)) * Math.abs(currentY - goldenY) * camKoef;
			} else {
				middleY = goldenY - (goldenY / Math.abs(goldenY)) * Math.abs(currentY - goldenY) * camKoef;
			}*/
			goldenSection = new Point(Platformer._ballActor.getSpriteLoc().x, middleY);
			previousVelocity15 = previousVelocity14.Copy();
			previousVelocity14 = previousVelocity13.Copy();
			previousVelocity13 = previousVelocity12.Copy();
			previousVelocity12 = previousVelocity11.Copy();
			previousVelocity11 = previousVelocity10.Copy();
			previousVelocity10 = previousVelocity9.Copy();
			previousVelocity9 = previousVelocity8.Copy();
			previousVelocity8 = previousVelocity7.Copy();
			previousVelocity7 = previousVelocity6.Copy();
			previousVelocity6 = previousVelocity5.Copy();
			previousVelocity5 = previousVelocity4.Copy();
			previousVelocity4 = previousVelocity3.Copy();
			previousVelocity3 = previousVelocity2.Copy();
			previousVelocity2 = previousVelocity1.Copy();
			previousVelocity1 = previousVelocity0.Copy();
			previousVelocity0 = Platformer._ballActor._body.GetLinearVelocity().Copy();
			var previous:Point = new Point(
			previousVelocity0.x + 
			previousVelocity1.x + 
			previousVelocity2.x + 
			previousVelocity3.x + 
			previousVelocity4.x + 
			previousVelocity5.x + 
			previousVelocity6.x + 
			previousVelocity7.x + 
			previousVelocity8.x + 
			previousVelocity9.x + 
			previousVelocity10.x + 
			previousVelocity11.x + 
			previousVelocity12.x + 
			previousVelocity13.x + 
			previousVelocity14.x + 
			previousVelocity15.x, 
			previousVelocity0.y + 
			previousVelocity1.y + 
			previousVelocity2.y + 
			previousVelocity3.y + 
			previousVelocity4.y + 
			previousVelocity5.y + 
			previousVelocity6.y + 
			previousVelocity7.y + 
			previousVelocity8.y + 
			previousVelocity9.y + 
			previousVelocity10.y + 
			previousVelocity11.y + 
			previousVelocity12.y + 
			previousVelocity13.y + 
			previousVelocity14.y + 
			previousVelocity15.y);
			var groveSection:Point = new Point(Platformer._ballActor.getSpriteLoc().x + previous.x / 3, 
											   Platformer._ballActor.getSpriteLoc().y + previous.y / 3);
			var purpleSection:Point = new Point(Platformer._ballActor.getSpriteLoc().x,  
												Platformer._ballActor.getSpriteLoc().y - previous.y / 3);
			var lazySection:Point = new Point(Platformer._ballActor.getSpriteLoc().x - previous.x / 3,  
											  Platformer._ballActor.getSpriteLoc().y - previous.y / 3);
			var greenSection = new Point(Platformer._ballActor.getSpriteLoc().x,  groveSection.y - 18.144);
			var section:Point = greenSection;
			/*switch (Platformer.ShowMap) 
			{
				case 0:
					section = lazySection;
				break;
				case 1:
					section = groveSection;
				break;
				case 2:
					section = groveSection;
				break;
			default:
				trace("showmap balla error");
			}*/
			Platformer._camera.zoomTo(section, 0.3);//0.9
			Platformer._cameraOne.zoomTo(section, 1);
			Platformer._camera2.zoomTo(section, 0.6);//1/1.7
			Platformer._camera3.zoomTo(section, 0.6);//?
			Platformer._camera4.zoomTo(section, 0.6);//?
			Platformer._camera9.zoomTo(section, 0.6);//?
			Platformer._camera10.zoomTo(section, 0.6);//?
			Platformer._camera5.zoomTo(section, 0.6);//?
			Platformer._camera6.zoomTo(new Point(section.x * 0.2, section.y * 0.2), 0.6);//?
			Platformer._camera7.zoomTo(new Point(section.x * 0.2, section.y * 0.2), 0.6);//?
			Platformer._camera8.zoomTo(new Point(section.x * 0.2, section.y * 0.2), 0.6);//?
			renderArea.x = section.x;
			renderArea.y = section.y;
			if (Platformer.myTimer.currentCount % 10 == 0) {//25
				for each (var bitmap:Bitmap in LevelDirector._levelPieces) {
					if (renderArea.getRect(Platformer._cameraStaticLayer).intersects(bitmap.getRect(Platformer._cameraStaticLayer))) {
						if (bitmap.visible == false) {
							bitmap.visible = true;
							//Platformer._cameraStaticLayer1.addChild(bitmap);
						}
						//Platformer.superString += "true";
					} else {
						if (bitmap.visible == true) {
							bitmap.visible = false;
							//bitmap.parent.removeChild(bitmap);
						}
						//Platformer.superString += "false";
					}
				}
			}
			
			if (Platformer.Left) {//If Left Arrow is down
				if (ballBody.GetLinearVelocity().x > -7.0) {
					//ballBody.WakeUp();
					ballBody.ApplyForce(new b2Vec2( -2.0, 0.0), ballBody.GetWorldCenter()); //-1.0 0.0
				}
			}
			if (Platformer.Right) {//If right arrow is down
				if (ballBody.GetLinearVelocity().x < 7.0) {
					//ballBody.WakeUp();
					//Body.m_linearVelocity.x = 0.5;//Adds to the linearVelocity of the box.
					ballBody.ApplyForce(new b2Vec2(2.0, 0.0), ballBody.GetWorldCenter()); //1.0 0.0
				}
			}
			if (Platformer.Up) {
				if (Platformer.PlayerCanJump) {
					ballBody.ApplyImpulse(jumpImpulse, ballBody.GetWorldCenter());//0.0  -0.27 jumpImpulse
					jump();
					impulseReducer = 0;
				} else if (jumpTimeLeft) {
					if (impulseReducer < 0) {
						impulseReducer = 0;
					}
					var jumpForceReduced:b2Vec2 = new b2Vec2(jumpForce.x, jumpForce.y + 0.3 * impulseReducer);//0.3
					ballBody.ApplyForce(jumpForceReduced, ballBody.GetWorldCenter());//выполнится <= 12 раз
					//trace(jumpForceReduced.y);
					impulseReducer++;
				}/* else if (ballBody.GetLinearVelocity().y > 0) {
					if (!Platformer.Umbrella) {
						Platformer.Umbrella = true;
					}
				}*/
				if (Platformer.PlayerLeftWallJump) {
					ballBody.ApplyImpulse(leftWallJumpImpulse, ballBody.GetWorldCenter());//-0.2 -0.27
				} else
				if (Platformer.PlayerRightWallJump) {
					ballBody.ApplyImpulse(rightWallJumpImpulse, ballBody.GetWorldCenter());//0.2 -0.27
				}
			} else {
				if (jumpTimeLeft) {
					jumpTimeLeft = 0;
				}
				if (impulseReducer > 0) {
					impulseReducer = 0;
				}/*
				if (Platformer.Umbrella) {
					Platformer.Umbrella = false;
				}*/
			}
			if (Platformer.Down) {
				ballBody.ApplyImpulse(new b2Vec2(0.0, 0.05), ballBody.GetWorldCenter()); 
			}
			if (Platformer.Fly) {
				Platformer.jetpackTime--;
				ballBody.ApplyForce(new b2Vec2(0.0, -1.8), ballBody.GetWorldCenter()); ///-0.8
			}
			if (Platformer.Umbrella){
				ballBody.m_linearDamping = 3;
			} else {
				ballBody.m_linearDamping = 0;
			}
			var notPressedAnyButton:Boolean = !Platformer.Up && !Platformer.Left && !Platformer.Right && !Platformer.Down && !Platformer.Fly;
			var speedIsSmall:Boolean = (ballBody.GetLinearVelocity().x < 9) && (ballBody.GetLinearVelocity().x > -9);
			if (notPressedAnyButton && Platformer.PlayerCanJump && speedIsSmall) {
				ballBody.PutToSleep();
			}
			//Body.m_sweep.a = 0;//This is what stops the player from rotating
			super.childSpecificUpdating();
		}
		
		private function jump():void 
		{
			jumpTimeLeft = jumpTime;
		}
	}
}
package  
{
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Collision.Shapes.b2FilterData;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactResult;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class NewContactListener extends b2ContactListener
	{
		private var ballForce:b2Vec2 = new b2Vec2(0, -3.5);
		private var bulletForce:b2Vec2 = new b2Vec2(0, -0.5);
		
		public function NewContactListener() 
		{
			
		}
		public static function someShit(contact:b2Contact):void
		{
			var actor1:Actor = contact.m_shape1.m_body.GetUserData();
			var actor2:Actor = contact.m_shape2.m_body.GetUserData();
			var arbi:ArbiStaticActor;
			if (actor1 is ArbiStaticActor && actor2 is BallActor) {
				arbi = ArbiStaticActor(actor1);
				if (contact.m_shape1.m_body.GetWorldCenter().y < contact.m_shape2.m_body.GetWorldCenter().y) {//shit!
					contact.m_shape1.m_isSensor = true;
				}
			} else if (actor2 is ArbiStaticActor && actor1 is BallActor) {
				arbi = ArbiStaticActor(actor2);
				if (contact.m_shape1.m_body.GetWorldCenter().y > contact.m_shape2.m_body.GetWorldCenter().y) {//shit!
					contact.m_shape2.m_isSensor = true;
				}
			}
		}
		/*override public function Add(point:b2ContactPoint):void 
		{
			var actor1:Actor = point.shape1.GetBody().GetUserData();
			var actor2:Actor = point.shape2.GetBody().GetUserData();
			var arbi:ArbiStaticActor;
			if (actor1 is ArbiStaticActor && actor2 is BallActor) {
				arbi = ArbiStaticActor(actor1);
			} else if (actor2 is ArbiStaticActor && actor1 is BallActor) {
				arbi = ArbiStaticActor(actor2);
			}
			if (point.normal.y > 0) {
				//ArbiStaticActor(arbi)._body.GetShapeList().m_isSensor = true;
				//var filter:b2FilterData = arbi._body.GetShapeList().GetFilterData();
				//filter.groupIndex = -3;
				if (actor1 is ArbiStaticActor) {
					//point.shape1.GetBody().GetShapeList().m_isSensor = true;
				} else if (actor2 is ArbiStaticActor) {
					//point.shape2.GetBody().GetShapeList().m_isSensor = true;
					//point.shape2.GetBody().GetShapeList().SetFilterData(filter);
				}
				//arbi._body.GetShapeList().SetFilterData(filter);
			}
			super.Add(point);
		}*/
		override public function Persist(point:b2ContactPoint):void 
		{
			var actor1:Actor = point.shape1.GetBody().GetUserData();
			var actor2:Actor = point.shape2.GetBody().GetUserData();
			
			//вода
			if (actor1 is ArbiStaticActor) {
				archimedesForce(ArbiStaticActor(actor1), point.shape2.GetBody());
			} else if (actor2 is ArbiStaticActor) {
				archimedesForce(ArbiStaticActor(actor2), point.shape1.GetBody());
			}
			//игрок берёт ключ
			if (actor1 is BallActor) {
				if (actor2 is CircleStaticActor) {
					keyGet(CircleStaticActor(actor2));
				} else if (actor2 is ArbiStaticActor) {
					//if ((BallActor(actor1)._body.GetWorldCenter().y * 30) - (ArbiStaticActor(actor2)._body.GetWorldCenter().y * 30) > 20) {
					
				}
			} else if (actor2 is BallActor) {
				if (actor1 is CircleStaticActor) {
					keyGet(CircleStaticActor(actor1));
				} else if (actor1 is ArbiStaticActor) {
					//if ((BallActor(actor2)._body.GetWorldCenter().y * 30) - (ArbiStaticActor(actor1)._body.GetWorldCenter().y * 30) > 20) {
					/*if (point.normal.y > 0) {
						ArbiStaticActor(actor1)._body.GetShapeList().m_isSensor = true;
					}*/
				}
			}
			//?что-то здесь было
			super.Persist(point);
		}
		
		private function keyGet(key:CircleStaticActor):void 
		{
			if (key.type == CircleStaticActor.KEY) {
				Platformer.handleKeyNum = key.keyNumber;
			} else if (key.type == CircleStaticActor.CHECKPOINT) {
				Platformer.handleKeyNum = key.keyNumber;
			}
		}
		
		private function archimedesForce(water:ArbiStaticActor, body:b2Body):void 
		{
			if (water.type == ArbiStaticActor.WATER) {
				if (body.GetUserData() is BallActor) {
					body.ApplyForce(ballForce, body.GetWorldCenter());
					body.m_linearDamping = 1.5;
				} else 
				if (body.GetUserData() is Bullet) {
					body.ApplyForce(bulletForce, body.GetWorldCenter());
					body.m_linearDamping = 5;
				} else 
				if (body.GetUserData() is WaterBall) {
					body.ApplyForce(ballForce, body.GetWorldCenter());
					body.m_linearDamping = 5;
				}
			}
		}
		
		override public function Result(point:b2ContactResult):void 
		{
			var actor1:Actor = point.shape1.GetBody().GetUserData();
			var actor2:Actor = point.shape2.GetBody().GetUserData();
			if (actor1 is BallActor) {
				if (actor2 is ArbiStaticActor) {
					ballHitsArbi(ArbiStaticActor(actor2), point);
				} else 
				if (actor2 is Enemy) {
					ballHitsEnemy(BallActor(actor1), Enemy(actor2), point);
				} else
				if (actor2 is CircleStaticActor) {
					if (CircleStaticActor(actor2).type == CircleStaticActor.ENEMY) {
						BallActor.splash();
						//Platformer.remakeBallTrue = true;
					}
				}
			} else 
			if (actor2 is BallActor) {
				if (actor1 is ArbiStaticActor) {
					ballHitsArbi(ArbiStaticActor(actor1), point);
				} else 
				if (actor1 is Enemy) {
					ballHitsEnemy(BallActor(actor2), Enemy(actor1), point);
				} else 
				if (actor1 is CircleStaticActor) {
					if (CircleStaticActor(actor1).type == CircleStaticActor.ENEMY) {
						BallActor.splash();
						//Platformer.remakeBallTrue = true;
					}
				}
			}
			if (actor1 is Bullet) {
				Platformer.deleteThisBullet = Bullet(actor1).numbOfThisBullet;
			} else 
			if (actor2 is Bullet) {
				Platformer.deleteThisBullet = Bullet(actor2).numbOfThisBullet;
			}
			
			super.Result(point);
		}
		
		private function handleJumps(normal:b2Vec2, typeOfArbi:int):void
		{
			if (!Platformer.PlayerCanJump) {
				if (normal.x > -0.72 && normal.x < 0.72 && normal.y < 0) {//горизонтальные поверхности, >-0.72 <0.72 <0 для круглого
					if (!Platformer.PlayerLeftWallJump && !Platformer.PlayerRightWallJump){
						Platformer.PlayerCanJump = true;
					}
				} else 
				if (normal.y > -0.72 && normal.y < 0.72) {
					if (normal.x < 0) {//левая стенка
						if (typeOfArbi != ArbiStaticActor.HAT) {
							Platformer.PlayerLeftWallJump = true;
						}
					}
					else 
					if (normal.x > 0) {//правая стенка
						if (typeOfArbi != ArbiStaticActor.HAT) {
							Platformer.PlayerRightWallJump = true;
						}
					}
				}
			}
		}
		
		private function ballHitsArbi(arbi:ArbiStaticActor, point:b2ContactResult):void
		{
			handleJumps(point.normal, arbi.type);
			if (arbi.type == ArbiStaticActor.CLOUD) {
				arbi.cloud.cloudHide();
			} else 
			if (arbi.type == ArbiStaticActor.ENEMY) {
				BallActor.splash();
				//Platformer.remakeBallTrue = true;
			} else 
			if (arbi.type == ArbiStaticActor.END_LEVEL) {
				//trace("stop level");
				Platformer.stopLevel = true;
			}
			
		}
		
		private function ballHitsEnemy(ball:BallActor, enemy:Enemy, point:b2ContactResult):void
		{
			if (enemy.type == Enemy.FROM_BELOW) {
				if (point.normal.y > 0.5) {
					Platformer.safeDeleteEnemy(enemy.enemyNumber);
					ball.ballBody.ApplyImpulse(
							new b2Vec2(0, -0.4), 
							ball.ballBody.GetWorldCenter());
					//Platformer(Platformer._camera.parent).addLive();
				} else {
					if (Platformer.removeLiveTime == 0) {
						Platformer(Platformer._camera.parent).removeLive();
					}
				}
			} else {
				if (point.normal.y < -0.5) {
					Platformer.safeDeleteEnemy(enemy.enemyNumber);
					ball.ballBody.ApplyImpulse(
							new b2Vec2(0, -0.4), 
							ball.ballBody.GetWorldCenter());
					//Platformer(Platformer._camera.parent).addLive();
				} else {
					if (enemy.type == Enemy.PUSH_AND_SMASH) {
						if (point.normal.x > 0.5 || point.normal.x < -0.5) {
							Enemy(Platformer._enemies[enemy.enemyNumber]).noShieldTimer = 100;
						} else if (point.normal.y < -0.5) {
							if (Enemy(Platformer._enemies[enemy.enemyNumber]).noShieldTimer > 0) {
								Platformer.safeDeleteEnemy(enemy.enemyNumber);
							} else {
								Platformer(Platformer._camera.parent).removeLive();
							}
						}
					} else if (Platformer.removeLiveTime == 0) {
						Platformer(Platformer._camera.parent).removeLive();
					}
				}
			}
		}
		
		override public function Remove(point:b2ContactPoint):void 
		{
			var actor1:Actor = point.shape1.GetBody().GetUserData();
			var actor2:Actor = point.shape2.GetBody().GetUserData();
			if (actor1 is ArbiStaticActor) {
				if (ArbiStaticActor(actor1).type == ArbiStaticActor.WATER) {
					point.shape2.GetBody().m_linearDamping = 0;
				}
			} else 
			if (actor2 is ArbiStaticActor) {
				if (ArbiStaticActor(actor2).type == ArbiStaticActor.WATER) {
					point.shape1.GetBody().m_linearDamping = 0;
				}
			}
			Platformer.PlayerCanJump = false;
			Platformer.PlayerLeftWallJump = false;
			Platformer.PlayerRightWallJump = false;
			super.Remove(point);
		}
	}
}
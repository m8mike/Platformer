package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import com.touchmypixel.peepee.utils.Animation;
	import com.touchmypixel.peepee.utils.AnimationCache;
	import fl.motion.Motion;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class Platformer extends Sprite
	{
		public static var thisIs:Platformer;
		
		public static var levelNow:int = -1;
		public static var levelsOpen:int = 5;
		public static var ballIsHere:Boolean = false;
		//public static var remakeBallTrue:Boolean = false;
		public static var makeBallTrue:Boolean = false;
		public static var stopLevel:Boolean = false;
		public static var deleting:Boolean = false;
		public static var deleteEnemy:int = -1;
		public static var hideCloud:int = -1;
		public static var needToStartLevel:int = -1;
		public static var handleKeyNum:int = -1;
		public static var cannonCount:int = 0;
		public static var score:int = 0;
		
		public static var _ballActor:BallActor;
		
		public static var _allActors:Array = [];
		public static var _clouds:Array = [];
		public static var _enemies:Array = [];
		public static var _lifes:Array = [];
		public static var _keys:Array = [];
		public static var _actorsToRemove:Array = [];
		public static var _waterBalls:Array = [];
		//public static var _levSelMCs:Array = [];
		
		public static var _camera:Camera;
		public static var _cameraOne:Camera;
		public static var _cameraTwo:Camera;
		public static var _camera2:Camera;
		public static var _camera3:Camera;
		public static var _camera4:Camera;
		public static var _camera5:Camera;
		public static var _camera6:Camera;
		public static var _camera7:Camera;
		public static var _camera8:Camera;
		public static var _camera9:Camera;
		public static var _camera10:Camera;
		public static var _cameraLoading:Camera;
		
		public static var _cameraStaticLayer:Camera;
		public static var _cameraStaticLayer1:Camera;
		public static var _cameraDynamicLayer:Camera;
		
		public static var PlayerCanJump:Boolean = false;
		public static var PlayerLeftWallJump:Boolean;
		public static var PlayerRightWallJump:Boolean;
		
		public static var Left:Boolean = false;
		public static var Right:Boolean = false;
		public static var Up:Boolean = false;
		public static var Down:Boolean = false;
		
		public static var Umbrella:Boolean = false;
		public static var ShowMap:int = 0;
		public static var mapIsShown:Boolean = false;
		public static var Fly:Boolean = false;
		public static var jetpackTime:int = 0;
		public static var ShootCannon:Boolean = false;
		public static var removeLiveTime:int = 0;
		
		public static var _cannon:Cannon;
		public static var _cannon2:Cannon;
		public static var _cannonShotgun:Cannon;
		
		public static var deleteThisBullet:int = -1;
		public static var thereIsAGun:Boolean = false;
		
		public static var childCounter:int = 0;
		public static var superString:String = "";
		public static var myTimer:Timer;
		
		private const LAUNCH_POINT:Point = new Point(500, 100);
		private const LAUNCH_POINT2:Point = new Point(1000, 100);
		public static var LAUNCH_POINT_PLAYER:Point = new Point(80, -50);//300, 100);//16*30
		private const LAUNCH_POINT_PLAYER2:Point = new Point(200, 10);
		public static const MAX_LIFES:int = 5;
		private var key1:CircleStaticActor;
		private var key2:CircleStaticActor;
		public static var e1:Enemy;
		public static var e2:Enemy;
		public static var e3:Enemy;
		public static var c1:Cloud;
		public static var c2:Cloud;
		public static var c3:Cloud;
		public static var w1:Cloud;
		public static var w2:Cloud;
		public static var w3:Cloud;
		private var time:int;
		private var periods : int = 0;
		private var leftButton:Sprite;
		private var rightButton:Sprite;
		
		public function Platformer() 
		{
			thisIs = this;
			createMenu();
		}
		
		public function createMenu():void 
		{
			var levSel:LevelSelectionMC = LevelSelectionMC.getInstance(levelsOpen);
			thisIs.addLoadingScreen();
			thisIs.addEventListener(Event.ENTER_FRAME, onChangeLevel);
		}
		
		public function addLoadingScreen():void 
		{
			LevelDirector.screen = new loadingBackground();
			LevelDirector.screen.x = 0;
			LevelDirector.screen.y = 0;
			LevelDirector.screen.scaleX = 0.8;
			LevelDirector.screen.scaleY = 0.8;
			LevelDirector.screen.gotoAndStop(1);
			LevelDirector.screen.visible = false;
			if (_cameraLoading) {
				while (_cameraLoading.numChildren) {
					_cameraLoading.removeChildAt(0);
				}
				if (_cameraLoading.parent) {
					_cameraLoading.parent.removeChild(_cameraLoading);
				}
			}
			_cameraLoading = new Camera(1);
			this.addChild(_cameraLoading);
			_cameraLoading.addChild(LevelDirector.screen);
			//Platformer._camera.addEventListener(Event.ENTER_FRAME, checkForRemovingLoadingScreen);
		}
		public function onChangeLevel(e:Event):void 
		{
			if (needToStartLevel == 100) {
				startEditedLevel();
				needToStartLevel = -1;
			}
			if (needToStartLevel != -1) {
				//clearMenu();
				LevelSelectionMC.hide();
				startLevel(needToStartLevel);
				needToStartLevel = -1;
			}
		}
		
		private function initCameras():void
		{
			_camera8 = new Camera(1);
			_camera7 = new Camera(2);
			_camera6 = new Camera(3);
			this.addChildAt(_camera6, 1);
			this.addChildAt(_camera7, 2);
			this.addChildAt(_camera8, 3);
			_camera9 = new Camera(0.3);
			this.addChildAt(_camera9, 4);
			_camera10 = new Camera(0.4);
			this.addChildAt(_camera10, 5);
			_camera4 = new Camera(0.5);
			this.addChildAt(_camera4, 6);
			_camera5 = new Camera(0.75);
			this.addChildAt(_camera5, 7);
			_camera3 = new Camera(1);
			this.addChildAt(_camera3, 8);
			_camera2 = new Camera(2);
			this.addChildAt(_camera2, 9);
			if (levelNow == 11) {//editor
				_camera = new Camera(1);
			} else {
				_camera = new Camera(0.1);//10
			}
			this.addChildAt(_camera, 10);
			_cameraOne = new Camera(1);
			this.addChildAt(_cameraOne, 11);
			_cameraTwo = new Camera(1);
			this.addChildAt(_cameraTwo, 12);
			_cameraStaticLayer = new Camera(1);
			_camera.addChild(_cameraStaticLayer);
			_cameraStaticLayer1 = new Camera(1);
			_camera.addChild(_cameraStaticLayer1);
			_cameraDynamicLayer = new Camera(1);
			_camera.addChild(_cameraDynamicLayer);
			/*
			var rectangleInOldStyle:Sprite = new Sprite();
			rectangleInOldStyle.graphics.beginFill(0xFF9C6C);
			rectangleInOldStyle.blendMode = BlendMode.DIFFERENCE;
			rectangleInOldStyle.graphics.drawRect( -200, -200, 1000, 1000);
			rectangleInOldStyle.graphics.endFill();
			this.addChild(rectangleInOldStyle);
			*/
		}
		
		public function startLevel(level:int):void 
		{
			levelNow = level + 1;
			initCameras();
			if (level != 10) {
				setupPhysicsWorld();
				makeBall();
			}
			LevelDirector.createLevel(level);
			/*switch (level) {
				case 0: LevelDirector.createLevel1(); break;
				case 1: LevelDirector.createLevel2(); break;
				case 2: LevelDirector.createLevel3(); break;
				case 3: LevelDirector.createLevel4(); break;
				case 4: LevelDirector.createLevel5(); break;
				case 5: LevelDirector.createLevel6(); break;
				case 6: LevelDirector.createLevel7(); break;
				case 7: LevelDirector.createLevel8(); break;
				case 10: launchEditor(); break;
				default: LevelDirector.createLevel9();
			}*/
			if (level != 10) {
				setupTimers();
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
				addEventListener(Event.ENTER_FRAME, newEventListener);
				stage.addEventListener(Event.DEACTIVATE, deactivation);
				stage.addEventListener(Event.ACTIVATE, activation);
				addLife();
				addLife();
				addLife();
				
				leftButton = new Sprite();
				leftButton.graphics.beginFill(0xFF0000, 0);
				leftButton.graphics.drawRect(-200, 0, 200+640 / 2, 480);
				leftButton.graphics.endFill();
				leftButton.addEventListener(MouseEvent.MOUSE_DOWN, touchQ);
				leftButton.addEventListener(MouseEvent.MOUSE_UP, endTouchQ);
				leftButton.addEventListener(MouseEvent.MOUSE_OUT, endTouchQ);
				this.addChild(leftButton);
				rightButton = new Sprite();
				rightButton.graphics.beginFill(0x00FF00, 0);
				rightButton.graphics.drawRect(640 / 2, 0, 200+640 / 2, 480);
				rightButton.graphics.endFill();
				rightButton.addEventListener(MouseEvent.MOUSE_DOWN, touchE);
				rightButton.addEventListener(MouseEvent.MOUSE_UP, endTouchE);
				rightButton.addEventListener(MouseEvent.MOUSE_OUT, endTouchE);
				this.addChild(rightButton);
			}
			/*for (var k:int = 0; k < this.numChildren; k++) {
				if (this.getChildAt(k) is levelSelectMc) {
					this.removeChildAt(k);
				}
			}*/
			//childCounter = 0;
			//countChildren(this);
			//trace("childCounter=" + childCounter);
			/*trace(this.width);
			trace(this.height);
			trace(stage.width);
			trace(stage.height);*/
			
			/*for each (var bitmap:Bitmap in _levelPieces) {
				var rect:Rectangle = bitmap.getRect(bitmap.parent);
				superString += "x = " + rect.x + ", y = " + rect.y + ", w = " + rect.width + ", h = " + rect.height + "\n";
			}
			var file:FileReference = new FileReference();
			try {
				file.save(superString, "text.txt");
			}
			catch (e:Error) { trace(e) }*/
		}
		
		private function endTouchE(e:MouseEvent):void 
		{
			Right = false;
			Up = false;
		}
		
		private function endTouchQ(e:MouseEvent):void 
		{
			Left = false;
			Up = false;
		}
		
		private function touchE(e:MouseEvent):void 
		{
			Right = true;
			Up = true;
		}
		
		private function touchQ(e:MouseEvent):void 
		{
			Left = true;
			Up = true;
		}
		
		private function setupTimers():void 
		{
			myTimer = new Timer(200);
			myTimer.addEventListener(TimerEvent.TIMER, timerListener);
			time = 0;
			function timerListener (e:TimerEvent):void {
				time += 0.2;
				//timeNumbText.text = time.toString();
				if (BallActor.jumpTimeLeft > 0) {
					BallActor.jumpTimeLeft--;
				}
			}
			
			var timeNumbText:TextField = new TextField();
			timeNumbText.x = 0;
			timeNumbText.y = 0;
			timeNumbText.visible = true;
			timeNumbText.scaleX = 2;
			timeNumbText.scaleY = 2;
			timeNumbText.selectable = false;
			timeNumbText.text = "0"; // Platformer.childCounter.toString();
			stage.addChild(timeNumbText);
			myTimer.start();
			
			var timer : Timer = new Timer( 1000 );
			timer.addEventListener( TimerEvent.TIMER, function( ... args ) : void
			{
				timeNumbText.text = periods.toString();
				//timeNumbText.text = jetpackTime.toString();
				//timeNumbText.text = CircleStaticActor.keysCount.toString();
				//timeNumbText.text = RandomMap.playerIcon.x + " " + RandomMap.playerIcon.y;
				//timeNumbText.text = BallActor.renderArea.x.toString() + " " + BallActor.renderArea.y.toString();
				periods = 0;
			} );
			timer.start();
		}
		/*
		public static function launchEditor():void 
		{
			new LevelEditor(_camera);
		}
		*/
		private function startEditedLevel():void
		{
			initCameras();
			setupPhysicsWorld();
			makeBall();
			for each (var r:RectInRed in LevelEditor._arrRect) {
				r.makeIt();
			}
			LevelDirector.addBackground();
			trace("camera static layer: " + _cameraStaticLayer.numChildren);
			LevelDirector.rasterizeAll();
			setupTimers();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			addEventListener(Event.ENTER_FRAME, newEventListener);
			stage.addEventListener(Event.DEACTIVATE, deactivation);
			stage.addEventListener(Event.ACTIVATE, activation);
			addLife();
			addLife();
			addLife();
			_camera.ZOOM_IN_AMT = 10;
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			//trace(e.keyCode);
			switch (e.keyCode) {
				case 77 ://m
					if (levelNow == 4) {
						if (!mapIsShown) {
							if (ShowMap >= 2) {
								ShowMap = 0;
							} else {
								ShowMap++;
							}
							switch (ShowMap) 
							{
								case 0:
									this.removeChild(LevelDirector._rm);
								break;
								case 1:
									LevelDirector._rm.scaleX = 1;
									LevelDirector._rm.scaleY = 1;
									this.addChild(LevelDirector._rm);
								break;
								case 2:
									LevelDirector._rm.scaleX = 0.4;
									LevelDirector._rm.scaleY = 0.4;
								break;
							default:
								trace("showmap error");
							}
							/*if (ShowMap) {
								this.addChild(LevelDirector._rm);
							} else {
								this.removeChild(LevelDirector._rm);
							}*/
							mapIsShown = true;
						}
					}
					break;
				case 90 ://z
					if (BallActor.carryingItem == BallActor.UMBRELLA) {
						Umbrella = true;
					}
					break;
				case 81 ://q
					Left = true;
					Up = true;
					break;
				case 69 ://e
					Right = true;
					Up = true;
					break;
				case 37 ://Left
					Left = true;
					break;
				case 65 ://a
					Left = true;
					break;
				case 38 ://Up
					Up = true;
					break;
				case 87 ://w
					Up = true;
					break;
				case 39 ://Right
					Right = true;
					break;
				case 68 ://d
					Right = true;
					break;
				case 40 ://Down
					Down = true;
					trace(_ballActor.getSpriteLoc().toString());
					break;
				case 83 ://s
					Down = true;
					trace(_ballActor.getSpriteLoc().toString());
					break;
				case 70 ://Fly //83
					if (PhysiVals.fps > 0 && PhysiVals.fps != Infinity) {
						if (jetpackTime > 0) {
							Fly = true;
						} else {
							Fly = false;
						}
					}
					break;
				/*case 83 ://Shoot Cannon
					ShootCannon = true;
					break;	*/
				case 192 :
					/*if (stage.displayState == StageDisplayState.FULL_SCREEN) {
						stage.displayState = StageDisplayState.NORMAL;
					} else */stage.displayState = StageDisplayState.FULL_SCREEN;
					break;
				case 85 :
					changeCharacter();
					break;
				case 73 :
					changeHat();
					break;
				case 79 :
					changeShoes();
					break;
			}
		}
		
		private function keyUp(e:KeyboardEvent):void 
		{
			//trace(e.keyCode);
			switch (e.keyCode) {
				case 77 ://m
					if (levelNow == 4) {
						mapIsShown = false;
					}
					break;
				case 90 ://z
					Umbrella = false;
					break;
				case 81 ://q
					Left = false;
					Up = false;
					break;
				case 69 ://e
					Right = false;
					Up = false;
					break;
				case 37 ://Left
					Left = false;
					break;
				case 65 ://a
					Left = false;
					break;
				case 38 ://Up
					Up = false;
					break;
				case 87 ://w
					Up = false;
					break;
				case 39 ://Right
					Right = false;
					break;
				case 68 ://d
					Right = false;
					break;
				case 40 ://Down
					Down = false;
					break;
				case 83 ://s
					Down = false;
					break;
				case 70 ://Fly
					Fly = false;
					break;
				/*case 83 ://Shoot Cannon
					ShootCannon = false;
					break;*/
			}
		}
		
		private function changeShoes():void 
		{
			if (BallActor.shoesIndex == 2) {
				BallActor.shoesIndex = 0;
			} else {
				BallActor.shoesIndex++;
			}
			trace("shoesIndex " + BallActor.shoesIndex);
		}
		
		private function changeHat():void 
		{
			if (BallActor.hatIndex == 23) {
				BallActor.hatIndex = 8;
			} else {
				BallActor.hatIndex++;
			}
			trace("hatIndex " + BallActor.hatIndex);
		}
		
		private function changeCharacter():void 
		{
			if (BallActor.characterIndex == 6) {
				BallActor.characterIndex = 0;
			} else {
				BallActor.characterIndex += 2;
			}
			trace("characterIndex " + BallActor.characterIndex);
		}
		
		public function addLife():void
		{
			if (Platformer._lifes.length < MAX_LIFES) {
				var hpHeart1:MovieClip = new heart();
				hpHeart1.x = 60 + Platformer._lifes.length * 40;
				hpHeart1.y = 420;
				hpHeart1.scaleX = 0.5;
				hpHeart1.scaleY = 0.5;
				this.addChild(hpHeart1);
				_lifes.push(hpHeart1);
			}
		}
		
		public function removeLive():void
		{
			if (removeLiveTime <= 0){
				removeLiveTime = 100;
				if (Platformer._lifes.length > 0) {
					for (var i:int = this.numChildren - 1; i > 0; i--) {
						if (this.getChildAt(i) is heart) {
							this.removeChildAt(i);
							break;
						}
					}
					Platformer._lifes.splice(Platformer._lifes.length - 1, 1);
				}
			}
		}
		
		private function countChildren(parent:DisplayObjectContainer):void 
		{
			trace(parent.toString());
			//superString += 1 + parent.toString() + "\n";
			if (parent.numChildren > 0) {
				for (var i:int = 0; i < parent.numChildren; i++) {
					childCounter++;
					if (parent.getChildAt(i) is DisplayObjectContainer) {
						countChildren(parent.getChildAt(i) as DisplayObjectContainer);
					}
				}
			}
		}
		/*
		private function addWaves():void 
		{
			for (var i:int = 0; i < 10; i++ ) {
				for (var j:int = 0; j < 4; j++ ) {
					_waterBalls.push(new WaterBall(_cameraDynamicLayer, new Point(1000 + i * 20, j * 20), new Point(0, 0)));
				}
			}
		}
		*/
		/*private function clearMenu():void 
		{
			for each(var levelSelect:levelSelectMc in _levSelMCs) {
				levelSelect.remEvLis();
			}
		}*/
		/*
		public function levelSelectionMc(beaten:int):void 
		{
			//var setup:setupClass = new setupClass();
			for (var x:int = 0; x < setupClass.totalLevels; x++) {
				var levelSelect:levelSelectMc = new levelSelectMc(x, (x <= beaten));
				addChild(levelSelect);
				_levSelMCs.push(levelSelect);
			}
		}*/
		
		private function activation(e:Event):void 
		{
			PhysiVals.fps = 30.0;
		}
		
		private function deactivation(e:Event):void 
		{
			PhysiVals.fps = Infinity;
			keyUp(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 37, 37));
			keyUp(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 38, 38));
			keyUp(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 39, 39));
			keyUp(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 40, 40));
			keyUp(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 70, 70));
			keyUp(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 83, 83));
			keyUp(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 27, 27));
		}
		
		private function newEventListener(e:Event):void 
		{
			//обновлялка
			//trace("numChildren: " + this.numChildren);
            ++periods;
			if (removeLiveTime > 0) {
				removeLiveTime--;
			}
			if (jetpackTime <= 0) {
				Fly = false;
			}
			if (PlayerCanJump && !Fly && jetpackTime<100 && PhysiVals.fps!=Infinity) {
				jetpackTime++;
			}
			if (!stopLevel) {
				PhysiVals.world.Step(1 / PhysiVals.fps, 10);
			} else {
				if (!deleting) {
					deleting = true;
					deleteAll();
				}
			}
			
			//_ballActor.updateNow();
			if (handleKeyNum>=0) {
				handleKey(handleKeyNum);
				//_keys.splice(handleKeyNum, 1);
				handleKeyNum = -1;
			}
			/*if (remakeBallTrue) {
				remakeBall();
				remakeBallTrue = false;
			} */
			if (makeBallTrue && !ballIsHere) {
				makeBallTrue = false;
				makeBall();
			}
			for each (var actor:Actor in _allActors) {
				if (!actor._body.IsStatic()){
					actor.updateNow();
				}
			}
			for each (var cloud:Cloud in _clouds) {
				cloud.update();
			}
			/*if (thereIsAGun){
				bulletsUpdate();
			}*/
			if (deleteEnemy >= 0) {
				safeRemoveActor(_enemies[deleteEnemy]);
				Platformer._enemies.splice(deleteEnemy, 1);
				
				deleteEnemy = -1;
			}
			//trace(e1.enemyNumber + "" + e2.enemyNumber + "" + e3.enemyNumber);
			reallyRemoveActors();
		}
		
		private static function deleteAll():void 
		{
			var animationCache:AnimationCache = AnimationCache.getInstance();
			//thisIs.removeChild(LevelDirector.funkyMountains);
			//thisIs.removeChild(LevelDirector.coniferous);
			/*thisIs.removeChild(LevelDirector.bigCloud1);
			thisIs.removeChild(LevelDirector.bigCloud2);
			//thisIs.removeChild(LevelDirector.bigCloud3);
			thisIs.removeChild(LevelDirector.fon);
			thisIs.removeChild(LevelDirector.fon2);
			//thisIs.removeChild(LevelDirector.fon3);
			thisIs.removeChild(LevelDirector.fon4);*/
			thisIs.removeChild(_camera);
			thisIs.removeChild(_camera2);
			thisIs.removeChild(_camera3);
			thisIs.removeChild(_camera4);
			thisIs.removeChild(_camera5);
			thisIs.removeChild(_camera6);
			thisIs.removeChild(_camera7);
			thisIs.removeChild(_camera8);
			thisIs.removeChild(_camera9);
			thisIs.removeChild(_camera10);
			thisIs.removeChild(thisIs.leftButton);
			thisIs.removeChild(thisIs.rightButton);
			var length:int  = _lifes.length;
			for (var i:int = 0; i < length; i++) {
				thisIs.removeLive();
				removeLiveTime = 0;
			}
			levelsOpen++;
			/*var s:int = thisIs.numChildren;
			for (var j:int = s-1; j >= 0; j--) {
				trace("j=" + j + "num=" + thisIs.numChildren);
				if (!(thisIs.getChildAt(j) is Shape)) {
					thisIs.removeChildAt(j);
					j--;
					if (j < 0) {
						break;
					}
				}
				trace("_" + thisIs.getChildAt(j).toString() + "_");
				
				if (thisIs.getChildAt(j) is LevelSelectionMC) {
					trace("yes");
					var r:int = LevelSelectionMC(thisIs.getChildAt(j)).numChildren;
					trace("r=" + r);
					for (var k:int = r-1; k >= 0; k--) {
						trace(levelSelectMc(LevelSelectionMC(thisIs.getChildAt(j)).getChildAt(k)).icon.toString());
					}
				}
			}*/
			LevelSelectionMC.hide();
			while (thisIs.numChildren) {
				if (thisIs.getChildAt(0) is Shape) {
					if (thisIs.numChildren > 1) {
						thisIs.removeChildAt(1);
					} else {
						break;
					}
				} else {
					thisIs.removeChildAt(0);
				}
			}
			LevelSelectionMC.getInstance(levelsOpen);
			thisIs.addLoadingScreen();
			//thisIs.removeChildAt(4);
			//thisIs.clearMenu();
			/*for each(var actor:levelSelectMc in _levSelMCs) {
				if (actor.parent) {
					thisIs.removeChild(actor);
				}
				actor.remEvLis();
			}
			_levSelMCs = [];*/
			//thisIs.createMenu();
			/*for each(var actor:Actor in _allActors) {
				if (actor is ArbiStaticActor) {
					safeRemoveActor(actor);
				}
			}*/
			
		}
		
		public static function safeDeleteEnemy(enemyNum:int):void 
		{
			//trace("enemyNum: " + enemyNum);
			if (deleteEnemy < 0) {
				if (Enemy(_enemies[enemyNum]).type == Enemy.PUSH_AND_SMASH) {
					if (Enemy(_enemies[enemyNum]).noShieldTimer > 0) {
						deleteEnemy = enemyNum;
					} else {
						thisIs.removeLive();
					}
				} else if (Enemy(_enemies[enemyNum]).invincibleTimer == 0) {
					if (Enemy(_enemies[enemyNum]).lives > 1) {
						Enemy(_enemies[enemyNum]).lives--;
						if (Enemy(_enemies[enemyNum]).type == Enemy.HEAVY || Enemy(_enemies[enemyNum]).type == Enemy.GHOST) {
							Enemy(_enemies[enemyNum]).invincibleTimer = 100;
						}
					} else {
						deleteEnemy = enemyNum;
					}
				} else if (Enemy(_enemies[enemyNum]).type == Enemy.HEAVY) {
					thisIs.removeLive();
				}
			}
		}
		
		private function handleKey(handleKeyNum:int):void 
		{
			//var keyToRemove:CircleStaticActor = _keys[handleKeyNum];
			//_keys[handleKeyNum] = null;
			//_keys.splice(handleKeyNum, 1);
			safeRemoveActor(_keys[handleKeyNum]);
			/*switch (handleKeyNum) {
				case 0: safeRemoveActor(key1); break;
				case 1: safeRemoveActor(key2); break;
				break;
			}*/
			handleKeyNum = -1;
		}
		
		/*private function remakeBall():void 
		{
			safeRemoveActor(_ballActor);
		}*/
		
		private function bulletsUpdate():void
		{
			for each (var nextBullet:Bullet in Cannon._cannonBullets) {
				nextBullet.updateNow();
			}
			/*for each (var nextWaterBall:WaterBall in _waterBalls) {
				nextWaterBall.updateNow();
			}*/
			/*if (cannonCount < 120) {
				cannonCount++;
			} else { 
				_cannon.shootCannon(_ballActor.ballBody.GetWorldCenter()); 
				for each (var enemy:Enemy in _enemies) {
					enemy.shoot(_ballActor.ballBody.GetWorldCenter());
				}
				cannonCount = 0; 
			}*///cannon2
			/*
			if (Bullet._bulletsNumber > 50) {
				if (cannonCount == 13) {
					safeRemoveActor(Cannon._cannonBullets[0]);
				}
			}
			*/
			if (!(deleteThisBullet < 0)) {
				safeRemoveActor(Cannon._cannonBullets[deleteThisBullet]);
			}
		}
		// Actually remove an actors that have been marked for deletion
		// in my removeActor function
		private function reallyRemoveActors():void 
		{
			for each (var removeMe:Actor in _actorsToRemove) {
				if (removeMe is BallActor){
					removeMe.destroy();
					if (!stopLevel) {
						makeBallTrue = true;
					}
				} else removeMe.destroy();
				
				// Remove it from our main list of actors
				var actorIndex:int = _allActors.indexOf(removeMe);
				if (actorIndex > -1) {
					_allActors.splice(actorIndex, 1);
				}
			}
			_actorsToRemove = [];
		}
		// Mark an actor to be removed later
		public static function safeRemoveActor(actorToRemove:Actor):void
		{
			if (_actorsToRemove.indexOf(actorToRemove) < 0) {
				_actorsToRemove.push(actorToRemove);
			}
		}
		
		public function makeBall():void 
		{
			_ballActor = new BallActor(_cameraDynamicLayer, LAUNCH_POINT_PLAYER, new Point(10, -3));
			//_ballActor.addEventListener(BallEvent.BALL_OFF_SCREEN, handleBallOffScreen);
			_allActors.push(_ballActor);
			
		}
		
		private function setupPhysicsWorld():void 
		{
			var worldBounds:b2AABB = new b2AABB();
			worldBounds.lowerBound.Set( -50000 / PhysiVals.RATIO, -50000 / PhysiVals.RATIO);
			worldBounds.upperBound.Set(50000 / PhysiVals.RATIO, 50000 / PhysiVals.RATIO);
			
			var allowSleep:Boolean = true;
			
			PhysiVals.world = new b2World(worldBounds, PhysiVals.gravity, allowSleep);
			PhysiVals.world.SetContactListener(new NewContactListener());
		}
	}
}
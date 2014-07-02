package  
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	/**
	 * ...
	 * @author 
	 */
	public class LevelEditor extends Sprite
	{
		public static var _camera:Camera;
		private var zoom:Number = 1;
		public static var condition:int;
		public static var mode:int;
		public static var _arrRect:Array = [];
		public static var _menuItems:Array = [];
		private var startPoint:Point = new Point(0, 0);
		public static const DELETE = 0;
		public static const HAND = 1;
		public static const MOVE = 2;
		public static const SCALE = 3;
		public static const RIGID = 4;
		public static const TRANSPARENT = 19;
		public static const MOVING = 5;
		public static const CLOUD = 6;
		public static const WINK = 7;
		public static const WATER = 8;
		public static const ENEMY = 9;
		public static const SIMPLE_ENEMY = 10;
		public static const JUMPING_ENEMY = 11;
		public static const WALKING_ENEMY = 12;
		public static const FLYING_ENEMY = 13;
		public static const FROM_BELOW_ENEMY = 14;
		public static const HEAVY_ENEMY = 15;
		public static const GHOST_ENEMY = 16;
		public static const RUSHING_ENEMY = 17;
		public static const PUSH_AND_SMASH_ENEMY = 18;
		
		public static const EDITOR_MODE = 1;
		public static const PLAY_MODE = 2;
		private var color:uint;
		private var greenSquare:Sprite;
		private var isSaving:Boolean = false;
		private var file:FileReference;
		private var textToSave:String;
		private var _moveTarget:RectInRed;
		private var backgroundLayout:Sprite;
		
		public function LevelEditor(camera:Camera) 
		{
			mode = EDITOR_MODE;
			_camera = camera;
			backgroundLayout = new Sprite();
			backgroundLayout.graphics.beginFill(0xC0C0C0);
			backgroundLayout.graphics.drawRect( -1000, -1000, 2000, 2000);
			backgroundLayout.graphics.endFill();
			_camera.addChild(backgroundLayout);
			greenSquare = new Sprite();
			greenSquare.graphics.beginFill(0xD5FFD5);
			for (var i = -1000; i < 1000; i += 5 ) {
				for (var j = -1000; j < 1000; j += 5 ) {
					if ((i % 25 == 0) && (j % 25 == 0)) {
						greenSquare.graphics.beginFill(0x004080);
					} else { 
						greenSquare.graphics.beginFill(0xD5FFD5); 
					}
					greenSquare.graphics.drawRect(i, j, 1, 1);
				}
			}
			greenSquare.graphics.beginFill(0xFF0000);
			greenSquare.graphics.drawRect(0, 0, 1, 1);	
			backgroundLayout.addChild(greenSquare);
			
			_camera.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			zoom = 11;
			_camera.zoomTo(new Point(0, 0), zoom);
			addMenuItem("инструменты");
			addMenuItem("платформы");
			addMenuItem("декор");
			addMenuItem("враги");
			
			addMenuItem("рука", 0, handTool);
			addMenuItem("перетащить", 0, moveTool);
			addMenuItem("масштабировать", 0, scaleTool);
			addMenuItem("удалить", 0, deleteTool);
			addMenuItem("сохранить в файл", 0, saveToFileTool);
			addMenuItem("загрузить из файла", 0, loadFromFileTool);
			addMenuItem("играть", 0, playTool);
			
			addMenuItem("твёрдые", 1, rigidPlatform);
			addMenuItem("двигающиеся", 1, movingPlatform);
			addMenuItem("шипы", 1, enemyPlatform);
			addMenuItem("вода", 1, waterPlatform);
			addMenuItem("облака", 1, cloudPlatform);
			addMenuItem("мигающие", 1, winkPlatform);
			addMenuItem("прозрачные", 1, transparentPlatform);
			addMenuItem("магнит", 1);
			
			addMenuItem("трава", 2);
			addMenuItem("кусты", 2);
			addMenuItem("деревья", 2);
			addMenuItem("холмы", 2);
			addMenuItem("лес", 2);
			addMenuItem("горы", 2);
			addMenuItem("облака", 2);
			addMenuItem("подземелье", 2);
			
			addMenuItem("простые", 3, simpleEnemy);
			addMenuItem("стреляющие", 3);
			addMenuItem("прыгающие", 3, jumpingEnemy);
			addMenuItem("ходячие", 3, walkingEnemy);
			addMenuItem("летающие", 3, flyingEnemy);
			addMenuItem("летающие перевёрнутые", 3, fromBelowEnemy);
			addMenuItem("тяжёлые", 3, heavyEnemy);
			addMenuItem("призраки", 3, ghostEnemy);
			addMenuItem("нападающие", 3, rushingEnemy);
			addMenuItem("push and smash", 3, pushAndSmashEnemy);
		}
		
		private function playTool(e:MouseEvent = null):void 
		{
			handRemover();
			//remove all - visible false
			for each(var r:RectInRed in _arrRect) {
				r.visible = false;
			}
			for each(var a:Array in _menuItems) {
				for each(var s:Sprite in a) {
					s.visible = false;
					s.removeEventListener(MouseEvent.ROLL_OUT, rollOutListener);
					s.removeEventListener(MouseEvent.ROLL_OVER, rollOverListener);
				}
			}
			backgroundLayout.visible = false;
			_camera.ZOOM_IN_AMT = 10;
			//start play
			Platformer.needToStartLevel = 100;
			mode = PLAY_MODE;
		}
		
		private function simpleEnemy(e:MouseEvent = null):void 
		{
			handRemover();
			condition = SIMPLE_ENEMY;
			trace("simple enemy");
			backgroundLayout.addEventListener(MouseEvent.CLICK, putSimpleEnemy);
			color = 0xFF6600;
		}
		
		private function heavyEnemy(e:MouseEvent = null):void 
		{
			handRemover();
			condition = HEAVY_ENEMY;
			trace("heavy enemy");
			backgroundLayout.addEventListener(MouseEvent.CLICK, putSimpleEnemy);
			color = 0xFF8040;
		}
		
		private function pushAndSmashEnemy(e:MouseEvent = null):void 
		{
			handRemover();
			condition = PUSH_AND_SMASH_ENEMY;
			trace("push and smash enemy");
			backgroundLayout.addEventListener(MouseEvent.CLICK, putSimpleEnemy);
			color = 0xEA0006;
		}
		
		private function ghostEnemy(e:MouseEvent = null):void 
		{
			handRemover();
			condition = GHOST_ENEMY;
			trace("ghost enemy");
			backgroundLayout.addEventListener(MouseEvent.CLICK, putSimpleEnemy);
			color = 0xFFBE7D;
		}
		
		private function rushingEnemy(e:MouseEvent = null):void 
		{
			handRemover();
			condition = RUSHING_ENEMY;
			trace("rushing enemy");
			backgroundLayout.addEventListener(MouseEvent.CLICK, putSimpleEnemy);
			color = 0xFD3939;
		}
		
		private function jumpingEnemy(e:MouseEvent = null):void 
		{
			handRemover();
			condition = JUMPING_ENEMY;
			trace("jumping enemy");
			backgroundLayout.addEventListener(MouseEvent.CLICK, putSimpleEnemy);
			color = 0xFF7700;
		}
		
		private function walkingEnemy(e:MouseEvent = null):void 
		{
			handRemover();
			condition = WALKING_ENEMY;
			trace("walking enemy");
			backgroundLayout.addEventListener(MouseEvent.CLICK, putWalkingEnemy);
			color = 0xFFFF00;
		}
		
		private function flyingEnemy(e:MouseEvent = null):void 
		{
			handRemover();
			condition = FLYING_ENEMY;
			trace("flying enemy");
			backgroundLayout.addEventListener(MouseEvent.CLICK, putWalkingEnemy);
			color = 0x8000FF;
		}
		
		
		private function fromBelowEnemy(e:MouseEvent = null):void 
		{
			handRemover();
			condition = FROM_BELOW_ENEMY;
			trace("from below enemy");
			backgroundLayout.addEventListener(MouseEvent.CLICK, putWalkingEnemy);
			color = 0xBD05FA;
		}
		
		private function enemyPlatform(e:MouseEvent = null):void 
		{
			handRemover();
			condition = ENEMY;
			trace("enemy");
			backgroundLayout.addEventListener(MouseEvent.MOUSE_DOWN, drawStart);
			color = 0x7F7F7F;
		}
		
		private function waterPlatform(e:MouseEvent = null):void 
		{
			handRemover();
			condition = WATER;
			trace("water");
			backgroundLayout.addEventListener(MouseEvent.MOUSE_DOWN, drawStart);
			color = 0x0000FF;
		}
		
		private function winkPlatform(e:MouseEvent = null):void 
		{
			handRemover();
			condition = WINK;
			trace("wink");
			backgroundLayout.addEventListener(MouseEvent.CLICK, putCloud);
			color = 0x400080;
		}
		
		private function cloudPlatform(e:MouseEvent = null):void 
		{
			handRemover();
			condition = CLOUD;
			trace("cloud");
			backgroundLayout.addEventListener(MouseEvent.CLICK, putCloud);
			color = 0xA6D2FF;
		}
		
		private function movingPlatform(e:MouseEvent = null):void 
		{
			handRemover();
			condition = MOVING;
			trace("moving");
			backgroundLayout.addEventListener(MouseEvent.MOUSE_DOWN, drawStartMoving);
			color = 0x00E800;
		}
		
		private function drawStartMoving(e:MouseEvent):void 
		{
			startPoint.x = e.stageX; 
			startPoint.y = e.stageY;
			backgroundLayout.addEventListener(MouseEvent.MOUSE_UP, drawFinishMoving);
		}
		
		private function drawFinishMoving(e:MouseEvent):void 
		{
			var localX:Number = Math.round((startPoint.x - _camera.x) / zoom);
			var localY:Number = Math.round((startPoint.y - _camera.y) / zoom);
			if (startPoint.x > e.stageX) { localX = Math.round((e.stageX - _camera.x) / zoom);}
			if (startPoint.y > e.stageY) { localY = Math.round((e.stageY - _camera.y) / zoom);}
			var localW:Number = Math.abs(Math.round((e.stageX - _camera.x) / zoom) - localX );
			var localH:Number = Math.abs(Math.round((e.stageY - _camera.y) / zoom) - localY);
			if (localW != 0 && localH != 0) {
				var rect:RectInRed = new RectInRed(localW, localH, localX, localY, color);
				_arrRect.push(rect);
				startPoint.x = e.stageX;
				startPoint.y = e.stageY;
				_moveTarget = rect;
				backgroundLayout.addEventListener(MouseEvent.MOUSE_MOVE, moveAlphaRectMoving);
				backgroundLayout.addEventListener(MouseEvent.MOUSE_UP, moveFinishMoving);
			}
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_UP, drawFinishMoving);
		}
		
		private function moveAlphaRectMoving(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			if (startPoint.x > e.stageX) { localX = Math.round((e.stageX - _camera.x) / zoom);};
			if (startPoint.y > e.stageY) { localY = Math.round((e.stageY - _camera.y) / zoom);};
			_moveTarget.movingTo(localX, localY);
		}
		
		private function moveFinishMoving(e:MouseEvent):void 
		{
			_moveTarget = null;
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_MOVE, moveAlphaRectMoving);
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_UP, moveFinishMoving);
		}
		
		private function rigidPlatform(e:MouseEvent = null):void 
		{
			handRemover();
			condition = RIGID;
			trace("rigid");
			backgroundLayout.addEventListener(MouseEvent.MOUSE_DOWN, drawStart);
			color = 0x008000;
		}
		
		private function transparentPlatform(e:MouseEvent = null):void 
		{
			handRemover();
			condition = TRANSPARENT;
			trace("transparent");
			backgroundLayout.addEventListener(MouseEvent.MOUSE_DOWN, drawStart);
			color = 0x64FF64;
		}
		
		private function scaleTool(e:MouseEvent = null):void 
		{
			if (condition != SCALE) {
				handRemover();
				condition = SCALE;
				trace("scale");
				for each(var r:RectInRed in _arrRect) {
					if ((r._color == 0x008000) ||
						(r._color == 0x0000FF) ||
						(r._color == 0x7F7F7F)) {
						var circle1:Sprite = new Sprite();
						circle1.graphics.beginFill(0x000000);
						circle1.graphics.drawCircle(r._x, r._y, 0.4);
						circle1.graphics.endFill();
						r.addChild(circle1);
						circle1.addEventListener(MouseEvent.MOUSE_DOWN, moveLU);
						var circle2:Sprite = new Sprite();
						circle2.graphics.beginFill(0x000000);
						circle2.graphics.drawCircle(r._x + r._w, r._y, 0.4);
						circle2.graphics.endFill();
						r.addChild(circle2);
						circle2.addEventListener(MouseEvent.MOUSE_DOWN, moveRU);
						var circle3:Sprite = new Sprite();
						circle3.graphics.beginFill(0x000000);
						circle3.graphics.drawCircle(r._x + r._w, r._y + r._h, 0.4);
						circle3.graphics.endFill();
						r.addChild(circle3);
						circle3.addEventListener(MouseEvent.MOUSE_DOWN, moveRD);
						var circle4:Sprite = new Sprite();
						circle4.graphics.beginFill(0x000000);
						circle4.graphics.drawCircle(r._x, r._y + r._h, 0.4);
						circle4.graphics.endFill();
						r.addChild(circle4);
						circle4.addEventListener(MouseEvent.MOUSE_DOWN, moveLD);
					}
				}
			}
		}
		
		private function moveLU(e:MouseEvent):void 
		{
			startPoint.x = e.stageX; 
			startPoint.y = e.stageY;
			_moveTarget = RectInRed(Sprite(e.target).parent);
			backgroundLayout.addEventListener(MouseEvent.MOUSE_UP, changeLU);
		}
		
		private function changeLU(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			_moveTarget.changeLU(localX, localY);
			_moveTarget = null;
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_UP, changeLU);
			condition = HAND;
			scaleTool();
		}
		
		private function moveRU(e:MouseEvent):void 
		{
			startPoint.x = e.stageX; 
			startPoint.y = e.stageY;
			_moveTarget = RectInRed(Sprite(e.target).parent);
			backgroundLayout.addEventListener(MouseEvent.MOUSE_UP, changeRU);
		}
		
		private function changeRU(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			_moveTarget.changeRU(localX, localY);
			_moveTarget = null;
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_UP, changeRU);
			condition = HAND;
			scaleTool();
		}
		
		private function moveRD(e:MouseEvent):void 
		{
			startPoint.x = e.stageX; 
			startPoint.y = e.stageY;
			_moveTarget = RectInRed(Sprite(e.target).parent);
			backgroundLayout.addEventListener(MouseEvent.MOUSE_UP, changeRD);
		}
		
		private function changeRD(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			_moveTarget.changeRD(localX, localY);
			_moveTarget = null;
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_UP, changeRD);
			condition = HAND;
			scaleTool();
		}
		
		private function moveLD(e:MouseEvent):void 
		{
			startPoint.x = e.stageX; 
			startPoint.y = e.stageY;
			_moveTarget = RectInRed(Sprite(e.target).parent);
			backgroundLayout.addEventListener(MouseEvent.MOUSE_UP, changeLD);
		}
		
		private function changeLD(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			_moveTarget.changeLD(localX, localY);
			_moveTarget = null;
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_UP, changeLD);
			condition = HAND;
			scaleTool();
		}
		
		private function moveTool(e:MouseEvent = null):void 
		{
			handRemover();
			condition = MOVE;
			trace("move");
			for each(var r:RectInRed in _arrRect) {
				r.addEventListener(MouseEvent.MOUSE_DOWN, moveStart);
			}
		}
		
		private function handTool(e:MouseEvent = null):void 
		{
			handRemover();
			condition = HAND;
			Mouse.cursor = MouseCursor.HAND;
			trace("hand");
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_DOWN, drawStart);
			backgroundLayout.addEventListener(MouseEvent.MOUSE_WHEEL, scrolls);
			backgroundLayout.addEventListener(MouseEvent.MOUSE_DOWN, handDown);
			backgroundLayout.addEventListener(MouseEvent.MOUSE_UP, handUp);
			for each(var a:Array in _menuItems) {
				for each(var s:Sprite in a) {
					s.addEventListener(MouseEvent.ROLL_OVER, arrowCursor);
					s.addEventListener(MouseEvent.ROLL_OUT, handCursor);
				}
			}
		}
		
		private function handCursor(e:MouseEvent):void 
		{
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function arrowCursor(e:MouseEvent):void 
		{
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		private function deleteTool(e:MouseEvent = null):void 
		{
			handRemover();
			condition = DELETE;
			//backgroundLayout.removeEventListener(MouseEvent.CLICK, deletePlatform);
			for each (var red:RectInRed in _arrRect) {
				red.addEventListener(MouseEvent.CLICK, deletePlatform);
			}
			trace("delete");
		}
		
		private function deletePlatform(e:MouseEvent = null):void 
		{
			RectInRed(e.target).removeRect(e);
		}
		
		private function loadFromFileTool(e:MouseEvent = null):void 
		{
			
		}
		
		private function saveToFileTool(e:MouseEvent = null):void 
		{
			if (!isSaving) {
				isSaving = true;
				textToSave = "";
				for each (var red:RectInRed in _arrRect) {
					textToSave += red.name + "";
				}
				file = new FileReference();
				try {
                    file.save(textToSave, "text.txt");
                }
                catch (e:Error) { trace(e) }
				isSaving = false;
			}
		}
		
		private function handRemover():void 
		{
			if (condition == HAND) {
				Mouse.cursor = MouseCursor.ARROW;
				backgroundLayout.removeEventListener(MouseEvent.MOUSE_WHEEL, scrolls);
				backgroundLayout.removeEventListener(MouseEvent.MOUSE_DOWN, handDown);
				backgroundLayout.removeEventListener(MouseEvent.MOUSE_UP, handUp);
				if (backgroundLayout.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					/*switch (condition) 
					{
						case RIGID:
							
						break;
						default:
					}
					backgroundLayout.removeEventListener(MouseEvent.MOUSE_DOWN,*/
					trace("has " + condition);
				}
				for each(var a:Array in _menuItems) {
					for each(var s:Sprite in a) {
						s.removeEventListener(MouseEvent.ROLL_OVER, arrowCursor);
						s.removeEventListener(MouseEvent.ROLL_OUT, handCursor);
					}
				}
				for each(red in _arrRect) {
					while (red.numChildren) {
						red.removeChildAt(0);
					}
				}
			} else if (condition == MOVING) {
				backgroundLayout.removeEventListener(MouseEvent.MOUSE_DOWN, drawStartMoving);
			} else if (condition == DELETE) {
				for each (var red:RectInRed in _arrRect) {
					red.removeEventListener(MouseEvent.CLICK, deletePlatform);
				}
			} else if (condition == CLOUD || condition == WINK) {
				backgroundLayout.removeEventListener(MouseEvent.CLICK, putCloud);
			} else if (condition == RIGID || condition == WATER || condition == ENEMY || condition == TRANSPARENT) {
				backgroundLayout.removeEventListener(MouseEvent.MOUSE_DOWN, drawStart);
			} else if (condition == SIMPLE_ENEMY || condition == JUMPING_ENEMY || 
					   condition == HEAVY_ENEMY || condition == GHOST_ENEMY || 
					   condition == RUSHING_ENEMY || condition == PUSH_AND_SMASH_ENEMY) {
				backgroundLayout.removeEventListener(MouseEvent.CLICK, putSimpleEnemy);
			} else if (condition == WALKING_ENEMY || condition == FLYING_ENEMY || condition == FROM_BELOW_ENEMY) {
				backgroundLayout.removeEventListener(MouseEvent.CLICK, putWalkingEnemy);
			} else if (condition == MOVE) {
				for each (red in _arrRect) {
					red.removeEventListener(MouseEvent.MOUSE_DOWN, moveStart);
				}
			} else if (condition == SCALE) {
				for each(red in _arrRect) {
					while (red.numChildren) {
						red.removeChildAt(0);
					}
				}
			}
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			//trace(e.keyCode);
			switch (e.keyCode) 
			{
				case 49://1
					handTool();
				break;
				case 50://2
					rigidPlatform();
				break;
				case 51://3
					cloudPlatform();
				break;
				case 52://4
					winkPlatform();
				break;
				case 53://5
					waterPlatform();
				break;
				case 54://6 вроде
					enemyPlatform();
				break;
				case 192://`
					deleteTool();
				break;
				case 90://z
					//trace(_arrRect);
					for each (var red:RectInRed in _arrRect) {
						trace(red.name);
					}
				break;
				case 80://p
					playTool();
				break;
				case 83://s save
					saveToFileTool();
				break;
				//default:
				
			}
			if (e.keyCode > 49) {
				handRemover();
			}
		}
		
		private function putSimpleEnemy(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			_arrRect.push(new RectInRed(1, 1, localX, localY, color));
		}
		
		private function putWalkingEnemy(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			var rect:RectInRed = new RectInRed(1, 1, localX, localY, color);
			_arrRect.push(rect);
			startPoint.x = e.stageX; 
			startPoint.y = e.stageY;
			_moveTarget = rect;
			backgroundLayout.addEventListener(MouseEvent.MOUSE_MOVE, moveAlphaRectWalking);
			backgroundLayout.addEventListener(MouseEvent.MOUSE_UP, moveFinishWalking);
			backgroundLayout.removeEventListener(MouseEvent.CLICK, putWalkingEnemy);
		}
		
		private function moveAlphaRectWalking(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			if (startPoint.x > e.stageX) { localX = Math.round((e.stageX - _camera.x) / zoom);};
			if (startPoint.y > e.stageY) { localY = Math.round((e.stageY - _camera.y) / zoom); };
			_moveTarget.movingTo(localX, localY);
		}
		
		private function moveFinishWalking(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			if (startPoint.x > e.stageX) { localX = Math.round((e.stageX - _camera.x) / zoom);};
			if (startPoint.y > e.stageY) { localY = Math.round((e.stageY - _camera.y) / zoom); };
			_moveTarget.movingTo(localX, localY);
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_MOVE, moveAlphaRectWalking);
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_UP, moveFinishWalking);
			_moveTarget = null;
		}
		
		private function putCloud(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			_arrRect.push(new RectInRed(3.75, 1, localX, localY, color));
		}
		
		private function moveStart(e:MouseEvent):void 
		{
			startPoint.x = e.stageX; 
			startPoint.y = e.stageY;
			_moveTarget = RectInRed(e.target);
			backgroundLayout.addEventListener(MouseEvent.MOUSE_MOVE, moveAlphaRect);
			backgroundLayout.addEventListener(MouseEvent.MOUSE_UP, moveFinish);
		}
		
		private function moveAlphaRect(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			if (startPoint.x > e.stageX) { localX = Math.round((e.stageX - _camera.x) / zoom);};
			if (startPoint.y > e.stageY) { localY = Math.round((e.stageY - _camera.y) / zoom);};
			_moveTarget.moveTo(localX, localY);
		}
		
		private function moveFinish(e:MouseEvent):void 
		{
			var localX:Number = Math.round((e.stageX - _camera.x) / zoom);
			var localY:Number = Math.round((e.stageY - _camera.y) / zoom);
			if (startPoint.x > e.stageX) { localX = Math.round((e.stageX - _camera.x) / zoom);};
			if (startPoint.y > e.stageY) { localY = Math.round((e.stageY - _camera.y) / zoom);};
			_moveTarget.moveTo(localX, localY);
			_moveTarget = null;
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_MOVE, moveAlphaRect);
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_UP, moveFinish);
		}
		
		private function drawStart(e:MouseEvent):void 
		{
			startPoint.x = e.stageX; 
			startPoint.y = e.stageY;
			backgroundLayout.addEventListener(MouseEvent.MOUSE_UP, drawFinish);
		}
		
		private function drawFinish(e:MouseEvent):void 
		{
			var localX:Number = Math.round((startPoint.x - _camera.x) / zoom);
			var localY:Number = Math.round((startPoint.y - _camera.y) / zoom);
			if (startPoint.x > e.stageX) { localX = Math.round((e.stageX - _camera.x) / zoom); trace("x"); };
			if (startPoint.y > e.stageY) { localY = Math.round((e.stageY - _camera.y) / zoom); trace("y"); };
			//var localW:Number = Math.abs(Math.round(((e.localX - _camera.x) / zoom) - ((startPoint.x - _camera.x) / zoom)));
			//var localH:Number = Math.abs(Math.round(((e.localY - _camera.y) / zoom) - ((startPoint.y - _camera.y) / zoom)));
			var localW:Number = Math.abs(Math.round((e.stageX - _camera.x) / zoom) - localX );
			var localH:Number = Math.abs(Math.round((e.stageY - _camera.y) / zoom) - localY);
			//trace("x1 " + localX + " x2 " + Math.round((e.stageX - _camera.x) / zoom));
			//trace("y1 " + localY + " y2 " + Math.round((e.stageY - _camera.y) / zoom));
			trace('w ' + localW);
			trace('h ' + localH);
			trace('x ' + localX);
			trace('y ' + localY);
			if (localW != 0 && localH != 0) {
				_arrRect.push(new RectInRed(localW, localH, localX, localY, color));
			}
			backgroundLayout.removeEventListener(MouseEvent.MOUSE_UP, drawFinish);
		}
		
		private function addMenuItem(text:String, itemParent:int = -1, listener:Function = null):void 
		{
			var rectangle:Sprite = new Sprite();
			rectangle.graphics.beginFill(0x000000);
			var name:TextField = new TextField();
			name.visible = true;
			//name.setTextFormat(new TextFormat("consolas", 10));
			name.text = text;
			name.textColor = 0x00FF64;
			name.selectable = false;
			if (itemParent == -1) {
				_menuItems.push(new Array());
				rectangle.graphics.drawRect(100 * (_menuItems.length - 1), 0, 100, 20);
				(_menuItems[_menuItems.length - 1] as Array).push(rectangle);
				name.x = 100 * (_menuItems.length - 1);
				name.y = 0;
				rectangle.z = _menuItems.length - 1;
			} else {
				rectangle.graphics.drawRect(100 * itemParent, (_menuItems[itemParent] as Array).length * 20, 100, 20);
				(_menuItems[itemParent] as Array).push(rectangle);
				name.x = 100 * itemParent;
				name.y = ((_menuItems[itemParent] as Array).length - 1) * 20;
				rectangle.visible = false;
				name.visible = false;
				rectangle.z = -1 * itemParent - 1;
			}
			rectangle.addEventListener(MouseEvent.ROLL_OUT, rollOutListener);
			rectangle.addEventListener(MouseEvent.ROLL_OVER, rollOverListener);
			rectangle.graphics.endFill();
			Platformer._camera.parent.addChild(rectangle);
			rectangle.addChild(name);
			if (listener != null) {
				rectangle.addEventListener(MouseEvent.CLICK, listener);
			}
		}
		
		private function rollOverListener(e:MouseEvent):void 
		{
			if (Sprite(e.target).z >= 0) {
				for (var i:int = 1; i < (_menuItems[Sprite(e.target).z] as Array).length; i++ ) {
					(_menuItems[Sprite(e.target).z] as Array)[i].visible = true;
					(_menuItems[Sprite(e.target).z] as Array)[i].getChildAt(0).visible = true;
				}
			} else {
				for (i = 1; i < (_menuItems[ -1 * (Sprite(e.target).z + 1)] as Array).length; i++ ) {
					(_menuItems[ -1 * (Sprite(e.target).z + 1)] as Array)[i].visible = true;
					(_menuItems[ -1 * (Sprite(e.target).z + 1)] as Array)[i].getChildAt(0).visible = true;
				}
			}
		}
		
		private function rollOutListener(e:MouseEvent):void 
		{
			if (Sprite(e.target).z >= 0) {
				for (var i:int = 1; i < (_menuItems[Sprite(e.target).z] as Array).length; i++ ) {
					(_menuItems[Sprite(e.target).z] as Array)[i].visible = false;
					(_menuItems[Sprite(e.target).z] as Array)[i].getChildAt(0).visible = false;
				}
			} else {
				for (i = 1; i < (_menuItems[ -1 * (Sprite(e.target).z + 1)] as Array).length; i++ ) {
					(_menuItems[ -1 * (Sprite(e.target).z + 1)] as Array)[i].visible = false;
					(_menuItems[ -1 * (Sprite(e.target).z + 1)] as Array)[i].getChildAt(0).visible = false;
				}
			}
		}
		
		private function handUp(e:MouseEvent):void 
		{
			_camera.stopDrag();
		}
		
		private function handDown(e:MouseEvent):void 
		{
			_camera.startDrag();
		}
		
		private function scrolls(e:MouseEvent):void 
		{
			if (e.delta > 0) {
				zoom += 0.5;
				_camera.zoomTo(new Point(0, 0), zoom);
			} else if (e.delta < 0) {
				if (zoom > 0) {
					zoom -= 0.5;
					_camera.zoomTo(new Point(0, 0), zoom);
				}
			}
			trace(zoom);
		}
	}
}
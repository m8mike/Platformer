package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class RectInRed extends Sprite
	{
		public var _w:Number;
		public var _h:Number;
		public var _x:Number;
		public var _y:Number;
		public var _color:uint;
		public var _finishPos:Point;
		
		public function RectInRed(w:Number, h:Number, x:Number, y:Number, color:uint) 
		{
			_w = w;
			_h = h;
			_x = x;
			_y = y;
			_color = color;
			init();
			LevelEditor._camera.addChild(this);
			//this.addEventListener(MouseEvent.CLICK, removeRect);
			super();
		}
		
		private function init():void 
		{
			this.graphics.beginFill(_color);
			this.graphics.drawRect(_x, _y, _w, _h);
			switch (_color) 
			{
				case 0x008000://rigid
					this.name = "LevelDirector.makeRect(" + _w + ", " + _h + ", " + _x + ", " + _y + ");";
				break;
				case 0x64FF64://transparent
					this.name = "LevelDirector.makeRect(" + _w + ", " + _h + ", " + _x + ", " + _y + ", ArbiStaticActor.TRANSPARENT);";
				break;
				case 0x00E800://moving
					if (_finishPos == null) {
						trace("finishPos error");
					} else {
						this.graphics.drawRect(_finishPos.x, _finishPos.y, _w, _h);
						this.graphics.moveTo(_finishPos.x, _finishPos.y);
						this.graphics.lineTo(_x, _y);
						this.name = "LevelDirector.makeElevator(" + _w + ", " + _h + ", " + _x + ", " + _y + ", " + 
													_finishPos.x + ", " + _finishPos.y + ");";
					}
				break;
				case 0xA6D2FF://cloud
					this.name = "LevelDirector.new Cloud(" + 3.75 + ", " + 1 + ", " + _x + ", " + _y + ");";
				break;
				case 0x400080://wink
					this.name = "LevelDirector.new Cloud(" + 3.75 + ", " + 1 + ", " + _x + ", " + _y + ", true);";
				break;
				case 0x0000FF://water
					this.name = "LevelDirector.makeRect(" + _w + ", " + _h + ", " + _x + ", " + _y + ", ArbiStaticActor.WATER);";
				break;
				case 0x7F7F7F://enemy
					this.name = "LevelDirector.makeRect(" + _w + ", " + _h + ", " + _x + ", " + _y + ", ArbiStaticActor.ENEMY);";
				break;
				case 0xFF6600://simple enemy
					this.name = "_allActors.push(new Enemy(_cameraDynamicLayer, new Point(" + _x * 20 + ", " + _y * 20 + 
					"), new Point( -50, 0)));";
				break;
				case 0xFF7700://jumping enemy
					this.name = "_allActors.push(new Enemy(_cameraDynamicLayer, new Point(" + _x * 20 + ", " + _y * 20 + 
					"), new Point( -50, 0), Enemy.JUMPING));";
				break;
				case 0xFF8040://heavy enemy
					this.name = "_allActors.push(new Enemy(_cameraDynamicLayer, new Point(" + _x * 20 + ", " + _y * 20 + 
					"), new Point( -50, 0), Enemy.HEAVY));";
				case 0xEA0006://push and smash enemy
					this.name = "_allActors.push(new Enemy(_cameraDynamicLayer, new Point(" + _x * 20 + ", " + _y * 20 + 
					"), new Point( -50, 0), Enemy.PUSH_AND_SMASH));";
				case 0xFFBE7D://ghost enemy
					this.name = "_allActors.push(new Enemy(_cameraDynamicLayer, new Point(" + _x * 20 + ", " + _y * 20 + 
					"), new Point( -50, 0), Enemy.GHOST));";
				break;
				case 0xFD3939://rushing enemy
					this.name = "_allActors.push(new Enemy(_cameraDynamicLayer, new Point(" + _x * 20 + ", " + _y * 20 + 
					"), new Point( -50, 0), Enemy.RUSHING));";
				break;
				case 0xFFFF00://walking enemy
					if (_finishPos == null) {
						trace("finishPos error");
					} else {
						this.graphics.drawRect(_finishPos.x, _finishPos.y, _w, _h);
						this.graphics.moveTo(_finishPos.x, _finishPos.y);
						this.graphics.lineTo(_x, _y);
						this.name = "_allActors.push(new Enemy(_cameraDynamicLayer, new Point(" + _x * 20 + ", " + _y * 20 + 
						"), new Point( -50, 0), Enemy.WALKING, new Point(" + _finishPos.x + ", " + _finishPos.y + ")));";
					}
				break;
				case 0x8000FF://flying enemy
					if (_finishPos == null) {
						trace("finishPos error");
					} else {
						this.graphics.drawRect(_finishPos.x, _finishPos.y, _w, _h);
						this.graphics.moveTo(_finishPos.x, _finishPos.y);
						this.graphics.lineTo(_x, _y);
						this.name = "_allActors.push(new Enemy(_cameraDynamicLayer, new Point(" + _x * 20 + ", " + _y * 20 + 
						"), new Point( -50, 0), Enemy.FLYING, new Point(" + _finishPos.x + ", " + _finishPos.y + ")));";
					}
				break;
				case 0xBD05FA://from below enemy
					if (_finishPos == null) {
						trace("finishPos error");
					} else {
						this.graphics.drawRect(_finishPos.x, _finishPos.y, _w, _h);
						this.graphics.moveTo(_finishPos.x, _finishPos.y);
						this.graphics.lineTo(_x, _y);
						this.name = "_allActors.push(new Enemy(_cameraDynamicLayer, new Point(" + _x * 20 + ", " + _y * 20 + 
						"), new Point( -50, 0), Enemy.FROM_BELOW, new Point(" + _finishPos.x + ", " + _finishPos.y + ")));";
					}
				break;
			}
			this.graphics.endFill();
		}
		
		public function removeRect(e:MouseEvent = null):void 
		{
			if (LevelEditor.condition == LevelEditor.DELETE) {
				LevelEditor._arrRect.splice(LevelEditor._arrRect.indexOf(e.target), 1);
				LevelEditor._camera.removeChild(e.target as Sprite);
			}
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			_x = x;
			_y = y;
			this.graphics.clear();
			init();
		}
		
		public function movingTo(x:Number, y:Number):void
		{
			_finishPos = new Point(x, y);
			this.graphics.clear();
			init();
		}
		
		public function changeLU(x:Number, y:Number):void
		{
			if ((x >= _x + _w) || (y >= _y + _h)) {
				trace("LU error");
			} else {
				if (x > _x) {
					_w -= Math.abs(x - _x);
				} else if (x < _x) {
					_w += Math.abs(x - _x);
				}
				if (y > _y) {
					_h -= Math.abs(y - _y);
				} else if (y < _y) {
					_h += Math.abs(y - _y);
				}
				_x = x;
				_y = y;
				this.graphics.clear();
				init();
			}
		}
		
		public function changeRU(x:Number, y:Number):void
		{
			if ((x <= _x) || (y >= _y + _h)) {
				trace("RU error");
			} else {
				if (x > (_x + _w)) {
					_w += Math.abs(x - (_x + _w));
				} else if (x < (_x + _w)) {
					_w -= Math.abs(x - (_x + _w));
				}
				if (y > _y) {
					_h -= Math.abs(y - _y);
				} else if (y < _y) {
					_h += Math.abs(y - _y);
				}
				_y = y;
				this.graphics.clear();
				init();
			}
		}
		
		public function changeRD(x:Number, y:Number):void
		{
			if ((x <= _x) || (y <= _y)) {
				trace("RD error");
			} else {
				if (x > (_x + _w)) {
					_w += Math.abs(x - (_x + _w));
				} else if (x < (_x + _w)) {
					_w -= Math.abs(x - (_x + _w));
				}
				if (y > (_y + _h)) {
					_h += Math.abs(y - (_y + _h));
				} else if (y < (_y + _h)) {
					_h -= Math.abs(y - (_y + _h));
				}
				this.graphics.clear();
				init();
			}
		}
		
		public function changeLD(x:Number, y:Number):void
		{
			if ((x >= _x + _w) || (y <= _y)) {
				trace("LD error");
			} else {
				if (x > _x) {
					_w -= Math.abs(x - _x);
				} else if (x < _x) {
					_w += Math.abs(x - _x);
				}
				if (y > (_y + _h)) {
					_h += Math.abs(y - (_y + _h));
				} else if (y < (_y + _h)) {
					_h -= Math.abs(y - (_y + _h));
				}
				_x = x;
				this.graphics.clear();
				init();
			}
		}
		
		public function makeIt():void
		{
			//
			switch (_color) 
			{
				case 0x008000://rigid
					LevelDirector.makeRect(_w, _h, _x, _y);
				break;
				case 0x64FF64://transparent
					LevelDirector.makeRect(_w, _h, _x, _y, ArbiStaticActor.TRANSPARENT);
				break;
				case 0x00E800://moving
					LevelDirector.makeElevator(_w, _h, _x, _y, _finishPos.x, _finishPos.y);
				break;
				case 0xA6D2FF://cloud
					new Cloud(_w, _h, _x, _y);
				break;
				case 0x400080://wink
					new Cloud(_w, _h, _x, _y, true);
				break;
				case 0x0000FF://water
					LevelDirector.makeRect(_w, _h, _x, _y, ArbiStaticActor.WATER);
				break;
				case 0x7F7F7F://enemy
					LevelDirector.makeRect(_w, _h, _x, _y, ArbiStaticActor.ENEMY);
				break;
				case 0xFF6600://simple enemy
					Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, 
												new Point(_x * 20, _y * 20), new Point( -50, 0)));
				break;
				case 0xFF7700://jumping enemy
					Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, 
												new Point(_x * 20, _y * 20), new Point( -50, 0), Enemy.JUMPING));
				break;
				case 0xFFFF00://walking enemy
					Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, 
												new Point(_x * 20, _y * 20), new Point( -50, 0), Enemy.WALKING, _finishPos));
				break;
				case 0x8000FF://flying enemy
					Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, 
												new Point(_x * 20, _y * 20), new Point( -50, 0), Enemy.FLYING, _finishPos));
				break;
				case 0xBD05FA://from below enemy
					Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, 
												new Point(_x * 20, _y * 20), new Point( -50, 0), Enemy.FROM_BELOW, _finishPos));
				break;
				case 0xFF8040://heavy enemy
					Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, 
												new Point(_x * 20, _y * 20), new Point( -50, 0), Enemy.HEAVY));
				break;
				case 0xEA0006://push and smash enemy
					Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, 
												new Point(_x * 20, _y * 20), new Point( -50, 0), Enemy.PUSH_AND_SMASH));
				break;
				case 0xFFBE7D://ghost enemy
					Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, 
												new Point(_x * 20, _y * 20), new Point( -50, 0), Enemy.GHOST));
				break;
				case 0xFD3939://rushing enemy
					Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, 
												new Point(_x * 20, _y * 20), new Point( -50, 0), Enemy.RUSHING));
				break;
			}
			//
		}
		
	}

}
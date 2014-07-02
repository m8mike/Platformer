package com.touchmypixel.peepee.utils 
{
	import com.bit101.display.BigAssCanvas;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	public class Animation extends Sprite
	{
		public var bitmap:Bitmap;
		public var clip:MovieClip;
		public var frames:Array = [];
		public var currentFrame:Number = 1;
		private var _playing:Boolean = false;
		private var _cache:Boolean = true;
		
		public var repeat:Boolean = true;
		public var onEnd:Function;
		private var clipData:MovieClip;
		public var reverse:Boolean = false;
		
		public var speed:Number = 1;
		
		public var treatAsLoopedGraphic:Boolean = false;
		public var bigBitmap:BigAssCanvas;
		
		public var cols:Number = 0;
		public var rows:Number = 0
		public var r:Rectangle
		private var _totalFrames;
		
		private var clipDef;
		
		public var useSpriteSheet:Boolean = false;
		
		
		
		public function Animation() 
		{
			bitmap = new Bitmap();
			bitmap.smoothing = false;
			addChild(bitmap);
		}
		
		
		public function set bitmapData(value:BitmapData){ bitmap.bitmapData = value; }
		public function get bitmapData():BitmapData{ return bitmap.bitmapData; }
		
		public function get playing():Boolean { return _playing; }
		
		public function get totalFrames():Number { return clip.totalFrames; }
		
		public function buildCacheFromLibrary(identifier:String):void
		{
			clipDef = new (getDefinitionByName(identifier))();
			if (clipDef is go_right) {
				for (var j:int = 0; j < MovieClip(go_right(clipDef).getChildAt(0)).numChildren; j++) {
					MovieClip(go_right(clipDef).getChildAt(0)).getChildAt(j).visible = false;
					MovieClip(go_right(clipDef).getChildAt(3)).getChildAt(j).visible = false;
				}
				
				for (j = 0; j < MovieClip(go_right(clipDef).getChildAt(4)).numChildren; j++) {
					//правая рука
					MovieClip(go_right(clipDef).getChildAt(4)).getChildAt(j).visible = false;
				}
				for (j = 0; j < MovieClip(go_right(clipDef).getChildAt(1)).numChildren; j++) {
					//левая рука
					MovieClip(go_right(clipDef).getChildAt(1)).getChildAt(j).visible = false;
				}
				
				MovieClip(go_right(clipDef).getChildAt(0)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(go_right(clipDef).getChildAt(3)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(go_right(clipDef).getChildAt(1)).getChildAt(0).visible = true;
				if (BallActor.carryingItem == BallActor.UMBRELLA) {
					MovieClip(go_right(clipDef).getChildAt(4)).getChildAt(0).visible = true;
				} else {
					MovieClip(go_right(clipDef).getChildAt(4)).getChildAt(1).visible = true;
				}
				if (go_right(clipDef).getChildAt(2) is head) {
					for (var i:int = 0; i < MovieClip(MovieClip(go_right(clipDef).getChildAt(2)).getChildAt(0)).numChildren; i++) {
						trace("i = " + i + " is" + MovieClip(MovieClip(go_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(i).toString());
						MovieClip(MovieClip(go_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(i).visible = false;
					}
					MovieClip(MovieClip(go_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.characterIndex).visible = true;
					MovieClip(MovieClip(go_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.hatIndex).visible = true;
				}
			} else 
			if (clipDef is go_left) {
				for (j = 0; j < MovieClip(go_left(clipDef).getChildAt(0)).numChildren; j++) {
					MovieClip(go_left(clipDef).getChildAt(0)).getChildAt(j).visible = false;
					MovieClip(go_left(clipDef).getChildAt(3)).getChildAt(j).visible = false;
				}
				
				for (j = 0; j < MovieClip(go_left(clipDef).getChildAt(1)).numChildren; j++) {
					MovieClip(go_left(clipDef).getChildAt(1)).getChildAt(j).visible = false;
				}
				
				MovieClip(go_left(clipDef).getChildAt(0)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(go_left(clipDef).getChildAt(3)).getChildAt(BallActor.shoesIndex).visible = true;
				if (BallActor.carryingItem == BallActor.UMBRELLA) {
					MovieClip(go_left(clipDef).getChildAt(1)).getChildAt(1).visible = true;
				} else {
					MovieClip(go_left(clipDef).getChildAt(1)).getChildAt(0).visible = true;
				}
				if (go_left(clipDef).getChildAt(2) is headleft) {
					for (i = 0; i < MovieClip(MovieClip(go_left(clipDef).getChildAt(2)).getChildAt(0)).numChildren; i++) {
						MovieClip(MovieClip(go_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(i).visible = false;
					}
					MovieClip(MovieClip(go_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.characterIndex + 1).visible = true;
					MovieClip(MovieClip(go_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.hatIndex).visible = true;
				}
			} else 
			if (clipDef is stay_right) {
				for (j = 0; j < MovieClip(stay_right(clipDef).getChildAt(0)).numChildren; j++) {
					MovieClip(stay_right(clipDef).getChildAt(0)).getChildAt(j).visible = false;
					MovieClip(stay_right(clipDef).getChildAt(3)).getChildAt(j).visible = false;
				}
				
				for (j = 0; j < MovieClip(stay_right(clipDef).getChildAt(4)).numChildren; j++) {
					//правая рука
					MovieClip(stay_right(clipDef).getChildAt(4)).getChildAt(j).visible = false;
				}
				for (j = 0; j < MovieClip(stay_right(clipDef).getChildAt(1)).numChildren; j++) {
					//левая рука
					MovieClip(stay_right(clipDef).getChildAt(1)).getChildAt(j).visible = false;
				}
				
				MovieClip(stay_right(clipDef).getChildAt(0)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(stay_right(clipDef).getChildAt(3)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(stay_right(clipDef).getChildAt(1)).getChildAt(0).visible = true;
				if (BallActor.carryingItem == BallActor.UMBRELLA) {
					MovieClip(stay_right(clipDef).getChildAt(4)).getChildAt(1).visible = true;
				} else {
					MovieClip(stay_right(clipDef).getChildAt(4)).getChildAt(0).visible = true;
				}
				if (stay_right(clipDef).getChildAt(2) is head) {
					for (i = 0; i < MovieClip(MovieClip(stay_right(clipDef).getChildAt(2)).getChildAt(0)).numChildren; i++) {
						MovieClip(MovieClip(stay_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(i).visible = false;
					}
					MovieClip(MovieClip(stay_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.characterIndex).visible = true;
					MovieClip(MovieClip(stay_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.hatIndex).visible = true;
				}
			} else 
			if (clipDef is stay_left) {
				for (j = 0; j < MovieClip(stay_left(clipDef).getChildAt(0)).numChildren; j++) {
					MovieClip(stay_left(clipDef).getChildAt(0)).getChildAt(j).visible = false;
					MovieClip(stay_left(clipDef).getChildAt(3)).getChildAt(j).visible = false;
				}
				for (j = 0; j < MovieClip(stay_left(clipDef).getChildAt(1)).numChildren; j++) {
					MovieClip(stay_left(clipDef).getChildAt(1)).getChildAt(j).visible = false;
				}
				for (j = 0; j < MovieClip(stay_left(clipDef).getChildAt(4)).numChildren; j++) {
					MovieClip(stay_left(clipDef).getChildAt(4)).getChildAt(j).visible = false;
				}
				MovieClip(stay_left(clipDef).getChildAt(0)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(stay_left(clipDef).getChildAt(3)).getChildAt(BallActor.shoesIndex).visible = true;
				if (BallActor.carryingItem == BallActor.UMBRELLA) {
					MovieClip(stay_left(clipDef).getChildAt(1)).getChildAt(1).visible = true;
				} else {
					MovieClip(stay_left(clipDef).getChildAt(1)).getChildAt(0).visible = true;
				}
				MovieClip(stay_left(clipDef).getChildAt(4)).getChildAt(1).visible = true;
				if (stay_left(clipDef).getChildAt(2) is headleft) {
					for (i = 0; i < MovieClip(MovieClip(stay_left(clipDef).getChildAt(2)).getChildAt(0)).numChildren; i++) {
						MovieClip(MovieClip(stay_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(i).visible = false;
					}
					MovieClip(MovieClip(stay_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.characterIndex + 1).visible = true;
					MovieClip(MovieClip(stay_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.hatIndex).visible = true;
				}
			} else 
			if (clipDef is jump_right) {
				for (j = 0; j < MovieClip(jump_right(clipDef).getChildAt(0)).numChildren; j++) {
					MovieClip(jump_right(clipDef).getChildAt(0)).getChildAt(j).visible = false;
					MovieClip(jump_right(clipDef).getChildAt(3)).getChildAt(j).visible = false;
				}
				
				for (j = 0; j < MovieClip(jump_right(clipDef).getChildAt(4)).numChildren; j++) {
					//правая рука
					MovieClip(jump_right(clipDef).getChildAt(4)).getChildAt(j).visible = false;
				}
				for (j = 0; j < MovieClip(jump_right(clipDef).getChildAt(1)).numChildren; j++) {
					//левая рука
					MovieClip(jump_right(clipDef).getChildAt(1)).getChildAt(j).visible = false;
				}
				
				MovieClip(jump_right(clipDef).getChildAt(0)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(jump_right(clipDef).getChildAt(3)).getChildAt(BallActor.shoesIndex).visible = true;
				if (BallActor.carryingItem == BallActor.UMBRELLA) {
					MovieClip(jump_right(clipDef).getChildAt(4)).getChildAt(0).visible = true;
				} else {
					MovieClip(jump_right(clipDef).getChildAt(4)).getChildAt(1).visible = true;
				}
				MovieClip(jump_right(clipDef).getChildAt(1)).getChildAt(0).visible = true;
				if (jump_right(clipDef).getChildAt(2) is head) {
					for (i = 0; i < MovieClip(MovieClip(jump_right(clipDef).getChildAt(2)).getChildAt(0)).numChildren; i++) {
						MovieClip(MovieClip(jump_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(i).visible = false;
					}
					MovieClip(MovieClip(jump_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.characterIndex).visible = true;
					MovieClip(MovieClip(jump_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.hatIndex).visible = true;
				}
			} else 
			if (clipDef is jump_left) {
				for (j = 0; j < MovieClip(jump_left(clipDef).getChildAt(0)).numChildren; j++) {
					MovieClip(jump_left(clipDef).getChildAt(0)).getChildAt(j).visible = false;
					MovieClip(jump_left(clipDef).getChildAt(3)).getChildAt(j).visible = false;
				}
				for (j = 0; j < MovieClip(jump_left(clipDef).getChildAt(4)).numChildren; j++) {
					//правая рука
					MovieClip(jump_left(clipDef).getChildAt(4)).getChildAt(j).visible = false;
				}
				for (j = 0; j < MovieClip(jump_left(clipDef).getChildAt(1)).numChildren; j++) {
					//левая рука
					MovieClip(jump_left(clipDef).getChildAt(1)).getChildAt(j).visible = false;
				}
				MovieClip(jump_left(clipDef).getChildAt(0)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(jump_left(clipDef).getChildAt(3)).getChildAt(BallActor.shoesIndex).visible = true;
				if (BallActor.carryingItem == BallActor.UMBRELLA) {
					MovieClip(jump_left(clipDef).getChildAt(1)).getChildAt(1).visible = true;
				} else {
					MovieClip(jump_left(clipDef).getChildAt(1)).getChildAt(0).visible = true;
				}
				MovieClip(jump_left(clipDef).getChildAt(4)).getChildAt(0).visible = true;
				if (jump_left(clipDef).getChildAt(2) is headleft) {
					for (i = 0; i < MovieClip(MovieClip(jump_left(clipDef).getChildAt(2)).getChildAt(0)).numChildren; i++) {
						MovieClip(MovieClip(jump_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(i).visible = false;
					}
					MovieClip(MovieClip(jump_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.characterIndex + 1).visible = true;
					MovieClip(MovieClip(jump_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.hatIndex).visible = true;
				}
			} else 
			if (clipDef is fall_right) {
				for (j = 0; j < MovieClip(fall_right(clipDef).getChildAt(0)).numChildren; j++) {
					//ноги
					MovieClip(fall_right(clipDef).getChildAt(0)).getChildAt(j).visible = false;
					MovieClip(fall_right(clipDef).getChildAt(3)).getChildAt(j).visible = false;
				}
				//руки
				for (j = 0; j < MovieClip(fall_right(clipDef).getChildAt(4)).numChildren; j++) {
					MovieClip(fall_right(clipDef).getChildAt(4)).getChildAt(j).visible = false;
				}
				for (j = 0; j < MovieClip(fall_right(clipDef).getChildAt(1)).numChildren; j++) {
					MovieClip(fall_right(clipDef).getChildAt(1)).getChildAt(j).visible = false;
				}
				MovieClip(fall_right(clipDef).getChildAt(0)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(fall_right(clipDef).getChildAt(3)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(fall_right(clipDef).getChildAt(1)).getChildAt(0).visible = true;
				MovieClip(MovieClip(MovieClip(fall_right(clipDef).getChildAt(1)).getChildAt(0)).getChildAt(0)).getChildAt(1).visible = false;
				if (BallActor.carryingItem == BallActor.UMBRELLA) {
					MovieClip(fall_right(clipDef).getChildAt(4)).getChildAt(1).visible = true;
				} else {
					MovieClip(fall_right(clipDef).getChildAt(4)).getChildAt(2).visible = true;
				}
				if (fall_right(clipDef).getChildAt(2) is head) {
					for (i = 0; i < MovieClip(MovieClip(fall_right(clipDef).getChildAt(2)).getChildAt(0)).numChildren; i++) {
						MovieClip(MovieClip(fall_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(i).visible = false;
					}
					MovieClip(MovieClip(fall_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.characterIndex).visible = true;
					MovieClip(MovieClip(fall_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.hatIndex).visible = true;
				}
			} else 
			if (clipDef is fall_left) {
				for (j = 0; j < MovieClip(fall_left(clipDef).getChildAt(0)).numChildren; j++) {
					//ноги
					MovieClip(fall_left(clipDef).getChildAt(0)).getChildAt(j).visible = false;
					MovieClip(fall_left(clipDef).getChildAt(3)).getChildAt(j).visible = false;
				}
					//руки
				for (j = 0; j < MovieClip(fall_left(clipDef).getChildAt(4)).numChildren; j++) {
					MovieClip(fall_left(clipDef).getChildAt(4)).getChildAt(j).visible = false;
				}
				for (j = 0; j < MovieClip(fall_left(clipDef).getChildAt(1)).numChildren; j++) {
					MovieClip(fall_left(clipDef).getChildAt(1)).getChildAt(j).visible = false;
				}
				MovieClip(fall_left(clipDef).getChildAt(0)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(fall_left(clipDef).getChildAt(3)).getChildAt(BallActor.shoesIndex).visible = true;
				if (BallActor.carryingItem == BallActor.UMBRELLA) {
					MovieClip(fall_left(clipDef).getChildAt(1)).getChildAt(0).visible = true;
				} else {
					MovieClip(fall_left(clipDef).getChildAt(1)).getChildAt(0).visible = true;
					MovieClip(MovieClip(MovieClip(fall_left(clipDef).getChildAt(1)).getChildAt(0)).getChildAt(0)).getChildAt(1).visible = false;
				}
				MovieClip(fall_left(clipDef).getChildAt(4)).getChildAt(2).visible = true;
				
				if (fall_left(clipDef).getChildAt(2) is headleft) {
					for (i = 0; i < MovieClip(MovieClip(fall_left(clipDef).getChildAt(2)).getChildAt(0)).numChildren; i++) {
						MovieClip(MovieClip(fall_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(i).visible = false;
					}
					MovieClip(MovieClip(fall_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.characterIndex + 1).visible = true;
					MovieClip(MovieClip(fall_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.hatIndex).visible = true;
				}
			}
			if (clipDef is umbrella_right) {
				for (j = 0; j < MovieClip(umbrella_right(clipDef).getChildAt(0)).numChildren; j++) {
					//ноги
					MovieClip(umbrella_right(clipDef).getChildAt(0)).getChildAt(j).visible = false;
					MovieClip(umbrella_right(clipDef).getChildAt(3)).getChildAt(j).visible = false;
				}
				//руки
				for (j = 0; j < MovieClip(umbrella_right(clipDef).getChildAt(4)).numChildren; j++) {
					MovieClip(umbrella_right(clipDef).getChildAt(4)).getChildAt(j).visible = false;
				}
				for (j = 0; j < MovieClip(umbrella_right(clipDef).getChildAt(1)).numChildren; j++) {
					MovieClip(umbrella_right(clipDef).getChildAt(1)).getChildAt(j).visible = false;
				}
				MovieClip(umbrella_right(clipDef).getChildAt(0)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(umbrella_right(clipDef).getChildAt(3)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(umbrella_right(clipDef).getChildAt(1)).getChildAt(0).visible = true;
				MovieClip(MovieClip(umbrella_right(clipDef).getChildAt(1)).getChildAt(0)).getChildAt(0).visible = false;
				MovieClip(umbrella_right(clipDef).getChildAt(4)).getChildAt(0).visible = true;
				if (umbrella_right(clipDef).getChildAt(2) is head) {
					for (i = 0; i < MovieClip(MovieClip(umbrella_right(clipDef).getChildAt(2)).getChildAt(0)).numChildren; i++) {
						MovieClip(MovieClip(umbrella_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(i).visible = false;
					}
					MovieClip(MovieClip(umbrella_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.characterIndex).visible = true;
					MovieClip(MovieClip(umbrella_right(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.hatIndex).visible = true;
				}
			} else 
			if (clipDef is umbrella_left) {
				for (j = 0; j < MovieClip(umbrella_left(clipDef).getChildAt(0)).numChildren; j++) {
					//ноги
					MovieClip(umbrella_left(clipDef).getChildAt(0)).getChildAt(j).visible = false;
					MovieClip(umbrella_left(clipDef).getChildAt(3)).getChildAt(j).visible = false;
				}
					//руки
				for (j = 0; j < MovieClip(umbrella_left(clipDef).getChildAt(4)).numChildren; j++) {
					MovieClip(umbrella_left(clipDef).getChildAt(4)).getChildAt(j).visible = false;
				}
				for (j = 0; j < MovieClip(umbrella_left(clipDef).getChildAt(1)).numChildren; j++) {
					MovieClip(umbrella_left(clipDef).getChildAt(1)).getChildAt(j).visible = false;
				}
				MovieClip(umbrella_left(clipDef).getChildAt(0)).getChildAt(BallActor.shoesIndex).visible = true;
				MovieClip(umbrella_left(clipDef).getChildAt(3)).getChildAt(BallActor.shoesIndex).visible = true;
				//MovieClip(umbrella_left(clipDef).getChildAt(1)).getChildAt(1).visible = true;
				MovieClip(umbrella_left(clipDef).getChildAt(4)).getChildAt(0).visible = true;
				if (umbrella_left(clipDef).getChildAt(2) is headleft) {
					for (i = 0; i < MovieClip(MovieClip(umbrella_left(clipDef).getChildAt(2)).getChildAt(0)).numChildren; i++) {
						MovieClip(MovieClip(umbrella_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(i).visible = false;
					}
					MovieClip(MovieClip(umbrella_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.characterIndex + 1).visible = true;
					MovieClip(MovieClip(umbrella_left(clipDef).getChildAt(2)).getChildAt(0)).getChildAt(BallActor.hatIndex).visible = true;
				}
			}
			if (useSpriteSheet) {
				buildCacheFromClip2(clipDef);
				
			} else {
				buildCacheFromClip(clipDef);
			}
		}
		public function buildCacheFromClip(_clip:MovieClip):void
		{			
			clip = _clip;
			
			if (clip["e_bounds"] != null)
			{
				var c = clip["e_bounds"];
				r = new Rectangle(c.x, c.y, c.width, c.height);
				clip["e_bounds"].visible = false;
			} else {
				r = clip.getRect(clip)
			}
			
			for (var i = 1; i <= clip.totalFrames; i++)
			{
				clip.gotoAndStop(i)
				makeAllChildrenGoToFrame(clip, i);
				var bitmapData:BitmapData;
				if (clipDef is GroundBackground || clipDef is GrassBackground) {
					bitmapData = new BitmapData(r.width, r.height, true, 0x00000000);
				} else {
					bitmapData = new BitmapData(r.width*1.2, r.height*1.1, true, 0x00000000);
				}
				var m:Matrix = new Matrix();
				if (clipDef is Zombie || clipDef is Mountains) {
					m.translate( -r.x * 1.2, -r.y * 1.1);
				} else {
					m.translate(-r.x, -r.y);
				}
				m.scale(clip.scaleX, clip.scaleY);
				bitmapData.draw(clip,m);
				frames.push(bitmapData);
			}
			bitmap.x = r.x;
			bitmap.y = r.y;
			//bitmap.smoothing = true;
		}
		
		public function buildCacheFromClip2(_clip:MovieClip):void
		{
			clip = _clip;
			
			if (clip["e_bounds"] != null)
			{
				var c = clip["e_bounds"];
				r = new Rectangle(c.x, c.y, c.width, c.height);
				clip["e_bounds"].visible = false;
			} else {
				r = clip.getRect(clip)
			}
			
			cols= Math.floor(2880 / r.width);
			rows= Math.ceil(clip.totalFrames / cols);
			
			bigBitmap = new BigAssCanvas( Math.ceil(cols * clip.width), Math.ceil(rows * clip.height), true);
			
			for (var i = 0; i <= clip.totalFrames-1; i++)
			{
				clip.gotoAndStop(i+1)
				makeAllChildrenGoToFrame(clip, i+1);
				
				var xx = i % cols * r.width;
				var yy = Math.floor(i/cols) * r.height;
				
				var m:Matrix = new Matrix();
				m.translate(-r.x, -r.y);
				
				m.scale(clip.scaleX, clip.scaleY);
				m.translate(xx, yy)
				
				bigBitmap.draw(clip, m, null, null);
			}
			_totalFrames = clip.totalFrames;
		}
		
		private function makeAllChildrenGoToFrame(m:MovieClip, f:int):void
		{
			for (var i:int = 0; i < m.numChildren; i++) {
				var c = m.getChildAt(i);
				if (c is MovieClip) {
					makeAllChildrenGoToFrame(c, f);
					c.gotoAndStop(f);
				}
			}
		}
		
		public function play():void
		{
			_playing = true;
			addEventListener(Event.ENTER_FRAME, enterFrame, false, 0, true);
		}
		
		public function stop():void
		{
			_playing = false;
			removeEventListener(Event.ENTER_FRAME, enterFrame)
		}
		
		public function gotoAndStop(frame:Number):void
		{
			if (treatAsLoopedGraphic) {
				if (frame > totalFrames) {
					frame = frame % totalFrames;
				}
			}
			currentFrame = frame;
			
			goto(currentFrame);
			stop();
		}
		
		public function gotoAndPlay(frame:Number):void
		{
			currentFrame = frame;
			goto(currentFrame);
			play();
		}
		
		public function gotoAndPlayRandomFrame():void
		{
			gotoAndPlay(Math.ceil(Math.random() * totalFrames));
		}
		
		public function nextFrame(useSpeed:Boolean = false):void
		{
			useSpeed ? currentFrame += speed : currentFrame++;
			if (currentFrame > totalFrames) currentFrame = 1;
			goto(Math.floor(currentFrame));
		}
		public function prevFrame(useSpeed:Boolean = false):void
		{
			useSpeed ? currentFrame -= speed : currentFrame--;
			
			if (currentFrame < 1) currentFrame = totalFrames;
			goto(Math.floor(currentFrame));
		}
		import flash.utils.getQualifiedClassName;
		
		private function goto(frame:Number):void
		{
			if (!_cache)
			{
				if (!clipData)
				{
					var c = getQualifiedClassName(clip);
					clipData = new(getDefinitionByName(c))();
					var rect:Rectangle = clipData.getRect(clipData);
					clipData.x = rect.x;
					clipData.y = rect.y;
					addChild(clipData);
				}
				clipData.gotoAndStop(frame);
			} else {
				
					if (useSpriteSheet) {
						var temp:Rectangle = r.clone();
						temp.x = ((currentFrame-1) % cols) * r.width;
						temp.y = Math.floor((currentFrame-1) / cols) * r.height;
						
						if(bitmapData)bitmapData.dispose();
						bitmapData = bigBitmap.copyPixelsOut(temp);
						bitmap.bitmapData = bitmapData;
						bitmap.smoothing = true;
					} else {
						bitmap.bitmapData = frames[currentFrame-1];
						bitmap.smoothing = true;
					}
			}
		}
		
		public function enterFrame(e:Event = null):void
		{
			if(reverse){
				prevFrame(true)
			}else {
				nextFrame(true);
			}
			
			if (currentFrame >= totalFrames) {
				
				if (!repeat) {
					stop();
				}
				dispatchEvent(new Event(Event.COMPLETE))
				if (onEnd != null) onEnd();
			}
		}
		
		public function update():void
		{
			//addChild(bigBitmap);
			stop();
			frames = [];
			buildCacheFromClip(clip);
		}
		
		public function destroy()
		{
			stop();
			if (parent) parent.removeChild(this);
		}
	}
}
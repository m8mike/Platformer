package  
{
	import com.touchmypixel.peepee.utils.Animation;
	import com.touchmypixel.peepee.utils.AnimationCache;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class LevelDirector 
	{
		public static var _levelPieces:Array = [];
		public static var _rm:RandomMap;
		public static var screen:MovieClip;
		public static var removeScreen:Boolean = false;
		
		static public var funkyMountains:Animation;
		static public var coniferous:Animation;
		static public var bigCloud1:Animation;
		static public var bigCloud2:Animation;
		static public var bigCloud3:Animation;
		static public var fon:Animation;
		static public var fon2:Animation;
		static public var fon3:Animation;
		static public var fon4:Animation;
		
		public function LevelDirector() 
		{
			
		}
		
		public static function createLevel(level:int):void
		{
			switch (level) {
				case 0: createLevel2(); break;
				case 1: createLevel2(); break;
				case 2: createLevel2(); break;
				case 3: createLevel2(); break;
				case 4: createLevel2(); break;
				case 5: createLevel6(); break;
				case 6: createLevel7(); break;
				case 7: createLevel8(); break;
				case 10: new LevelEditor(Platformer._camera); break;
				default: createLevel9();
			}
			removeScreen = true;
		}
		
		public static function removeLoadingScreen():void 
		{
			Platformer._cameraLoading.removeChild(screen);
			screen = null;
		}
		
		public static function setLoadingScreen(e:Event):void 
		{
			if (screen) {
				trace("no error");
				if (screen.currentFrame == 35) {
					screen.gotoAndStop(35);
					Platformer._cameraLoading.removeEventListener(Event.ENTER_FRAME, setLoadingScreen);
					Platformer._cameraLoading.addEventListener(Event.ENTER_FRAME, checkForRemovingLoadingScreen);
					Platformer.needToStartLevel = levelSelectMc.needToStartLevel;
				}
			} else {
				trace("error");
			}
		}
		
		public static function checkForRemovingLoadingScreen(e:Event):void 
		{
			if (removeScreen){
				if (screen.currentFrame == 35) {
					screen.gotoAndPlay(36);
				} else
				if (screen.currentFrame >= 45) {
					removeLoadingScreen();
					Platformer._cameraLoading.removeEventListener(Event.ENTER_FRAME, checkForRemovingLoadingScreen);
				}
			}
		}
		
		private static function cropBitmap(bmd:BitmapData, newWidth:uint, newHeight:uint, newX:uint=0, newY:uint=0):BitmapData
		{
			var newBMD:BitmapData = new BitmapData(newWidth, newHeight);
			newBMD.copyPixels(bmd, new Rectangle(newX, newY, newWidth, newHeight), new Point(0, 0));
			return newBMD;
		}
		
		public static function rasterize2(clip:Sprite):void {
			var clipContentsBound:Rectangle = clip.getBounds(clip);
			var bitmapData1:BitmapData;
			bitmapData1 = new BitmapData(clipContentsBound.width * 2, 
										clipContentsBound.height * 2, true, 0x00000000);
			var matrix1:Matrix = new Matrix();
			matrix1.scale(2, 2);
			matrix1.translate( -clipContentsBound.x * 0, -clipContentsBound.y * 2);
			bitmapData1.draw(clip, matrix1);
			while (clip.numChildren > 0) clip.removeChildAt(0);
			clip.graphics.clear();
			var bitmap1:Bitmap = new Bitmap(bitmapData1);
			bitmap1.x = 0;
			bitmap1.y = clipContentsBound.y;
			bitmap1.smoothing = true;
			bitmap1.scaleX = 0.5;
			bitmap1.scaleY = 0.5;
			
			//clip.addChild(bitmap1);
			for (var i:int = bitmapData1.width / 640 ; i >= 0; i--) {
				for (var j:int = bitmapData1.height / 480 ; j >= 0; j--) {
					var bmd:BitmapData = cropBitmap(bitmapData1, 640, 480, i * 640, j * 480);
					var bitmap:Bitmap = new Bitmap(bmd);
					bitmap.x = 0 + i * 640;
					bitmap.y = clipContentsBound.y + j * 480;
					_levelPieces.push(bitmap);
					//bitmap.smoothing = true;/////////////////////////////////
					(j+i) % 2 ? Platformer._cameraStaticLayer1.addChild(bitmap):clip.addChild(bitmap);
				}
			}
			Platformer._cameraStaticLayer1.scaleX = 0.5;
			Platformer._cameraStaticLayer1.scaleY = 0.5;
			clip.scaleX = 0.5;
			clip.scaleY = 0.5;
			clip.x = Platformer._cameraStaticLayer1.x - clip.x;
			clip.y = Platformer._cameraStaticLayer1.y - clip.y;
			Platformer._cameraStaticLayer1.x = 0;
			Platformer._cameraStaticLayer1.y = clipContentsBound.y/2;
			clip.x += Platformer._cameraStaticLayer1.x;
			clip.y += Platformer._cameraStaticLayer1.y;
		}
		
		public static function rasterize(clip:Sprite):void {
			var clipContentsBound:Rectangle = clip.getBounds(clip);
			var bitmapData:BitmapData = new BitmapData(clipContentsBound.width, 
													   clipContentsBound.height, true, 0x00000000);
			var matrix:Matrix = new Matrix();
			matrix.translate( -clipContentsBound.x, -clipContentsBound.y);
			bitmapData.draw(clip, matrix);
			while (clip.numChildren > 0) clip.removeChildAt(0);
			clip.graphics.clear();
			var bitmap:Bitmap = new Bitmap(bitmapData);
			bitmap.x = clipContentsBound.x;
			bitmap.y = clipContentsBound.y;
			//bitmap.smoothing = true;///////////////////////////////////
			clip.addChild(bitmap);
		}
		
		public static function rasterizeAll():void
		{
			for (var n:int = 0; n < Platformer._camera2.numChildren; n++) {
				rasterize(Sprite(Platformer._camera2.getChildAt(n)));
			}
			for (n = 0; n < Platformer._camera3.numChildren; n++) {
				rasterize(Sprite(Platformer._camera3.getChildAt(n)));
			}
			for (n = 0; n < Platformer._camera4.numChildren; n++) {
				rasterize(Sprite(Platformer._camera4.getChildAt(n)));
			}
			for (n = 0; n < Platformer._camera5.numChildren; n++) {
				rasterize(Sprite(Platformer._camera5.getChildAt(n)));
			}
			for (n = 0; n < Platformer._camera6.numChildren; n++) {
				rasterize(Sprite(Platformer._camera6.getChildAt(n)));
			}
			for (n = 0; n < Platformer._camera7.numChildren; n++) {
				rasterize(Sprite(Platformer._camera7.getChildAt(n)));
			}
			for (n = 0; n < Platformer._camera8.numChildren; n++) {
				rasterize(Sprite(Platformer._camera8.getChildAt(n)));
			}
			/*for (n = 0; n < Platformer._camera9.numChildren; n++) {
				rasterize(Sprite(Platformer._camera9.getChildAt(n)));
			}*/
			for (n = 0; n < Platformer._camera10.numChildren; n++) {
				rasterize(Sprite(Platformer._camera10.getChildAt(n)));
			}
			/*if (Platformer.levelNow >= 1 && Platformer.levelNow <= 8) {
				rasterize2(Platformer._cameraStaticLayer);
			} else {
				rasterize(Platformer._cameraStaticLayer);
			}*/
		}
		public static function addBackground():void 
		{
			var offset:Number = -300;
			var animationCache:AnimationCache = AnimationCache.getInstance();
			animationCache.replaceExisting = true;
			animationCache.cacheAnimation("Mountains");
			animationCache.cacheAnimation("Coniferous");
			animationCache.cacheAnimation("bigCloud");
			animationCache.cacheAnimation("hillsWithTrees1");//"fon1");
			animationCache.cacheAnimation("hillsWithTrees2");//"fon32");
			animationCache.cacheAnimation("hillsWithTrees3");//"fon6");
			animationCache.cacheAnimation("hillsWithTrees4");//"fon5");
			for (var i:int = -2; i < 5; i++) {
				/*funkyMountains = animationCache.getAnimation("Mountains");
				funkyMountains.x = (funkyMountains.width*3.3) * i;
				funkyMountains.scaleX = 4;
				funkyMountains.scaleY = 4;
				Platformer._camera9.addChild(funkyMountains);
				coniferous = animationCache.getAnimation("Coniferous");
				coniferous.scaleX = 0.5;
				coniferous.scaleY = 0.5;
				coniferous.x = (coniferous.width - 1300) * i;
				Platformer._camera10.addChild(coniferous);*/
				bigCloud1 = animationCache.getAnimation("bigCloud");
				bigCloud1.x += i * bigCloud1.width;
				bigCloud1.y = -300;
				Platformer._camera6.addChild(bigCloud1);
				bigCloud2 = animationCache.getAnimation("bigCloud");
				bigCloud2.x += i * bigCloud1.width;
				bigCloud2.y = -150;
				Platformer._camera7.addChild(bigCloud2);/*
				bigCloud3 = animationCache.getAnimation("bigCloud");
				bigCloud3.x += i * bigCloud1.width;
				bigCloud3.y = -300;
				Platformer._camera8.addChild(bigCloud3);*/
				fon = animationCache.getAnimation("hillsWithTrees1");//"fon1");
				fon.x += offset;
				Platformer._camera2.addChild(fon);
				fon4 = animationCache.getAnimation("hillsWithTrees3");//"fon32");
				fon4.x += offset;
				Platformer._camera5.addChild(fon4);
				offset -= fon.width / 2;
				fon2 = animationCache.getAnimation("hillsWithTrees2");//"fon6");
				fon2.x += offset;/*
				fon3 = animationCache.getAnimation("hillsWithTrees4");//"fon5");
				fon3.x += offset;*/
				Platformer._camera3.addChild(fon2);
				//Platformer._camera4.addChild(fon3);
				offset += fon.width*4/3;
			}
			
			/*for (var j:int = -2; j < 5; j++) 
			{
				var bigCloud1:MovieClip = new bigCloud();
				bigCloud1.x += j * bigCloud1.width;
				bigCloud1.y = -150;
				_camera6.addChild(bigCloud1);
				var bigCloud2:MovieClip = new bigCloud();
				bigCloud2.x += j * bigCloud1.width;
				bigCloud2.y = -150;
				_camera7.addChild(bigCloud2);
				var bigCloud3:MovieClip = new bigCloud();
				bigCloud3.x += j * bigCloud1.width;
				bigCloud3.y = -150;
				_camera8.addChild(bigCloud3);
				var fon:MovieClip = new fon1();
				fon.x += offset;
				_camera2.addChild(fon);
				var fon4:MovieClip = new fon32();
				fon4.x += offset;
				_camera5.addChild(fon4);
				offset -= fon.width / 2;
				var fon2:MovieClip = new fon6();
				fon2.x += offset;
				var fon3:MovieClip = new fon5();
				fon3.x += offset;
				var mountains:MovieClip = new Mountains();
				mountains.scaleX = 4;
				mountains.scaleY = 4;
				mountains.x = (mountains.width - 40) * j;
				var coniferous:MovieClip = new Coniferous();
				coniferous.scaleX = 4;
				coniferous.scaleY = 4;
				coniferous.x = (coniferous.width - 40) * j;
				_camera3.addChild(fon2);
				_camera4.addChild(fon3);
				//_camera9.addChild(mountains);
				_camera10.addChild(coniferous);
				offset += fon.width * 3 / 2;
			}*/
		}
		
		private static function addTopHat(x:int, y:int):void 
		{
			makeRect(0.5, 3.4, 3+x-5, -3.4+y, ArbiStaticActor.HAT);
			makeRect(0.7, 3.4, 6.3 + x - 5, -3.4 + y, ArbiStaticActor.HAT);
			makeRect(3.3, 0.5, 3+x-5+0.5, -0.5+y, ArbiStaticActor.END_LEVEL);
			var hat:MovieClip = new hatFinish();
			hat.x = x*20;
			hat.y = y*20;
			hat.scaleX = 0.2;
			hat.scaleY = 0.2;
			Platformer._camera.addChildAt(hat, 0);
			var topHat:MovieClip = new hatFinishTop();
			topHat.x = x*20;
			topHat.y = y*20;
			topHat.scaleX = 0.2;
			topHat.scaleY = 0.2;
			Platformer._camera.addChild(topHat);
		}
		
		private static function addHighTree(x:int, y:int):void 
		{
			makeRect(1.7, 1, x+1, y-6.4, ArbiStaticActor.TREE);
			makeRect(1.7, 1, x+1, y-13.1, ArbiStaticActor.TREE);
			makeRect(1.3, 1, x+1, y-1.8, ArbiStaticActor.TREE);
			makeRect(1.7, 1, x-1.5, y-4.2, ArbiStaticActor.TREE);//левая ветка 
			makeRect(1.7, 1, x-1.5, y-9.7, ArbiStaticActor.TREE);//левая ветка 
			
			var animationCache:AnimationCache = AnimationCache.getInstance();
			animationCache.replaceExisting = true;
			animationCache.cacheAnimation("highTree");
			var tree:Animation = animationCache.getAnimation("highTree");
			tree.x = x*20;
			tree.y = y*20;
			tree.scaleX = 0.3;
			tree.scaleY = 0.3;
			Platformer._cameraStaticLayer.addChild(tree);
		}
		// Arbi if rigid/transparent add grass x 4
		public static function makeRect(w:Number, h:Number, x:Number, y:Number, pType:int = 0, cloud:Cloud = null):ArbiStaticActor
		{
			var koef:int = 20;//15
			var shape:Array = [[new Point(0, 0), new Point(w * koef, 0), new Point(w * koef, h * koef), new Point(0, h * koef)]];
			var rect:ArbiStaticActor;
			if (cloud) {
				rect = new ArbiStaticActor(Platformer._cameraDynamicLayer, new Point(x * koef, y * koef), shape, pType, null, cloud);
			} else {
				rect = new ArbiStaticActor(Platformer._cameraStaticLayer, new Point(x * koef, y * koef), shape, pType, null, cloud);
			}
			Platformer._allActors.push(rect);
			if (pType == ArbiStaticActor.RIGID || pType == ArbiStaticActor.TRANSPARENT) {
				var grassSection:MovieClip = new MovieClip();
				var m:int = 1;
				while (grassSection.width < w * koef) {
					var grass:MovieClip;
					if (y > 0) {
						grass = new GroundBackground();
					} else { 
						grass = new GrassBackground();
					}
					grass.x = 40 * m - 11 * (m - 1);
					grass.y = 0;
					grass.scaleX = 0.15;
					grass.scaleY = 0.15;
					
					var grassBmp:BmpFrames = BmpFrames.createBmpFramesFromMC(grass);
					var bmp1:Bitmap = new Bitmap(grassBmp.frames[0], PixelSnapping.ALWAYS, true);
					bmp1.x = grass.x-bmp1.width*0.15;
					bmp1.y = grass.y-bmp1.height*0.07;
					bmp1.scaleX = 0.15;
					bmp1.scaleY = 0.15;
					
					grassSection.addChild(bmp1);
					var ceiling:MovieClip = new GroundBackground();
					ceiling.scaleX = 0.15;
					ceiling.scaleY = 0.15;
					ceiling.x = 40 * m - 11 * (m - 1);
					ceiling.y = h * koef;
					
					var boundsBmp:BmpFrames = BmpFrames.createBmpFramesFromMC(ceiling);
					var bmp2:Bitmap = new Bitmap(boundsBmp.frames[0], PixelSnapping.ALWAYS, true);
					bmp2.x = ceiling.x+3;
					bmp2.y = ceiling.y+2;
					bmp2.scaleX = 0.15;
					bmp2.scaleY = 0.15;
					bmp2.rotation = 180;
					grassSection.addChild(bmp2);
					m++;
				}
				m = 1;
				var boundsSection:MovieClip = new MovieClip();
				while (boundsSection.height < h * koef) {
					var leftBound:MovieClip = new GroundBackground();
					leftBound.x = 0;
					leftBound.y = 40 * m - 11 * (m - 1);
					leftBound.scaleX = 0.15;
					leftBound.scaleY = 0.15;
					leftBound.rotation = -90;
					var boundsBmp1:BmpFrames = BmpFrames.createBmpFramesFromMC(leftBound);
					bmp1 = new Bitmap(boundsBmp1.frames[0], PixelSnapping.ALWAYS, true);
					bmp1.x = leftBound.x-6;
					bmp1.y = leftBound.y+bmp1.height*0.8-40;
					bmp1.scaleX = 0.15;
					bmp1.scaleY = 0.15;
					bmp1.rotation = -90;
					boundsSection.addChild(bmp1);
					var rightBound:MovieClip = new GroundBackground();
					rightBound.x = w * koef;
					rightBound.y = 40 * m - 11 * (m - 1);
					rightBound.scaleX = 0.15;
					rightBound.scaleY = 0.15;
					var boundsBmp2:BmpFrames = BmpFrames.createBmpFramesFromMC(rightBound);
					bmp2 = new Bitmap(boundsBmp2.frames[0], PixelSnapping.ALWAYS, true);
					bmp2.x = rightBound.x+6;
					bmp2.y = rightBound.y-bmp2.height*0.07-40;
					bmp2.scaleX = 0.15;
					bmp2.scaleY = 0.15;
					bmp2.rotation = 90;
					boundsSection.addChild(bmp2);
					m++;
				}
				grassSection.x = x * koef;
				grassSection.y = y * koef;
				boundsSection.x = x * koef;
				boundsSection.y = y * koef;
				grassSection.width = w * koef + 10;
				boundsSection.height = h * koef;
				Platformer._cameraStaticLayer.addChild(boundsSection);
				Platformer._cameraStaticLayer.addChild(grassSection);
			}
			
			return rect;
		}
		// Arbi 
		public static function makeElevator(w:Number, h:Number, x:Number, y:Number, x2:Number, y2:Number):void 
		{
			var koef:int = 20;//15
			var wClouds:Number = 3.75;
			var shape:Array = [[new Point(0, 0), new Point(wClouds * koef, 0), new Point(wClouds * koef, h * koef), new Point(0, h * koef)]];
			var rect:ArbiStaticActor = new ArbiStaticActor(Platformer._cameraDynamicLayer, new Point(x * koef, y * koef), shape, 
				ArbiStaticActor.ELEVATOR, 
				new Point(x2 * koef, y2 * koef));
			Platformer._allActors.push(rect);
		}
		//
		private static function createLevel1():void 
		{
			/*_cannon = new Cannon(Platformer.LAUNCH_POINT);
			_cannon2 = new Cannon(Platformer.LAUNCH_POINT2);
			
			var leftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 0), setupClass.wallShapes);
			_allActors.push(leftWall);
			var rightWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3, 0), setupClass.wallShapes);
			_allActors.push(rightWall);
			var rightLeftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12, -7*12), setupClass.wallShapes);
			_allActors.push(rightLeftWall);		
			var rightRightWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(100 * PhysiVals.RATIO, 10 * PhysiVals.RATIO), setupClass.wallShapes);
			_allActors.push(rightRightWall);
			var rightRightWall2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(97 * PhysiVals.RATIO, 5 * PhysiVals.RATIO), setupClass.wallShapes);
			_allActors.push(rightRightWall2);
			
			
			var topFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 0), setupClass.floorShapes);
			_allActors.push(topFloor);
			var downFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 41 * 12), setupClass.floorShapes);
			_allActors.push(downFloor);
			var rightFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*2, 41 * 12), setupClass.floorShapes);
			_allActors.push(rightFloor);
			var rightRightFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3, 41 * 12), setupClass.floorShapes);
			_allActors.push(rightRightFloor);
			var rightDownFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(3000 - 58 * 6 - 58 * 12, 300 + 42 * 12 + 12 * 12), setupClass.floorShapes);
			_allActors.push(rightDownFloor);
			
			var floorH:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58 * 12, 41 * 12), setupClass.floorShapes);
			_allActors.push(floorH);
			var holm:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(3000-58*6 , 300+42*12 + 12 * 12), setupClass.holmShapes);
			_allActors.push(holm);
			*/
		}
		private static function createLevel2():void 
		{
			makeRect(1,60,0,-60);
			makeRect(60,30,0,0);
			makeRect(3,3,34,-3);
			makeRect(41,15,60,-9);
			makeRect(9,1,32,-20);
			makeRect(2,5,49,-19);
			makeRect(7,1,47,-20);
			makeRect(17,1,49,-15);
			makeRect(9,1,32,-20);
			makeRect(6,1,49,-30);
			makeRect(16,1,69,-14);
			makeRect(18,1,77,-21);
			makeRect(38, 17, 101, -23);
			makeElevator(4, 1, 55, -2, 55, -9);
			makeElevator(4, 1, 96, -10, 96, -23);
			addBackground();
			rasterizeAll();
			addTopHat(115, -23);
			Platformer._camera.ZOOM_IN_AMT = 12;
			Platformer.stopLevel = true;
		}
		
		private static function createLevel3():void 
		{
			makeRect(1, 10 * 5, 0, -10 * 5);
			makeRect(6 * 5 + 3, 6 * 5, 0, 0);
			makeRect(3, 3, 4 * 5 + 4, -3);
			makeRect(6 * 5, 1, 6 * 5 + 2, 0);
			makeRect(8 * 5 + 1, 9, 11 * 5 + 3, -9);
			makeRect(7 * 5 + 3, 2 * 5 + 3, 18 * 5 + 2, -23);
			makeRect(10, 1, 18 * 5 - 2, -10);
			makeRect(4, 1, 17 * 5 + 3, -14);
			makeRect(16, 1, 13 * 5 + 2, -14);
			makeRect(17, 1, 9 * 5 + 4, -15);
			makeRect(2, 4, 9 * 5 + 4, -19);
			makeRect(7, 1, 9 * 5 + 2, -20);
			makeRect(9, 1, 6 * 5 + 2, -20);
			makeRect(6, 1, 8 * 5 + 1, -26);
			makeRect(5, 1, 9 * 5 + 4, -31);
			makeRect(9, 1, 11 * 5 + 4, -20);
			makeRect(18, 1, 14 * 5 + 4, -21);
			//makeRect(6, 1, 18 * 5, -36);
			makeRect(8, 1, 19 * 5 + 2, -32);
			makeRect(19, 1, 21 * 5 + 1, -28);
			makeRect(6, 4, 22 * 5 + 4, -27);
			makeRect(29, 1, 20 * 5 + 1, -37);
			makeRect(1, 8, 23 * 5 + 4, -36);
			makeRect(2, 3, 21 * 5 + 3, -40);
			makeRect(2, 3, 24 * 5 + 2, -40);
			makeRect(1, 10, 25 * 5 + 4, -47);
			makeRect(6, 1, 25 * 5 + 4, -48);
			makeRect(7, 1, 27 * 5, -42);
			makeRect(5, 1, 28 * 5 + 2, -37);
			makeRect(5, 45, 29 * 5 + 1, -75);
			makeRect(4, 1, 25 * 5, -31);
			makeRect(10, 6, 28 * 5 + 1, -32);
			makeRect(6, 28, 27 * 5, -32);
			makeRect(2, 1, 26 * 5 + 3, -20);
			makeRect(3, 1, 26 * 5, -16);
			makeRect(2, 1, 26 * 5 + 3, -12);
			makeRect(24, 19, 23 * 5 + 2, -5);
			makeRect(12, 1, 19 * 5 + 4, -5);
			makeRect(3, 1, 22 * 5 + 4, 1);
			makeRect(6, 1, 21 * 5 + 3, 7);
			makeRect(15, 13, 21 * 5 + 3, 13);
			makeRect(44, 1, 15 * 5 + 4, 26);
			makeRect(10, 7, 13 * 5 + 4, 26);
			makeRect(9, 17, 12 * 5, 16);
			makeRect(8, 1, 10 * 5 + 2, 16);
			makeRect(11, 1, 7 * 5 + 1, 13);
			makeRect(3, 1, 6 * 5 + 3, 20);
			makeRect(11, 1, 8 * 5 + 1, 23);
			makeRect(5, 1, 11 * 5, 28);
			makeRect(1, 11, 15 * 5 + 3, 33);
			makeRect(32, 6, 9 * 5 + 2, 37);
			makeRect(9, 18, 6 * 5 + 4, 37);
			makeRect(1, 8, 6 * 5 + 3, 32);
			makeRect(2, 1, 6 * 5 + 1, 32);
			makeRect(4, 1, 6 * 5, 40);
			makeRect(1, 7, 5 * 5 + 1, 30);
			makeRect(17, 10, 11, 36);
			makeRect(3, 1, 5 * 5 + 3, 36);
			makeRect(3, 1, 5 * 5 + 3, 45);
			makeRect(12, 8, 0, 46);
			makeRect(1, 18, 0, 53);
			makeRect(20, 1, 0, 71);
			makeRect(7, 3, 12, 51);
			makeRect(3, 12, 19, 51);
			makeRect(8, 4, 27, 51);
			
			makeRect(12,3,8,12*5);
			makeRect(3,5,5,11*5+3);
			makeRect(2,1,3,11*5+3);
			makeRect(2,1,1,12*5+1);
			makeRect(2,1,3,13*5);
			makeRect(2,1,1,13*5+3);
			makeRect(3,1,9,14*5);
			makeRect(17,2,18,13*5+4);
			makeRect(12,1,34,13*5+3);
			makeRect(5,1,26,63);
			makeRect(4,1,34,65);
			makeRect(33,1,45,67);
			makeRect(31,5,27,54);
			makeRect(3,1,43,46);
			makeRect(3,1,46,49);
			makeRect(3,4,49,59);
			makeRect(6,5,52,59);
			makeRect(8,4,58,60);
			makeRect(4,8,66,56);
			makeRect(6,3,70,56);
			makeRect(3,5,76,56);
			makeRect(5,1,73,61);
			makeRect(2,1,70,63);
			makeRect(2,1,73,64);
			makeRect(2,1,76,65);
			makeRect(24,7,78,61);
			makeRect(24,15,101,66);
			makeRect(1,5,107,61);
			makeRect(1,6,110,60);
			makeRect(1,7,113,59);
			makeRect(14,16,118,57);
			makeRect(13,21,135,52);
			makeRect(23,1,125,80);
			makeRect(1,7,147,73);
			makeRect(3,1,125,78);
			makeRect(3,1,137,78);
			makeRect(3,1,143,78);
			makeRect(31,28,130,24);
			makeRect(14,8,78,44);
			makeRect(11,6,92,44);
			makeRect(7,18,102,33);
			makeRect(13,8,109,42);
			makeRect(4,8,112,32);
			makeRect(3,1,79,35);
			makeRect(1,1,85,36);
			makeRect(1,1,88,35);
			makeRect(1,1,92,34);
			makeRect(1,1,94,35);
			makeRect(3,1,97,36);
			makeRect(3,1,119,31);
			makeRect(3,1,127,50);
			makeRect(3,1,122,45);
			makeRect(3,1,127,40);
			makeRect(4,1,126,31);
			makeRect(3,1,125,28);
			makeRect(3,1,127,25);
			makeRect(3,1,123,23);
			makeRect(7,1,144,19);
			makeRect(1,5,147,14);
			makeRect(4,1,156,21);
			makeRect(6,6,160,18);
			makeRect(20,16,166,9);
			makeRect(60,10,150,0);
			makeRect(3,1,144,1);
			makeRect(3,1,147,9);
			makeRect(4,1,146,4);
			//makeRect(3, 1, 142, 8);//
			makeRect(20, 1, 141, 13);
			
			/*e1 = new Enemy(_cameraDynamicLayer, new Point(200, -20), new Point( -50, 0), 0, new Point(280, -20));
			_allActors.push(e1);
			e2 = new Enemy(_cameraDynamicLayer, new Point(300, -20), new Point( -50, 0), 0, new Point(300, -80));
			_allActors.push(e2);
			e3 = new Enemy(_cameraDynamicLayer, new Point(400, -20), new Point( -50, 0), 0, new Point(480, -200));
			_allActors.push(e3);*/
			
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(660, -20), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(860, -20), new Point( -50, 0), Enemy.GHOST));
			//Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(1000, -20), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(1790, -210), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(1460, -300), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(1240, -320), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(1290, -420), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(1660, -440), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2000, -520), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2220, -480), new Point( -50, 0), Enemy.GHOST));
			//Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(1040, -240), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(1820, -320), new Point( -50, 0), Enemy.GHOST));
			//Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(1050, -340), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2330, -630), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2230, -680), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2260, -750), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2520, -1050), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2780, -960), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2860, -680), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2640, -720), new Point( -50, 0), Enemy.GHOST));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2440, -500), new Point( -50, 0), Enemy.GHOST));
			
			
			makeRect(1, 1, 20, -1, ArbiStaticActor.ENEMY);
			
			//safeRemoveActor(Platformer.e3);
			Platformer.e3 = new Enemy(Platformer._camera, new Point(400, -20), new Point( -50, 0));
			Platformer._allActors.push(Platformer.e3);
			trace(Platformer.e3.enemyNumber+" "+Enemy._enemiesCount);
			
			
			makeRect(39, 6, 13 * 5 + 4, 20, ArbiStaticActor.WATER);
			
			Platformer.c1 = new Cloud(3.75, 1, 30, -3);
			Platformer.c2 = new Cloud(3.75, 1, 27 * 5 + 2, -45);
			Platformer.c3 = new Cloud(3.75, 1, 26 * 5, -33);
			
			Platformer.w1 = new Cloud(4, 1, 20-1, -5, true);
			Platformer.w2 = new Cloud(4, 1, 15-1, -6, true, 50);
			Platformer.w3 = new Cloud(4, 1, 12 - 1, -8, true);
			
			//trace(c1.cloudNumber + "" +c2.cloudNumber + "" +c3.cloudNumber);
			
			makeRect(3, 3, 46, -3);
			makeElevator(5, 1, 50, -2, 50, -10);
			makeElevator(3, 1, 84, -11, 84, -15);
			makeRect(3, 1, 51, -16);
			makeElevator(3, 1, 55, -17, 55, -21);
			makeRect(3, 2, 98, -25);
			makeElevator(3, 1, 102, -25, 102, -29);
			makeRect(3, 1, 110, -31);
			makeElevator(5, 1, 90, -32, 90, -40);
			makeElevator(3, 1, 142, 11, 142, 3);
			makeElevator(3, 1, 125, -40, 125, -50);
			
			/*
			makeElevator(3, 1, 5, -15, 15, -15);
			
			var shape321:Array = [[new Point(0, 0), new Point(3 * 20, 0), new Point(3 * 20, 1 * 20), new Point(0, 1 * 20)]];
			var rect300:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(5 * 20, -15 * 20), shape321, 3);
			var rect200:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(15 * 20, -15 * 20), shape321, 3);
			*/
			
			addBackground();
			addHighTree(7, 0);
			/*rasterize(_camera2);
			rasterize(_camera3);
			rasterize(_camera4);
			rasterize(_camera5);
			rasterize(_camera6);
			rasterize(_camera7);
			rasterize(_camera8);*/
			
			/*for (var k:int = 0; k < 50; k++) {
				for (var l:int = 0; l < 50; l++) {
					var underground:MovieClip = new ug();
					underground.x = underground.width * k * 0.80;
					underground.y = underground.height * l * 0.50;
					//underground.cacheAsBitmap = true;
					Platformer._cameraStaticLayer.addChildAt(underground, 0);
				}
			}*/
			/*childCounter = 0;
			countChildren(this);
			trace("childCounter="+childCounter);*/
			rasterizeAll();
			//_cameraStaticLayer.visible = false;
			//_cannon = new Cannon(new Point(500, -300));
			Platformer._camera.ZOOM_IN_AMT = 10;
		}
		
		private static function createLevel4():void 
		{
			_rm = new RandomMap();
		}
		private static function createLevel5():void 
		{
			makeRect(1, 50, 0, -50);
			makeRect(33, 20, 0, 0);
			makeRect(3, 3, 33, 3);
			makeRect(50, 6, 36, 0);
			makeRect(15, 3, 86, 3);
			makeRect(50, 6, 101, 0);
			makeRect(3, 3, 103, -3);
			makeRect(6, 6, 151, 3);
			makeRect(6, 12, 157, -3);
			/*_allActors.push(new Enemy(_cameraDynamicLayer, new Point(200, -20), new Point( -50, 0)));
			_allActors.push(new Enemy(_cameraDynamicLayer, new Point(300, -20), new Point( -50, 0)));
			_allActors.push(new Enemy(_cameraDynamicLayer, new Point(400, -20), new Point( -50, 0)));
			_allActors.push(new Enemy(_cameraDynamicLayer, new Point(680, -20), new Point( -50, 0), Enemy.JUMPING));
			_allActors.push(new Enemy(_cameraDynamicLayer, new Point(800, -20), new Point( -50, 0), Enemy.JUMPING));
			_allActors.push(new Enemy(_cameraDynamicLayer, new Point(900, -20), new Point( -50, 0), Enemy.JUMPING));
			_allActors.push(new Enemy(_cameraDynamicLayer, new Point(1000, -20), new Point( -50, 0), Enemy.JUMPING));
			_allActors.push(new Enemy(_cameraDynamicLayer, new Point(87*20, 40), new Point(0, 0), Enemy.WALKING, new Point(100*20, 40)));
			_allActors.push(new Enemy(_cameraDynamicLayer, new Point(102*20, -80), new Point(0, 0), Enemy.FLYING, new Point(107*20, -80)));
			_allActors.push(new Enemy(_cameraDynamicLayer, new Point(151*20, -20), new Point(0, 0), Enemy.FLYING, new Point(157*20, -80)));*/
			addBackground();
			rasterizeAll();
			Platformer._camera.ZOOM_IN_AMT = 10;
		}
		
		
		private static function createLevel6():void 
		{
			makeRect(31, 2, -9, 1);
			makeRect(3, 6, -12, -3);
			makeRect(3, 2, -15, 1);
			makeRect(2, 16, -17, -12);
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(160, 0), new Point( -50, 0)));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point( -280, 0), new Point( -50, 0), Enemy.JUMPING));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point( -180, -40), new Point( -50, 0), Enemy.FLYING, new Point( -9, -8)));
			makeRect(2, 3, 22, 0);
			makeRect(4, 3, 26, -2);
			makeRect(11, 2, 22, 3);
			makeRect(3, 5, 33, 0);
			makeRect(11, 4, 36, 1);
			makeRect(6, 2, 47, 3);
			makeRect(3, 11, 53, -6);
			makeRect(2, 9, 46, -10);
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(480, 40), new Point( -50, 0), Enemy.WALKING, new Point(31, 2)));
			makeRect(5, 9, 56, -4);
			makeRect(4, 7, 61, -2);
			makeRect(14, 2, 65, 3);
			makeRect(5, 3, 79, 1);
			makeRect(3, 5, 84, -2);
			makeRect(4, 10, 87, -7);
			new Cloud(3.75, 1, 68, -3);
			new Cloud(3.75, 1, 74, -5);
			new Cloud(3.75, 1, 80, -6);
			new Cloud(3.75, 1, 74, -1);
			makeRect(25, 2, 91, 3);
			makeRect(25, 5, 91, -2, ArbiStaticActor.WATER);
			makeRect(6, 13, 100, -15);
			makeRect(6, 1, 106, -3);
			makeRect(8, 12, 116, -7);
			new Cloud(3.75, 1, 109, -6, true);
			new Cloud(3.75, 1, 127, -8, true);
			new Cloud(3.75, 1, 134, -9, true);
			new Cloud(3.75, 1, 141, -10, true);
			new Cloud(3.75, 1, 148, -12, true);
			makeRect(9, 16, 156, -12);
			makeRect(32, 1, 124, 3);
			makeRect(4, 6, 124, -3);
			makeRect(3, 4, 128, -1);
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2720, 20), new Point( -50, 0), Enemy.JUMPING));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2840, 20), new Point( -50, 0), Enemy.JUMPING));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(2960, 20), new Point( -50, 0), Enemy.JUMPING));
			Platformer._allActors.push(new Enemy(Platformer._cameraDynamicLayer, new Point(3060, 20), new Point( -50, 0), Enemy.JUMPING));
			makeRect(3, 21, 165, -31);
		}
		private static function createLevel7():void 
		{
			makeRect(1, 10 * 5, 0, -10 * 5);
			makeRect(6 * 5 + 3, 6 * 5, 0, 0);
			makeRect(3, 3, 4 * 5 + 4, -3);
			addHighTree(7, 0);
			addHighTree(12, 0);
			addHighTree(18, 0);
			addHighTree(26, 0);
			rasterizeAll();
			Platformer._camera.ZOOM_IN_AMT = 10;
		}
		private static function createLevel8():void 
		{
			//makeRect(60, 1, 0, 0);
			//makeRect(3, 3, 34, -3);
			//makeRect(41, 10, 58, -9);
			//
			//makeRect(0.5, 3.4, 3, -3.4, ArbiStaticActor.HAT);
			//makeRect(0.7, 3.4, 6.3, -3.4, ArbiStaticActor.HAT);
			//
			
			/*makeRect(1,60,0,-60);
			makeRect(60,30,0,0);
			makeRect(3,3,34,-3);
			makeRect(41,10,59,-9);
			makeRect(9,1,33,-20);
			makeRect(2,5,50,-19);
			makeRect(7,1,48,-20);
			makeRect(17,1,50,-15);
			makeRect(9,1,33,-20);
			makeRect(6,1,50,-30);
			makeRect(9,1,60,-20);
			makeRect(16,1,70,-14);
			makeRect(18,1,79,-21);
			makeRect(38,14,100,-23);*/
			
			//
			/*makeRect(1, 20, 0, 0);
			makeRect(20, 1, 0, 0);
			makeRect(20, 1, 0, 20);
			makeRect(10, 2, 20, 19);
			makeRect(10, 1, 29, 21);
			makeRect(1, 20, 39, -3);
			makeRect(5, 2, 39, 20);*/
			//
			/*Platformer.addKey(0, 0);
			Platformer.addKey(100, 0);
			Platformer.addKey(100, 100);*/
		}
		private static function createLevel9():void 
		{
			
		}
		//
		
		/*
		private function createLevel1():void 
		{
			_cannon = new Cannon(LAUNCH_POINT);
			_cannon2 = new Cannon(LAUNCH_POINT2);
			
			var leftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 0), setupClass.wallShapes);
			_allActors.push(leftWall);
			var rightWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3, 0), setupClass.wallShapes);
			_allActors.push(rightWall);
			var rightLeftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12, -7*12), setupClass.wallShapes);
			_allActors.push(rightLeftWall);		
			var rightRightWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(100 * PhysiVals.RATIO, 10 * PhysiVals.RATIO), setupClass.wallShapes);
			_allActors.push(rightRightWall);
			var rightRightWall2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(97 * PhysiVals.RATIO, 5 * PhysiVals.RATIO), setupClass.wallShapes);
			_allActors.push(rightRightWall2);
			
			
			var topFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 0), setupClass.floorShapes);
			_allActors.push(topFloor);
			var downFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 41 * 12), setupClass.floorShapes);
			_allActors.push(downFloor);
			var rightFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*2, 41 * 12), setupClass.floorShapes);
			_allActors.push(rightFloor);
			var rightRightFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3, 41 * 12), setupClass.floorShapes);
			_allActors.push(rightRightFloor);
			
			
			var holm:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58 * 12, 41 * 12), setupClass.holmShapes);
			_allActors.push(holm);
			var leftHolm:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58 , 41 * 10), setupClass.holmShapes);
			_allActors.push(leftHolm);
			
			
			var pryamougolnik1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*3, -7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik1);
			var pryamougolnik2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*4, 0), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik2);
			var pryamougolnik3:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*7, -7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik3);
			var pryamougolnik4:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*11, 7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik4);
			var pryamougolnik5:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*16, 2*7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik5);
			var pryamougolnik6:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*7, 5*7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik6);
			var pryamougolnik7:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*3, 4*7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik7);
			var pryamougolnik8:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*20, 5*8*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik8);
			var pryamougolnik9:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*19, 4*8*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik9);
			var pryamougolnik11:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3+7*12*2, 6*7*7), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik11);
			var pryamougolnik12:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3+7*12*4, 6*7*4), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik12);
			var pryamougolnik13:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3+7*12*7, 6*7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik13);
			var pryamougolnik14:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3+7*12*11, 3*7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik14);
			var pryamougolnik15:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3+7*12*16, 3*7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik15);
			var pryamougolnik16:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3+7*12*7, 5*7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik16);
			var pryamougolnik17:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3+7*12*3, 8*7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik17);
			var pryamougolnik18:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3+7*12*20, 5*8*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik18);
			var pryamougolnik19:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3+7*12*19, 4*8*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik19);
			var pryamougolnik20:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(95 * PhysiVals.RATIO, 25 * PhysiVals.RATIO), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik20);
			
			var circle1:CircleStaticActor = new CircleStaticActor(_camera, new Point(36, 10), 10);
			_allActors.push(circle1);
			var circle2:CircleStaticActor = new CircleStaticActor(_camera, new Point(10, 5), 20);
			_allActors.push(circle2);
			var circle3:CircleStaticActor = new CircleStaticActor(_camera, new Point(50, 15), 30);
			_allActors.push(circle3);
			
			
			//var enemyWall1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(2000, 0), setupClass.rectangle1, ArbiStaticActor.ENEMY);
			//var water1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(1000, 0), setupClass.rectangle1, ArbiStaticActor.WATER);
			//var magnet1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(3000, 0), setupClass.rectangle1, ArbiStaticActor.MAGNET);
			
			//addWaves();
			key1 = new CircleStaticActor(_camera, new Point(10, 10), 12, CircleStaticActor.KEY);
			_allActors.push(key1);
			key2 = new CircleStaticActor(_camera, new Point(62, 4), 12, CircleStaticActor.KEY);
			_allActors.push(key2);
		}
		
		private function createLevel2():void 
		{
			var leftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 0), setupClass.wallShapes);
			_allActors.push(leftWall);
			var rightWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3, 0), setupClass.wallShapes);
			_allActors.push(rightWall);
			var rightLeftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12, -7*12), setupClass.wallShapes);
			_allActors.push(rightLeftWall);
			
			var downFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 41 * 12), setupClass.floorShapes);
			_allActors.push(downFloor);
			var rightFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*2, 41 * 12), setupClass.floorShapes);
			_allActors.push(rightFloor);
			var rightRightFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3, 41 * 12), setupClass.floorShapes);
			_allActors.push(rightRightFloor);
			
			var rrrRec:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12+42, 41 * 12), setupClass.pryamougolnikShapes);
			_allActors.push(rightRightFloor);
			//var pryamougolnik1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58, -7*6), setupClass.pryamougolnikShapes, 0, new Point(58 + 100, -7*6-40));
			//_allActors.push(pryamougolnik1);
			//var pryamougolnik2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*4, 0), setupClass.pryamougolnikShapes);
			//_allActors.push(pryamougolnik2);
			
			var sqar1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58 * 12, 38.5 * 12), setupClass.squareSmall);
			_allActors.push(sqar1);
			var lilHolm1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(65 * 12 + 42, 41 * 12), setupClass.holmSmall);
			_allActors.push(lilHolm1);
			var rec1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(94 * 12 + 42, 37 * 12), setupClass.pryamougolnikShapes)
			_allActors.push(rec1);
			var recEn1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(94 * 12 + 42, 41 * 12), setupClass.longRecShapes, ArbiStaticActor.ENEMY);
			_allActors.push(recEn1);
			var recVert1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(73 * 30, 0), setupClass.recVert);
			_allActors.push(recVert1);
			var rec2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(73 * 30, 7 * 12), setupClass.longRecShapes);
			_allActors.push(rec2);
			//
			var circle1:CircleStaticActor = new CircleStaticActor(_camera, new Point(36, 10), 10);
			_allActors.push(circle1);
			var circle2:CircleStaticActor = new CircleStaticActor(_camera, new Point(10, 5), 20);
			_allActors.push(circle2);
			var circle3:CircleStaticActor = new CircleStaticActor(_camera, new Point(50, 15), 30);
			_allActors.push(circle3);
			
			var circle4:CircleStaticActor = new CircleStaticActor(_camera, new Point(36+50, 10), 10, CircleStaticActor.ENEMY);
			_allActors.push(circle4);
			var circle5:CircleStaticActor = new CircleStaticActor(_camera, new Point(10+30, 5), 20, CircleStaticActor.WATER, new Point(40+80, 5));
			_allActors.push(circle5);
			var circle6:CircleStaticActor = new CircleStaticActor(_camera, new Point(50+30, 15), 30, CircleStaticActor.MAGNET);
			_allActors.push(circle6);
			//
			//_cannonShotgun = new Cannon(new Point(500, 150), Cannon.STICKY);
			
		}
		
		
		private function createLevel3():void 
		{
			var circle1:CircleStaticActor = new CircleStaticActor(_camera, new Point(50, 15), 30);
			_allActors.push(circle1);
			var circle2:CircleStaticActor = new CircleStaticActor(_camera, new Point(50, 15), 30);
			_allActors.push(circle2);
			
			_cannon2 = new Cannon(LAUNCH_POINT2);
		}
		
		private function createLevel4():void 
		{
			var leftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 0), setupClass.wallShapes);
			_allActors.push(leftWall);
			var rightWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3, 0), setupClass.wallShapes);
			_allActors.push(rightWall);
			var rightLeftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12, -7*12), setupClass.wallShapes);
			_allActors.push(rightLeftWall);		
			var topFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 0), setupClass.floorShapes);
			_allActors.push(topFloor);
			var downFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 41 * 12), setupClass.floorShapes);
			_allActors.push(downFloor);
			var rightFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*2, 41 * 12), setupClass.floorShapes);
			_allActors.push(rightFloor);
			var rightRightFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3, 41 * 12), setupClass.floorShapes);
			_allActors.push(rightRightFloor);
			var rrFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58 * 12, 41 * 12), setupClass.floorShapes);
			_allActors.push(rrFloor);
			var firstSquare:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(20*30, 13.5*30), setupClass.squareSmall);
			_allActors.push(firstSquare);
			
			//30 13.5*30
		}
		
		private function createLevel5():void
		{
			var leftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 0), setupClass.wallShapes);
			_allActors.push(leftWall);
			var downFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 41 * 12), setupClass.floorShapes);
			_allActors.push(downFloor);
			var rec1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(70 * 12, 41 * 12), setupClass.pryamougolnikShapes);
			_allActors.push(rec1);
			var rec2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(80 * 12, 39 * 12), setupClass.pryamougolnikShapes);
			_allActors.push(rec2);
			var rec3:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(100 * 12, 44 * 12), setupClass.pryamougolnikShapes);
			_allActors.push(rec3);
			var rec4:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(110 * 12, 35 * 12), setupClass.pryamougolnikShapes);
			_allActors.push(rec4);
			var rec5:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(110 * 12, 36 * 12), setupClass.recVert);
			_allActors.push(rec5);
			var rec6:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(110 * 12, 43 * 12), setupClass.pryamougolnikShapes);
			_allActors.push(rec6);
			var rec7:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(120 * 12, 41 * 12), setupClass.pryamougolnikShapes);
			_allActors.push(rec7);
			var rec8:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(105 * 12, 34 * 12), setupClass.recVert);
			_allActors.push(rec8);
		}
		
		private function createLevel6():void
		{
			var leftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 0), setupClass.wallShapes);
			_allActors.push(leftWall);
			var downFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 41 * 12), setupClass.floorShapes);
			_allActors.push(downFloor);
			var downFloor2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(41*12, 41 * 12), setupClass.floorShapes);
			_allActors.push(downFloor2);
			var downFloor3:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(41*24, 41 * 12), setupClass.floorShapes);
			_allActors.push(downFloor3);
			var vertRec1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(41 * 12, 34 * 12), setupClass.recVert);
			_allActors.push(vertRec1);
			var vertRec2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(34 * 12, 30 * 12), setupClass.recVert);
			_allActors.push(vertRec2);
			var vertRec3:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(70 * 12, 34 * 12), setupClass.recVert);
			_allActors.push(vertRec3);
			var vertRec4:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(63 * 12, 30 * 12), setupClass.recVert);
			_allActors.push(vertRec4);
			var vertRec5:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(70 * 12, 27 * 12), setupClass.recVert);
			_allActors.push(vertRec5);
			var vertRec6:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(63 * 12, 23 * 12), setupClass.recVert);
			_allActors.push(vertRec6);
			var vertRecBig1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(90 * 12, -1 * 12), setupClass.wallShapes);
			_allActors.push(vertRecBig1);
			var vertRecBig2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(83 * 12, -8 * 12), setupClass.wallShapes);
			_allActors.push(vertRecBig2);
			var vertRecBig3:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(120 * 12, -8 * 12), setupClass.wallShapes);
			_allActors.push(vertRecBig3);
			_cannon = new Cannon(new Point(135 * 12, 60));
			var vertRecBig4:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(150 * 12, -1 * 12), setupClass.wallShapes);
			_allActors.push(vertRecBig4);
		}
		
		private function createLevel7():void
		{
			_cannon = new Cannon(new Point(135 * 12, 60));
			
			//
			
			var leftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 0), setupClass.wallShapes);
			_allActors.push(leftWall);
			var rightWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3, 0), setupClass.wallShapes);
			_allActors.push(rightWall);
			var rightLeftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12, 0), setupClass.wallShapes);
			_allActors.push(rightLeftWall);
			var rightRightWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*2, 0), setupClass.wallShapes);
			_allActors.push(rightRightWall);
			var leftWall2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, -41*12), setupClass.wallShapes);
			_allActors.push(leftWall2);
			var rightWall2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3, -41*12), setupClass.wallShapes);
			_allActors.push(rightWall2);
			var rightLeftWall2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12, -58*12), setupClass.wallShapes);
			_allActors.push(rightLeftWall2);
			var rightRightWall2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*2, -58*12), setupClass.wallShapes);
			_allActors.push(rightRightWall2);
			
			var rightFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58 * 12, 41 * 12), setupClass.floorShapes);
			_allActors.push(rightFloor);
			var downFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 41 * 12), setupClass.floorShapes);
			_allActors.push(downFloor);
			var downMiddleFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58 * 12*2, 41 * 12), setupClass.floorShapes);
			_allActors.push(downMiddleFloor);
			//var downRightFloor:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(41 * 12*3, 41 * 12), setupClass.floorShapes);
			//_allActors.push(downRightFloor);
			
			
			var pryamougolnik1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*3, -7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik1);
			var pryamougolnik2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*4, 0), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik2);
			var pryamougolnik3:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*7, -7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik3);
			var pryamougolnik4:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(58*12*3-7*12*11, 7*6), setupClass.pryamougolnikShapes);
			_allActors.push(pryamougolnik4);
			
			//
		}
		
		private function createLevel8():void
		{
			_cannon = new Cannon(new Point(135 * 12, 60));
			
			//
			
			var leftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 0), setupClass.wallShapes);
			_allActors.push(leftWall);
			var big01:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 42*12), setupClass.bigg);
			_allActors.push(big01);
			var long01:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(1.5 * 42 * 12, 42 * 12), setupClass.long);
			_allActors.push(long01);
			var fat01:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(2.3 * 42 * 12, 42 * 12), setupClass.fatt);
			_allActors.push(fat01);
			//
		}
		
		private function createLevel9():void
		{
			makeRect(1,60,0,-60);
			makeRect(60,30,0,0);
			makeRect(3,3,34,-3);
			makeRect(41,10,59,-9);
			makeRect(9,1,33,-20);
			makeRect(2,5,50,-19);
			makeRect(7,1,48,-20);
			makeRect(17,1,50,-15);
			makeRect(9,1,33,-20);
			makeRect(6,1,50,-30);
			makeRect(9,1,60,-20);
			makeRect(16,1,70,-14);
			makeRect(18,1,79,-21);
			makeRect(38, 14, 100, -23);
			//
			var leftWall:ArbiStaticActor = new ArbiStaticActor(_camera, new Point( -42 * 12, 0), setupClass.wallShapes);
			_allActors.push(leftWall);
			var downFloor1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point( -42 * 12, 41 * 12), setupClass.floorShapes);
			_allActors.push(downFloor1);
			var downFloor2:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(0, 41 * 12), setupClass.floorShapes);
			_allActors.push(downFloor2);
			var vertSmall1:ArbiStaticActor = new ArbiStaticActor(_camera, new Point(42 * 12, 41 * 12 - 7*12), setupClass.recVert);
			_allActors.push(vertSmall1);//
		}
		*/
	}

}
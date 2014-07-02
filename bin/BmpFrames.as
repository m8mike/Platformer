package  
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BmpFrames {
		public var frames : Array;
		public var frameXs : Array;
		public var frameYs : Array;
		public var totalFrames : int;
		
		protected static const INDENT_FOR_FILTER : int = 64;
		protected static const INDENT_FOR_FILTER_DOUBLED : int = INDENT_FOR_FILTER * 2;
		protected static const DEST_POINT : Point = new Point(0, 0);
		
		public function BmpFrames() {
			frames = new Array();
			frameXs = new Array();
			frameYs = new Array();
			totalFrames = 0;
		}
		
		public static function createBmpFramesFromMC(clipClass : MovieClip) : BmpFrames {
			//var clip : MovieClip = MovieClip( new clipClass() );
			var clip : MovieClip = clipClass;
			var res : BmpFrames = new BmpFrames();
			
			var totalFrames : int = clip.totalFrames;

			var frames : Array = res.frames;
			var frameXs : Array = res.frameXs;
			var frameYs : Array = res.frameYs;
			
			var rect : Rectangle;
			var flooredX : int;
			var flooredY : int;
			var mtx : Matrix = new Matrix();
			var scratchBitmapData : BitmapData = null;

			for (var i : int = 1; i <= totalFrames; i++) {
				clip.gotoAndStop(i);
				rect = clip.getBounds(clip);
				rect.width = Math.ceil(rect.width) + INDENT_FOR_FILTER_DOUBLED;
				rect.height = Math.ceil(rect.height) + INDENT_FOR_FILTER_DOUBLED;
				rect.width *= 2;
				rect.height *= 2;
				
				flooredX = Math.floor(rect.x) - INDENT_FOR_FILTER;
				flooredY = Math.floor(rect.y) - INDENT_FOR_FILTER;
				mtx.tx = -flooredX*2;
				mtx.ty = -flooredY*2;
				
				scratchBitmapData = new BitmapData(rect.width*2, rect.height*2, true, 0);
				scratchBitmapData.draw(clip, mtx);
				
				var trimBounds : Rectangle = scratchBitmapData.getColorBoundsRect(0xFF000000, 0x00000000, false);
				trimBounds.x -= 1;
				trimBounds.y -= 1;
				trimBounds.width += 2;
				trimBounds.height += 2;
				
				var bmpData : BitmapData = new BitmapData(trimBounds.width, trimBounds.height, true, 0);
				bmpData.copyPixels(scratchBitmapData, trimBounds, DEST_POINT);
				
				flooredX += trimBounds.x;
				flooredY += trimBounds.y;
				
				var matrix:Matrix = new Matrix();
				matrix.scale(.5, .5);
				var bmpData2:BitmapData = new BitmapData(trimBounds.width / 2, trimBounds.height / 2);
				bmpData2.draw(bmpData, matrix);
				
				frames.push(bmpData);
				frameXs.push(flooredX);
				frameYs.push(flooredY);
				
				scratchBitmapData.dispose();
			}
			res.totalFrames = res.frames.length;
			return res;
		}
	}
}
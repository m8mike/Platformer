package com.touchmypixel.peepee.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	public class TileCache 
	{
		public var tiles:Array = [];
		protected var writeScope:Sprite;
		protected var readScope:Sprite;
		public var tileWidth:Number = 256;
		public var tileHeight:Number = 256;
		public var offsetX:Number;
		public var offsetY:Number;
		public var gap:Number = 0;
		
		public function TileCache(_readScope:Sprite, _writeScope:Sprite) 
		{
			readScope = _readScope;
			writeScope = _writeScope;
			offsetX = readScope.getRect(readScope).x;
			offsetY = readScope.getRect(readScope).y;
			update();
		}
		
		private function createTiles()
		{
			var rect = readScope.getRect(readScope);
			var nw = Math.ceil(readScope.width / tileWidth);
			var nh = Math.ceil(readScope.height / tileHeight);
			
			for (var i = 0; i < nh; i++)
			{
				var row:Array = [];
				for (var j = 0; j < nw; j++)
				{
					var tileData:BitmapData = new BitmapData(tileWidth, tileHeight, true, 0x00ffffff);
					var tile = new Bitmap(tileData);
					var matrix:Matrix = new Matrix();
					matrix.translate( -j * tileWidth - rect.x, -i * tileWidth-rect.y);
					tileData.draw(readScope, matrix);
					tile.x = j * tileWidth + j*gap;
					tile.y = i * tileHeight + i*gap;
					
					writeScope.addChild(tile);
					row.push(tile)
				}
				tiles.push(row);
			}
		}
		private function removeTiles()
		{
			for each(var tile:Bitmap in tiles)
			{
				writeScope.removeChild(tile);
			}
		}
		
		public function update()
		{
			removeTiles();
			createTiles();
		}
	}
}
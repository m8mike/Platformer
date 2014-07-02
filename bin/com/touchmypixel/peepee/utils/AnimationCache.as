package com.touchmypixel.peepee.utils
{
	import com.touchmypixel.events.ProcessEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	
	public class AnimationCache extends EventDispatcher
	{
		public var cacheQueue:Array = [];
		public var currentlyProcessingItem:uint = 0;
		public var replaceExisting:Boolean = false;
		
		private var animations:Object = {};
		
		private static var instance:AnimationCache;
		
		public function AnimationCache() {
			if(AnimationCache.instance) throw(new Error("AnimationCache is a Singleton. Don't Instantiate!"));
			instance = this;
		}	
		public static function getInstance():AnimationCache
		{
			return !instance ? new AnimationCache() : instance;
		}
		
		public function cacheAnimation(identifier:String, useSpriteSheet:Boolean=false):Animation
		{
			var animation:Animation
			if(!animations[identifier] || replaceExisting){
				animation = new Animation();
				animation.useSpriteSheet = useSpriteSheet;
				animation.buildCacheFromLibrary(identifier);
				animations[identifier] = animation;
			} else {
				animation = animations[identifier]
			}
			return animation;
		}
		
		public function getAnimation(id):Animation
		{
			if (!animations[id]) {
				trace("MISSING ANIMATION :"+ id);
				return null;
			}
			
			var animation:Animation = new Animation();
			animation.frames = animations[id].frames;
			animation.bigBitmap = animations[id].bigBitmap;
			animation.bitmap.x = animations[id].bitmap.x
			animation.bitmap.y = animations[id].bitmap.y
			animation.cols = animations[id].cols;
			animation.rows = animations[id].rows;
			animation.r = animations[id].r;
			animation.clip = animations[id].clip;
			animation.useSpriteSheet = animations[id].useSpriteSheet;
			animation.gotoAndStop(1);	
			return animation;
		}
		
		public function addToBulkCache(items:Array)
		{
			for each( var item in items)
				cacheQueue.push(item);
		}
		
		public function processQueue()
		{
			currentlyProcessingItem = 0;
			dispatchEvent(new ProcessEvent(ProcessEvent.START));
			process();
		}
		
		private function process():void
		{
			var id = cacheQueue[currentlyProcessingItem++];
			if (id != null)
			{
				cacheAnimation(id);
				dispatchEvent(new ProcessEvent(ProcessEvent.PROGRESS,currentlyProcessingItem/cacheQueue.length));
				setTimeout(process, 1);
			} else {
				dispatchEvent(new ProcessEvent(ProcessEvent.COMPLETE));
				cacheQueue = [];
			}
		}
	}
}


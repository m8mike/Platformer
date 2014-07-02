package  
{
	import adobe.utils.CustomActions;
	/**
	 * ...
	 * @author 
	 */
	public class Cloud 
	{
		public static var _cloudsNumber:int = 0;		//кол-во
		public var cloudNumber:int = 0;					//индекс
		private var cloud:ArbiStaticActor;
		private var index:int = -1;
		private var w:Number;
		private var h:Number;
		private var x:Number;
		private var y:Number;
		public var wink:Boolean = false;
		
		public function Cloud(w:Number, h:Number, x:Number, y:Number, winked:Boolean = false, offset:int = 1) 
		{
			wink = winked;
			this.y = y;
			this.x = x;
			this.h = h;
			this.w = w;
			cloudNumber = _cloudsNumber++;
			if (wink) {
				index += offset;
			}
			if (wink == true) {
				cloud = LevelDirector.makeRect(w, h, x, y, ArbiStaticActor.WINK, this);
			} else cloud = LevelDirector.makeRect(w, h, x, y, ArbiStaticActor.CLOUD, this);
			Platformer._clouds.push(this);
		}
		
		public function update():void 
		{
			if (index >= 0 && index < 50) {
				index++;
				cloud.decAlpha();
			} else
			if (index == 50) {
				Platformer.safeRemoveActor(cloud);
				index++;
			} else
			if ((index > 50 && index < 150) || (index>150 && index<200)) {
				index++;
			} else 
			if (index == 150) {
				//create again
				if (wink == false) {
					cloud = LevelDirector.makeRect(w, h, x, y, ArbiStaticActor.CLOUD, this);
					index = -1;
				} else 
				if (wink) {
					cloud = LevelDirector.makeRect(w, h, x, y, ArbiStaticActor.WINK, this);
					index++;
				}
			} else
			if (index == 200) {
				index = 0;
			}
		}
		
		public function cloudHide():void
		{
			if (index < 0) {
				index = 0;
			}
		}
	}
}
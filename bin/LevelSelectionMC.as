package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class LevelSelectionMC extends MovieClip
	{
		private static var instance:LevelSelectionMC;
		public static var _levSelMCs:Array = [];
		public function LevelSelectionMC() {
			/*if  (LevelSelectionMC.instance) throw(new Error("LevelSelectionMC is a Singleton. Don't Instantiate!"));
			instance = this;*/
		}	
		public static function getInstance(beaten:int):LevelSelectionMC
		{
			/*if (instance) {
				instance.init(beaten);
				return instance;
			} else {*/
				var lsmc:LevelSelectionMC = new LevelSelectionMC();
				lsmc.init(beaten);
				instance = lsmc;
				Platformer.thisIs.addChild(instance);
				return lsmc;
			//}
			//return !instance ? new LevelSelectionMC() : instance;
		}
		
		public function init(beaten:int):void 
		{
			//var setup:setupClass = new setupClass();
			for (var x:int = 0; x < setupClass.totalLevels; x++) {
			//if (levelSelectMc.nums < 81) {
				var levelSelect:levelSelectMc = new levelSelectMc(x, (x <= beaten));
				addChild(levelSelect);
				_levSelMCs.push(levelSelect);
			
			}
		}
		/*public function reinit(beaten:int):void
		{
			for each(var lev:levelSelectMc in _levSelMCs) {
				lev.remEvLis();
			}
			_levSelMCs = [];
			for (var x:int = 0; x < setupClass.totalLevels; x++) {
				var levelSelect:levelSelectMc = new levelSelectMc(x, (x <= beaten));
				addChild(levelSelect);
				_levSelMCs.push(levelSelect);
			}
		}*/
		/*public function setup(beaten:int):void
		{
			for (var x:int = 0; x < setupClass.totalLevels; x++) {
				if (levelSelectMc.nums < 81) {
					var levelSelect:levelSelectMc = new levelSelectMc(x, (x <= beaten));
					addChild(levelSelect);
					_levSelMCs.push(levelSelect);
				}
			}*/
			
			/*for (var x:int = 0; x < setupClass.totalLevels; x++) {
				_levSelMCs[x].visible = true;
				if (x <= beaten){
					_levSelMCs[x].setType(levelSelectMc.UNLOCKED);
				} else {
					_levSelMCs[x].setType(levelSelectMc.LOCKED);
				}
			}*/
		//}
		
		public static function hide():void
		{
			for each (var level:levelSelectMc in _levSelMCs) {
				level.remEvLis();
				//level.visible = false;
			}
		}
	}
}
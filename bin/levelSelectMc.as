package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class levelSelectMc extends Sprite {
		public static const LOCKED = 0;
		public static const UNLOCKED = 1;
		private var num:int;
		public static var nums:int = 0;
		private var level:Number;
		public static var needToStartLevel:Number;
		public var icon:Sprite;
		public function levelSelectMc(n:Number, solved:Boolean):void {
			level = n;
			if (!solved) {
				icon = new lockedMc();
			} else {
				icon = new homeButtonMc();
				addEventListener(MouseEvent.CLICK, clicked);
				buttonMode=true;
			}
			this.addChild(icon);
			num =++nums;
			//Platformer.thisIs.addChild(icon);
			var levelWidth:Number = setupClass.levelsPerRow * width + (setupClass.levelsPerRow - 1) * setupClass.levelsHorizontalSpacing;
			var numberOfRows:Number = Math.floor(setupClass.totalLevels / setupClass.levelsPerRow);
			var levelHeight:Number = numberOfRows * height + (numberOfRows - 1) * setupClass.levelsVerticalSpacing;
			var xOffset:Number = (setupClass.gameWidth - levelWidth) / 2 + setupClass.levelsOffsetX;
			var yOffset:Number = (setupClass.gameHeight - levelHeight) / 2 + setupClass.levelsOffsetY;
			x = n % setupClass.levelsPerRow * (width + setupClass.levelsHorizontalSpacing) + xOffset;
			y = Math.floor(n / setupClass.levelsPerRow) * (height + setupClass.levelsVerticalSpacing) + yOffset;
			//leveltext.text=(n+1).toString();
			mouseChildren=false;
		}
		
		/*public function setType(type:int):void
		{
			if (type == UNLOCKED) {
				icon = new homeButtonMc();
				this.addChild(icon);
					if (icon is lockedMc) {
						this.removeChild(icon);
						icon = null;
					}
				addEventListener(MouseEvent.CLICK, clicked);
			} else if (type == LOCKED) {
				icon = new lockedMc();
				this.addChild(icon);
					if (icon is homeButtonMc) {
						this.removeChild(icon);
						icon = new lockedMc();
						this.addChild(icon);
					}
			}
		}*/
		
		public function remEvLis():void
		{
			if (icon) {
				icon.x = -1000;
				if (icon.hasEventListener(MouseEvent.CLICK)) {
					removeEventListener(MouseEvent.CLICK, clicked);
				}
			}
			/*if (icon.parent) {
				icon.parent.removeChild(icon);
				icon = null;
			}*/
			if (this.parent) {
				//parent.x = -1000;
				this.parent.removeChild(this);
			}
		}
		// запускает экран загрузки
		public function clicked(e:MouseEvent):void {
			trace("num1 " + num);
			LevelDirector.removeScreen = false;
			LevelDirector.screen.gotoAndPlay(1);
			trace("num2 "+num);
			LevelDirector.screen.visible = true;
			trace("num3 "+num);
			needToStartLevel = level;
			trace("num4 " + num);
			Platformer._cameraLoading.addEventListener(Event.ENTER_FRAME, LevelDirector.setLoadingScreen);
			trace("num5 "+num);
		}
	}
}
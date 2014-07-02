package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Mad Mike
	 */
	public class setupClass 
	{
		// basic game info
		public static var gameWidth:Number=708;
		public static var gameHeight:Number=504;
		// levels
		public static var totalLevels:Number=40;
		public static var levelsPerRow:Number=8
		public static var levelsHorizontalSpacing:Number=5;
		public static var levelsVerticalSpacing:Number=5;
		public static var levelsOffsetX:Number=0;
		public static var levelsOffsetY:Number=30;
		// play game button
		public static var playGameButtonX:Number=320;
		public static var playGameButtonY:Number=230;
		// back to menu button
		public static var homeButtonX:Number=560;
		public static var homeButtonY:Number=0;
		// level completed
		public static var completedReplayButtonX:Number=320;
		public static var completedReplayButtonY:Number=200;
		public static var completedPlayNextButtonX:Number=320;
		public static var completedPlayNextButtonY:Number=240;
		public static var completedShowLevelsButtonX:Number=320;
		public static var completedShowLevelsButtonY:Number=280;
		// level failed
		public static var failedReplayButtonX:Number=320;
		public static var failedReplayButtonY:Number=320;
		public static var failedShowLevelsButtonX:Number=320;
		public static var failedShowLevelsButtonY:Number=360;
		//platforms
		public static var wallShapes:Array = [[new Point(0, 0), new Point(12, 0), new Point(12, 42*12), new Point(0, 42*12)]];
		public static var floorShapes:Array = [[new Point(0, 0), new Point(58 * 12, 0), new Point(58 * 12, 12), new Point(0, 12)]];
		public static var holmShapes:Array = [[new Point(0, 0), new Point(58 * 6, -12 * 12), new Point(58 * 12, 0), new Point(58 * 12, 12), new Point(0, 12)]];
		public static var holmSmall:Array = [[new Point(0, 0), new Point(58 * 3, -12 * 5), new Point(58 * 6, 0), new Point(58 * 6, 12), new Point(0, 12)]];
		public static var hillLeft:Array = [[new Point(0, 0), new Point(24, -12), new Point(24, 0)]];
		public static var hillRight:Array = [[new Point(0, 0), new Point(24, 12), new Point(0, 12)]];
		public static var pryamougolnikShapes:Array = [[new Point(0, 0), new Point(7 * 12, 0), new Point(7 * 12, 12), new Point(0, 12)]];
		public static var longRecShapes:Array = [[new Point(0, 0), new Point(58 * 12 * 2 - 94 * 12 + 42, 0), new Point(58 * 12 * 2 - 94 * 12 + 42, 12), new Point(0, 12)]];
		public static var rectangle1:Array = [[new Point(0, 0), new Point(58 * 6, 0), new Point(58 * 6, 58 * 6), new Point(0, 58 * 6)]];
		public static var recVert:Array = [[new Point(0, 0), new Point(20, 0), new Point(20, 7*12), new Point(0, 7*12)]];
		public static var sqrVert:Array = [[new Point(0, 0), new Point(40, 0), new Point(40, 7*12), new Point(0, 7*12)]];
		public static var squareSmall:Array = [[new Point(0, 0), new Point(6*7, 0), new Point(6*7, 6*7), new Point(0, 6*7)]];
		public static var bigg:Array = [[new Point(0, 0), new Point(1.5*42*12, 0), new Point(1.5*42*12, 42*12), new Point(0, 42*12)]];
		public static var long:Array = [[new Point(0, 0), new Point(1.5*42*12, 0), new Point(1.5*42*12, 12), new Point(0, 12)]];
		
		public function setupClass() 
		{
			
		}
		
	}

}
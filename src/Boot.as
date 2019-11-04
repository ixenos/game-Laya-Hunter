package {
	
	import PathFinding.core.Grid;
	import PathFinding.finders.AStarFinder;
	
	import laya.debug.tools.comps.Rect;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.filters.GlowFilter;
	import laya.map.TiledMap;
	import laya.maths.Rectangle;
	import laya.net.Loader;
	import laya.net.LoaderManager;
	import laya.particle.Particle2D;
	import laya.particle.ParticleSetting;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class Boot {
		private var _loadM:Loader;
		private var _lsSp:Sprite;
		private const MIN_W:int = 1120;
		private var screen_H:int;
		private var screen_W:int;
		
		public function Boot() {
			Laya.init(1400,640,WebGL);//优先使用WebGL渲染
			
			Laya.stage.scaleMode = "fixedauto";
			Laya.stage.screenMode = "horizontal";
			Laya.stage.frameRate = Stage.FRAME_FAST;
			Laya.stage.bgColor= "#ffffff";
			
			var matrix:Array = [
				[0,1,0,0,0],
				[0,1,0,1,0],
				[0,1,0,1,0],
				[0,1,0,1,0],
				[0,0,0,1,0]
			];
			
			var grid:Grid = new Grid(5,5,matrix);
			var opt:Object = {};
			opt.allowDiagonal = false;
			var finder:AStarFinder = new AStarFinder(opt);
			var path:Array = finder.findPath(0,0,4,4,grid);
			trace( path );
			
//			Grid.createGridFromAStarMap
//			var tiledMap:TiledMap = new TiledMap();
//			tiledMap.createMap("desert.json",new Rectangle(0, 0, Laya.stage.width, Laya.stage.height),null);
			
			
			Laya.loader.load("Lighthouse.jpg",Handler.create(this,function():void{
				var t:Texture = Laya.loader.getRes("Lighthouse.jpg");
				var ape:Sprite = new Sprite();
				ape.graphics.drawTexture(t,0,0);
				Laya.stage.addChild(ape);
				ape.pos(200, 200);
				ape.scale(0.5,0.5,true);
				
				var filter:GlowFilter = new GlowFilter(0x00FF00, 40, 20, 20);
				ape.filters = [filter];
			}),null,Loader.IMAGE);
			
		}
		

	}
}
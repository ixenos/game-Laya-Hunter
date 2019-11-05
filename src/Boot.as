package {
	
	import PathFinding.core.Grid;
	import PathFinding.finders.AStarFinder;
	
	import laya.debug.DebugPanel;
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
		private var tMap:TiledMap;
		
		public function Boot() {
			
			//初始化舞台
			Laya.init(Browser.width, Browser.height, WebGL);
			//创建TiledMap实例
			tMap = new TiledMap();
			//创建Rectangle实例，视口区域
			var viewRect:Rectangle = new Rectangle(0, 0, Browser.width, Browser.height);
			//创建TiledMap地图
			tMap.createMap("res/tiledMap/orthogonal-outside.json",viewRect);
			
//			DebugPanel.init(false);
			
			//寻路demo
//			var matrix:Array = [
//				[0,1,0,0,0],
//				[0,11,0,12,0],
//				[0,13,0,12,0],
//				[0,11,0,15,0],
//				[0,0,0,17,0]
//			];
//			var grid:Grid = new Grid(5,5,matrix);
//			var opt:Object = {};
//			opt.allowDiagonal = false;
//			var finder:AStarFinder = new AStarFinder(opt);
//			var path:Array = finder.findPath(0,0,4,4,grid);
//			trace( path );
			
			
//			Laya.loader.load("tmw_desert_spacing.png",Handler.create(this,function():void{
//				var t:Texture = Laya.loader.getRes("tmw_desert_spacing.png");
//				var ape:Sprite = new Sprite();
//				ape.graphics.drawTexture(t,0,0);
//				Laya.stage.addChild(ape);
//				ape.pos(200, 200);
//				ape.scale(0.5,0.5,true);
//				
//				var filter:GlowFilter = new GlowFilter(0x00FF00, 40, 20, 20);
//				ape.filters = [filter];
//			}),null,Loader.IMAGE);
			
//			Laya.loader.load("res/tiledMap/buch-outdoor.png",Handler.create(this,function():void{
//				var t:Texture = Laya.loader.getRes("res/tiledMap/buch-outdoor.png");
//				var ape:Sprite = new Sprite();
//				ape.graphics.drawTexture(t,0,0);
//				Laya.stage.addChild(ape);
//				ape.pos(200, 200);
//				ape.scale(0.5,0.5,true);
//				
//				var grid:Grid = Grid.createGridFromAStarMap(t);
//				trace(grid);
//				
//				var filter:GlowFilter = new GlowFilter(0x00FF00, 40, 20, 20);
//				ape.filters = [filter];
//			}),null,Loader.IMAGE);
			
			Laya.loader.load("res/tiledMap/orthogonal-outside.json",Handler.create(this,function(e:*):void{
				var jsonData:* = e;
				if(!jsonData)return;
				var layers:Array = jsonData.layers;
				if(!layers)return;
				
				//TODO 根据图形宽高构建二维数组，0代表没有地形障碍的地方
				//TODO 寻路只根据障碍层来判断
				var burdenLayer:*;
				for (var i:int = 0; i < layers.length; i++) {
					if(layers[i].type=="tilelayer" && layers[i].name=="Fringe"){
						burdenLayer = layers[i];
						break;
					}
				}
				if(!burdenLayer)return;
				var grid:Grid = Grid.createAStarGridFromBurdenLayer(burdenLayer);				
				var opt:Object = {};
				opt.allowDiagonal = false;
				var finder:AStarFinder = new AStarFinder(opt);
				var path:Array = finder.findPath(0,0,44,30,grid);
				trace( "grid",grid );
				trace( "path",path );
				
				var spp:Sprite = new Sprite();
				spp.graphics.drawCircle(0,0,8,"0xFFFFFF");
				Laya.stage.addChildAt(spp,0);
				
				Laya.timer.frameLoop(10,Laya.stage,function():void{
					var pos:Array = path[idx++];
					if(!pos){
						Laya.timer.clear(Laya.stage,arguments.callee);
						return;
					}
					spp.pos((pos[0]+1)*16+8,(pos[1]+1)*16+8);
				});
				
			}),null,Loader.JSON);
			
		}
		
		private var idx:int=0;

	}
}
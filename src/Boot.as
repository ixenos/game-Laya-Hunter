package {
	
	import PathFinding.core.Grid;
	import PathFinding.core.Heuristic;
	import PathFinding.finders.AStarFinder;
	
	import laya.debug.DebugPanel;
	import laya.debug.tools.comps.Rect;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.filters.GlowFilter;
	import laya.map.TiledMap;
	import laya.maths.Point;
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
//			tMap.createMap("res/tiledMap/orthogonal-outside.json",viewRect);
			tMap.createMap("res/tiledMap/untitled.json",viewRect);
//			tMap.scale = 0.3;
//			tMap.moveViewPort(1000,1000);
			
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
			
//			Laya.loader.load("res/tiledMap/orthogonal-outside.json",Handler.create(this,function(e:*):void{
			Laya.loader.load("res/tiledMap/untitled.json",Handler.create(this,function(e:*):void{
				var jsonData:* = e;
				if(!jsonData)return;
				var layers:Array = jsonData.layers;
				if(!layers)return;
				
				var burdenLayer:*;
				for (var i:int = 0; i < layers.length; i++) {
//					if(layers[i].type=="tilelayer" && layers[i].name=="Fringe"){
					if(layers[i].type=="tilelayer" && layers[i].name=="burden"){
						burdenLayer = layers[i];
						break;
					}
				}
				if(!burdenLayer)return;
				
				//根据图形宽高构建二维数组，0代表没有地形障碍的地方
				//寻路只根据障碍层来判断，如果有多重障碍，那么就要归并数据
				var grid:Grid = Grid.createAStarGridFromBurdenLayer(burdenLayer);				
				trace( "grid",grid );
				
				var opt:Object = {};
				opt.allowDiagonal = false;
				opt.heuristic = Heuristic.euclidean;//启发函数
				
				var finder:AStarFinder = new AStarFinder(opt);
				
				var spp:Sprite = new Sprite();
				var spp1:Sprite = new Sprite();
				spp1.graphics.drawRect(0,0,10*120,20*120,"0x234123");
				spp.graphics.drawCircle(0,0,8,"0xFFFFFF");
				Laya.stage.addChildAt(spp1,0);
				Laya.stage.addChildAt(spp,1);
				
				Laya.stage.on(Event.CLICK, this, function(e:Event):void{
					var x:int = Math.floor(e.currentTarget.mouseX/120);
					var y:int = Math.floor(e.currentTarget.mouseY/120);
					
					var grid1:Grid = grid.clone();
					if(!lastP){
						lastP = new Point(0,0);
					}
					var path:Array = finder.findPath(lastP.x,lastP.y,x,y,grid1);
					lastP.x = x;
					lastP.y = y;
					trace( "path",path );
					
					Laya.timer.frameLoop(5,Laya.stage,function():void{
						var pos:Array = path[idx++];
						if(!pos){
							idx = 0;
							Laya.timer.clear(Laya.stage,arguments.callee);
							return;
						}
						var aimX:Number = (pos[0]+1)*120-60;
						var aimY:Number = (pos[1]+1)*120-60;
						spp1.graphics.drawLine(spp.x,spp.y,aimX,aimY,"0x00FFFF",10);
						spp.pos(aimX,aimY);
					});	
					
				});
				
			}),null,Loader.JSON);
			
		}
		
		private var lastP:Point;
		
		private var idx:int=0;

	}
}
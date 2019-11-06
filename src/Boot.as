package {
	
	import PathFinding.core.DiagonalMovement;
	import PathFinding.core.Grid;
	import PathFinding.core.Heuristic;
	import PathFinding.finders.AStarFinder;
	
	import laya.debug.DebugPanel;
	import laya.debug.tools.comps.Rect;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.filters.GlowFilter;
	import laya.flash.Window;
	import laya.map.TiledMap;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.net.Loader;
	import laya.net.LoaderManager;
	import laya.particle.Particle2D;
	import laya.particle.ParticleSetting;
	import laya.renders.RenderContext;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;

	public class Boot {
		private var tMap:TiledMap;
		private var lastP:Point;
		private var idx:int=0;
		
		public function Boot() {
			//初始化舞台
			Laya.init(Browser.width, Browser.height, WebGL);
//			DebugPanel.init(false);
			
			//创建TiledMap实例
			tMap = new TiledMap();
			//创建Rectangle实例，视口区域
			var viewRect:Rectangle = new Rectangle(0, 0, Browser.width, Browser.height);
			//创建TiledMap地图
			tMap.createMap("res/tiledMap/untitled.json",viewRect,null);
//			tMap.scale = 0.3;
//			tMap.moveViewPort(1000,1000);
			
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
			
			//阴影滤镜demo		
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
			
//			Laya.loader.load("res/tiledMap/untitled1.png");
			
			var _loader:Loader = new Loader();
			var onTextureComplete:Function = function(image:*){
				//地图寻路demo			
				Laya.loader.load("res/tiledMap/untitled.json",Handler.create(this,function(e:*):void{
					var jsonData:* = e;
					if(!jsonData)return;
					var layers:Array = jsonData.layers;
					if(!layers)return;
					
					var burdenLayer:*;
					for (var i:int = 0; i < layers.length; i++) {
						if(layers[i].type=="tilelayer" && layers[i].name=="burden"){
							burdenLayer = layers[i];
							break;
						}
					}
					if(!burdenLayer)return;
					
					//根据图形宽高构建二维数组，0代表没有地形障碍的地方
					//寻路只根据障碍层来判断，如果有多重障碍，那么就要归并数据
					var grid:Grid = Grid.createAStarGridFromBurdenLayer(burdenLayer);
//					var t:Texture = Loader.getRes("res/tiledMap/untitled1.png");
//					var grid:Grid = Grid.createGridFromAStarMap(t);				
					trace( "grid",grid );
					
					var opt:Object = {};
					//看源码，这两句等于DiagonalMovement.OnlyWhenNoObstacles
	//				opt.allowDiagonal = true;//是否允许对角线
	//				opt.dontCrossCorners = true;//不要穿越角落（角落直线走，不对角线）
					opt.diagonalMovement = DiagonalMovement.OnlyWhenNoObstacles;//当没有障碍物的时候对角线行走
					opt.heuristic = Heuristic.euclidean;//启发函数
					opt.weight = 1;//启发函数权重
					
					var finder:AStarFinder = new AStarFinder(opt);
					
					var spp:Sprite = new Sprite();
					var spp1:Sprite = new Sprite();
					spp1.graphics.drawRect(0,0,10*120,20*120,"0x234123");
					spp.graphics.drawCircle(0,0,20,"0xFFFFFF");
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
							
							//pattern
//		//					var strokeStyle:* = Browser.context.createPattern(image,"repeat"); 
//							//gradient
//							var strokeStyle:*=Browser.context.createLinearGradient(0,0,170,0);
//							strokeStyle.addColorStop(0,"magenta");
//							strokeStyle.addColorStop(0.5,"blue");
//							strokeStyle.addColorStop(1.0,"red");
//							//color
////							var strokeStyle:* = "#0000FF";
//							spp1.graphics.drawLine(spp.x,spp.y,aimX,aimY,strokeStyle,30);
//							
//							spp.pos(aimX,aimY);
						});
						
						
						//pattern
	//					var strokeStyle:* = Browser.context.createPattern(image,"repeat"); 
						//gradient
	//					var strokeStyle:*=Browser.context.createLinearGradient(0,0,170,0);
	//					strokeStyle.addColorStop(0,"magenta");
	//					strokeStyle.addColorStop(0.5,"blue");
	//					strokeStyle.addColorStop(1.0,"red");
						//color
						var strokeStyle:* = "#0000FF";
						//drawLines
						var realPaths:Array = [];
						var lastSlope:Number = -1;
						for (var j:int = 0; j < path.length; j++) {
							var pos:Array = path[j];
							var aimX:Number = (pos[0]+1)*120-60;
							var aimY:Number = (pos[1]+1)*120-60;
							realPaths.push(aimX,aimY);			
						}
						spp1.graphics.drawLines(spp.x,spp.y,realPaths,strokeStyle,20);
						//drawPath
//						var realPaths:Array = [];
//						var lastSlope:Number = -1;
//						for (var j:int = 0; j < path.length; j++) {
//							var pos:Array = path[j];
//							var aimX:Number = (pos[0]+1)*120-60;
//							var aimY:Number = (pos[1]+1)*120-60;
//							
//							if(j==0){
//								realPaths.push(["moveTo",aimX,aimY]);
//							}else{
//								var lastPos:Array = path[j-1];
//								var curSlope:Number = (pos[1]-lastPos[1])/(pos[0]-lastPos[0]);
//								var lastAimX:Number = (lastPos[0]+1)*120-60;
//								var lastAimY:Number = (lastPos[1]+1)*120-60;
//								if(j==1){
//									realPaths.push(["lineTo",aimX,aimY]);
//								}else{
//									if(curSlope!=lastSlope){
//										realPaths.push(["arcTo",lastAimX,lastAimY,aimX,aimY,10]);
//									}else{
//										realPaths.push(["lineTo",aimX,aimY]);
//									}
//								}
//								lastSlope = curSlope;
//							}
//						}
//						spp1.graphics.drawPath(0,0,realPaths,null,{strokeStyle:strokeStyle,lineWidth:20});
					});
					
				}),null,Loader.JSON);
			};
			_loader.once("complete", this, onTextureComplete);
			_loader.load("cao.jpg", "nativeimage", false);
		}
	}
}
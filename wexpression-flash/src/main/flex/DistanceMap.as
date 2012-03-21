package
{
	import flash.display.BitmapData;
	
	import mx.controls.Alert;
	
	import org.as3commons.collections.ArrayList;

	public class DistanceMap
	{
		var source:BitmapData;
		var result:BitmapData;
		
		public function DistanceMap(source:BitmapData){
			this.source = source;
			result = new BitmapData(source.width, source.height, false, 0xffffff);
//			result = source.clone();

		}
			public function getDistanceMap():BitmapData{
				
				sweep(1);
//				sweep(-1);
				
				return result;
			}
			
			private function sweep(increment:int):void{
				
				var A:VertexArray = new VertexArray(source.height);
//				var stack:ArrayList = new ArrayList();
				
				for(var i:int=0; i<source.width; i++){
					var c:int = (i * increment) % source.width;
//					for(var y:int = 0;y<source.height;y++)
//						if((source.getPixel32(c,y) >> 24 & 0xFF) ==0x0) //find transparent pixel
//							A[y] = c;
					
					for(var j:int =0;j<source.height;j++){
						if(A.length==0) A.insertAt(j,Number.NEGATIVE_INFINITY); 
						if((source.getPixel32(c,j) >> 24 & 0xFF) ==0x0){
							var nextBelow:int;
							if(nextBelow==int.MAX_VALUE) break;
							var y:int = int.MAX_VALUE;
							while(((nextBelow = A.findNextIndexInArray(j, true))!=int.MAX_VALUE)  
							&& (y= bisectorIntersection(c,j,A.getXFor(nextBelow), nextBelow,c))>A.getUpperBoundFor(nextBelow))
							A.removeAt(nextBelow);
							if (y!=int.MAX_VALUE) A.insertAt(j,y);
							else{
								var nextAbove:int;

								while(((nextAbove = A.findNextIndexInArray(j, true))!=int.MAX_VALUE)  
								&& (y= bisectorIntersection(c,j,A.getXFor(nextAbove), nextAbove,c))<A.getLowerBoundFor(nextAbove))
								A.removeAt(nextAbove);
								if (y!=int.MAX_VALUE) A.insertAt(j,y);
							}
						}
					}
					
					for(var j:int = 0;j<source.height;j++){
						if(source.getPixel32(c,j)!=0x00000000) //find transparent pixel
						{
							if(j>currentVertice.part
								currentVertice = stack.removeFirst();
							var val:uint = (0xff * (computeDist(c,j,currentVertice.x,currentVertice.y) / (source.width))) << 16;
							if(result.getPixel(c,j)>val)
								result.setPixel(c,j, val);
						}
					}
				}
			}
			
			private function bisectorIntersection(x1:Number, y1:Number, x2:Number, y2:Number, x:Number):Number{
				var slope:Number = (x1-x2) / (y2-y1);
				
				//y = slope * x + b
				var b:Number = (y1+y2)/2 - (x1+x2)/2 * slope;
				
				return slope * x + b;
			}
			
			private static function computeDist(x1:int, y1:int, x2:int, y2:int):Number{
				return Math.sqrt(Math.pow((x1-x2),2)+Math.pow((y1-y2),2));
			}
	}
}
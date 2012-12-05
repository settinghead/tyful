package com.settinghead.tyful.client.model.polarcore
{
	import com.settinghead.tyful.client.model.IShapeGenerator;
	import com.settinghead.tyful.client.model.TextShapeGenerator;
	import com.settinghead.tyful.client.model.vo.DisplayWordListVO;
	import com.settinghead.tyful.client.model.vo.DisplayWordVO;
	import com.settinghead.tyful.client.model.vo.template.PlaceInfo;
	import com.settinghead.tyful.client.model.vo.template.TemplateVO;
	import com.settinghead.tyful.client.model.vo.wordlist.WordListVO;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.Base64Encoder;

	
	public class NativeClientPolarCore extends AbstractPolarCore
	{
		private var wDict:Vector.<DisplayWordVO>;
		private var shapeGenerator:TextShapeGenerator;
		
		
		public function NativeClientPolarCore(wordList:WordListVO)
		{
			shapeGenerator = new TextShapeGenerator(wordList);
		}
		
		public override function load():void{
			dispatchEvent(new Event(LOAD_COMPLETE));
			ExternalInterface.call("moduleDidLoad");
			ExternalInterface.addCallback("feedMe", feedMe);
			ExternalInterface.addCallback("slap", slap);
		}
		
		public function feedMe(numFeeds:int, shrinkage:Number):void {
			var sid:int = wDict.length;
			var shape:DisplayWordVO = shapeGenerator.nextShape(sid,shrinkage) as DisplayWordVO;
			for(var i:int=0;i<numFeeds;i++)
				feedShape(sid,shape.toBitmapData(),shrinkage);
		}
		
		public function slap(sid:uint, x:int, y:int, rotation:Number, lNum:int,color:uint, failureCount:int):void {
			var shape:DisplayWordVO = wDict[sid];
			var place:PlaceInfo = new PlaceInfo(sid,x,y,rotation,lNum,color,failureCount);
			shape.putToPlace(place);
			dispatchEvent(new ResultEvent(shape));

		}
		
		private function postBase64String(b:ByteArray):void{
						
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.reset();
			b.position = 0;
			encoder.encodeBytes(b,0,b.length);
			ExternalInterface.call("decodeAndPostMessage", encoder.toString());
		}
		
		public override function updateTemplate(template:TemplateVO):void{
			var b:ByteArray = new ByteArray();
			b.endian = Endian.LITTLE_ENDIAN;
			b.position = 0;
			b.writeInt(0);
			template.writeExternal(b);
			postBase64String(b);
			wDict = new Vector.<DisplayWordVO>();
		}
		public override function startRender():void{
			var b:ByteArray = new ByteArray();
			b.endian = Endian.LITTLE_ENDIAN;

			b.position = 0;
			b.writeInt(1);
			postBase64String(b);
		}
		public override function pauseRender():void{
			var b:ByteArray = new ByteArray();
			b.endian = Endian.LITTLE_ENDIAN;

			b.position = 0;
			b.writeInt(2);
			postBase64String(b);
		}
		public override function feedShape(sid:int,bmpd:BitmapData,shrinkage:int):void{
			var shape:DisplayWordVO = shapeGenerator.nextShape(wDict.length,shrinkage) as DisplayWordVO;
			var b:ByteArray = new ByteArray();
			b.endian = Endian.LITTLE_ENDIAN;

			b.position = 0;
			b.writeInt(3);
			b.writeUnsignedInt(sid);
			TemplateVO.writeBitmapDataAndInfo(bmpd,b);
			postBase64String(b);
		}
		public override function updatePerseverance(perseverance:int):void{
			var b:ByteArray = new ByteArray();
			b.endian = Endian.LITTLE_ENDIAN;

			b.position = 0;
			b.writeInt(4);
			b.writeUnsignedInt(perseverance);
			postBase64String(b);
		}
		public override function updateWordList(wordList:WordListVO):void{
			shapeGenerator.wordList = wordList;
		}
	}
}
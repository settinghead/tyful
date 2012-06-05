package com.settinghead.groffle.client.model.zip
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.settinghead.groffle.client.model.vo.template.TemplateVO;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import ion.utils.png.PNGDecoder;
	
	import mx.collections.ArrayCollection;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	import org.bytearray.decoder.JPEGDecoder;

	public class ZipInputImpl implements IZipInput
	{
		
		public function ZipInputImpl()
		{
		}
		
		private var file:ZipFile;

		public function parse(b:ByteArray):TemplateVO{
			file = new ZipFile(b);
			var t:TemplateVO = instantiateInstanceByPath("") as TemplateVO;
			for each(var e:ZipEntry in file.entries){
				process(e, t);
			}
			t.connectLayers();
			return t;
		}
		
		private function process(e:ZipEntry, root:Object):void{
			var pos:int = 0;
			var prevPos:int = 0;
//			while((pos = nextPos(e.name, pos))<e.name.length) {
			pos = nextPos(e.name,pos);
				processCurrent(e, prevPos+1, pos, root, null);
//				prevPos = pos;
//			}
		}
		
		private function nextPos(name:String, pos:int):int{
			do{
				pos++;
			}
				while(pos<name.length && name.charAt(pos)!='/');
			return pos;
		}
		
		private function processCurrent(e:ZipEntry, start:int, end:int, parent:Object, grandParent:Object, numericalName:Boolean = false):void{
			if(start==end || end>e.name.length) return;
			var name:String = e.name.substring(start, end);
			
			if(end==e.name.length && name=="/") return;
			if(name=="properties.json"){
				
			}
			else if(endWith(name, ".png")){
				parent[name.substr(0,name.length-4)] = readBitmapFromPNGFile(e);
			}
			else if(endWith(name, ".jpg")){
				parent[name.substr(0,name.length-4)] = readBitmapFromJPEGFile(e);
			}
			else if(endWith(name, ".jpeg")){
				parent[name.substr(0,name.length-5)] = readBitmapFromJPEGFile(e);
			}
			else if(numericalName) //array entry
			{
				var index:int = parseInt(name);
				
					//expand to fit capacity
					while(parent.length < index+1){
						if(parent is ArrayCollection)
							(parent as ArrayCollection).addItem(null);
						else if(parent is Vector)
							parent.push(null);
						else if(parent is Array)
							(parent as Array).push(null);
					}
					
					if(parent[index]==undefined || parent[index]==null){
						//determine instance type
	//					if(grandParent is IZippable)
	//						childName = (grandParent as IZippable).type + childName;
						var childName:String = (index+1).toString();
						var ins:* = instantiateInstance(e,childName,parent,grandParent,index,start,end);
						parent[index] = ins;
					}
				
				processCurrent(e, end+1, nextPos(e.name, end), parent[index], parent);
			}
			else{
				if(parent==null){
					this.hasOwnProperty();
				}
				if (parent[name] is Vector || parent[name] is Array || parent[name] is ArrayCollection){
					processCurrent(e, end+1, nextPos(e.name, end), parent[name], parent, true);
				}
				else{
					if(parent[name]==null||parent[name]==undefined){
						parent[name] = instantiateInstance(e,name,parent,grandParent,-1,start,end);
					}
					processCurrent(e, end+1, nextPos(e.name, end), parent[name], parent);
				}
			}
		}
		
		private function instantiateInstance(e:ZipEntry, name:String, parent:Object, grandParent:Object, index:int, start:int, end:int):Object{			
			return instantiateInstanceByPath(e.name.substring(0, end),name,parent,grandParent,index);
		}
		
		private function instantiateInstanceByPath(fullPath:String, name:String=null, parent:Object=null, grandParent:Object=null,index:int=-1):Object{
			var str:String = readStringFromFile(file.getEntry(fullPath+ "/properties.json"));
			var jsonDecoder:JSONDecoder = new JSONDecoder(str,true);
			var jsonObj:Object = jsonDecoder.getValue();
			var typeStr:String = jsonObj["type"] as String;
			var newInstance:* = TypeRegistrar.getObject(typeStr, name, index, parent, grandParent);
			
			//apply all properties
			var decoder2:JSONDecoder = new JSONDecoder(str,true, newInstance);
			return newInstance;
		}
		
		private function readBitmapFromPNGFile(e:ZipEntry):BitmapData{

			return PNGDecoder.decodeImage(file.getInput(e));
		}
		
		private function readBitmapFromJPEGFile(e:ZipEntry):BitmapData{			
			var myDecoder:JPEGDecoder = new JPEGDecoder();
			myDecoder.parse(file.getInput(e));
			var width:uint = myDecoder.width;
			var height:uint = myDecoder.height;
			var pixels:Vector.<uint> = myDecoder.pixels;
			var bitmap:BitmapData = new BitmapData ( width, height, false );
			bitmap.setVector ( bitmap.rect, pixels );
			return bitmap;
		}
		
		
		private function readBytesFromFile(e:ZipEntry):ByteArray{
			return file.getInput(e);
		}
		
		private static function endWith(str:String, match:String):Boolean{
			return (str.substr(str.length-match.length, match.length)==match);
		}

		
		private function readStringFromFile(e:ZipEntry):String{
			var b:ByteArray = file.getInput(e);
			return b.toString();
		}
	}
}
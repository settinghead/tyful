package com.settinghead.wexpression.client.model.zip
{
	import com.adobe.serialization.json.JSONDecoder;
	import com.settinghead.wexpression.client.model.vo.template.TemplateVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import ion.utils.png.PNGDecoder;
	
	import mx.collections.ArrayCollection;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;

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
			else if(numericalName)
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
					var childName:String = (index+1).toString();
//					if(grandParent is IZippable)
//						childName = (grandParent as IZippable).type + childName;
					parent[index] = instantiateInstance(e,childName,parent,grandParent,start,end);
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
						parent[name] = instantiateInstance(e,name,parent,grandParent,start,end);
					}
					processCurrent(e, end+1, nextPos(e.name, end), parent[name], parent);
				}
			}
		}
		
		private function instantiateInstance(e:ZipEntry, name:String, parent:Object, grandParent:Object, start:int, end:int):Object{			
			return instantiateInstanceByPath(e.name.substring(0, end),name,parent,grandParent);
		}
		
		private function instantiateInstanceByPath(fullPath:String, name:String=null, parent:Object=null, grandParent:Object=null):Object{
			var str:String = readStringFromFile(file.getEntry(fullPath+ "/properties.json"));
			var jsonDecoder:JSONDecoder = new JSONDecoder(str,true);
			var jsonObj:Object = jsonDecoder.getValue();
			var typeStr:String = jsonObj["type"] as String;
			var newInstance:* = TypeRegistrar.getObject(typeStr, name, parent, grandParent);
			
			//apply all properties
			var decoder2:JSONDecoder = new JSONDecoder(str,true, newInstance);
			return newInstance;
		}
		
		private function readBitmapFromPNGFile(e:ZipEntry):BitmapData{
//			var l:Loader = new Loader();
//			var obj:BitmapData;
//			var complete:Boolean = false;
//			l.addEventListener(Event.COMPLETE, function (evt:Event):void{
//				obj = Bitmap(LoaderInfo(evt.target).content).bitmapData;
//				complete = true;
//			}
//			);
//			l.loadBytes(readBytesFromFile(e));
//			while(!complete){}
//			return obj;
			return PNGDecoder.decodeImage(file.getInput(e));
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
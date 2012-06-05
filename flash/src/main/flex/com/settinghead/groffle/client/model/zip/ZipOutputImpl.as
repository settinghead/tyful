package com.settinghead.groffle.client.model.zip
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.serialization.json.JSONEncoder;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipOutput;
	
	public class ZipOutputImpl implements IZipOutput
	{
		
		private var zipOut:ZipOutput = new ZipOutput();
		private var prefix:String = "";
		
		public function ZipOutputImpl()
		{
		}
		
		public function putStringToFile(fileName:String, data:String):void
		{
			if(data==null) return;
			var b:ByteArray = new ByteArray();
			b.writeMultiByte(data, "utf-8");
			putBytesToFile(fileName, b);
		}
		
		public function putBytesToFile(fileName:String, bytes:ByteArray):void
		{
			if(bytes==null) return;
			var ze:ZipEntry = new ZipEntry(prefix+fileName);
			zipOut.putNextEntry(ze);
			zipOut.write(bytes);
			zipOut.closeEntry();
		}
		
		public function putBitmapDataToPNGFile(fileName: String, bmpData:BitmapData):void{
			if(bmpData ==null) return;
			putBytesToFile(fileName, PNGEncoder2.encode(bmpData));
		}
		

		
		public function putBitmapDataToJPEGFile(fileName: String, bmpData:BitmapData):void{
			
			if(bmpData ==null) return;
			
//			
//			var jpeglib:Object; 
//			var jpeginit:CLibInit = new CLibInit(); // get library 
//			jpeglib=jpeginit.init(); 
//			
//			var out:ByteArray = new ByteArray();
//			
//			jpeglib.encode( bmpData, out, bmpData.width, bmpData.height, 60 );			

			var e:JPGEncoder = new JPGEncoder(60);
			var out:ByteArray = e.encode(bmpData);
			putBytesToFile(fileName, out);
		}
		
		public function process(object:Object, dirName:String=""):void
		{
			if(object == null) return;
			var prev_prefix:String = prefix;
			prefix += dirName + "/";
			if (object is Vector || object is Array || object is ArrayCollection){
				for(var i:int =0; i<object.length; i++){
					process(object[i], i.toString());
				}
			}
			else 
			{
				if (object is IZippable){
					var properties:Object = new Object();
					(object as IZippable).saveProperties(properties);
					if((object as IZippable).type!=null)
						properties["type"] = (object as IZippable).type;
					putStringToFile("properties.json", (new JSONEncoder(properties)).getString());

					(object as IZippable).writeNonJSONPropertiesToZip(this);
				}
				else{
					putStringToFile("properties.json",(new JSONEncoder(object)).getString());
				}
			}
			prefix = prev_prefix;
		}
		
		public function zipUp():ByteArray{
			zipOut.finish();
			return zipOut.byteArray;
		}
	}
}
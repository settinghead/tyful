package com.settinghead.wexpression.client.model.zip
{
	import com.adobe.images.PNGEncoder;
	import com.adobe.serialization.json.JSONEncoder;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.preloaders.Preloader;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipOutput;
	
	import org.as3commons.lang.HashArray;
	
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
			putBytesToFile(fileName, PNGEncoder.encode(bmpData));
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
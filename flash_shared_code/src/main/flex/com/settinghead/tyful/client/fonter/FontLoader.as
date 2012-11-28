package com.settinghead.tyful.client.fonter
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.*;
	
	public class FontLoader extends Sprite {
		
		public function FontLoader() {
			loadFont("_Arial.swf");
		}
		
		private function loadFont(url:String):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fontLoaded);
			loader.load(new URLRequest(url));
		}
		
		private function fontLoaded(event:Event):void {
			var FontLibrary:Class = event.target.applicationDomain.getDefinition("_Arial") as Class;
			Font.registerFont(FontLibrary._Arial);
			drawText();
		}
		
		public function drawText():void {
			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat("_Arial", 16, 0);
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.border = true;
			tf.text = "Scott was here\nScott was here too\nblah scott...:;*&^% ";
			tf.rotation = 15;
			
			addChild(tf);
		}
	}
}
package net.codestore.flex
{
	import flash.display.Sprite;
	
	import mx.containers.Box;
	import mx.controls.Label;
	import mx.controls.ProgressBar;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	public class Mask extends Box
	{
		
		private static var _mask:Mask;
		public static function get shown():Boolean{
			return (_mask!=null);
		}
		private var _message:String;
		
		public function Mask()
		{
			super();
		}
		
		public static function show(message:String, parent:Sprite=null):Mask{
			if(shown) close();
			_mask = new Mask();
			_mask._message = message;
			PopUpManager.addPopUp(_mask, parent||Sprite(FlexGlobals.topLevelApplication), true);
			PopUpManager.centerPopUp(_mask);
			
			return _mask;	
		}
		
		
		public static function close():void {
			PopUpManager.removePopUp(_mask);
			_mask = null;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			var pb:ProgressBar = new ProgressBar();
			
			pb.label = _message||"Just a second...";
//			pb.indeterminate = true;
			pb.labelPlacement= 'center';
			pb.setStyle('barColor', uint(0xADCDFF));
//			pb.setStyle('indeterminateMoveInterval', 9999999999);
			pb.height = 26;
			
			addChild(pb);				
		}
	}
}
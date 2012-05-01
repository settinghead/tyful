package net.codestore.flex
{
	import flash.display.Sprite;
	
	import mx.containers.Box;
	import mx.controls.ProgressBar;
	import mx.core.Application;
	import mx.managers.PopUpManager;
	
	public class Mask extends Box
	{
		
		private static var _mask:Mask;
		
		private var _message:String;
		
		public function Mask()
		{
			super();
		}
		
		public static function show(message:String, parent:Sprite=null):Mask{
			
			_mask = new Mask();
			_mask._message = message;
			PopUpManager.addPopUp(_mask, parent||Sprite(Application.application), true);
			PopUpManager.centerPopUp(_mask);
			
			return _mask;	
		}
		
		
		public static function close():void {
			PopUpManager.removePopUp(_mask);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			var pb:ProgressBar = new ProgressBar();
			pb.label = _message||"Please wait...";
			pb.indeterminate = true;
			pb.labelPlacement= 'center';
			pb.setStyle('barColor', uint(0xAEAEAE));
			pb.height = 26;
			
			addChild(pb);				
		}
	}
}
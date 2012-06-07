package {
	import cmodule.polartree.CLibInit;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	
	import mx.controls.Alert;
	
	import polartree.BBPolarRootTreeVO;
	import polartree.BBPolarTreeBuilder;
	import polartree.TextShapeVO;

	public class EchoTest extends Sprite
	{
		public function EchoTest()
		{
			var loader:CLibInit = new CLibInit;
			var lib:Object = loader.init();
			
			var s:TextShapeVO = new TextShapeVO(true,"hello",0,30,0,"judson");
			var t:BBPolarRootTreeVO = BBPolarTreeBuilder.makeTree(s,0);
			
			ExternalInterface.call( "console.log" , t.toString());
			
			ExternalInterface.call( "console.log" , lib.echo('aaaaaa'));

		}
	}
}

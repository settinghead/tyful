package {
	import cmodule.polartree.CLibInit;
	
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	
	import polartree.BBPolarRootTreeVO;
	import polartree.BBPolarTreeBuilder;
	import polartree.TextShapeVO;

	public class EchoTest extends Sprite
	{
		public function EchoTest()
		{
			var loader:CLibInit = new CLibInit;
			var lib:Object = loader.init();			
			
			ExternalInterface.call( "console.log" , lib.echo('aaaaaa'));		
		}
	}
}

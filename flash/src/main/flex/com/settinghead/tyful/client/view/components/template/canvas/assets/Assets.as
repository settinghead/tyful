package com.settinghead.tyful.client.view.components.template.canvas.assets
{
	import flash.display.Shader;
	
	import mx.core.BitmapAsset;

	public class Assets
	{
		[Embed("SmallA.png")]
		public static var SmallA:Class;
		
		[Embed(source="lock_boundary.pbj", mimeType="application/octet-stream")] 
		private static var LockBoundaryShaderClass:Class; 
		
		public static function getSmallA():BitmapAsset{
			return new SmallA();
		}
		
		public static function getLockBoundaryShader():Shader{
			var shader:Shader  = new Shader(new LockBoundaryShaderClass());
			return shader;
		}
	}
}
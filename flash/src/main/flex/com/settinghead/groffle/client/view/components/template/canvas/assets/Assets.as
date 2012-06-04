package com.settinghead.groffle.client.view.components.template.canvas.assets
{
	import mx.core.BitmapAsset;

	public class Assets
	{
		[Embed("SmallA.png")]
		public static var SmallA:Class;
		
		public static function getSmallA():BitmapAsset{
			return new SmallA();
		}
	}
}
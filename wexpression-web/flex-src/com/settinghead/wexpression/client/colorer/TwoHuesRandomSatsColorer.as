package com.settinghead.wexpression.client.colorer
{
	import com.lorentz.SVG.utils.MathUtils;
	import com.settinghead.wexpression.client.Word;
	
	import de.polygonal.utils.PM_PRNG;
	
	import mx.utils.ColorUtil;
	
	import org.peaceoutside.utils.ColorMath;
	
	public class TwoHuesRandomSatsColorer implements WordColorer
	{
		var hues:Array;
		var prng:PM_PRNG = new PM_PRNG();
		public function TwoHuesRandomSatsColorer()
		{
			hues= new Array(Math.random()*256, Math.random()*256 );

		}
		
		public function colorFor(word:Word):uint
		{
			var hue:Number= hues[prng.nextIntRange(0,hues.length-1)];
			var sat:Number= Math.random()*256;
			var val:Number= prng.nextIntRange(100, 256);
			
			
			return ColorMath.HSLToRGB(hue/256, sat/256, val/256);
		}
	}
}
package com.settinghead.wexpression.client {
import flash.geom.Rectangle;


internal interface ImageShape {

	function contains(x:Number, y:Number, width:Number, height:Number):Boolean ;

	function intersects(x:Number, y:Number, width:Number, height:Number):Boolean ;

	function getBounds2D():Rectangle ;
	public function getWidth():int;
	public function getHeight():int;
	
}
}
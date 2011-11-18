package com.settinghead.wexpression.client {
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.geom.Rectangle;


	internal interface ImageShape {
	
		function contains(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean;
		function containsPoint(x:Number, y:Number,transformed:Boolean):Boolean;
		function intersects(x:Number, y:Number, width:Number, height:Number, transformed:Boolean):Boolean;
		function getBounds2D():Rectangle ;
		function getWidth():int;
		function getHeight():int;
		function translate(tx:Number,ty:Number):void;
		function get object(): DisplayObject;
		function get shape(): DisplayObject

	}
}
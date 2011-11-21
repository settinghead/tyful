package com.settinghead.wenwentu.client {
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.geom.Rectangle;


	internal interface ImageShape {
	
		function contains(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean;
		function containsPoint(x:Number, y:Number,transformed:Boolean):Boolean;
		function intersects(x:Number, y:Number, width:Number, height:Number, transformed:Boolean):Boolean;
//		function translate(tx:Number,ty:Number):void;
//		function get object(): DisplayObject;
//		function get shape(): DisplayObject
		
		function get objectWidth():Number;
		function get objectHeight():Number;

	}
}
package com.settinghead.wenwentu.client.model.vo {
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.geom.Rectangle;


	public interface IImageShape {
	
		function contains(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean;
		function containsPoint(x:Number, y:Number,transformed:Boolean):Boolean;
		function intersects(x:Number, y:Number, width:Number, height:Number, transformed:Boolean):Boolean;
//		function translate(tx:Number,ty:Number):void;
//		function get object(): DisplayObject;
//		function get shape(): DisplayObject
		
		function get width():Number;
		function get height():Number;

	}
}
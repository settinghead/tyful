package com.settinghead.wexpression.client.model.vo {
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.geom.Rectangle;


	public interface IImageShape {
	
		function contains(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean;
		function containsPoint(x:Number, y:Number,transformed:Boolean):Boolean;
		function intersects(x:Number, y:Number, width:Number, height:Number, transformed:Boolean):Boolean;
		
		function get width():Number;
		function get height():Number;

	}
}
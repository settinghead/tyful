package com.settinghead.groffle.client.model.vo {
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.geom.Rectangle;


	public interface IImageShape {
	
		function contains(x:Number, y:Number, width:Number, height:Number, rotation:Number, transformed:Boolean):Boolean;
		function containsPoint(x:Number, y:Number,transformed:Boolean, refX:Number=-1,refY:Number=-1):Boolean;
		function intersects(x:Number, y:Number, width:Number, height:Number, transformed:Boolean):Boolean;
		
		function get width():Number;
		function get height():Number;

	}
}
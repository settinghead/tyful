package com.settinghead.groffle.client.model.algo.tree;	
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.geom.Rectangle;


interface IImageShape {
	
	function contains(x:Float, y:Float, width:Float, height:Float, rotation:Float, transformed:Bool):Bool;
	function containsPoint(x:Float, y:Float,transformed:Bool, refX:Float=-1,refY:Float=-1):Bool;
	function intersects(x:Float, y:Float, width:Float, height:Float, transformed:Bool):Bool;
		
	function getWidth():Float;
	function getHeight():Float;

}
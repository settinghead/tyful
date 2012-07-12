package com.settinghead.tyful.client.model.algo.tree;	

interface IImageShape {
	
	function contains(x:Float, y:Float, width:Float, height:Float, rotation:Float, transformed:Bool):Bool;
	function containsPoint(x:Float, y:Float,transformed:Bool, refX:Float=-1,refY:Float=-1):Bool;
	function intersects(x:Float, y:Float, width:Float, height:Float, transformed:Bool):Bool;
		
	function getWidth():Float;
	function getHeight():Float;

}
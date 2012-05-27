package com.settinghead.groffle.client.model.vo.template
{
	
	import com.settinghead.groffle.client.NotImplementedError;
	import com.settinghead.groffle.client.RenderOptions;
	import com.settinghead.groffle.client.angler.MostlyHorizAngler;
	import com.settinghead.groffle.client.angler.ShapeConfinedAngler;
	import com.settinghead.groffle.client.angler.WordAngler;
	import com.settinghead.groffle.client.colorer.TwoHuesRandomSatsColorer;
	import com.settinghead.groffle.client.colorer.WordColorer;
	import com.settinghead.groffle.client.fonter.AlwaysUseFonter;
	import com.settinghead.groffle.client.fonter.WordFonter;
	import com.settinghead.groffle.client.model.vo.BBPolarRootTreeVO;
	import com.settinghead.groffle.client.model.vo.IImageShape;
	import com.settinghead.groffle.client.model.zip.IZipInput;
	import com.settinghead.groffle.client.model.zip.IZipOutput;
	import com.settinghead.groffle.client.model.zip.IZippable;
	import com.settinghead.groffle.client.nudger.ShapeConfinedRandomWordNudger;
	import com.settinghead.groffle.client.nudger.ShapeConfinedSpiralWordNudger;
	import com.settinghead.groffle.client.nudger.ShapeConfinedZigZagWordNudger;
	import com.settinghead.groffle.client.nudger.WordNudger;
	import com.settinghead.groffle.client.placer.ShapeConfinedPlacer;
	import com.settinghead.groffle.client.placer.WordPlacer;
	import com.settinghead.groffle.client.sizers.ByWeightSizer;
	import com.settinghead.groffle.client.sizers.WordSizer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	import mx.controls.Alert;
	import mx.utils.HSBColor;
	
	import org.as3commons.bytecode.util.Assertions;
	import org.as3commons.lang.Assert;
	import org.peaceoutside.utils.ColorMath;
	
	
	[Bindable]
	public class Layer implements IImageShape, IZippable, IWithEffectiveBorder
	{
		protected var _template:TemplateVO;
		protected var _thumbnail:BitmapData;
		private var _name:String;
		public var above:Layer;
		public var below:Layer;
		protected var _effectiveBorder:TwoPointBorder = null;

		
		public function get name():String{
			return _name;
		}
		
		public function set name(v:String):void{
			this._name = v;
		}
		
		public function Layer(n:String, template:TemplateVO, autoAddAndConnect:Boolean = true){
			this.name = n;
			this._template = template;
			if(autoAddAndConnect){
				if(this._template.layers.length>0)
				{
					connect(this, this._template.layers[this._template.layers.length-1] as Layer);
						
				}
				this._template.layers.addItem(this);
			}
		}
		
		public function get width():Number{
			throw new  NotImplementedError();
		}
		
		public function get height():Number{
			throw new  NotImplementedError();
		}
		
		public function toString():String{
			return name;
		}
		
		public function contains(x:Number, y:Number, width:Number, height:Number,rotation:Number, transformed:Boolean):Boolean {
			throw new NotImplementedError();
		}
		
		public function containsPoint(x:Number, y:Number,transformed:Boolean,  refX:Number,refY:Number, tolerance:Number):Boolean{
			throw new NotImplementedError();
		}
		
		public function containsAllPolarPoints(centerX:Number, centerY:Number, points:Array, rotation:Number, refX:Number,refY:Number, tolerance:Number):Boolean{
			for(var i:int = 0 ;i<points.length;i++){
				var theta:Number = (points[i] as Array)[0];
				var d:Number = (points[i] as Array)[1];
				theta -= rotation;
				var x:Number = centerX + Math.cos(theta) * d;
				var y:Number = centerY + Math.sin(theta) * d;
				
				if(!containsPoint(x,y,false, refX,refY, tolerance)) return false;
			}
			return true;
		}
		
		public function containsAnyPolarPoints(centerX:Number, centerY:Number, points:Array, rotation:Number, refX:Number,refY:Number, tolerance:Number):Boolean{
			for(var i:int = 0 ;i<points.length;i++){
				var theta:Number = (points[i] as Array)[0];
				var d:Number = (points[i] as Array)[1];
				theta -= rotation;
				var x:Number = centerX + Math.cos(theta) * d;
				var y:Number = centerY + Math.sin(theta) * d;
				
				if(containsPoint(x,y,false, refX,refY, tolerance)) return true;
			}
			return false;
		}
		
		public function intersects(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean {
			throw new NotImplementedError();
		}
		
		public function aboveContains(x:Number, y:Number, width:Number, height:Number,rotation:Number, transformed:Boolean):Boolean {
			if(above!=null){
				if(above.contains(x,y,width,height, rotation, transformed)) return true;
				else return above.aboveContains(x,y,width,height,rotation, transformed);
			}
			else return false;
		}
		
		public function aboveContainsPoint(x:Number, y:Number, transformed:Boolean, refX:Number, refY:Number, tolerance:Number):Boolean {
			if(above!=null){
				if(above.containsPoint(x,y, transformed, refX, refY, tolerance)) return true;
				else return above.aboveContainsPoint(x,y,transformed, refX, refY, tolerance);
			}
			else return false;
		}
		
		public function aboveContainsAnyPolarPoints(centerX:Number, centerY:Number, points:Array, rotation:Number, refX:Number,refY:Number, tolerance:Number):Boolean{
			if(above!=null){
				if(above.containsAnyPolarPoints(centerX,centerY,points, rotation,refX,refY,tolerance)) return true;
				else return above.aboveContainsAnyPolarPoints(centerX,centerY, points, rotation, refX,refY, tolerance);
			}
			else return false;
		}

		
		public static function connect(above:Layer, below:Layer):void{
			if(above!=null) above.below = below;
			if(below!=null) below.above = above;
		}
		
		public function writeNonJSONPropertiesToZip(output:IZipOutput):void {
			throw new NotImplementedError();
		}
		
		public function readNonJSONPropertiesFromZip(input:IZipInput):void {
			throw new NotImplementedError();
		}
		
		public function saveProperties(dict:Object):void{
			throw new NotImplementedError();
		}
		
		public function generateEffectiveBorder():void{
			throw new NotImplementedError();

		}
		
		public function get effectiveBorder():TwoPointBorder{
			if(this._effectiveBorder==null)
				generateEffectiveBorder();
			return this._effectiveBorder;
		}
		
		public function get type():String{
			throw new NotImplementedError();
		}
		
		public function set type(t:String):void{
			//dummy method; do nothing 
		}
	}
}
package com.settinghead.tyful.client.model.vo.template
{
	
	import com.settinghead.tyful.client.NotImplementedError;
	import com.settinghead.tyful.client.model.algo.tree.IImageShape;
	import com.settinghead.tyful.client.model.zip.IZipInput;
	import com.settinghead.tyful.client.model.zip.IZipOutput;
	import com.settinghead.tyful.client.model.zip.IZippable;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	
	
	[Bindable]
	public class Layer implements IImageShape, IZippable, IWithEffectiveBorder
	{
		protected var _template:TemplateVO;
		protected var _thumbnail:BitmapData;
		private var _name:String;
		public var above:Layer;
		public var below:Layer;
		protected var _effectiveBorder:Rectangle = null;

		
		public function get name():String{
			return _name;
		}
		
		public function set name(v:String):void{
			this._name = v;
		}
		
		public function Layer(n:String, template:TemplateVO, index:int = -1, autoAddAndConnect:Boolean = true){
			this.name = n;
			this._template = template;
			if(autoAddAndConnect){
				if(index<0){
					if(this._template.layers.length>0)
					{
						connect(this, this._template.layers[this._template.layers.length-1] as Layer);
							
					}
				}
				else{
					if(index>0&&this._template.layers.length>=index && this._template.layers[index-1]!=null)
					{
						connect(this, this._template.layers[index-1] as Layer);	
					}
					if(index<this._template.layers.length-1&&this._template.layers[index+1]!=null)
					{
						connect(this._template.layers[index+1] as Layer,this);	
					}
					
				}
				this._template.layers.addItem(this);
			}
		}
		
		public function getWidth():Number{
			throw new  NotImplementedError();
		}
		
		public function getHeight():Number{
			throw new  NotImplementedError();
		}
		
		public function toString():String{
			return name;
		}
		
		public function contains(x:Number, y:Number, width:Number, height:Number,rotation:Number, transformed:Boolean):Boolean {
			throw new NotImplementedError();
		}
		
		public function containsPoint(x:Number, y:Number,transformed:Boolean,  refX:Number=-1,refY:Number=-1):Boolean{
			throw new NotImplementedError();
		}
		
		public function containsAllPolarPoints(centerX:Number, centerY:Number, points:Array, rotation:Number, refX:Number,refY:Number):Boolean{
			for(var i:int = 0 ;i<points.length;i++){
				var theta:Number = (points[i] as Array)[0];
				var d:Number = (points[i] as Array)[1];
				theta -= rotation;
				var x:Number = centerX + Math.cos(theta) * d;
				var y:Number = centerY + Math.sin(theta) * d;
				
				if(!containsPoint(x,y,false, refX,refY)) return false;
			}
			return true;
		}
		
		public function containsAnyPolarPoints(centerX:Number, centerY:Number, points:Array, rotation:Number, refX:Number,refY:Number):Boolean{
			for(var i:int = 0 ;i<points.length;i++){
				var theta:Number = (points[i] as Array)[0];
				var d:Number = (points[i] as Array)[1];
				theta -= rotation;
				var x:Number = centerX + Math.cos(theta) * d;
				var y:Number = centerY + Math.sin(theta) * d;
				
				if(containsPoint(x,y,false, refX,refY)) return true;
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
		
		public function aboveContainsPoint(x:Number, y:Number, transformed:Boolean, refX:Number=-1, refY:Number=-1):Boolean {
			if(above!=null){
				if(above.containsPoint(x,y, transformed, refX, refY)) return true;
				else return above.aboveContainsPoint(x,y,transformed, refX, refY);
			}
			else return false;
		}
		
		public function aboveContainsAnyPolarPoints(centerX:Number, centerY:Number, points:Array, rotation:Number, refX:Number,refY:Number):Boolean{
			if(above!=null){
				if(above.containsAnyPolarPoints(centerX,centerY,points, rotation,refX,refY)) return true;
				else return above.aboveContainsAnyPolarPoints(centerX,centerY, points, rotation, refX,refY);
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
		
		public function get effectiveBorder():Rectangle{
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
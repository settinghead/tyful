/**
 * This is a generated sub-class of _Layer.as and is intended for behavior
 * customization.  This class is only generated when there is no file already present
 * at its target location.  Thus custom behavior that you add here will survive regeneration
 * of the super-class. 
 *
 * NOTE: Do not manually modify the RemoteClass mapping unless
 * your server representation of this class has changed and you've 
 * updated your ActionScriptGeneration,RemoteClass annotation on the
 * corresponding entity 
 **/ 
 
package com.settinghead.wexpression.client.model.vo.template
{

import com.adobe.fiber.core.model_internal;
import com.adobe.images.PNGEncoder;
import com.settinghead.wexpression.client.density.DensityPatchIndex;
import com.settinghead.wexpression.client.model.vo.BBPolarRootTreeVO;

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
import flash.utils.ByteArray;

import mx.controls.Alert;
import mx.utils.HSBColor;

import org.as3commons.bytecode.util.Assertions;
import org.as3commons.lang.Assert;
import org.peaceoutside.utils.ColorMath;
import org.springextensions.actionscript.context.support.mxml.Template;


public class Layer extends _Super_Layer
{
    /** 
     * DO NOT MODIFY THIS STATIC INITIALIZER - IT IS NECESSARY
     * FOR PROPERLY SETTING UP THE REMOTE CLASS ALIAS FOR THIS CLASS
     *
     **/
     
    /**
     * Calling this static function will initialize RemoteClass aliases
     * for this value object as well as all of the value objects corresponding
     * to entities associated to this value object's entity.  
     */     
    public static function _initRemoteClassAlias() : void
    {
        _Super_Layer.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.Layer);
        _Super_Layer.model_internal::initRemoteClassAliasAllRelated();
    }
     
    model_internal static function initRemoteClassAliasSingleChild() : void
    {
        _Super_Layer.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.Layer);
    }
    
    {
        _Super_Layer.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.Layer);
    }
    /** 
     * END OF DO NOT MODIFY SECTION
     *
     **/  
	
	private var tree:BBPolarRootTreeVO;
	public var _img:Bitmap;
	private var _bounds:Rectangle= null;
	private var hsbArray:Array;

	private static const SAMPLE_DISTANCE:Number= 100;
	private static const MISS_PERCENTAGE_THRESHOLD:Number= 0.1;
	
	public function get height():int {
		return img.height;
	}
	
	public function get width():int {
		return img.width;
	}
	
	public function get img():Bitmap{
		if(this._img == null)
			this.loadLayerFromPNG();
		return _img;
	}
	
	private function loadLayerFromPNG():void{
		var loader:Loader = new Loader();
		loader.loadBytes(this.imgPNG);
		var bmpd:BitmapData = new BitmapData(loader.width, loader.height, true);
		bmpd.draw(loader);
		var bmp:Bitmap = new Bitmap(bmpd);
		
		this._img = bmp;
	}
	
	public function set img(bmp:Bitmap):void{
		this._img = bmp;
	}
	
	public override function get imgPNG():ByteArray{
		return PNGEncoder.encode(this.img.bitmapData);
	}
	
	public function getBounds2D():Rectangle {
		
		if (this._bounds == null) {
			var centerX:Number= img.width / 2;
			var centerY:Number= img.height / 2;
			var radius:Number= Math.sqrt(Math.pow(centerX, 2)
				+ Math.pow(centerY, 2));
			var diameter:int= int((radius * 2));
			
			this._bounds = new Rectangle(int((centerX - radius)),
				int((centerY - radius)), diameter, diameter);
		}
		return this._bounds;
	}
	
	public function contains(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean {
		if (tree == null) {
			
			
			// sampling approach
			var numSamples:int= int((width * height / SAMPLE_DISTANCE));
			//				var numSamples = 10;
			// TODO: devise better lower bound
			if (numSamples < 10)
				numSamples = 10;
			var threshold:int= 1;
			var darkCount:int= 0;
			var i:int= 0;
			while (i < numSamples) {
				var relativeX:int= int((Math.random() * width));
				var relativeY:int= int((Math.random() * height));
				var sampleX:int= relativeX + x;
				var sampleY:int= relativeY + y;
				var brightness:Number = getBrightness(sampleX, sampleY);
				if ((isNaN(brightness) || brightness < 0.01) && ++darkCount >= threshold)
					//					if ((!containsPoint(sampleX, sampleY, false)) && ++darkCount >= threshold)
					return false;
				i++;
			}
			
			return true;
			
		} else {
			return tree.contains(x, y, x + width, y + height);
		}
	}
	
	
	public function containsPoint(x:Number, y:Number, transform:Boolean):Boolean{
		return img.hitTestPoint(x,y,true);
	}
	
	public function intersects(x:Number, y:Number, width:Number, height:Number,transformed:Boolean):Boolean {
		if (tree == null) {
			var threshold:int= 10;
			var darkCount:int= 0;
			var brightCount:int= 0;
			
			var numSamples:int= int((width * height / SAMPLE_DISTANCE));
			// TODO: devise better lower bound
			if (numSamples < 4)
				numSamples = 4;
			
			var i:int= 0;
			while (i < numSamples) {
				var relativeX:int= int((Math.random() * width));
				var relativeY:int= int((Math.random() * height));
				var sampleX:int= int((relativeX + x));
				var sampleY:int= int((relativeY + y));
				if (getBrightness(int((sampleX)), int((sampleY))) < 0.01)
					//					if(!containsPoint(sampleX, sampleY, false))
					darkCount++;
				else
					brightCount++;
				if (darkCount >= threshold && brightCount >= threshold)
					return true;
				i++;
			}
			
			return false;
			
		} else {
			return tree.overlapsCoord(x, y, x + width, y + height);
		}
	}
	
	public function translate(tx:Number, ty: Number):void{
		var mtx: Matrix = img.transform.matrix;
		mtx.translate(tx,ty);
		img.transform.matrix = mtx;
	}

	private function getHSB(x:int, y:int):int{
		if(this.hsbArray[x]==null)
			this.hsbArray[x] = new Array(this._img.height);
		if(this.hsbArray[x][y]==null){
			var rgbPixel : uint = _img.bitmapData.getPixel32( x, y );
			var alpha:uint = rgbPixel>> 24 & 0xFF;
			if(alpha == 0) {
				hsbArray[x][y]  = NaN;
				return NaN;
			}
			else {
				var colour:int =  ColorMath.RGBtoHSB(rgbPixel);
				hsbArray[x][y] = colour;
				return colour;
			}
		}
		return this.hsbArray[x][y];
	}
	
	public function getBrightness(x:int, y:int):Number {
		var colour : int =getHSB(x,y);
		var b:Number= (colour & 0xFF);
		b/=255;
		return b;
	}
	
	public function getHue(x:int, y:int):Number {
		var colour : int = getHSB(x,y);
		//			Assert.isTrue(!isNaN(colour.hue));
		var h:Number= ( (colour & 0x00FF0000) >> 16);
		h/=255;
		return h;
	}
}



}
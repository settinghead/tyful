package com.settinghead.wexpression.client.model.vo.template
{
	
	import com.settinghead.wexpression.client.NotImplementedError;
	import com.settinghead.wexpression.client.RenderOptions;
	import com.settinghead.wexpression.client.angler.MostlyHorizAngler;
	import com.settinghead.wexpression.client.angler.ShapeConfinedAngler;
	import com.settinghead.wexpression.client.angler.WordAngler;
	import com.settinghead.wexpression.client.colorer.TwoHuesRandomSatsColorer;
	import com.settinghead.wexpression.client.colorer.WordColorer;
	import com.settinghead.wexpression.client.density.DensityPatchIndex;
	import com.settinghead.wexpression.client.fonter.AlwaysUseFonter;
	import com.settinghead.wexpression.client.fonter.WordFonter;
	import com.settinghead.wexpression.client.model.vo.BBPolarRootTreeVO;
	import com.settinghead.wexpression.client.model.vo.IImageShape;
	import com.settinghead.wexpression.client.nudger.ShapeConfinedRandomWordNudger;
	import com.settinghead.wexpression.client.nudger.ShapeConfinedSpiralWordNudger;
	import com.settinghead.wexpression.client.nudger.ShapeConfinedZigZagWordNudger;
	import com.settinghead.wexpression.client.nudger.WordNudger;
	import com.settinghead.wexpression.client.placer.ShapeConfinedPlacer;
	import com.settinghead.wexpression.client.placer.WordPlacer;
	import com.settinghead.wexpression.client.sizers.ByWeightSizer;
	import com.settinghead.wexpression.client.sizers.WordSizer;
	
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
	
	import mx.controls.Alert;
	import mx.utils.HSBColor;
	
	import org.as3commons.bytecode.util.Assertions;
	import org.as3commons.lang.Assert;
	import org.peaceoutside.utils.ColorMath;
	import org.springextensions.actionscript.context.support.mxml.Template;
	
	
	[Bindable]
	public class Layer
	{
		protected var _template:TemplateVO;
		protected var _thumbnail:BitmapData;

		
		public function Layer(template:TemplateVO){
			this._template = template;
			this._template.layers.push(this);
		}
		
		public function get width():Number{
			throw new  NotImplementedError();
		}
		
		public function get height():Number{
			throw new  NotImplementedError();
		}
	
	}
}
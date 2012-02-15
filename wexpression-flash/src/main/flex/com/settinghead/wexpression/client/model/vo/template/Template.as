/**
 * This is a generated sub-class of _Template.as and is intended for behavior
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
import com.settinghead.wexpression.client.density.DensityPatchIndex;
import com.settinghead.wexpression.client.model.vo.template.colorer.TwoHuesRandomSatsColorer;
import com.settinghead.wexpression.client.model.vo.template.fonter.AlwaysUseFonter;
import com.settinghead.wexpression.client.model.vo.template.nudger.ShapeConfinedZigZagWordNudger;
import com.settinghead.wexpression.client.model.vo.template.placer.ShapeConfinedPlacer;
import com.settinghead.wexpression.client.model.vo.template.sizer.ByWeightSizer;

public class Template extends _Super_Template
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
        _Super_Template.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.Template);
        _Super_Template.model_internal::initRemoteClassAliasAllRelated();
    }
     
    model_internal static function initRemoteClassAliasSingleChild() : void
    {
        _Super_Template.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.Template);
    }
    
    {
        _Super_Template.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.Template);
    }
    /** 
     * END OF DO NOT MODIFY SECTION
     *
     **/
	
	private var _width:Number, _height:Number;
	private var _patchIndex:DensityPatchIndex;

	public function Template(){
		super();
		this._patchIndex = new DensityPatchIndex(this);

	}
	
	public function get width():Number{
		if(isNaN(_width)){
			var maxWidth:Number = 0;
			for each(var l:Layer in layers)
			if(maxWidth < l.width) maxWidth = l.width;
			if(maxWidth > 0) _width = maxWidth; 
		}
		return _width;
	}
	
	public function get height():Number{
		if(isNaN(_height)){
			var maxHeight:Number = 0;
			for each(var l:Layer in layers)
			if(maxHeight < l.height) maxHeight = l.height;
			if(maxHeight > 0) _height = maxHeight; 
		}
		return _height;
	}
	
	public function get patchIndex():DensityPatchIndex{
		return this._patchIndex;
	}
	
	public override function get renderOptions():RenderOptions{
		if(super.renderOptions==null){
			super.renderOptions = new RenderOptions();
		}
		return super.renderOptions;
	}
	
	public override function get placer():WordPlacer{
		if(super.placer==null){
			super.placer = new ShapeConfinedPlacer(this);
		}
		return super.placer;
	}
	
	public override function get sizer():WordSizer{
		if(super.sizer==null){
			super.sizer = new ByWeightSizer(14,100);
		}
		return super.sizer;
	}
	
	public override function get fonter():WordFonter{
		if(super.fonter==null){
			super.fonter = new AlwaysUseFonter("Vera");
		}
		return super.fonter;
	}
	
	
	public override function get colorer():WordColorer{
		if(super.colorer==null){
			super.colorer = new TwoHuesRandomSatsColorer();
		}
		return super.colorer;
	}
	
	public override function get nudger():WordNudger{
		if(super.nudger==null){
			//								this._nudger = new ShapeConfinedSpiralWordNudger();
			//				this._nudger = new ShapeConfinedRandomWordNudger();
			super.nudger = new ShapeConfinedZigZagWordNudger();
			
		}
		return super.nudger;
	}

}

}
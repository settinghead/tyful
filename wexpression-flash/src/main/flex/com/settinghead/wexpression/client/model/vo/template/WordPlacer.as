/**
 * This is a generated sub-class of _WordPlacer.as and is intended for behavior
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
import com.settinghead.wexpression.client.NotImplementedError;
import com.settinghead.wexpression.client.PlaceInfo;
import com.settinghead.wexpression.client.model.vo.WordVO;
import com.settinghead.wexpression.client.model.vo.template.placer.CenterClumpPlacer;
import com.settinghead.wexpression.client.model.vo.template.placer.ShapeConfinedPlacer;

import flash.net.registerClassAlias;

public class WordPlacer extends _Super_WordPlacer
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
        _Super_WordPlacer.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.WordPlacer);
        _Super_WordPlacer.model_internal::initRemoteClassAliasAllRelated();
    }
     
    model_internal static function initRemoteClassAliasSingleChild() : void
    {
        _Super_WordPlacer.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.WordPlacer);
    }
    
    {
        _Super_WordPlacer.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.WordPlacer);
    }
    /** 
     * END OF DO NOT MODIFY SECTION
     *
     **/    
	
	public function WordPlacer(){
		super();
		registerClassAlias("com.settinghead.wexpression.data.template.placer.CenterClumpPlacer",CenterClumpPlacer);
		registerClassAlias("com.settinghead.wexpression.data.template.placer.ShapeConfinedPlacer",ShapeConfinedPlacer);
	}
	
	public function place(word:WordVO, wordIndex:int, wordsCount:int,
				   wordImageWidth:int, wordImageHeight:int, fieldWidth:int,
				   fieldHeight:int): Vector.<PlaceInfo> {
		throw new NotImplementedError();
	}
	
	public function fail(returnedObj:Object):void {
		throw new NotImplementedError();
	}
	
	public function success(returnedObj:Object):void{
		throw new NotImplementedError();
	}
}

}
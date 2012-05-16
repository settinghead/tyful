/**
 * This is a generated sub-class of _WordColorer.as and is intended for behavior
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
import com.settinghead.wexpression.client.model.vo.WordVO;
import com.settinghead.wexpression.client.model.vo.template.colorer.AlwaysUseColorer;
import com.settinghead.wexpression.client.model.vo.template.colorer.TwoHuesRandomSatsColorer;

import flash.net.registerClassAlias;

public class WordColorer extends _Super_WordColorer
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
        _Super_WordColorer.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.WordColorer);
        _Super_WordColorer.model_internal::initRemoteClassAliasAllRelated();
    }
     
    model_internal static function initRemoteClassAliasSingleChild() : void
    {
        _Super_WordColorer.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.WordColorer);
    }
    
    {
        _Super_WordColorer.model_internal::initRemoteClassAliasSingle(com.settinghead.wexpression.client.model.vo.template.WordColorer);
    }
    /** 
     * END OF DO NOT MODIFY SECTION
     *
     **/   
	
	public function WordColorer(){
		super();
		registerClassAlias("com.settinghead.wexpression.data.template.colorer.AlwaysUseColorer",AlwaysUseColorer);
		registerClassAlias("com.settinghead.wexpression.data.template.colorer.TwoHuesRandomSatsColorer",TwoHuesRandomSatsColorer);	
	}
	
	public function colorFor(word:WordVO):uint{
		throw new NotImplementedError();
	}
}

}
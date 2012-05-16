/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this value object you may modify the generated sub-class of this class - RenderOptions.as.
 */

package com.settinghead.wexpression.client.model.vo.template
{
import com.adobe.fiber.services.IFiberManagingService;
import com.adobe.fiber.valueobjects.IValueObject;
import flash.events.EventDispatcher;
import mx.collections.ArrayCollection;
import mx.events.PropertyChangeEvent;

import flash.net.registerClassAlias;
import flash.net.getClassByAlias;
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.valueobjects.IPropertyIterator;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;

use namespace model_internal;

[ExcludeClass]
public class _Super_RenderOptions extends flash.events.EventDispatcher implements com.adobe.fiber.valueobjects.IValueObject
{
    model_internal static function initRemoteClassAliasSingle(cz:Class) : void
    {
        try
        {
            if (flash.net.getClassByAlias("com.settinghead.wexpression.data.template.RenderOptions") == null)
            {
                flash.net.registerClassAlias("com.settinghead.wexpression.data.template.RenderOptions", cz);
            }
        }
        catch (e:Error)
        {
            flash.net.registerClassAlias("com.settinghead.wexpression.data.template.RenderOptions", cz);
        }
    }

    model_internal static function initRemoteClassAliasAllRelated() : void
    {
    }

    model_internal var _dminternal_model : _RenderOptionsEntityMetadata;
    model_internal var _changedObjects:mx.collections.ArrayCollection = new ArrayCollection();

    public function getChangedObjects() : Array
    {
        _changedObjects.addItemAt(this,0);
        return _changedObjects.source;
    }

    public function clearChangedObjects() : void
    {
        _changedObjects.removeAll();
    }

    /**
     * properties
     */
    private var _internal_maxNumberOfWordsToDraw : int;
    private var _internal_wordPadding : int;
    private var _internal_maxAttemptsToPlaceWord : int;
    private var _internal_minShapeSize : int;

    private static var emptyArray:Array = new Array();


    /**
     * derived property cache initialization
     */
    model_internal var _cacheInitialized_isValid:Boolean = false;

    model_internal var _changeWatcherArray:Array = new Array();

    public function _Super_RenderOptions()
    {
        _model = new _RenderOptionsEntityMetadata(this);

        // Bind to own data or source properties for cache invalidation triggering

    }

    /**
     * data/source property getters
     */

    [Bindable(event="propertyChange")]
    public function get maxNumberOfWordsToDraw() : int
    {
        return _internal_maxNumberOfWordsToDraw;
    }

    [Bindable(event="propertyChange")]
    public function get wordPadding() : int
    {
        return _internal_wordPadding;
    }

    [Bindable(event="propertyChange")]
    public function get maxAttemptsToPlaceWord() : int
    {
        return _internal_maxAttemptsToPlaceWord;
    }

    [Bindable(event="propertyChange")]
    public function get minShapeSize() : int
    {
        return _internal_minShapeSize;
    }

    public function clearAssociations() : void
    {
    }

    /**
     * data/source property setters
     */

    public function set maxNumberOfWordsToDraw(value:int) : void
    {
        var oldValue:int = _internal_maxNumberOfWordsToDraw;
        if (oldValue !== value)
        {
            _internal_maxNumberOfWordsToDraw = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "maxNumberOfWordsToDraw", oldValue, _internal_maxNumberOfWordsToDraw));
        }
    }

    public function set wordPadding(value:int) : void
    {
        var oldValue:int = _internal_wordPadding;
        if (oldValue !== value)
        {
            _internal_wordPadding = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "wordPadding", oldValue, _internal_wordPadding));
        }
    }

    public function set maxAttemptsToPlaceWord(value:int) : void
    {
        var oldValue:int = _internal_maxAttemptsToPlaceWord;
        if (oldValue !== value)
        {
            _internal_maxAttemptsToPlaceWord = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "maxAttemptsToPlaceWord", oldValue, _internal_maxAttemptsToPlaceWord));
        }
    }

    public function set minShapeSize(value:int) : void
    {
        var oldValue:int = _internal_minShapeSize;
        if (oldValue !== value)
        {
            _internal_minShapeSize = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "minShapeSize", oldValue, _internal_minShapeSize));
        }
    }

    /**
     * Data/source property setter listeners
     *
     * Each data property whose value affects other properties or the validity of the entity
     * needs to invalidate all previously calculated artifacts. These include:
     *  - any derived properties or constraints that reference the given data property.
     *  - any availability guards (variant expressions) that reference the given data property.
     *  - any style validations, message tokens or guards that reference the given data property.
     *  - the validity of the property (and the containing entity) if the given data property has a length restriction.
     *  - the validity of the property (and the containing entity) if the given data property is required.
     */


    /**
     * valid related derived properties
     */
    model_internal var _isValid : Boolean;
    model_internal var _invalidConstraints:Array = new Array();
    model_internal var _validationFailureMessages:Array = new Array();

    /**
     * derived property calculators
     */

    /**
     * isValid calculator
     */
    model_internal function calculateIsValid():Boolean
    {
        var violatedConsts:Array = new Array();
        var validationFailureMessages:Array = new Array();

        var propertyValidity:Boolean = true;

        model_internal::_cacheInitialized_isValid = true;
        model_internal::invalidConstraints_der = violatedConsts;
        model_internal::validationFailureMessages_der = validationFailureMessages;
        return violatedConsts.length == 0 && propertyValidity;
    }

    /**
     * derived property setters
     */

    model_internal function set isValid_der(value:Boolean) : void
    {
        var oldValue:Boolean = model_internal::_isValid;
        if (oldValue !== value)
        {
            model_internal::_isValid = value;
            _model.model_internal::fireChangeEvent("isValid", oldValue, model_internal::_isValid);
        }
    }

    /**
     * derived property getters
     */

    [Transient]
    [Bindable(event="propertyChange")]
    public function get _model() : _RenderOptionsEntityMetadata
    {
        return model_internal::_dminternal_model;
    }

    public function set _model(value : _RenderOptionsEntityMetadata) : void
    {
        var oldValue : _RenderOptionsEntityMetadata = model_internal::_dminternal_model;
        if (oldValue !== value)
        {
            model_internal::_dminternal_model = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "_model", oldValue, model_internal::_dminternal_model));
        }
    }

    /**
     * methods
     */


    /**
     *  services
     */
    private var _managingService:com.adobe.fiber.services.IFiberManagingService;

    public function set managingService(managingService:com.adobe.fiber.services.IFiberManagingService):void
    {
        _managingService = managingService;
    }

    model_internal function set invalidConstraints_der(value:Array) : void
    {
        var oldValue:Array = model_internal::_invalidConstraints;
        // avoid firing the event when old and new value are different empty arrays
        if (oldValue !== value && (oldValue.length > 0 || value.length > 0))
        {
            model_internal::_invalidConstraints = value;
            _model.model_internal::fireChangeEvent("invalidConstraints", oldValue, model_internal::_invalidConstraints);
        }
    }

    model_internal function set validationFailureMessages_der(value:Array) : void
    {
        var oldValue:Array = model_internal::_validationFailureMessages;
        // avoid firing the event when old and new value are different empty arrays
        if (oldValue !== value && (oldValue.length > 0 || value.length > 0))
        {
            model_internal::_validationFailureMessages = value;
            _model.model_internal::fireChangeEvent("validationFailureMessages", oldValue, model_internal::_validationFailureMessages);
        }
    }


}

}

/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this value object you may modify the generated sub-class of this class - Template.as.
 */

package com.settinghead.wexpression.client.model.vo.template
{
import com.adobe.fiber.services.IFiberManagingService;
import com.adobe.fiber.valueobjects.IValueObject;
import com.settinghead.wexpression.client.model.vo.template.Layer;
import com.settinghead.wexpression.client.model.vo.template.RenderOptions;
import com.settinghead.wexpression.client.model.vo.template.WordAngler;
import com.settinghead.wexpression.client.model.vo.template.WordColorer;
import com.settinghead.wexpression.client.model.vo.template.WordFonter;
import com.settinghead.wexpression.client.model.vo.template.WordNudger;
import com.settinghead.wexpression.client.model.vo.template.WordPlacer;
import com.settinghead.wexpression.client.model.vo.template.WordSizer;
import flash.events.EventDispatcher;
import flash.utils.ByteArray;
import mx.collections.ArrayCollection;
import mx.events.PropertyChangeEvent;

import flash.net.registerClassAlias;
import flash.net.getClassByAlias;
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.valueobjects.IPropertyIterator;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;

use namespace model_internal;

[Managed]
[ExcludeClass]
public class _Super_Template extends flash.events.EventDispatcher implements com.adobe.fiber.valueobjects.IValueObject
{
    model_internal static function initRemoteClassAliasSingle(cz:Class) : void
    {
        try
        {
            if (flash.net.getClassByAlias("com.settinghead.wexpression.data.template.Template") == null)
            {
                flash.net.registerClassAlias("com.settinghead.wexpression.data.template.Template", cz);
            }
        }
        catch (e:Error)
        {
            flash.net.registerClassAlias("com.settinghead.wexpression.data.template.Template", cz);
        }
    }

    model_internal static function initRemoteClassAliasAllRelated() : void
    {
        com.settinghead.wexpression.client.model.vo.template.WordSizer.initRemoteClassAliasSingleChild();
        com.settinghead.wexpression.client.model.vo.template.WordAngler.initRemoteClassAliasSingleChild();
        com.settinghead.wexpression.client.model.vo.template.Layer.initRemoteClassAliasSingleChild();
        com.settinghead.wexpression.client.model.vo.template.WordColorer.initRemoteClassAliasSingleChild();
        com.settinghead.wexpression.client.model.vo.template.WordFonter.initRemoteClassAliasSingleChild();
        com.settinghead.wexpression.client.model.vo.template.WordNudger.initRemoteClassAliasSingleChild();
        com.settinghead.wexpression.client.model.vo.template.RenderOptions.initRemoteClassAliasSingleChild();
        com.settinghead.wexpression.client.model.vo.template.WordPlacer.initRemoteClassAliasSingleChild();
    }

    model_internal var _dminternal_model : _TemplateEntityMetadata;
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
    private var _internal_id : String;
    private var _internal_sizer : com.settinghead.wexpression.client.model.vo.template.WordSizer;
    private var _internal_previewPNG : ByteArray;
    private var _internal_angler : com.settinghead.wexpression.client.model.vo.template.WordAngler;
    private var _internal_layers : ArrayCollection;
    model_internal var _internal_layers_leaf:com.settinghead.wexpression.client.model.vo.template.Layer;
    private var _internal_path : String;
    private var _internal_renderOptions : com.settinghead.wexpression.client.model.vo.template.RenderOptions;
    private var _internal_colorer : com.settinghead.wexpression.client.model.vo.template.WordColorer;
    private var _internal_fonter : com.settinghead.wexpression.client.model.vo.template.WordFonter;
    private var _internal_placer : com.settinghead.wexpression.client.model.vo.template.WordPlacer;
    private var _internal_nudger : com.settinghead.wexpression.client.model.vo.template.WordNudger;

    private static var emptyArray:Array = new Array();


    /**
     * derived property cache initialization
     */
    model_internal var _cacheInitialized_isValid:Boolean = false;

    model_internal var _changeWatcherArray:Array = new Array();

    public function _Super_Template()
    {
        _model = new _TemplateEntityMetadata(this);

        // Bind to own data or source properties for cache invalidation triggering

    }

    /**
     * data/source property getters
     */

    [Bindable(event="propertyChange")]
    public function get id() : String
    {
        return _internal_id;
    }

    [Bindable(event="propertyChange")]
    public function get sizer() : com.settinghead.wexpression.client.model.vo.template.WordSizer
    {
        return _internal_sizer;
    }

    [Bindable(event="propertyChange")]
    public function get previewPNG() : ByteArray
    {
        return _internal_previewPNG;
    }

    [Bindable(event="propertyChange")]
    public function get angler() : com.settinghead.wexpression.client.model.vo.template.WordAngler
    {
        return _internal_angler;
    }

    [Bindable(event="propertyChange")]
    public function get layers() : ArrayCollection
    {
        return _internal_layers;
    }

    [Bindable(event="propertyChange")]
    public function get path() : String
    {
        return _internal_path;
    }

    [Bindable(event="propertyChange")]
    public function get renderOptions() : com.settinghead.wexpression.client.model.vo.template.RenderOptions
    {
        return _internal_renderOptions;
    }

    [Bindable(event="propertyChange")]
    public function get colorer() : com.settinghead.wexpression.client.model.vo.template.WordColorer
    {
        return _internal_colorer;
    }

    [Bindable(event="propertyChange")]
    public function get fonter() : com.settinghead.wexpression.client.model.vo.template.WordFonter
    {
        return _internal_fonter;
    }

    [Bindable(event="propertyChange")]
    public function get placer() : com.settinghead.wexpression.client.model.vo.template.WordPlacer
    {
        return _internal_placer;
    }

    [Bindable(event="propertyChange")]
    public function get nudger() : com.settinghead.wexpression.client.model.vo.template.WordNudger
    {
        return _internal_nudger;
    }

    public function clearAssociations() : void
    {
    }

    /**
     * data/source property setters
     */

    public function set id(value:String) : void
    {
        var oldValue:String = _internal_id;
        if (oldValue !== value)
        {
            _internal_id = value;
        }
    }

    public function set sizer(value:com.settinghead.wexpression.client.model.vo.template.WordSizer) : void
    {
        var oldValue:com.settinghead.wexpression.client.model.vo.template.WordSizer = _internal_sizer;
        if (oldValue !== value)
        {
            _internal_sizer = value;
        }
    }

    public function set previewPNG(value:ByteArray) : void
    {
        var oldValue:ByteArray = _internal_previewPNG;
        if (oldValue !== value)
        {
            _internal_previewPNG = value;
        }
    }

    public function set angler(value:com.settinghead.wexpression.client.model.vo.template.WordAngler) : void
    {
        var oldValue:com.settinghead.wexpression.client.model.vo.template.WordAngler = _internal_angler;
        if (oldValue !== value)
        {
            _internal_angler = value;
        }
    }

    public function set layers(value:*) : void
    {
        var oldValue:ArrayCollection = _internal_layers;
        if (oldValue !== value)
        {
            if (value is ArrayCollection)
            {
                _internal_layers = value;
            }
            else if (value is Array)
            {
                _internal_layers = new ArrayCollection(value);
            }
            else if (value == null)
            {
                _internal_layers = null;
            }
            else
            {
                throw new Error("value of layers must be a collection");
            }
        }
    }

    public function set path(value:String) : void
    {
        var oldValue:String = _internal_path;
        if (oldValue !== value)
        {
            _internal_path = value;
        }
    }

    public function set renderOptions(value:com.settinghead.wexpression.client.model.vo.template.RenderOptions) : void
    {
        var oldValue:com.settinghead.wexpression.client.model.vo.template.RenderOptions = _internal_renderOptions;
        if (oldValue !== value)
        {
            _internal_renderOptions = value;
        }
    }

    public function set colorer(value:com.settinghead.wexpression.client.model.vo.template.WordColorer) : void
    {
        var oldValue:com.settinghead.wexpression.client.model.vo.template.WordColorer = _internal_colorer;
        if (oldValue !== value)
        {
            _internal_colorer = value;
        }
    }

    public function set fonter(value:com.settinghead.wexpression.client.model.vo.template.WordFonter) : void
    {
        var oldValue:com.settinghead.wexpression.client.model.vo.template.WordFonter = _internal_fonter;
        if (oldValue !== value)
        {
            _internal_fonter = value;
        }
    }

    public function set placer(value:com.settinghead.wexpression.client.model.vo.template.WordPlacer) : void
    {
        var oldValue:com.settinghead.wexpression.client.model.vo.template.WordPlacer = _internal_placer;
        if (oldValue !== value)
        {
            _internal_placer = value;
        }
    }

    public function set nudger(value:com.settinghead.wexpression.client.model.vo.template.WordNudger) : void
    {
        var oldValue:com.settinghead.wexpression.client.model.vo.template.WordNudger = _internal_nudger;
        if (oldValue !== value)
        {
            _internal_nudger = value;
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
    public function get _model() : _TemplateEntityMetadata
    {
        return model_internal::_dminternal_model;
    }

    public function set _model(value : _TemplateEntityMetadata) : void
    {
        var oldValue : _TemplateEntityMetadata = model_internal::_dminternal_model;
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

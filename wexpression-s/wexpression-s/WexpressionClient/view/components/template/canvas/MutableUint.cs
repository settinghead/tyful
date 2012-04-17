// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:00 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------
using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
using PureMVC.Interfaces;
using PureMVC.Patterns;
namespace Com.Settinghead.Wexpression.Client.View.Components.Template.Canvas
{
    public class MutableUint : Proxy, IEventDispatcher
    {
        protected internal EventDispatcher eventDispatcher;

        public MutableUint(uint v = 0)
        {
            this._value = v;
            eventDispatcher = new EventDispatcher(this);
        }

        private uint _value;

        //[Bindable(event="UintChanged")]
        public uint v
        {
            get
            {
                return _value;
            }
            set
            {
                this._value = value;
                dispatchEvent(new Event("UintChanged"));
            }
        }

        public MutableUint Clone()
        {
            return new MutableU(v);
        }

        public bool HasEventListener(String type)
        {
            return eventDispatcher.HasEventListener(type);
        }

        public bool WillTrigger(String type)
        {
            return eventDispatcher.WillTrigger(type);
        }

        public void addEventListener(String type, Function listener, bool useCapture = false, int priority = 0.0, boolean useWeakReference = false)
        {
            eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        public void removeEventListener(String type, Function listener, bool useCapture = false)
        {
            eventDispatcher.removeEventListener(type, listener, useCapture);
        }

        public bool dispatchEvent(Event evt0)
        {
            return eventDispatcher.DispatchEvent(evt0);
        }
    }

}
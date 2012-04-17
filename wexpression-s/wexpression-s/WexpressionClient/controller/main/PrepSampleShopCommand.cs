// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:00 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------

using Com.Settinghead.Wexpression.Client.Model;
using Com.Settinghead.Wexpression.Client.Model.Vo;
using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
using PureMVC.Interfaces;
using PureMVC.Patterns;
namespace Com.Settinghead.Wexpression.Client.Controller.Main
{
    public class PrepSampleShopCommand : SimpleCommand
    {
        private ShopProxy shopProxy;

        public PrepSampleShopCommand()
            : base()
        {
        }

        public void execute(INotification note)
        {
            this.shopProxy = Facade.retrieveProxy(ShopProxy.NAME) as ShopProxy;
            ShopItemVO maleTee = new ShopItemVO("http://www.zazzle.com/male");
            ShopItemVO femaleTee = new ShopItemVO("http://www.zazzle.com/female");
            //TODO
            shopProxy.addItem(maleTee);
            shopProxy.addItem(femaleTee);
        }

    }
}
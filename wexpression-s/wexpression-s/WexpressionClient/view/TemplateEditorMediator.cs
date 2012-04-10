// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:00 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------

using Com.Settinghead.Wexpression.Client;

using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
using PureMVC.Patterns;
using PureMVC.Interfaces;
using Com.Settinghead.Wexpression.Client.View.Components.Template;
using Com.Settinghead.Wexpression.Client.Model;

namespace Com.Settinghead.Wexpression.Client.View
{


    public class TemplateEditorMediator : Mediator
    {

        new public const string NAME = "TemplateEditorMediator";

        public TemplateEditorMediator(Object viewComponent)
            : base(NAME, viewComponent)
        {
            templateEditor.RenderTu += renderTu;
            templateEditor.UploadTemplate += uploadTemplate;
            templateEditor.SaveTemplate += saveTemplate;
        }



        public IList<String> listNotificationInterests()
        {
            return new List<String>(){ApplicationFacade.EDIT_TEMPLATE,
					ApplicationFacade.TEMPLATE_LOADED,
					ApplicationFacade.TEMPLATE_UPLOADED
				};
        }

        public void handleNotification(INotification notification)
        {
            switch (notification.getName())
            {
                case ApplicationFacade.TEMPLATE_LOADED:
                    templateEditor.template = notification.getBody() as TemplateVO;
                    break;
                case ApplicationFacade.TEMPLATE_UPLOADED:
                    Alert.show(notification.getBody().toString());
                    break;
            }
        }


        public String GetMediatorName()
        {
            return TemplateEditorMediator.NAME;
        }

        private TemplateEditor templateEditor
        {
            get
            {
                return (TemplateEditor)ViewComponent;
            }
        }

        private void renderTu(object sender)
        {
            TuProxy tuProxy = Facade.retrieveProxy(TuProxy.NAME) as TuProxy;
            WordListProxy wordListProxy = Facade.retrieveProxy(WordListProxy.NAME) as WordListProxy;
            tuProxy.template = templateEditor.template;
            tuProxy.wordList = wordListProxy.currentWordList;
            tuProxy.load();
            Facade.sendNotification(ApplicationFacade.RENDER_TU);


        }

        private void saveTemplate(object sender)
        {

            Facade.sendNotification(ApplicationFacade.SAVE_TEMPLATE, templateEditor.template);
        }

        private void uploadTemplate(object sender)
        {
            Facade.sendNotification(ApplicationFacade.UPLOAD_TEMPLATE, templateEditor.template);
        }

    }
}

// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:01 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------
using Com.Settinghead.Wexpression.Client.Model.Vo;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
using System.Net;
namespace Com.Settinghead.Wexpression.Client.Model
{

    public class WordListProxy : EntityProxy
    {
        new public const string NAME = "WordListProxy";
        new public const string SRNAME = "WordListSRProxy";

        private WordListVO _list = null;
        private WebClient mvc = new WebClient();
        public WordListProxy():base(NAME, null)
        {
            
        }

        public void Load()
        {
            if (this._list == null)
            {

                String wordListId = ClientGlobals.Resources["wordListId"];
                WebClient loader = new WebClient();
                loader.OpenReadCompleted += jsonLoaded;
                loader.OpenReadAsync(new Uri("wordlists/" + wordListId, UriKind.Relative));

            }
        }

        public void jsonLoaded(Object sender, OpenReadCompletedEventArgs e)
        {
            DataContractJsonSerializer json = new DataContractJsonSerializer(typeof(List<WordVO>));
            List<WordVO> l = (List<WordVO>)json.ReadObject(e.Result);
            this._list = new WordListVO(l);
        }


        public WordListVO currentWordList
        {
            get
            {
                return _list;
            }
        }

        public WordListVO SampleWordList()
        {
            WordListVO list = new WordListVO();
            for (int i = 0; i < 1000; i++)
            {
                list.Add(new WordVO("Art", (new Random()).Next() * 5 + 0.5d));
                list.Add(new WordVO("Sample", (new Random()).Next() * 5 + 0.5d));
                list.Add(new WordVO("Created by Wexpression", (new Random()).Next() * 5 + 0.5d));
                list.Add(new WordVO("typography", (new Random()).Next() * 5 + 0.5d));
            }
            return list;
        }
    }
}

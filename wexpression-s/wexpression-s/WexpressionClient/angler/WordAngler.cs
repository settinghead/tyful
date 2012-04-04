using Com.Settinghead.Wexpression.Client.Model.Vo;
using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;

namespace Com.Settinghead.Wexpression.Client.Angler
{
    public interface WordAngler
    {
        /**
         * What angle should this {@link Word} be rotated at?
         * 
         * @param word
         *            The Word that WordCram is about to draw, and wants to rotate
         * @return the rotation angle for the Word, in radians
         * @handler =translation_wexpression-j_Wed_Mar_28_02_51_05_EDT_2012/src<com.settinghead.wexpression.client.angler{WordAngler.java[WordAngler~angleFor~QEngineWordVO;
         * @signature (com.settinghead.wexpression.client.model.vo.EngineWordVO)DangleFor
         */
        double AngleFor(EngineWordVO eWord);
    }
}



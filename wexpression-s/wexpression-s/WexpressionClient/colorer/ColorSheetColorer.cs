// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:01 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------
using Com.Settinghead.Wexpression.Client.Model.Vo;
using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
namespace Com.Settinghead.Wexpression.Client.Colorer
{

    public class ColorSheetColorer : WordColorer
    {
        private WordColorer otherwise = new TwoHuesRandomSatsColorer();
        public ColorSheetColorer()
        {

        }

        public uint ColorFor(EngineWordVO eWord)
        {
            uint color =
                eWord.GetCurrentLocation().patch.layer.colorSheet.WriteableBitmap.GetPixel(
                    eWord.GetCurrentLocation().GetpVector().x, eWord.GetCurrentLocation().GetpVector().y);
            if (color > 0) return color;
            else return otherwise.ColorFor(eWord);
        }
    }

}

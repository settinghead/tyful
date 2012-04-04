// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:01 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------
using Com.Settinghead.Wexpression.Client.Model.Vo;
using De.Polygonal.Utils;
using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
namespace Com.Settinghead.Wexpression.Client.Colorer
{

    public class TwoHuesRandomSatsColorer : WordColorer
    {
        private Array hues;
        private PM_PRNG prng = new PM_PRNG();
        public TwoHuesRandomSatsColorer()
        {
            hues = new Array((new Random()).Next() * 256, (new Random()).Next() * 256);

        }

        public uint colorFor(EngineWordVO eWord)
        {
            double hue = hues[prng.NextIntRange(0, hues.length - 1)];
            //			double sat= Math.random()*256;
            double sat = prng.NextIntRange(150, 256);
            double val = prng.NextIntRange(50, 256);


            return Org.Peaceoutside.Utils.ColorMath.HSLToRGB(hue / 256, sat / 256, val / 256);
        }
    }
}

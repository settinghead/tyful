// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:01 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------
using Com.Settinghead.Wexpression.Client.Model.Vo;
using Com.Settinghead.Wexpression.Client.Model.Vo.Template;
using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
namespace Com.Settinghead.Wexpression.Client.Angler
{

    public class ShapeConfinedAngler : WordAngler
    {
        private WordLayer layer;
        private WordAngler otherwise;

        public ShapeConfinedAngler(WordLayer layer_0, WordAngler otherwise_1)
        {
            this.layer = layer_0;
            this.otherwise = otherwise_1;
        }

        public virtual double AngleFor(EngineWordVO eWord)
        {
            if (eWord.GetCurrentLocation() == null)
                return otherwise.AngleFor(eWord);
            // float angle = (img.getHue(
            // (int) eWord.getCurrentLocation().getpVector().x, (int) eWord
            // .getCurrentLocation().getpVector().y) + BBPolarTree.PI)
            // % BBPolarTree.TWO_PI;
            double angle = (layer.GetHue(
                    ((int)eWord.GetCurrentLocation().GetpVector().x), ((int)eWord
                            .GetCurrentLocation().GetpVector().y)) * BBPolarTreeVO.TWO_PI);
            if (Double.IsNaN(angle) || angle == 0)
                return otherwise.AngleFor(eWord);
            else
                return angle;
        }
    }

}

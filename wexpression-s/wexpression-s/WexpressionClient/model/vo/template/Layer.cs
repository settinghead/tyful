// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:01 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------
using Com.Settinghead.Wexpression.Client;
using Com.Settinghead.Wexpression.Client.Model.Vo;
using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
using System.Windows.Media.Imaging;

namespace Com.Settinghead.Wexpression.Client.Model.Vo.Template
{
    [Bindable]
    public abstract class Layer : IImageShape, IZippable
    {
        protected internal TemplateVO _template;
        protected internal WriteableBitmap _thumbnail;
        private String _name;
        public Layer above;
        public Layer below;

        public string Name
        {
            get { return _name; }
            set { this._name = value; }
        }

        public Layer(String n, TemplateVO template)
        {
            this.Name = n;
            this._template = template;
            if (this._template.layers.length > 0)
            {
                connect(this, this._template.layers[this._template.layers.length - 1] as Layer);

            }
            this._template.layers.addItem(this);
        }

        public abstract double Width
        {
            get;
        }

        public abstract double Height
        {
            get;
        }

        public override String ToString()
        {
            return name;
        }

        public virtual bool Contains(double x, double y, double width, double height, double rotation, bool transformed)
        {
            throw new Exception("Not implemented.");
        }

        public virtual bool ContainsPoint(double x, double y, bool transformed)
        {
            throw new Exception("Not implemented.");
        }

        public bool containsAllPolarPoints(double centerX, double centerY, Array points, double rotation)
        {
            for (int i = 0; i < points.length; i++)
            {
                double theta = (points[i] as Array)[0];
                double d = (points[i] as Array)[1];
                theta -= rotation;
                double x = centerX +Math.Cos(theta) * d;
                double y = centerY +Math.Sin(theta) * d;
                if (!containsPo((int)x, y, false)) return false;
            }
            return true;
        }

        public virtual bool Intersects(double x, double y, double width, double height, bool transformed)
        {
            throw new Exception("Not implemented.");
        }

        public bool AboveContains(double x, double y, double width, double height, double rotation, bool transformed)
        {
            if (above != null)
            {
                if (above.Contains(x, y, width, height, rotation, transformed)) return true;
                else return above.AboveContains(x, y, width, height, rotation, transformed);
            }
            else return false;
        }

        public bool aboveContainsAllPolarPoints(double centerX, double centerY, Array points, double rotation)
        {
            if (above != null)
            {
                if (above.ContainsAllPolarPoints(centerX, centerY, points, rotation)) return true;
                else return above.AboveContainsAllPolarPoints(centerX, centerY, points, rotation);
            }
            else return false;
        }


        public static void Connect(Layer above_0, Layer below_1)
        {
            above_0.below = below_1;
            below_1.above = above_0;
        }

        public virtual void WriteNonJSONPropertiesToZip(IZipOutput output)
        {
            throw new Exception("Not implemented.");
        }

        public virtual void ReadNonJSONPropertiesFromZip(IZipInput input)
        {
            throw new Exception("Not implemented.");
        }

        public virtual void SaveProperties(Object dict)
        {
            throw new Exception("Not implemented.");
        }

        public abstract bool ContainsPoint(int x, int y, bool transformed);
        public abstract bool Contains(int x, int y, int width, int height, double rotation, bool transformed);

    }

}

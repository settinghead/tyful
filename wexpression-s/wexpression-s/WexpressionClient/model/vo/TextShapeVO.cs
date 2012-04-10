//
// (BSD License) 100% Open Source see http://en.wikipedia.org/wiki/BSD_licenses
//
// Copyright (c) 2009, Martin Heidegger
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of the Martin Heidegger nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:01 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------
using Com.Settinghead.Wexpression.Client;
using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
using System.Windows.Media.Imaging;
using System.Windows.Controls;
using System.Windows;
using System.Windows.Media;
namespace Com.Settinghead.Wexpression.Client.Model.Vo
{
    public class TextShapeVO : IImageShape
    {
        //[internal Embed(source="Vera.ttf", fontFamily="vera", mimeType="application/x-font",
        //embedAsCFF="false", advancedAntiAliasing="true")]
        //public const Class Vera;

        //[Embed(source="pokoljaro-kRB.ttf", fontFamily="pokoljaro", mimeType='application/x-font',
        //embedAsCFF='false', advancedAntiAliasing="true")]
        //public static const Pokoljaro: Class;

        private WriteableBitmap _bmp;
        private TextBlock _textField;
        private double _size;
        private double _centerX, _centerY, _rotation = 0;

        public TextShapeVO(bool embeddedFont, String text, double safetyBorder, double size, double rotation = 0, String fontName = "pokoljaro")
        {
            this._size = size;

            _textField = CreateTextField(fontName, text, size);


            _bmp = new WriteableBitmap((int)(_textField.ActualWidth + safetyBorder * 2), (int)(_textField.ActualHeight + safetyBorder * 2));
            _bmp.Render(_textField, null);
        }

        private TextBlock CreateTextField(String fontName, String text, double size)
        {

            TextBlock textField = new TextBlock();
            textField.Text = text;
            textField.FontFamily = FontFamily(fontName);
            textField.FontSize = _size;
            textField.TextAlignment = TextAlignment.Center;
            if (text.length > 11)
            { //TODO: this is a temporary fix
                double w = textField.width;
                textField.TextWrapping = TextWrapping.Wrap;
                textField.width = w / (text.length / 11) * 1.1;
            }
            return textField;
        }

        public virtual bool Contains(int x, int y, int width, int height, double rotation, bool transformed)
        {
            if (rotation != 0) throw new Exception("Not implemented.");
            for (int i = 0; i < width; i++)
                for (int j = 0; j < height; j++)
                {
                    if (!ContainsPoint(x + i, y + j, transformed)) return false;
                }
            return true;
        }

        public virtual bool ContainsPoint(int x, int y, bool transformed)
        {
            //			if(transformed)
            //				return _textField.hitTestPo((int)x,y,true);
            //			else{
            //				return _bmp.hitTestPo((int)x,y,true);
            //			}
            return _bmp.Pixels[_bmp.PixelWidth * x + y] != 0;
        }

        public void SetCenterLocation(double centerX, double centerY)
        {
            this._centerX = centerX;
            this._centerY = centerY;
        }

        public double Width
        {
            get
            {
                return _textField.ActualWidth;
            }
        }
        public double Height
        {
            get
            {
                return _textField.ActualHeight;
            }
        }
        public double Rotation
        {
            get
            {
                return _rotation;
            }
        }
        public double CenterX
        {
            get
            {
                return _centerX;
            }
        }
        public double CenterY
        {
            get
            {
                return _centerY;
            }
        }

        public TextBlock TextField
        {
            get
            {
                return _textField;
            }
        }

        public void Rotate(double rotation)
        {

            this._rotation = rotation;
        }
    }
}

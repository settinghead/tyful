// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:01 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------
using Com.Settinghead.Wexpression.Client.Angler;
using Com.Settinghead.Wexpression.Client.Fonter;
using Com.Settinghead.Wexpression.Client.Model.Vo;
using Com.Settinghead.Wexpression.Client.Nudger;
using Com.Settinghead.Wexpression.Client.Colorer;
using Com.Settinghead.Wexpression.Client.Placer;
using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Windows.Media.Imaging;
using System.Runtime.CompilerServices;

namespace Com.Settinghead.Wexpression.Client.Model.Vo.Template
{
    public delegate void LayerLoadedFromPNGHandler(object sender);
    public class WordLayer : Layer, IImageShape, IZippable
    {
        public event LayerLoadedFromPNGHandler LayerLoadedFromPNG;

        public WordLayer(String name, TemplateVO template)
            : base(name, template)
        {

        }

        private WriteableBitmap _img;
        private WriteableBitmap _colorSheet;
        private BBPolarRootTreeVO _tree;
        public static double SAMPLE_DISTANCE = 100;
        private static double MISS_PERCENTAGE_THRESHOLD = 0.1;
        private String _path;
        private WordColorer _colorer;
        private WordNudger _nudger;
        private WordAngler _angler;
        //		private Array hsbArray;
        // Applet applet = new Applet();
        // Frame frame = new Frame("Roseindia.net");

        private WordFonter _fonter = null;
        public WordFonter fonter
        {
            get
            {
                if (this._fonter == null)
                {
                    return this._template.fonter;
                }
                else return this._fonter;
            }
        }

        private WordPlacer _placer;
        public WordColorer colorer
        {
            get
            {
                if (this._colorer == null)
                {
                    return this._template.colorer;
                }
                else return this._colorer;
            }
        }


        public WriteableBitmap thumbnail
        {
            get
            {
                if (this._thumbnail == null && this.img != null)
                    this._thumbnail = createThumbnail(this.img.WriteableBitmap);
                return this._thumbnail;
            }
        }

        private static WriteableBitmap createThumbnail(WriteableBitmap bmp)
        {
            return resizeImage(bmp, 100, 100);
        }

        private const double IDEAL_RESIZE_PERCENT = .5;
        public static WriteableBitmap resizeImage(WriteableBitmap source, uint width, uint height, bool constrainProportions = true)
        {
            double scaleX = width / source.width;
            double scaleY = height / source.height;
            if (constrainProportions)
            {
                if (scaleX > scaleY) scaleX = scaleY;
                else scaleY = scaleX;
            }

            WriteableBitmap WriteableBitmap = source;

            if (scaleX >= 1 && scaleY >= 1)
            {
                WriteableBitmap bmp = new WriteableBitmap(Math.Ceiling(source.width * scaleX), Math.Ceiling(source.height * scaleY), true, 0);
                bmp.Render(source, new Matrix(scaleX, 0, 0, scaleY), null, null, null, true);
                return bmp;
            }

            // scale it by the IDEAL for best quality
            double nextScaleX = scaleX;
            double nextScaleY = scaleY;
            while (nextScaleX < 1) nextScaleX /= IDEAL_RESIZE_PERCENT;
            while (nextScaleY < 1) nextScaleY /= IDEAL_RESIZE_PERCENT;

            if (scaleX < IDEAL_RESIZE_PERCENT) nextScaleX *= IDEAL_RESIZE_PERCENT;
            if (scaleY < IDEAL_RESIZE_PERCENT) nextScaleY *= IDEAL_RESIZE_PERCENT;

            WriteableBitmap temp = new WriteableBitmap(WriteableBitmap.width * nextScaleX, WriteableBitmap.height * nextScaleY, true, 0);
            temp.draw(WriteableBitmap, new Matrix(nextScaleX, 0, 0, nextScaleY), null, null, null, true);
            WriteableBitmap = temp;

            nextScaleX *= IDEAL_RESIZE_PERCENT;
            nextScaleY *= IDEAL_RESIZE_PERCENT;

            while (nextScaleX >= scaleX || nextScaleY >= scaleY)
            {
                double actualScaleX = nextScaleX >= scaleX ? IDEAL_RESIZE_PERCENT : 1;
                double actualScaleY = nextScaleY >= scaleY ? IDEAL_RESIZE_PERCENT : 1;
                temp = new WriteableBitmap(WriteableBitmap.width * actualScaleX, WriteableBitmap.height * actualScaleY, true, 0);
                temp.draw(WriteableBitmap, new Matrix(actualScaleX, 0, 0, actualScaleY), null, null, null, true);
                WriteableBitmap.dispose();
                nextScaleX *= IDEAL_RESIZE_PERCENT;
                nextScaleY *= IDEAL_RESIZE_PERCENT;
                WriteableBitmap = temp;
            }

            return WriteableBitmap;
        }




        public int GetHSB(int x, int y)
        {
            //			if(this.hsbArray[x]==null)
            //				this.hsbArray[x] = new Array(this._img.height);
            //			if(this.hsbArray[x][y]==null){
            //				uint rgbPixel = _img.WriteableBitmap.getPixel32( x, y );
            //				uint alpha = rgbPixel>> 24 & 0xFF;
            //				if(alpha == 0) {
            //					hsbArray[x][y]  = NaN;
            //					return NaN;
            //				}
            //				else {
            //					int colour =  ColorMath.RGBtoHSB(rgbPixel);
            //					hsbArray[x][y] = colour;
            //					return colour;
            //				}
            //			}
            //			return this.hsbArray[x][y];

            uint rgbPixel = _img.WriteableBitmap.getPixel32(x, y);
            uint alpha = rgbPixel >> 24 & 0xFF;
            if (alpha == 0)
            {
                return NaN;
            }
            else
            {
                int colour = ColorMath.RGBtoHSB(rgbPixel);
                return colour;
            }
        }

        public double GetBrightness(int x, int y)
        {
            int colour = getHSB(x, y);
            double b = (colour & 0xFF);
            b /= 255;
            return b;
        }

        public double GetHue(int x, int y)
        {
            int colour = getHSB(x, y);
            //			Assert.isTrue(!Double.IsNaN(colour.hue));
            double h = ((colour & 0x00FF0000) >> 16);
            h /= 255;
            return h;
        }

        public override double Height
        {
            get
            {
                return img.height;
            }
        }

        public override double Width
        {
            get
            {
                return img.width;
            }
        }


        public override bool Contains(int x, int y, int width, int height, double rotation, bool transformed)
        {
            if (_tree == null)
            {
                // sampling approach
                int numSamples = ((int)(width * height / SAMPLE_DISTANCE));
                //				var numSamples = 10;
                // TODO: devise better lower bound
                if (numSamples < 20)
                    numSamples = 20;
                int threshold = 1;
                int darkCount = 0;
                int i = 0;
                while (i < numSamples)
                {
                    int relativeX = ((int)(Math.random() * width));
                    int relativeY = ((int)(Math.random() * height));

                    //rotation
                    rotation = -rotation;

                    if (rotation != 0)
                    {

                        //					Alert.show(rotation.toString());
                        if (relativeX == 0) relativeX = 0.001d;
                        relativeX = (relativeX - width / 2);
                        relativeY = (relativeY - height / 2);

                        double r = Math.sqrt(Math.pow(relativeX, 2) + Math.pow(relativeY, 2));
                        double theta = Math.atan2(relativeY, relativeX);
                        theta += rotation;

                        relativeX = r * Math.Cos(theta);
                        relativeY = r * Math.Sin(theta);

                        //					relativeX = (relativeX *Math.Cos(rotation))
                        //						- (relativeY *Math.Sin(rotation));
                        //					relativeY =Math.Sin(rotation) * relativeX
                        //						+Math.Cos(rotation ) * relativeY;

                        relativeX = (relativeX + width / 2);
                        relativeY = (relativeY + height / 2);
                    }
                    int sampleX = relativeX + x;
                    int sampleY = relativeY + y;

                    double brightness = getBrightness(sampleX, sampleY);
                    if ((Double.IsNaN(brightness) || brightness < 0.01d) && ++darkCount >= threshold)
                        //											if ((!containsPo((int)sampleX, sampleY, false)) && ++darkCount >= threshold)
                        return false;
                    i++;
                }

                return true;

            }
            else
            {
                return _tree.overlapsCoord(x, y, x + width, y + height);
            }
        }


        public override bool ContainsPoint(int x, int y, bool transform)
        {
            //			if(x<0 || y<0 || x>width || y>height) return true;
            return Img.hitTestPoint(x, y, true);
        }

        public override bool Intersects(double x, double y, double width, double height, bool transformed)
        {
            if (_tree == null)
            {
                int threshold = 10;
                int darkCount = 0;
                int brightCount = 0;

                int numSamples = ((int)(width * height / SAMPLE_DISTANCE));
                // TODO: devise better lower bound
                if (numSamples < 10)
                    numSamples = 10;

                int i = 0;
                while (i < numSamples)
                {
                    int relativeX = ((int)(Math.random() * width));
                    int relativeY = ((int)(Math.random() * height));
                    int sampleX = ((int)(relativeX + x));
                    int sampleY = ((int)(relativeY + y));
                    if (Double.IsNaN(getBrightness(((int)(sampleX)), ((int)(sampleY)))))
                        //					if(!containsPo((int)sampleX, sampleY, false))
                        darkCount++;
                    else
                        brightCount++;
                    if (darkCount >= threshold && brightCount >= threshold)
                        return true;
                    i++;
                }

                return false;

            }
            else
            {
                return _tree.overlapsCoord(x, y, x + width, y + height);
            }
        }

        public void Translate(double tx, double ty)
        {
            Matrix mtx = img.transform.matrix;
            mtx.translate(tx, ty);
            img.transform.matrix = mtx;
        }

        public BitmapImage Img
        {
            get
            {
                if (this._img == null)
                {
                    if (path != null)
                        this.loadLayerFromPNG();
                    else
                    {
                        this._img = new WriteableBitmap(this._template.width, this._template.height, true, 0);
                    }
                }
                return _img;
            }
            set
            {
                this._img = value;

            }
        }

        public WriteableBitmap ColorSheet
        {
            set
            {
                this._colorSheet = bmp;
            }
            get
            {
                if (this._colorSheet == null)
                {
                    this._colorSheet = new WriteableBitmap(this._template.width, this._template.height);
                }
                return _colorSheet;
            }
        }

        public string Path
        {
            get
            {
                return this._path;
            }
            set
            {
                this._path = value;
            }
        }


        public WordNudger Nudger
        {
            get
            {
                if (this._nudger == null)
                {
                    return _template.nudger;
                }
                else return this._nudger;
            }
        }

        public WordAngler Angler
        {
            get
            {
                if (this._angler == null)
                {
                    this._angler = new ShapeConfinedAngler(this, new MostlyHorizAngler());
                }
                return this._angler;
            }
        }


        public void loadLayerFromPNG()
        {
            Loader my_loader = new Loader();

            my_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
            if (callback != null)
                my_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, callback);

            my_loader.load(new URLRequest(this._path));
        }

        private void onLoadComplete(Object sender, EventArgs e)
        {
            this._img = new Bitmap(evt0.target.content.WriteableBitmap);
            //			this.hsbArray = new Array(this._img.width);
            this._template.onLoadComplete(evt0);
        }

        public override void WriteNonJSONPropertiesToZip(IZipOutput output)
        {
            output.process(this._fonter, "fonter");
            output.process(this._colorer, "colorer");
            output.putWriteableBitmapToPNGFile("direction.png", this._img);
            output.putWriteableBitmapToPNGFile("color.png", this._colorSheet);
            //			output.process(this._nudger, "nudger");
            //			output.process(this._angler, "angler");
            //			output.process(this._placer, "placer");
        }

        public override void ReadNonJSONPropertiesFromZip(IZipInput input)
        {
            //TODO
        }

        public override void SaveProperties(Object dict)
        {
        }

    }
}

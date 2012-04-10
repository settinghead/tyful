using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Com.Settinghead.Wexpression.Client;
using Com.Settinghead.Wexpression.Client.Density;
using Com.Settinghead.Wexpression.Client.Model.Vo;
using System.Windows.Media.Imaging;

namespace Com.Settinghead.Wexpression.Client.View.Components
{
    public partial class TuRenderer : UserControl
    {
        public const string CREAT_NEXT_DISPLAYWORD = "createNextDisplayWord";
        public const string EDIT_TEMPLATE = "editTemplate";
        public const string TU_GENERATED = "tuGenerated";

        //	[Bindable] 
        private double _driftDistanceSum = 0;
        //	[Bindable] 
        public bool autoPostToFacebook = false;
        private TuVO _tu;

        public TuRenderer()
        {
            InitializeComponent();
        }


        public void slapWord(DisplayWordVO dWord)
        {
            this.wordLayer.addChild(dWord);
            this._tu.dWords.addItem(dWord);
            //				patchLayer.graphics.clear();
            foreach (PlaceInfo pi in dWord.engineWord.desiredLocations)
                this.highlightPatch(pi.patch);
            dWord.addEventListener(MouseEvent.ROLL_OVER, wordMouseOver);
            dWord.addEventListener(MouseEvent.ROLL_OUT, wordMouseOut);
            this._driftDistanceSum += dWord.engineWord.offsetDistance;

            //								patchLayer.patchQueue = patchLayer.patchQueue;

        }


        protected void btnEditTemplate_clickHandler(object sender, MouseEventArgs e)
        {
            dispatchEvent(new Event(EDIT_TEMPLATE));
        }


        protected void btnSaveAsPng_clickHandler(object sender, MouseEventArgs e)
        {
            generateImage();
            PNGEncoder encoder = new PNGEncoder();
            byte[] bild = encoder.encode(_tu.generatedImage);
            FileReference file = new FileReference();
            file.save(bild, "tu.png");
        }

        protected void btnForceFinish_clickHandler(object sender, MouseEventArgs e)
        {
            generateImage();
        }


        public void wordMouseOver(object sender, MouseEventArgs e)
        {
            DisplayWordVO dWord = (DisplayWordVO)e.target;
            //				patchLayer.graphics.clear();
            foreach (PlaceInfo pi in dWord.engineWord.desiredLocations)
                this.highlightPatch(pi.patch);
            dWord.visible = false;
            drawTree(dWord.engineWord.bbTree);
            drawSamplePoints(dWord.engineWord);
        }

        private void drawSamplePoints(EngineWordVO ew)
        {
            //				treeLayer.graphics.clear();
            treeLayer.graphics.beginFill(0xcccccc, 1.0);
            for (int i = 0; i < ew.samplePoints.length; i++)
            {
                double theta = (ew.samplePoints[i] as Array)[0];
                double d = (ew.samplePoints[i] as Array)[1];
                theta -= ew.bbTree.getRotation();
                double x = ew.bbTree.getRootX() +Math.Cos(theta) * d;
                double y = ew.bbTree.getRootY() +Math.Sin(theta) * d;

                treeLayer.graphics.drawCircle(x, y, 2);
            }
            treeLayer.graphics.endFill();
        }

        public void wordMouseOut(object sender, MouseEventArgs e)
        {
            DisplayWordVO dWord = (DisplayWordVO)e.target;
            dWord.visible = true;
        }

        public void highlightPatch(Patch patch)
        {
            //				patchLayer.graphics.beginFill(0xCCCCCC,0.5);
            //				patchLayer.graphics.drawRect(patch.getX(), patch.getY(), patch.getWidth(), patch.getHeight());
            //				patchLayer.graphics.endFill();
        }

        private void drawTree(BBPolarTreeVO tree)
        {
            treeLayer.graphics.clear();
            treeLayer.graphics.lineStyle(1, 0x111111, 1.0);
            drawLeaves(tree);
        }

        private void drawLeaves(BBPolarTreeVO tree)
        {
            if (tree.isLeaf() || tree.getKidsNoGrowth() == null || tree.getKidsNoGrowth().length == 0)
            {
                drawBounds(tree);
            }
            else
            {
                for (int i = 0; i < tree.getKidsNoGrowth().length; i++)
                {
                    drawLeaves(tree.getKidsNoGrowth()[i]);
                }
            }
        }

        private void drawBounds(BBPolarTreeVO tree)
        {
            int x1, x2, x3, x4, y1, y2, y3, y4;
            x1 = ((int)(tree.getRootX() + tree.d1 *Math.Cos(tree.getR1(true))));
            y1 = ((int)(tree.getRootY() - tree.d1 *Math.Sin(tree.getR1(true))));
            x2 = ((int)(tree.getRootX() + tree.d1 *Math.Cos(tree.getR2(true))));
            y2 = ((int)(tree.getRootY() - tree.d1 *Math.Sin(tree.getR2(true))));
            x3 = ((int)(tree.getRootX() + tree.d2 *Math.Cos(tree.getR1(true))));
            y3 = ((int)(tree.getRootY() - tree.d2 *Math.Sin(tree.getR1(true))));
            x4 = ((int)(tree.getRootX() + tree.d2 *Math.Cos(tree.getR2(true))));
            y4 = ((int)(tree.getRootY() - tree.d2 *Math.Sin(tree.getR2(true))));

            double r = tree.getR2(true) - tree.getR1(true);
            if (r < 0)
                r = BBPolarTreeVO.TWO_PI + r;
            Assert.isTrue(r < BBPolarTreeVO.PI);

            drawArc(tree.getRootX(),
                tree.getRootY(), tree.d2,
                tree.getR1(true), tree.getR2(true), 1);
            drawArc(tree.getRootX(),
                tree.getRootY(), tree.d1,
                tree.getR1(true), tree.getR2(true), 1);
            treeLayer.graphics.moveTo(x1, y1);
            treeLayer.graphics.lineTo(x3, y3);
            treeLayer.graphics.moveTo(x2, y2);
            treeLayer.graphics.lineTo(x4, y4);
        }

        private void drawArc(double center_x, double center_y, double radius, double angle_from, double angle_to, double precision)
        {
            double angle_diff = angle_to - angle_from;
            double steps = Math.round(angle_diff * precision);
            if (steps == 0) steps = 1;
            double angle = angle_from;
            double px = center_x + radius *Math.Cos(angle);
            double py = center_y - radius *Math.Sin(angle);
            treeLayer.graphics.moveTo(px, py);
            for (int i = 1; i <= steps; i++)
            {
                angle = angle_from + angle_diff / steps * i;
                treeLayer.graphics.lineTo(center_x + radius *Math.Cos(angle), center_y - radius *Math.Sin(angle));
            }
        }

        protected void onEnterFrameHandler(Object sender, EventArgs e)
        {
            if (this.visible)
            {
                if (newTu && this.tu != null)
                {
                    prepareForTu();
                }
                if (_tu != null)
                {
                    if (!_tu.finishedDisplayWordRendering)
                    {
                        dispatchEvent(new Event(CREAT_NEXT_DISPLAYWORD));
                    }
                    else
                    {
                        if (_tu.generatedImage == null)
                        {
                            generateImage();
                        }
                    }
                }
            }
        }

        public void generateImage()
        {
            WriteableBitmap bmpData = new WriteableBitmap(mainCanvas.width, mainCanvas.height, true);
            //						Bitmap bmp = new Bitmap(bmpData,"auto",true);
            bmpData.draw(mainCanvas);
            _tu.generatedImage = bmpData;
            tu.finishedDisplayWordRendering = true;
            dispatchEvent(new Event(TU_GENERATED));
        }
        //[Bindable]
        public TuVO tu
        {
            get
            {
                return _tu;
            }
            set
            {
                this._tu = _tu;
                newTu = true;
            }
        }

        private bool newTu = false;

        private void prepareForTu()
        {
            this.wordLayer.Children.Clear();
            //				this.width = _tu.width;
            //				this.height = _tu.height;
            this.MainCanvas.Width = _tu.width;
            this.MainCanvas.Height = _tu.height;
            foreach (DisplayWordVO displayWord in _tu.dWords)
                this.slapWord(displayWord);

            //				patchLayer.patchQueue=this._tu.template.patchIndex.map.getQueue(3);

            newTu = false;

        }


        protected void canvas1_mouseOverHandler(object sender, MouseEventArgs e)
        {
            Mouse.show();
        }

        private void LayoutRoot_Loaded(object sender, RoutedEventArgs e)
        {
            if (newTu && this.tu != null)
            {
                prepareForTu();
            }
        }
    }
}

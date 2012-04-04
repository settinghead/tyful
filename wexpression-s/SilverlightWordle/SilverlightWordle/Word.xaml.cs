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
using System.Windows.Browser;
using System.Windows.Media.Imaging;

namespace SilverlightWordle
{
    public partial class Word : UserControl
    {
        public delegate void WordHandler(object sender, EventArgs e);
        public event WordHandler loaded;

        private string _text;
        private string _searchurl;

        int x;
        int y;
        
        public int X { get { return x; } set { x = value; SetValue(Canvas.LeftProperty, (double)x); } }
        public int Y { get { return y; } set { y = value; SetValue(Canvas.TopProperty, (double)y); } }
        public WriteableBitmap wb;
        
        public Word(string searchUrl)
        {
            _searchurl = searchUrl;
            InitializeComponent();
        }

        public void Load(string Text, string TypeFace, int Size, int Angle, Color Color)
        {
            _text = Text;
            TextBlock tb = new TextBlock();
            tb.Text = _text;
            tb.FontFamily = new FontFamily(TypeFace);
            tb.FontSize = Size;
            tb.Foreground = new SolidColorBrush(Color);
            TransformGroup tg = new TransformGroup();
            TranslateTransform tt = new TranslateTransform();
            if (tb.ActualWidth > tb.ActualHeight)
            {
                tb.Width = tb.ActualWidth;
                tb.Height = tb.ActualWidth;
                tt.Y = (-tb.ActualHeight * 0.5) + (tb.Height * 0.5);
            }
            else
            {
                tb.Width = tb.ActualWidth;
                tb.Height = tb.ActualWidth;
                tt.Y = (-tb.ActualWidth * 0.5) + (tb.Width * 0.5);
            }            
            tg.Children.Add(tt);

            RotateTransform rt = new RotateTransform();
            rt.Angle = Angle;
            rt.CenterY = tb.Height * 0.5;
            rt.CenterX = tb.Width * 0.5;
            tg.Children.Add(rt);

            //Use a WriteableBitmap for collision detection of the TextBlock
            wb = new WriteableBitmap((int)tb.Width, (int)tb.Height); ;
            wb.Render(tb, tg);
            wb.Invalidate();

            img.Source = wb;

            img.Height = tb.ActualWidth;
            img.Width = tb.ActualWidth;
            imgBorder.Width = img.Width;
            imgBorder.Height = img.Height;

            this.Width = tb.Width;
            this.Height = tb.Height;

            tbTest.Text = _text;
            tbTest.FontSize = Size;
            tbTest.FontFamily = new FontFamily(TypeFace);
            tbTest.Foreground = new SolidColorBrush(Color);
            Rotate.Angle = Angle;
            tbTestBorder.Width = tbTest.ActualWidth;
            tbTestBorder.Height = tbTest.ActualHeight;

            loaded(this, null);
        }

        private void LayoutRoot_MouseEnter(object sender, MouseEventArgs e)
        {
            Scale.ScaleX = 1.5;
            Scale.ScaleY = 1.5;
        }

        private void LayoutRoot_MouseLeave(object sender, MouseEventArgs e)
        {
            Scale.ScaleX = 1;
            Scale.ScaleY = 1;
        }

        private void LayoutRoot_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            HtmlPage.Window.Navigate(new Uri(_searchurl + _text, UriKind.RelativeOrAbsolute), "wordle");
        }
    }
}

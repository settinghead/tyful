using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Animation;

namespace SilverlightWordle
{
    public partial class Page : UserControl
    {
        const int MAXWORDS = 60;
        Word[] Words = new Word[MAXWORDS];
        int Count = 0;
        Random rnd = new Random();
        DateTime start;
        Storyboard storyboard;
        Dictionary<string, int> Tags;
        Color[] Colors = new Color[5];
        string _searchUrl;
        int x_add, y_add;
        int x_start, y_start;
        int rotation;
        int font;
        AnimationWheel Loading = new AnimationWheel();
        static double APP_WIDTH = 300;  // Application Width
        static double APP_HEIGHT = 150; // Application Height

        public Page(string Url, string searchUrl)
        {
            _searchUrl = searchUrl;
            InitializeComponent();

            //http://www.colourlovers.com
            switch (rnd.Next(4))
            {
                case 0:
                    // o c t o b e r
                    Colors[0] = Color.FromArgb(255, 212, 066, 034);
                    Colors[1] = Color.FromArgb(255, 181, 045, 055);
                    Colors[2] = Color.FromArgb(255, 153, 002, 057);
                    Colors[3] = Color.FromArgb(255, 107, 041, 050);
                    Colors[4] = Color.FromArgb(255, 082, 041, 032);
                    break;
                case 1:
                    Colors[0] = Color.FromArgb(255, 026, 008, 031);
                    Colors[1] = Color.FromArgb(255, 077, 029, 077);
                    Colors[2] = Color.FromArgb(255, 005, 103, 110);
                    Colors[3] = Color.FromArgb(255, 072, 156, 121);
                    Colors[4] = Color.FromArgb(255, 235, 194, 136);
                    break;
                case 2:
                    // blue
                    Colors[0] = Color.FromArgb(255, 016, 127, 201);
                    Colors[1] = Color.FromArgb(255, 014, 078, 173);
                    Colors[2] = Color.FromArgb(255, 011, 016, 140);
                    Colors[3] = Color.FromArgb(255, 012, 015, 102);
                    Colors[4] = Color.FromArgb(255, 007, 009, 061);
                    break;
                default:
                    //Try to Remember
                    Colors[0] = Color.FromArgb(255, 163, 195, 145);
                    Colors[1] = Color.FromArgb(255, 076, 133, 121);
                    Colors[2] = Color.FromArgb(255, 022, 102, 101);
                    Colors[3] = Color.FromArgb(255, 016, 015, 014);
                    Colors[4] = Color.FromArgb(255, 066, 024, 020);
                    break;
            }
            storyboard = new Storyboard();
            storyboard.Completed += new EventHandler(storyboard_Completed);

            rotation = rnd.Next(4);
            font = rnd.Next(4);

            WebClient WC = new WebClient();
            WC.DownloadStringCompleted += new DownloadStringCompletedEventHandler(WC_DownloadStringCompleted);
            WC.DownloadStringAsync(new Uri(Url));
        }

        void LayoutRoot_Loaded(object sender, RoutedEventArgs e)
        {
            this.Width = APP_WIDTH;
            this.Height = APP_HEIGHT;
            try
            {
                LayoutRoot.Children.Add(Loading);
                Loading.SetValue(Canvas.LeftProperty, this.Width / 2);
                Loading.SetValue(Canvas.TopProperty, this.Height / 2);
            }
            catch { }
        }

        void WC_DownloadStringCompleted(object sender, DownloadStringCompletedEventArgs e)
        {
            Tags = wordcount.WordCounts(wordcount.ClearHTMLTags(e.Result), MAXWORDS);
            NewWord();
        }

        void storyboard_Completed(object sender, EventArgs e)
        {
            Words[Count].X = (int)(Words[Count].X + x_add);
            Words[Count].Y = (int)(Words[Count].Y + y_add);
            MoveWord();
        }

        void NewWord()
        {
            Words[Count] = new Word(_searchUrl);
            Words[Count].loaded += new Word.WordHandler(Word_Loaded);

            int angle;
            switch (rotation)
            {
                case 0:
                    angle = 90;
                    break;
                case 1:
                    angle = 0;
                    break;
                case 2:
                    angle = rnd.Next(0, 360);
                    break;
                default:
                    angle = rnd.Next(0, 2) == 1 ? 0 : -90;
                    break;
            }

            string fontname = "";
            switch (font)
            {
                case 0:
                    fontname = "Fonts/Fonts.zip#Jokerman";
                    break;
                case 1:
                    fontname = "Arial Black";                    
                    break;
                case 2:
                    fontname = "Georgia";
                    break;
                default:
                    fontname = "Impact";
                    break;
            }

            double size = 9 + 17 * (1.1 - Math.Log(Tags.ElementAt(0).Value + 2 - Tags.ElementAt(Count).Value, Tags.ElementAt(0).Value));
            Words[Count].Load(Tags.ElementAt(Count).Key, fontname, (int)size, angle, Colors[rnd.Next(0, 5)]);
        }

        void Word_Loaded(object sender, EventArgs e)
        {
            Words[Count].LayoutRoot.Opacity = 0.005;
            Words[Count].X = Convert.ToInt32(Width);
            Words[Count].Y = 0;
            if (Count < Tags.Count - 1)
            {
                Count++;
                NewWord();
            }
            else
            {
                Count = 0;
                Words[Count].Foreground = new SolidColorBrush(Colors[rnd.Next(0, 5)]);
                LayoutRoot.Children.Add(Words[Count]);
                x_start = Convert.ToInt32(Width / 2);
                y_start = Convert.ToInt32(Height / 2);
                Words[Count].X = rnd.Next(0, (int)(Width - Words[Count].Width));
                Words[Count].Y = rnd.Next(0, (int)(Height - Words[Count].Height));
                try
                {
                    LayoutRoot.Children.Remove(Loading);
                }
                catch { }
                start = DateTime.Now;
                storyboard.Begin();
            }
        }

        void MoveWord()
        {
            bool Collide = Collision.CheckCollision(Tags, Words, Count);
            if (!Collide)
            {
                Words[Count].sbShow.Begin();
                x_add = 0;
                y_add = 0;
                while (x_add == 0 && y_add == 0)
                {
                    x_add = rnd.Next(-5, 5);
                    y_add = rnd.Next(-5, 5);
                }
                if (Count < Tags.Count - 1)
                {
                    Count++;
                    LayoutRoot.Children.Add(Words[Count]);

                    if (Count > 0)
                    {
                        Words[Count].X = Words[Count - 1].X;
                        Words[Count].Y = Words[Count - 1].Y;
                    }
                    else
                    {
                        Words[Count].X = x_start;
                        Words[Count].Y = y_start;
                    }
                    start = DateTime.Now;
                    storyboard.Begin();
                }
            }
            else
            {
                if ((Words[Count].X + Words[Count].Width > Width - 20) || (Words[Count].X < 20) || (Words[Count].Y < 20) || (Words[Count].Y + Words[Count].Height > Height - 20))
                {
                    Words[Count].X = x_start;
                    Words[Count].Y = y_start;
                    x_add = 0;
                    y_add = 0;
                }
                while (x_add == 0 && y_add == 0)
                {
                    x_add = rnd.Next(-3, 3);
                    y_add = rnd.Next(-3, 3);
                }

                //If it takes to long to find a free spot then move to a new a random spot
                if (DateTime.Now.AddMilliseconds(-250) > start)
                {
                    Words[Count].X = rnd.Next(0, (int)(Width - Words[Count].Width));
                    Words[Count].Y = rnd.Next(0, (int)(Height - Words[Count].Height));
                    start = DateTime.Now;
                }

                storyboard.Begin();
            }
        }
    }
}
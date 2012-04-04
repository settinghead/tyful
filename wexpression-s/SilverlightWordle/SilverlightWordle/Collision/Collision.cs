using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;

namespace SilverlightWordle
{
    /// <summary>
    /// Based on the Improved HitTest Method for Silverlight 3 by Andy Beaulieu
    /// http://www.andybeaulieu.com/Home/tabid/67/EntryID/160/Default.aspx
    /// </summary>
    
    public static class Collision
    {
        public static bool CheckCollision(Dictionary<string, int> Tags, Word[] Words, int Count)
        {
            Rect rect1, rect2;
            Point ptCheck;
            FrameworkElement control1 = Words[Count];
            FrameworkElement control2;
            FrameworkElement controlElem1 = Words[Count];
            FrameworkElement controlElem2;

            for (int j = 0; j < Tags.Count; j++)
            {
                if (Count != j)
                {
                    controlElem2 = Words[j];
                    control2 = Words[j];

                    // first see if sprite rectangles collide
                    rect1 = UserControlBounds(control1);
                    rect2 = UserControlBounds(control2);

                    rect1.Intersect(rect2);
                    if (rect1 != Rect.Empty)
                    {
                        ptCheck = new Point();

                        // NOTE that creating the writeablebitmap is a bit intense
                        // so we will do this once and store results in Tag property
                        controlElem1.Tag = ((Word)control1).wb;
                        controlElem2.Tag = ((Word)control2).wb;

                        // now we do a more accurate pixel hit test
                        for (int x = Convert.ToInt32(rect1.X); x < Convert.ToInt32(rect1.X + rect1.Width); x++)
                        {
                            for (int y = Convert.ToInt32(rect1.Y); y < Convert.ToInt32(rect1.Y + rect1.Height); y++)
                            {
                                ptCheck.X = x;
                                ptCheck.Y = y;
                                if (CheckCollisionPoint(ptCheck, control1, controlElem1))
                                    if (CheckCollisionPoint(ptCheck, control2, controlElem2))
                                        return true;
                            }
                        }
                    }
                }
            }
            return false;
        }

        private static bool CheckCollisionPoint(Point pt, FrameworkElement control, FrameworkElement controlElem)
        {
            WriteableBitmap wb = controlElem.Tag as WriteableBitmap;

            int width = wb.PixelWidth;
            int height = wb.PixelHeight;

            double offSetX = Convert.ToDouble(control.GetValue(Canvas.LeftProperty));
            double offSetY = Convert.ToDouble(control.GetValue(Canvas.TopProperty));

            pt.X = pt.X - offSetX;
            pt.Y = pt.Y - offSetY;

            int offset = Convert.ToInt32((width * pt.Y) + pt.X);
            if (offset > wb.Pixels.GetUpperBound(0))
                return true;
            else
                return (wb.Pixels[offset] != 0);
        }

        private static Rect UserControlBounds(FrameworkElement control)
        {
            Point ptTopLeft = new Point(Convert.ToDouble(control.GetValue(Canvas.LeftProperty)), Convert.ToDouble(control.GetValue(Canvas.TopProperty)));
            Point ptBottomRight = new Point(Convert.ToDouble(control.GetValue(Canvas.LeftProperty)) + control.Width, Convert.ToDouble(control.GetValue(Canvas.TopProperty)) + control.Height);

            return new Rect(ptTopLeft, ptBottomRight);
        }
    }
}

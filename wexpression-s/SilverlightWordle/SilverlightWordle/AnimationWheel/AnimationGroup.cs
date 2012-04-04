//Copyright 2008 Jordan Knight
//This code is licenced under Creative Commons Licence: http://creativecommons.org/licenses/by-sa/3.0/

using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Animation;

namespace SilverlightWordle
{
    public class AnimationGroup : IEnumerable<AnimationConfig>, IDisposable
    {
        List<AnimationConfig> animations = new List<AnimationConfig>();

        public event EventHandler Complete;

        private Storyboard sb = null;

        private Timeline workingTimeline = null;

        private DependencyObject workingObject = null;

        private DependencyProperty workingProperty = null;

        private TimeSpan? workingDuration = null;

        private TimeSpan? workingKeyFrameOffset = null;

        private object workingContext = null;

        private bool serial = false;

        private Action<AnimationConfig, object> workingAction = null;

        public AnimationGroup()
        {

        }

        #region "Fluent"

        public AnimationGroup Serial()
        {
            serial = !serial;
            return this;
        }

        public AnimationGroup Target(DependencyObject animTarget)
        {
            workingObject = animTarget;
            return this;
        }

        public AnimationGroup Property(DependencyProperty animProperty)
        {
            workingProperty = animProperty;
            return this;
        }

        public AnimationGroup DoubleAnimation()
        {
            checkQueue();
            workingTimeline = new DoubleAnimation();
            return this;
        }

        public AnimationGroup DoubleAnimationK()
        {
            checkQueue();
            workingTimeline = new DoubleAnimationUsingKeyFrames();
           
            return this;
        }

        public AnimationGroup PointAnimation()
        {
            checkQueue();
            workingTimeline = new PointAnimation();
            return this;
        }

        public AnimationGroup PointAnimationK()
        {
            checkQueue();
            workingTimeline = new PointAnimationUsingKeyFrames();
            return this;
        }

        public AnimationGroup ColorAnimation()
        {
            checkQueue();
            workingTimeline = new ColorAnimation();
            return this;
        }

        public AnimationGroup ColorAnimationK()
        {
            checkQueue();
            workingTimeline = new ColorAnimationUsingKeyFrames();
            return this;
        }

        public AnimationGroup KeyFrame(double val, TimeSpan offset)
        {
            if (workingKeyFrameOffset == null)
            {
                workingKeyFrameOffset = offset;
            }
            else
            {
                workingKeyFrameOffset += offset;
            }
            (workingTimeline as DoubleAnimationUsingKeyFrames).KeyFrames.Add(new SplineDoubleKeyFrame() { KeyTime = workingKeyFrameOffset.Value, Value = val });
            return this;
        }

        public AnimationGroup KeyFrame(double val, TimeSpan offset, Point p1, Point p2)
        {
            if (workingKeyFrameOffset == null)
            {
                workingKeyFrameOffset = offset;
            }
            else
            {
                workingKeyFrameOffset += offset;
            }
            (workingTimeline as DoubleAnimationUsingKeyFrames).KeyFrames.Add(new SplineDoubleKeyFrame() { KeyTime = workingKeyFrameOffset.Value, Value = val, KeySpline=new KeySpline(){ControlPoint1= p1, ControlPoint2=p2} });
            return this;
        }

        public AnimationGroup KeyFrame(Point val, TimeSpan offset)
        {
            if (workingKeyFrameOffset == null)
            {
                workingKeyFrameOffset = offset;
            }
            else
            {
                workingKeyFrameOffset += offset;
            }
            (workingTimeline as PointAnimationUsingKeyFrames).KeyFrames.Add(new SplinePointKeyFrame() { KeyTime = workingKeyFrameOffset.Value, Value = val });
            return this;
        }

        public AnimationGroup KeyFrame(Color val, TimeSpan offset)
        {
            if (workingKeyFrameOffset == null)
            {
                workingKeyFrameOffset = offset;
            }
            else
            {
                workingKeyFrameOffset += offset;
            }
            (workingTimeline as ColorAnimationUsingKeyFrames).KeyFrames.Add(new SplineColorKeyFrame() { KeyTime = workingKeyFrameOffset.Value, Value = val });
            return this;
        }

        public AnimationGroup Context(object context)
        {
            workingContext = context;
            return this;
        }

        public AnimationGroup From(double from)
        {
            (workingTimeline as DoubleAnimation).From = from;
            return this;
        }

        public AnimationGroup From(Point from)
        {
            (workingTimeline as PointAnimation).From = from;
            return this;
        }

        public AnimationGroup From(Color from)
        {
            (workingTimeline as ColorAnimation).From = from;
            return this;
        }

        public AnimationGroup To(double to)
        {
            (workingTimeline as DoubleAnimation).To = to;
            return this;
        }

        public AnimationGroup To(Point to)
        {
            (workingTimeline as PointAnimation).To = to;
            return this;
        }

        public AnimationGroup To(Color to)
        {
            (workingTimeline as ColorAnimation).To = to;
            return this;
        }

        public AnimationGroup Duration(TimeSpan durationTime)
        {
            workingDuration = durationTime;
            return this;
        }

        public AnimationGroup Offset(TimeSpan offset)
        {
            workingTimeline.BeginTime = offset;
            return this;
        }

        public AnimationGroup CompleteAction(Action<AnimationConfig, object> action)
        {
            workingAction = action;
            return this;
        }

        public AnimationGroup Reverse()
        {
            workingTimeline.AutoReverse = !workingTimeline.AutoReverse;
            return this;
        }

        public AnimationGroup Repeat()
        {
            workingTimeline.RepeatBehavior = RepeatBehavior.Forever;
            return this;
        }

        void checkQueue()
        {
            if (workingTimeline != null)
            {
                Queue();
            }
        }

        public AnimationGroup Queue()
        {
            if (workingObject == null || workingProperty == null)
            {
                throw new InvalidOperationException("Must set Target, Property, an Animation (like DoubleAnimation)");
            }
            if (workingDuration != null)
            {
                workingTimeline.Duration = new Duration(workingDuration.Value);
            }

            Storyboard.SetTarget(workingTimeline, workingObject);
            Storyboard.SetTargetProperty(workingTimeline, new PropertyPath(workingProperty));

            AnimationConfig ac = new AnimationConfig(workingTimeline, workingContext);

            ac.CompleteAction = workingAction;
            this.animations.Add(ac);
            clearWorking();
            return this;

        }

        void clearWorking()
        {
            workingTimeline = null;
            workingContext = null;
            workingAction = null;
            workingKeyFrameOffset = null;
        }

        #endregion

        internal void Start(TimeSpan? cumulativeOffset)
        {
            sb = new Storyboard();
            foreach (AnimationConfig c in animations)
            {
                if (cumulativeOffset != null)
                {
                    c.TimeLine.BeginTime = cumulativeOffset.Value;
                }

                sb.Children.Add(c.TimeLine);
                if (serial)
                {
                    animations.Remove(c);
                    break;
                }
            }

            sb.Completed += new EventHandler(sb_Completed);
            sb.Begin();

        }

        void runSerial()
        {

        }

        void runAsync()
        {

        }

        void sb_Completed(object sender, EventArgs e)
        {
            sb.Completed -= new EventHandler(sb_Completed);
            if (serial && animations.Count > 0)
            {
                Start(null);
            }
            else
            {
                if (Complete != null)
                {
                    Complete(this, EventArgs.Empty);
                }
            }
        }

        public void Add(AnimationConfig config)
        {
            checkQueue();
            animations.Add(config);
        }

        public TimeSpan StartOffset
        {
            get;
            set;
        }

        #region IEnumerable<AnimationConfig> Members

        public IEnumerator<AnimationConfig> GetEnumerator()
        {
            foreach (AnimationConfig a in animations)
            {
                yield return a;
            }
        }

        #endregion

        #region IEnumerable Members

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            foreach (AnimationConfig a in animations)
            {
                yield return a;
            }
        }

        #endregion

        #region IDisposable Members

        public void Dispose()
        {
            if (sb.GetCurrentState() == ClockState.Active)
            {
                sb.Stop();
            }
            sb.Children.Clear();
            animations.ForEach(p => p.Dispose());
            animations.Clear();
        }

        #endregion
    }
}

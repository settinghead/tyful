//Copyright 2008 Jordan Knight
//This code is licenced under Creative Commons Licence: http://creativecommons.org/licenses/by-sa/3.0/

using System;
using System.Collections.Generic;
using System.Threading;

namespace SilverlightWordle
{
    public class AnimationChainManager
    {
        private object lockObj = new object();

        List<AnimationGroup> animationGroups = new List<AnimationGroup>();
        List<AnimationGroup> waiting = new List<AnimationGroup>();

        bool serialMode = false;

        AnimationGroup workingGroup = null;

        public AnimationChainManager(bool serialMode)
        {
            this.serialMode = serialMode;
        }

        /// <summary>
        /// Wait until currently executing animations end before invoking this animation group
        /// </summary>
        /// <param name="group"></param>
        public void Add(AnimationGroup group)
        {
            finaliseWorkingGroup();
            if (Monitor.TryEnter(lockObj, 20000))
            {
                try
                {
                    waiting.Add(group);
                }
                finally
                {
                    Monitor.Exit(lockObj);
                }
            }
        }
        #region "Fluent"

        public AnimationGroup Add()
        {
            finaliseWorkingGroup();
            AnimationGroup ag = new AnimationGroup();
            workingGroup = ag;
            return ag;
        }

        void finaliseWorkingGroup()
        {
            if (workingGroup != null)
            {
                if (Monitor.TryEnter(lockObj, 20000))
                {
                    try
                    {
                        waiting.Add(workingGroup);
                        workingGroup = null;
                    }
                    finally
                    {
                        Monitor.Exit(lockObj);
                    }
                }
            }
        }

        #endregion



        public void Begin(bool waitUntilFinished, bool cancelRunning)
        {
            finaliseWorkingGroup();
            if (cancelRunning)
            {
                clear();
            }
            if (waitUntilFinished && animationGroups.Count > 0)
            {
                return;
            }
            else
            {
                begin();
            }
        }

        void clear()
        {
            if (Monitor.TryEnter(lockObj, 20000))
            {
                try
                {
                    animationGroups.ForEach(p => p.Dispose());
                    animationGroups.Clear();
                }
                finally
                {
                    Monitor.Exit(lockObj);
                }
            }
        }

        void begin()
        {
            if (waiting.Count > 0 && animationGroups.Count == 0)
            {
                beginWaiting();
            }
            else
            {
                if (serialMode)
                {
                    serialAnims();
                }
                else
                {
                    asyncAnims();
                }
            }
        }

        private void asyncAnims()
        {
            if (Monitor.TryEnter(lockObj, 20000))
            {
                try
                {
                    TimeSpan? currentOffset = GroupDelay;
                    foreach (AnimationGroup g in animationGroups)
                    {
                        g.Complete += new EventHandler(g_Complete);
                        g.Start(currentOffset);
                        if (currentOffset.HasValue)
                        {
                            currentOffset += GroupDelay.Value;
                        }
                    }
                    animationGroups.Clear();
                }
                finally
                {
                    Monitor.Exit(lockObj);
                }
            }
        }

        void g_Complete(object sender, EventArgs e)
        {
            if (Monitor.TryEnter(lockObj, 20000))
            {
                try
                {
                    AnimationGroup g = sender as AnimationGroup;
                    animationGroups.Remove(g);

                    if (animationGroups.Count == 0)
                    {
                        beginWaiting();
                    }
                }
                finally
                {
                    Monitor.Exit(lockObj);
                }
            }
        }

        private void serialAnims()
        {
            if (Monitor.TryEnter(lockObj, 20000))
            {
                try
                {
                    if (animationGroups.Count > 0)
                    {
                        AnimationGroup ag = animationGroups[0];
                        ag.Complete += new EventHandler(ag_Complete);
                        animationGroups.RemoveAt(0);
                        ag.Start(null);
                    }
                }
                finally
                {
                    Monitor.Exit(lockObj);
                }
            }
        }

        void beginWaiting()
        {
            if (Monitor.TryEnter(lockObj, 20000))
            {
                try
                {
                    if (waiting.Count > 0 && animationGroups.Count == 0)
                    {
                        waiting.ForEach(p => animationGroups.Add(p));
                        waiting.Clear();
                        begin();
                    }
                }
                finally
                {
                    Monitor.Exit(lockObj);
                }

            }
        }

        void ag_Complete(object sender, EventArgs e)
        {
            AnimationGroup ag = sender as AnimationGroup;
            ag.Complete -= new EventHandler(ag_Complete);

            if (animationGroups.Count == 0)
            {
                beginWaiting();
            }
            else
            {
                begin();
            }

        }

        TimeSpan? groupDelay = null;
        public TimeSpan? GroupDelay
        {
            get
            {
                return groupDelay;
            }
            set
            {
                groupDelay = value;
            }
        }

    }
}

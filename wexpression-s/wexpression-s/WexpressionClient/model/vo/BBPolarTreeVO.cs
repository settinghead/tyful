// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:01 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------
using Com.Settinghead.Wexpression.Client;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
namespace Com.Settinghead.Wexpression.Client.Model.Vo
{


    /*
    Copyright 2010 Daniel Bernier
		
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
		
    http://www.apache.org/licenses/LICENSE-2.0
		
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    */



    public class BBPolarTreeVO
    {

        public const double HALF_PI = ((Math.PI / 2));
        public const double TWO_PI = ((Math.PI * 2));
        public const double PI = (Math.PI);
        public const double ONE_AND_HALF_PI = ((System.Math.PI + HALF_PI));
        public const double MARGIN = 0;

        protected internal int rStamp;

        protected internal double _x, _y, _right, _bottom;

        public double _r1, d1, _r2, d2;
        protected internal List<BBPolarChildTreeVO> _kids;
        protected internal double _computedR1 = double.NaN, _computedR2 = double.NaN;
        private double pointsStamp;
        private double _px, _py, _pright, _pbottom;


        public BBPolarTreeVO(double r1, double r2, double d1_0, double d2, int minBoxSize)
        {
            this.swelling = 0;
            this._leaf = false;
            this._r1 = r1;
            this._r2 = r2;
            this.d1 = d1_0;
            this.d2 = d2;
            double r = r2 - r1;
            double d = BBPolarTreeVO.PI * (d1_0 + d2) * r / BBPolarTreeVO.TWO_PI;

            bool tooSmallToContinue = d <= minBoxSize || d2 - d1_0 <= minBoxSize;
            //			boolean tooSmallToContinue = 
            //				this.getWidth(false) < minBoxSize || this.getHeight(false) < minBoxSize;
            if (tooSmallToContinue)
                this.SetLeaf(true);
        }

        public void AddKids(List<BBPolarChildTreeVO> kidList)
        {
            _kids = kidList;
        }

        public virtual int GetRootX()
        {
            throw new NotImplementedError();
        }

        public virtual int GetRootY()
        {
            throw new NotImplementedError();
        }

        public bool Overlaps(BBPolarTreeVO otherTree)
        {

            if (this.collide(otherTree))
            {
                if (this.isLeaf() && otherTree.isLeaf())
                {
                    return true;
                }
                else if (this.isLeaf())
                { // Then otherTree isn't a leaf.
                    foreach (BBPolarTreeVO otherKid in otherTree.getKids())
                    {
                        if (this.overlaps(otherKid))
                        {
                            return true;
                        }
                    }
                }
                else
                {
                    foreach (BBPolarTreeVO myKid in this.getKids())
                    {
                        if (otherTree.overlaps(myKid))
                        {
                            return true;
                        }
                    }
                }
            }
            return false;
        }

        public List<BBPolarChildTreeVO> GetKids()
        {
            if ((!this.isLeaf()) && this._kids == null)
                BBPolarTreeBuilder.makeChildren(this, getShape(), getMinBoxSize(),
                    getRoot());
            return this._kids;
        }

        public List<BBPolarChildTreeVO> GetKidsNoGrowth()
        {
            return this._kids;
        }

        public virtual BBPolarRootTreeVO GetRoot()
        {
            throw new NotImplementedError();
        }

        public virtual int GetMinBoxSize()
        {
            throw new NotImplementedError();
        }

        public virtual IImageShape GetShape()
        {
            throw new NotImplementedError();
        }

        public bool OverlapsCoord(double x, double y, double right, double bottom)
        {

            if (this.rectCollideCoord(x, y, right, bottom))
            {
                if (this.isLeaf())
                {
                    return true;
                }
                else
                {
                    foreach (BBPolarChildTreeVO myKid in this.getKids())
                    {
                        if (myKid.overlapsCoord(x, y, right, bottom))
                        {
                            return true;
                        }
                    }
                }
            }
            return false;
        }

        public bool Contains(double x, double y, double right, double bottom)
        {

            if (this.rectContain(x, y, right, bottom))
            {
                if (this.isLeaf())
                    return true;
                else
                {
                    foreach (BBPolarTreeVO myKid in this.getKids())
                    {
                        if (myKid.contains(x, y, right, bottom))
                        {
                            return true;
                        }
                    }
                    return false;
                }
            }
            else
                return false;
        }

        protected internal virtual double ComputeX(bool rotate) { throw new NotImplementedError(); }
        protected internal virtual double ComputeY(bool rotate) { throw new NotImplementedError(); }
        protected internal virtual double ComputeRight(bool rotate) { throw new NotImplementedError(); }
        protected internal virtual double ComputeBottom(bool rotate) { throw new NotImplementedError(); }

        public double GetR1(bool rotate)
        {
            if (rotate)
            {
                CheckRecompute();
                return this._computedR1;
            }
            else
                return this._r1;
        }

        public double GetR2(bool rotate)
        {
            if (rotate)
            {
                CheckRecompute();
                return this._computedR2;
            }
            else
                return this._r2;
        }

        public void CheckRecompute()
        {
            if (this.rStamp != this.GetCurrentStamp())
            {
                ComputeR1();
                ComputeR2();
                this.rStamp = this.GetCurrentStamp();
            }
        }

        private void ComputeR1()
        {
            _computedR1 = this._r1 + GetRotation();
            if (_computedR1 > TWO_PI)
                this._computedR1 = this._computedR1 % TWO_PI;

        }

        private void ComputeR2()
        {
            this._computedR2 = this._r2 + GetRotation();
            if (this._computedR2 > TWO_PI)
                this._computedR2 = this._computedR2 % TWO_PI;

        }

        private void CheckUpdatePoints()
        {
            if (this.pointsStamp != this.GetCurrentStamp())
            {
                this._px = GetRootX() - swelling + GetX(true);
                this._py = GetRootY() - swelling + GetY(true);
                this._pright = GetRootX() + swelling + GetRight(true);
                this._pbottom = GetRootY() + swelling + GetBottom(true);
                this.pointsStamp = this.GetCurrentStamp();

                //				try{
                //					Assert.isTrue(this._px < this._pright);
                //				}
                //				catch(e:Error){
                //					Alert.show("RootX:"+ getRootX().toString()+", "+swelling.toString()+",_X: "+_x.toString()
                //					+",Right: "+ getRight(true).toString()+", xstamp: "+this.xStamp.toString()+", cstamp: "+getCurrentStamp().toString());
                //				}

                //				Assert.isTrue(this._py < this._pbottom);
            }
        }

        protected double px
        {
            get
            {
                checkUpdatePoints();
                return this._px;
            }
        }

        protected double py
        {
            get
            {
                checkUpdatePoints();
                return this._py;
            }
        }

        protected double pright
        {
            get
            {
                checkUpdatePoints();
                return this._pright;
            }
        }

        protected double pbottom
        {
            get
            {
                checkUpdatePoints();
                return this._pbottom;
            }
        }


        protected bool Collide(BBPolarTreeVO bTree)
        {
            double dist = Math.Sqrt(Math.Pow(this.GetRootX() - bTree.GetRootX(), 2) + Math.Pow(this.GetRootY() - bTree.GetRootY(), 2));
            if (dist > this.d2 + bTree.d2) return false;
            else
            {
                //				double angle1 = -Math.atan2(bTree.getRootY() - this.getRootY(), bTree.getRootX() - this.getRootX());
                //				double angle2;
                //				if(angle1>=0) angle2 = angle1-Math.PI;
                //				else angle2 = angle1 + Math.PI;
                //				double angleSum1 = Math.abs(this.getR2(true)-angle2)%Math.PI + Math.abs(bTree.getR1(true)-angle1)%Math.PI;
                //				double angleSum2 = Math.abs(this.getR1(true)-angle1)%Math.PI+Math.abs(bTree.getR2(true)-angle2)%Math.PI;
                //				if(Math.abs(this.getR2(true)-angle2)%Math.PI + Math.abs(bTree.getR1(true)-angle1)%Math.PI>Math.PI 
                //					&& Math.abs(this.getR2(true)-angle2)%Math.PI + Math.abs(bTree.getR2(true)-angle2)%Math.PI>Math.PI
                //				&& Math.abs(this.getR1(true)-angle1)%Math.PI + Math.abs(bTree.getR2(true)-angle2)%Math.PI
                //				&& Math.abs(this.getR1(true)-angle1)%Math.PI + Math.abs(bTree.getR1(true)-angle1)%Math.PI) return false;
                return RectCollide(bTree);
            }
        }


        protected internal bool RectCollide(BBPolarTreeVO bTree)
        {
            return RectCollideCoord(bTree.px, bTree.py, bTree.pright, bTree.pbottom);
        }

        private bool RectContain(double x, double y, double right, double bottom)
        {
            return this.px <= x && this.py <= y && this.pright >= right && this.pbottom >= bottom;
        }

        private bool RectCollideCoord(double x, double y, double right, double bottom)
        {

            //			int margin = 2;
            return this.pbottom > y && this.py < bottom && this.pright > x && this.px < right;
        }

        public bool IsLeaf()
        {
            return _leaf;
        }

        private int swelling;
        private double xStamp, yStamp, rightStamp, bottomStamp;
        private bool _leaf;
        private double _relativeX = double.NaN, _relativeY = double.NaN,
            _relativeRight = double.NaN, _relativeBottom = double.NaN;

        public void Swell(int extra)
        {
            swelling += extra;
            if (!IsLeaf())
            {
                for (int i = 0; i < GetKids().length; i++)
                {
                    GetKids()[i].Swell(extra);
                }
            }
        }



        public double GetWidth(bool rotate)
        {
            return this.GetRight(rotate) - this.GetX(rotate);
        }

        public double GetHeight(bool rotate)
        {
            return this.GetBottom(rotate) - this.GetY(rotate);
        }


        /// <param name="rotation">the rotation to set</param>

        private void CheckComputeX()
        {
            if (this.xStamp != this.GetCurrentStamp())
            {
                this._x = ComputeX(true);
                this.xStamp = this.GetCurrentStamp();
            }
        }

        private void CheckComputeY()
        {
            if (this.yStamp != this.GetCurrentStamp())
            {
                this._y = ComputeY(true);
                this.yStamp = this.GetCurrentStamp();
            }

        }

        private void CheckComputeRight()
        {
            if (this.rightStamp != this.GetCurrentStamp())
            {
                this._right = ComputeRight(true);
                this.rightStamp = this.GetCurrentStamp();
            }
        }

        private void CheckComputeBottom()
        {
            if (this.bottomStamp != this.GetCurrentStamp())
            {
                this._bottom = ComputeBottom(true);
                this.bottomStamp = this.GetCurrentStamp();
            }
        }

        private double GetRelativeX()
        {
            if (IsNaN(this._relativeX))
                this._relativeX = ComputeX(false);
            return this._relativeX;
        }

        private double GetRelativeY()
        {
            if (IsNaN(this._relativeY))
                this._relativeY = ComputeY(false);
            return this._relativeY;
        }

        private double GetRelativeRight()
        {
            if (IsNaN(this._relativeRight))
                this._relativeRight = ComputeRight(false);
            return this._relativeRight;
        }

        private double GetRelativeBottom()
        {
            if (IsNaN(this._relativeBottom))
                this._relativeBottom = ComputeBottom(false);
            return this._relativeBottom;
        }

        public double GetX(bool rotate)
        {
            if (rotate)
            {
                CheckComputeX();
                return _x - MARGIN;
            }
            else
                return GetRelativeX();
        }

        public double GetY(bool rotate)
        {
            if (rotate)
            {
                CheckComputeY();
                return _y - MARGIN;
            }
            else
                return GetRelativeY();
        }

        public double GetRight(bool rotate)
        {
            if (rotate)
            {
                CheckComputeRight();
                return _right + MARGIN;
            }
            else
                return GetRelativeRight();
        }

        public double GetBottom(bool rotate)
        {
            if (rotate)
            {
                CheckComputeBottom();
                return _bottom + MARGIN;
            }
            return GetRelativeBottom();
        }


        /// <returns>the rotation</returns>
        public virtual double GetRotation()
        {
            throw new NotImplementedError();
        }

        public virtual double GetCurrentStamp()
        {
            throw new NotImplementedError();
        }

        public void SetLeaf(bool b)
        {
            this._leaf = b;
        }

    }
}

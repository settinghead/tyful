// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:01 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------

using System;
using System.Collections;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
namespace Com.Settinghead.Wexpression.Client.Model.Vo
{

    public class BBPolarRootTreeVO : BBPolarTreeVO
    {
        private int rootX;
        private int rootY;
        private double _rotation;
        protected internal int rootStamp;
        private IImageShape shape;
        private int _minBoxSize;

        public BBPolarRootTreeVO(IImageShape shape_0, int centerX, int centerY, double d, int minBoxSize)
            : base(0, TWO_PI, 0, d, minBoxSize)
        {
            this._rotation = 0;
            this.rootStamp = 0;
            this.rootX = centerX;
            this.rootY = centerY;
            this.shape = shape_0;
            this._minBoxSize = minBoxSize;
            this.rootStamp++;
        }

        public void SetLocation(int centerX, int centerY)
        {
            this.rootX = centerX;
            this.rootY = centerY;
            this.rootStamp++;
        }


        public override int GetRootX()
        {
            return rootX;
        }


        public override int GetRootY()
        {
            return rootY;
        }


        protected internal override double ComputeX(bool rotate)
        {
            //			if(shape.width<STOP_COMPUTE_TREE_THRESHOLD)
            //				return -shape.width/2;
            //			else 
            return -base.d2;
        }


        protected internal override double ComputeY(bool rotate)
        {
            //			if(shape.height<STOP_COMPUTE_TREE_THRESHOLD)
            //				return -shape.height/2;
            //			else 
            return -base.d2;
        }


        protected internal override double ComputeRight(bool rotate)
        {
            //			if(shape.width<STOP_COMPUTE_TREE_THRESHOLD)
            //				return shape.width/2;
            //			else 
            return (base.d2);
        }


        protected internal override double ComputeBottom(bool rotate)
        {
            //			if(shape.height<STOP_COMPUTE_TREE_THRESHOLD)
            //				return -shape.height/2;
            //			else 
            return (base.d2);
        }

        public void SetRotation(double rotation)
        {
            this._rotation = rotation % BBPolarTreeVO.TWO_PI;
            if (this._rotation < 0)
                this._rotation = BBPolarTreeVO.TWO_PI + this._rotation;
            this.rootStamp++;
        }


        public override double GetRotation()
        {
            return this._rotation;
        }


        public override double GetCurrentStamp()
        {
            return this.rootStamp;
        }


        public override BBPolarRootTreeVO GetRoot()
        {
            return this;
        }


        public override int GetMinBoxSize()
        {
            return this._minBoxSize;
        }


        public override IImageShape GetShape()
        {
            return this.shape;
        }

        //		public boolean overlaps(BBPolarTreeVO otherTree) {
        //			double min = 30;
        //			if(this.getHeight(false)<min || 
        //				this.getWidth(false)<min || 
        //				otherTree.getHeight(false)<min ||
        //				otherTree.getWidth(false)<min
        //			){
        //				return rectCollide(otherTree);
        //			}
        //			else
        //				return super.overlaps(otherTree);
        //		}

    }



}

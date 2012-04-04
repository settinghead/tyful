// --------------------------------------------------------------------------------------------------
// This file was automatically generated by J2CS Translator (http://j2cstranslator.sourceforge.net/). 
// Version 1.3.6.20110331_01     
// 3/28/12 3:01 AM    
// ${CustomMessageForDisclaimer}                                                                             
// --------------------------------------------------------------------------------------------------

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



    public class BBPolarTreeBuilder
    {

        private const double STOP_COMPUTE_TREE_THRESHOLD = 20;


        public static BBPolarRootTreeVO MakeTree(IImageShape shape, int swelling)
        {
            int minBoxSize = 1;
            // center
            int x = ((int)(shape.width / 2));
            int y = ((int)(shape.height / 2));
            // Assert.isTrue(x > 0);
            // Assert.isTrue(y > 0);

            double d = (Math.Sqrt(Math.Pow(shape.width / 2, 2)
                            + Math.Pow(shape.height / 2, 2)));

            BBPolarRootTreeVO tree = new BBPolarRootTreeVO(shape, x, y, d,
                    minBoxSize);
            // makeChildren(tree, shape, minBoxSize, tree);
            //		tree.swell(swelling);
            return tree;
        }

        public static void MakeChildren(BBPolarTreeVO tree, IImageShape shape, int minBoxSize, BBPolarRootTreeVO root)
        {
            int type = determineType(tree);

            ArrayList<BBPolarChildTreeVO> children;
            children = splitTree(tree, shape, minBoxSize, root, type);
            //		 if(children.length==0) 
            //			 tree.setLeaf(true);
            //		 else
            tree.addKids(children);
        }

        public static List<BBPolarChildTreeVO> SplitTree(BBPolarTreeVO tree, IImageShape shape, int minBoxSize, BBPolarRootTreeVO root, int type)
        {
            ArrayList<BBPolarChildTreeVO> result = new List<BBPolarChildTreeVO>();
            BBPolarChildTreeVO re;
            double r, r1, r2, r3, r4, r5;
            double d, d1, d2, d3, d4, d5;

            switch (type)
            {
                case SplitType._3RAYS:
                    {
                        r = (tree.getR2(false) - tree.getR1(false)) / 4;
                        r1 = tree.getR1(false);
                        r2 = r1 + r;
                        r3 = r2 + r;
                        r4 = r3 + r;
                        r5 = tree.getR2(false);
                        Assert.isTrue(r1 < r2 && r2 < r3 && r3 < r4 && r4 < r5);
                        re = makeChildTree(shape, minBoxSize, r1, r2, tree.d1, tree.d2, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r2, r3, tree.d1, tree.d2, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r3, r4, tree.d1, tree.d2, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r4, r5, tree.d1, tree.d2, root);
                        if (re != null) result.push(re);
                    }
                    break;

                case SplitType._2RAYS1CUT:
                    {
                        r = (tree.getR2(false) - tree.getR1(false)) / 3;
                        r1 = tree.getR1(false);
                        r2 = r1 + r;
                        r3 = r2 + r;
                        r4 = tree.getR2(false);
                        d1 = tree.d1;
                        d2 = tree.d1 + (tree.d2 - tree.d1) / 2;
                        d3 = tree.d2;
                        Assert.isTrue(r1 < r2 && r2 < r3 && r3 < r4);
                        re = makeChildTree(shape, minBoxSize, r1, r4, d1, d2, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r2, r3, d2, d3, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r3, r4, d2, d3, root);
                        if (re != null) result.push(re);
                    }
                    break;
                case SplitType._1RAY1CUT:
                    {
                        r = (tree.getR2(false) - tree.getR1(false)) / 2;
                        r1 = tree.getR1(false);
                        r2 = r1 + r;
                        r3 = tree.getR2(false);
                        d = (tree.d2 - tree.d1) / 2;
                        d1 = tree.d1;
                        d2 = d1 + d;
                        d3 = tree.d2;
                        Assert.isTrue(r1 < r2 && r2 < r3);

                        re = makeChildTree(shape, minBoxSize, r1, r2, d1, d2, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r2, r3, d1, d2, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r2, r3, d2, d3, root);
                        if (re != null) result.push(re);
                    }
                    break;
                case SplitType._1RAY2CUTS:
                    {
                        r = (tree.getR2(false) - tree.getR1(false)) / 2;
                        r1 = tree.getR1(false);
                        r2 = r1 + r;
                        r3 = tree.getR2(false);
                        d = (tree.d2 - tree.d1) / 3;
                        d1 = tree.d1;
                        d2 = d1 + d;
                        d3 = d2 + d;
                        d4 = tree.d2;
                        Assert.isTrue(r1 < r2 && r2 < r3);

                        re = makeChildTree(shape, minBoxSize, r1, r3, d1, d2, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r1, r3, d2, d3, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r1, r2, d3, d4, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r2, r3, d3, d4, root);
                        if (re != null) result.push(re);
                    }
                    break;
                case SplitType._3CUTS:
                    {
                        r1 = tree.getR1(false);
                        r2 = tree.getR2(false);
                        d = (tree.d2 - tree.d1) / 4;
                        d1 = tree.d1;
                        d2 = d1 + d;
                        d3 = d2 + d;
                        d4 = d3 + d;
                        d5 = tree.d2;
                        Assert.isTrue(r1 < r2);

                        re = makeChildTree(shape, minBoxSize, r1, r2, d1, d2, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r1, r2, d3, d4, root);
                        if (re != null) result.push(re);
                        re = makeChildTree(shape, minBoxSize, r1, r2, d4, d5, root);
                        if (re != null) result.push(re);
                    }
                    break;
            }
            return result;
        }

        private static int DetermineType(BBPolarTreeVO tree)
        {
            double d = (tree.d2 - tree.d1);
            double midLength = ((tree.d2 + tree.d1)
                    * (tree.GetR2(false) - tree.GetR1(false)) / 2);
            double factor = d / midLength;
            // System.out.println("d=" + d + ", midLength=" + midLength + ",factor="
            // + factor);
            if (factor < 0.7d)
                return SplitType._3RAYS;
            else if (factor > 1.3d)
                return SplitType._3CUTS;
            else
                return SplitType._1RAY1CUT;
        }

        private static BBPolarChildTreeVO MakeChildTree(IImageShape shape, int minBoxSize, double r1, double r2, double d1, double d2, BBPolarRootTreeVO root)
        {

            BBPolarChildTreeVO tree = new BBPolarChildTreeVO(r1, r2, d1, d2,
                    root, minBoxSize);
            double x = tree.GetX(false) + shape.width / 2;
            if (x > shape.width) return null;
            double y = tree.GetY(false) + shape.height / 2;
            if (y > shape.height) return null;
            double width = tree.GetRight(false) - tree.GetX(false);
            //		if(width<1) return null;
            if (x + width < 0) return null;
            double height = tree.GetBottom(false) - tree.GetY(false);
            //		if(height<1) return null;
            if (y + height < 0) return null;
            Assert.IsTrue(width > 0);
            Assert.IsTrue(height > 0);
            if (shape == null || shape.Contains(x, y, width, height, 0, false))
            {
                return tree;
            }
            else
            {
                if (shape.Intersects(x, y, width, height, false))
                {
                    return tree;
                }
                else
                { // neither contains nor intersects
                    return null;
                }
            }
        }

        public static int correctCount = 0;

        // To the best of my knowledge this code is correct.
        // If you find any errors or problems please contact
        // me at zunzun@zunzun.com.
        // James
        //
        // the code below was partially based on the fortran code at:
        // http://svn.scipy.org/svn/scipy/trunk/scipy/interpolate/fitpack/fpbisp.f
        // http://svn.scipy.org/svn/scipy/trunk/scipy/interpolate/fitpack/fpbspl.f

    }

}

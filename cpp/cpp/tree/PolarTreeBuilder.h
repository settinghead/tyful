#ifndef PolarTREEMAKER_H
#define PolarTREEMAKER_H

#include <math.h>
#include <assert.h>
#include <vector>

#include "PolarChildTree.h"
#include "PolarRootTree.h"
#include "PolarTree.h"
#include "../model/ImageShape.h"

//class PolarTreeBuilder{
//public:
    inline static SplitType determineType(PolarTree* tree) {
        double d = (tree->getD2(false) - tree->getD1(false));
        double midLength = (((tree->getD2(false) + tree->getD1(false)))
                * ((tree->getR2(-1,false) - tree->getR1(-1,false)))) / 2.0;
        double factor = d / midLength;
        if (factor < 0.7) {
            return _3RAYS;
        } else {
            if (factor > 1.3) {
                return _3CUTS;
            } else {
                return _1RAY1CUT;
            }
        }
    }

     inline static PolarTree* makeChildTree(ImageShape* shape, double r1, double r2, double d1, double d2,
            PolarRootTree* root) {
        PolarChildTree* tree = new PolarChildTree(r1, r2, d1, d2, root);
        double x = (tree->getX(-1,false)
                + shape->getWidth()/2);
        if (((x > shape->getWidth()))) {
            delete tree;
            return NULL;
        } else {
            double y = (tree->getY(-1,false)
                    + shape->getHeight()/2);
            if (((y > shape->getHeight()))) {
                delete tree;
                return NULL;
            } else {
                double width = (tree->getRight(-1,false) - tree->getX(-1,false));
                if ((((x + width) < 0))) {
                    delete tree;
                    tree = NULL;
                } else {
//#ifdef FLIP
                    double height = tree->getBottom(-1,false) - tree->getY(-1,false);
//#else
//                    double height =  tree->getY(false) - tree->getBottom(false);
//#endif
                    if ((((y + height) < 0))) {
                        delete tree;
                        return NULL;
                    } else {
                        assert(width > 0);
                        assert(height > 0);
                        if (((shape == NULL || shape->contains(x, y, width, height)))) {
                        } else {
                            if (shape->intersects(x, y, width, height)) {
                            } else {
                                delete tree;
                                return NULL;
                            }
                        }
                    }
                }
            }
        }
        return tree;
    }

    inline static vector<PolarTree*>* splitTree(PolarTree* tree,
            ImageShape* shape, PolarRootTree* root,
            SplitType type) {
        vector<PolarTree*>* result = new vector<PolarTree*>();
        PolarTree* re;
        double r;
        double r1;
        double r2;
        double r3;
        double r4;
        double r5;
        double d;
        double d1;
        double d2;
        double d3;
        double d4;
        double d5;
        switch (type) {
        case _3RAYS: {
            r = (double(((tree->getR2(-1,false) - tree->getR1(-1,false))))
                    / double((int) 4));
            r1 = tree->getR1(-1,false);
            r2 = (r1 + r);
            r3 = (r2 + r);
            r4 = (r3 + r);
            r5 = tree->getR2(-1,false);
            assert(
                    ((bool((bool((r1 < r2)) && bool((r2 < r3)))) && bool((r3 < r4)))
                            && bool((r4 < r5))));
            re = makeChildTree(shape, r1, r2, tree->getD1(false), tree->getD2(false), root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r2, r3, tree->getD1(false), tree->getD2(false), root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r3, r4, tree->getD1(false), tree->getD2(false), root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r4, r5, tree->getD1(false), tree->getD2(false), root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _2RAYS1CUT: {
            r = (double(((tree->getR2(-1,false) - tree->getR1(-1,false))))
                    / double((int) 3));
            r1 = tree->getR1(-1,false);
            r2 = (r1 + r);
            r3 = (r2 + r);
            r4 = tree->getR2(-1,false);
            d1 = tree->getD1(false);
            d2 = (tree->getD1(false) + (double(((tree->getD2(false) - tree->getD1(false)))) / double((int) 2)));
            d3 = tree->getD2(false);
            assert((bool((bool((r1 < r2)) && bool((r2 < r3)))) && bool((r3 < r4))));
            re = makeChildTree(shape, r1, r4, d1, d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r1, r2, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r2, r3, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r3, r4, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _1RAY1CUT: {
            r = (double(((tree->getR2(-1,false) - tree->getR1(-1,false))))
                    / double((int) 2));
            r1 = tree->getR1(-1,false);
            r2 = (r1 + r);
            r3 = tree->getR2(-1,false);
            d = (double(((tree->getD2(false) - tree->getD1(false)))) / double((int) 2));
            d1 = tree->getD1(false);
            d2 = (d1 + d);
            d3 = tree->getD2(false);
            assert((bool((r1 < r2)) && bool((r2 < r3))));
            re = makeChildTree(shape, r1, r2, d1, d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r2, r3, d1, d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r1, r2, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r2, r3, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _1RAY2CUTS: {
            r = (double(((tree->getR2(-1,false) - tree->getR1(-1,false))))
                    / double((int) 2));
            r1 = tree->getR1(-1,false);
            r2 = (r1 + r);
            r3 = tree->getR2(-1,false);
            d = (double(((tree->getD2(false) - tree->getD1(false)))) / double((int) 3));
            d1 = tree->getD1(false);
            d2 = (d1 + d);
            d3 = (d2 + d);
            d4 = tree->getD2(false);
            assert((bool((r1 < r2)) && bool((r2 < r3))));
            re = makeChildTree(shape, r1, r3, d1, d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r1, r3, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r1, r2, d3, d4, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r2, r3, d3, d4, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _3CUTS: {
            r1 = tree->getR1(-1,false);
            r2 = tree->getR2(-1,false);
            d = (double(((tree->getD2(false) - tree->getD1(false)))) / double((int) 4));
            d1 = tree->getD1(false);
            d2 = (d1 + d);
            d3 = (d2 + d);
            d4 = (d3 + d);
            d5 = tree->getD2(false);
            assert(r1 < r2);
            re = makeChildTree(shape, r1, r2, d1, d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r1, r2, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r1, r2, d3, d4, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, r1, r2, d4, d5, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        }
        return result;
    }

    inline static PolarRootTree* makeTree(ImageShape* shape, int swelling) {
//        int x = int(shape->getWidth() / 2.0);
//        int y = int(shape->getHeight() / 2.0);
        double d = sqrt(
                (pow((double(shape->getWidth()) / 2.0), 2.0)
                        + pow((double(shape->getHeight()) / 2.0), 2.0)));
        PolarRootTree* tree = new PolarRootTree(shape, d);
        return tree;
    }

    inline static void makeChildren(PolarTree* tree, ImageShape* shape, PolarRootTree* root) {
        {
            SplitType type = determineType(tree);
            vector<PolarTree*>* children = splitTree(tree, shape, root, type);
            tree->addKids(children);
        }
    }
//};
#endif

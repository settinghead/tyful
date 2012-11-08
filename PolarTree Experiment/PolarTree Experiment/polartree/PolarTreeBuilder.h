#ifndef PolarTREEMAKER_H
#define PolarTREEMAKER_H

#include <math.h>
#include <assert.h>
#include <vector>

#include "PolarChildTree.h"
#include "PolarRootTree.h"
#include "PolarTree.h"
#include "ImageShape.h"

//class PolarTreeBuilder{
//public:
    static SplitType determineType(PolarTree* tree) {
        double d = (tree->d2 - tree->d1);
        double midLength = (((tree->d2 + tree->d1))
                * ((tree->getR2(false) - tree->getR1(false)))) / 2.0;
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

     static PolarChildTree* makeChildTree(ImageShape* shape,
            int minBoxSize, double r1, double r2, double d1, double d2,
            PolarRootTree* root) {
        PolarChildTree* tree = new PolarChildTree(r1, r2, d1, d2, root,
                minBoxSize);
        double x = (tree->getX(false)
                + (double(shape->getWidth()) / double((int) 2)));
        if (((x > shape->getWidth()))) {
            delete tree;
            tree = NULL;
        } else {
            double y = (tree->getY(false)
                    + (double(shape->getHeight()) / double((int) 2)));
            if (((y > shape->getHeight()))) {
                delete tree;
                tree = NULL;
            } else {
                double width = (tree->getRight(false) - tree->getX(false));
                if ((((x + width) < (int) 0))) {
                    delete tree;
                    tree = NULL;
                } else {
                    double height = (tree->getBottom(false) - tree->getY(false));
                    if ((((y + height) < (int) 0))) {
                        delete tree;
                        tree = NULL;
                    } else {
                        assert(width > (int) 0);
                        assert(height > (int) 0);
                        if (((shape == NULL || shape->contains(x, y, width, height)))) {
                        } else {
                            if (shape->intersects(x, y, width, height)) {
                            } else {
                                delete tree;
                                tree = NULL;
                            }
                        }
                    }
                }
            }
        }
        return tree;
    }

    static vector<PolarChildTree*>* splitTree(PolarTree* tree,
            ImageShape* shape, int minBoxSize, PolarRootTree* root,
            SplitType type) {
        vector<PolarChildTree*>* result = new vector<PolarChildTree*>();
        PolarChildTree* re;
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
            r = (double(((tree->getR2(false) - tree->getR1(false))))
                    / double((int) 4));
            r1 = tree->getR1(false);
            r2 = (r1 + r);
            r3 = (r2 + r);
            r4 = (r3 + r);
            r5 = tree->getR2(false);
            assert(
                    ((bool((bool((r1 < r2)) && bool((r2 < r3)))) && bool((r3 < r4)))
                            && bool((r4 < r5))));
            re = makeChildTree(shape, minBoxSize, r1, r2, tree->d1, tree->d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r2, r3, tree->d1, tree->d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r3, r4, tree->d1, tree->d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r4, r5, tree->d1, tree->d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _2RAYS1CUT: {
            r = (double(((tree->getR2(false) - tree->getR1(false))))
                    / double((int) 3));
            r1 = tree->getR1(false);
            r2 = (r1 + r);
            r3 = (r2 + r);
            r4 = tree->getR2(false);
            d1 = tree->d1;
            d2 = (tree->d1 + (double(((tree->d2 - tree->d1))) / double((int) 2)));
            d3 = tree->d2;
            assert((bool((bool((r1 < r2)) && bool((r2 < r3)))) && bool((r3 < r4))));
            re = makeChildTree(shape, minBoxSize, r1, r4, d1, d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r2, r3, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r3, r4, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _1RAY1CUT: {
            r = (double(((tree->getR2(false) - tree->getR1(false))))
                    / double((int) 2));
            r1 = tree->getR1(false);
            r2 = (r1 + r);
            r3 = tree->getR2(false);
            d = (double(((tree->d2 - tree->d1))) / double((int) 2));
            d1 = tree->d1;
            d2 = (d1 + d);
            d3 = tree->d2;
            assert((bool((r1 < r2)) && bool((r2 < r3))));
            re = makeChildTree(shape, minBoxSize, r1, r2, d1, d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r2, r3, d1, d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r2, r3, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _1RAY2CUTS: {
            r = (double(((tree->getR2(false) - tree->getR1(false))))
                    / double((int) 2));
            r1 = tree->getR1(false);
            r2 = (r1 + r);
            r3 = tree->getR2(false);
            d = (double(((tree->d2 - tree->d1))) / double((int) 3));
            d1 = tree->d1;
            d2 = (d1 + d);
            d3 = (d2 + d);
            d4 = tree->d2;
            assert((bool((r1 < r2)) && bool((r2 < r3))));
            re = makeChildTree(shape, minBoxSize, r1, r3, d1, d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r1, r3, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r1, r2, d3, d4, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r2, r3, d3, d4, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        case _3CUTS: {
            r1 = tree->getR1(false);
            r2 = tree->getR2(false);
            d = (double(((tree->d2 - tree->d1))) / double((int) 4));
            d1 = tree->d1;
            d2 = (d1 + d);
            d3 = (d2 + d);
            d4 = (d3 + d);
            d5 = tree->d2;
            assert(r1 < r2);
            re = makeChildTree(shape, minBoxSize, r1, r2, d1, d2, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r1, r2, d2, d3, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r1, r2, d3, d4, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            re = makeChildTree(shape, minBoxSize, r1, r2, d4, d5, root);
            if (((re != NULL))) {
                result->push_back(re);
            }
            break;
        }
        }
        return result;
    }

    static PolarRootTree* makeTree(ImageShape* shape, int swelling) {
        int minBoxSize = (int) 1;
        int x = int(shape->getWidth() / 2.0);
        int y = int(shape->getHeight() / 2.0);
        double d = sqrt(
                (pow((double(shape->getWidth()) / double((int) 2)), 2.0)
                        + pow((double(shape->getHeight()) / 2.0), 2.0)));
        PolarRootTree* tree = new PolarRootTree(shape, x, y, d, minBoxSize);
        return tree;
    }

    static void makeChildren(PolarTree* tree, ImageShape* shape,
            int minBoxSize, PolarRootTree* root) {
        {
            SplitType type = determineType(tree);
            vector<PolarChildTree*>* children = splitTree(tree, shape,
                    minBoxSize, root, type);
            tree->addKids(children);
        }
    }
//};
#endif

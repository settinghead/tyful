#ifndef PolarCHILDTree_H
#define PolarCHILDTree_H

#include "PolarTree.h"
#include "PolarRootTree.h"
#include "../fasttrig.h"
class PolarRootTree;
class PolarChildTree: public PolarTree {
public:
	PolarChildTree(double r1, double r2, double d1,
                          double d2, PolarRootTree* root)
    :PolarTree::PolarTree(r1, r2, d1, d2),root(root) {
    }
	~PolarChildTree(){
        
    }
    
    
	PolarRootTree* root; 
    inline int getFinalSeq(){
        return root->getFinalSeq();
    }
    
    #if NUM_THREADS > 1
        inline void setFinalSeq(int seq){
            root->setFinalSeq(seq);
        }
    #endif
	inline double computeX(int seq,bool rotate){
        double r1 = getR1(seq,rotate),r2 = getR2(seq,rotate),
        d1 = getD1(rotate),d2 = getD2(rotate);
        
        double x;
        if (((r1 < HALF_PI))) {
            if (((r2 < r1))) {
                x = -d2;
            } else {
                if (((r2 < HALF_PI))) {
                    x = (d1 * cos(r2));
                } else {
                    if (((r2 < PI))) {
                        x = (d2 * cos(r2));
                    } else {
                        x = -d2;
                    }
                }
            }
        } else {
            if (((r1 < PI))) {
                if (((r2 < HALF_PI))) {
                    x = -d2;
                } else {
                    if (((r2 < PI))) {
                        x = (d2 * cos(r2));
                    } else {
                        if (((r2 < ONE_AND_HALF_PI))) {
                            x = -d2;
                        } else {
                            x = -d2;
                        }
                    }
                }
            } else {
                if (((r1 < ONE_AND_HALF_PI))) {
                    if (((r2 < HALF_PI))) {
                        x = (d2 * cos(r1));
                    } else {
                        if (((r2 < r1))) {
                            double x1 = (d2 * cos(r1));
                            double x2 = (d2 * cos(r2));
                            x = x1 < x2 ? x1 : x2;
                        } else {
                            if (((r2
                                  < ONE_AND_HALF_PI))) {
                                x = (d2 * cos(r1));
                            } else {
                                x = (d2 * cos(r1));
                            }
                        }
                    }
                } else {
                    if (((r2 < HALF_PI))) {
                        double xx1 = (d1 * cos(r1));
                        double xx2 = (d1 * cos(r2));
                        x = xx1 < xx2 ? xx1 : xx2;
                    } else {
                        if (((r2 < PI))) {
                            x = (d2 * cos(r2));
                        } else {
                            if (((r2 < r1))) {
                                x = -d2;
                            } else {
                                x = (d1 * cos(r1));
                            }
                        }
                    }
                }
            }
        }
        return x;
    }
	inline double computeY(int seq,bool rotate){
        double r1 = getR1(seq,rotate),r2 = getR2(seq,rotate),
        d1 = getD1(rotate),d2 = getD2(rotate);
        
        double y;
        if (((r1 < HALF_PI))) {
            if (((r2 < r1))) {
                y = d1;
            } else {
                if (((r2 < HALF_PI))) {
                    y = (d2 * sin(r2));
                } else {
                    if (((r2 < PI))) {
                        y = d2;
                    } else {
                        y = d2;
                    }
                }
            }
        } else {
            if (((r1 < PI))) {
                if (((r2 < HALF_PI))) {
                    double y1 = (d2 * sin(r1));
                    double y2 = (d2 * sin(r2));
                    y = ((((y1 > y2))) ? double(y1) : double(y2));
                } else {
                    if (((r2 < r1))) {
                        y = d2;
                    } else {
                        y = (d2 * sin(r1));
                    }
                }
            } else {
                if (((r1 < ONE_AND_HALF_PI))) {
                    if (((r2 < PI))) {
                        y = d2;
                    } else {
                        if (((r2 < r1))) {
                            y = (d1 * sin(r2));
                        } else {
                            if (((r2
                                  < ONE_AND_HALF_PI))) {
                                y = (d1 * sin(r1));
                            } else {
                                double val1 = (d1 * sin(r2));
                                double val2 = (d1 * sin(r1));
                                y =
                                ((((val1 > val2))) ?
                                 val1 : val2);
                            }
                        }
                    }
                } else {
                    if (((r2 < HALF_PI))) {
                        y = (d2 * sin(r2));
                    } else {
                        if (((r2 < r1))) {
                            y = d2;
                        } else {
                            y = (d1 * sin(r2));
                        }
                    }
                }
            }
        }
        //#ifdef FLIP
        return -y;
        //#else
        //	return y;
        //#endif
    }
	inline double computeRight(int seq,bool rotate){
        double r1 = getR1(seq,rotate),r2 = getR2(seq,rotate),
        d1 = getD1(rotate),d2 = getD2(rotate);
        
        double right;
        if (((r1 < HALF_PI))) {
            if (((r2 < r1))) {
//                right = d2* cos(r2);
                right = d2;
            } else {
                                if (((r2 < HALF_PI))) {
                right = (d2 * cos(r1));
                                } else {
                                    if (((r2 < PI))) {
                                        right = d2 * cos(r1);
                                    } else {
                                        right = d2;
                                    }
                                }
            }
        } else if(r1 < PI) {
            if (((r2 < r1))) {
                right = d2;
            } else {
                if (((r2 < PI))) {
                    right = (d1 * cos(r1));
                } else {
                    if (((r2 < ONE_AND_HALF_PI))) {
                        right = PI-r1 > r2-PI ? d1 * cos(r1) : d1 * cos(r2);
                    } else {
                        right = (d2 * cos(r2));
                    }
                }
            }
        }
        else if (((r1 < ONE_AND_HALF_PI))) {
            if (((r2 < r1))) {
                right = d2;
            } else {
                if (((r2 < ONE_AND_HALF_PI))) {
                    right = (d1 * cos(r2));
                } else {
                    right = (d2 * cos(r2));
                }
            }
        }
        else {
            if (((r2 < r1))) {
                right = d2;
            } else {
                right = (d2 * cos(r2));
            }
        }
        return right;
    }
	inline double computeBottom(int seq,bool rotate){
        double r1 = getR1(seq,rotate),r2 = getR2(seq,rotate),
        d1 = getD1(rotate),d2 = getD2(rotate);
        
        double bottom;
        if (((r1 < HALF_PI))) {
            if (((r2 < r1))) {
                bottom = -d1;
            } else {
                if (((r2 < HALF_PI))) {
                    bottom = (d1 * sin(r1));
                } else {
                    if (((r2 < PI))) {
                        double val1 = (d1 * sin(r1));
                        double val2 = (d1 * sin(r2));
                        bottom = val1 < val2 ? val1 : val2;
                    } else {
                        bottom = -d2;
                    }
                }
            }
        } else {
            if (((r1 < PI))) {
                if (((r2 < r1))) {
                    bottom = -d1;
                } else {
                    if (((r2 < PI))) {
                        bottom = (d1 * sin(r2));
                    } else {
                        if (((r2 < ONE_AND_HALF_PI))) {
                            bottom = (d2 * sin(r2));
                        } else {
                            bottom =
                            -d2;
                        }
                    }
                }
            } else {
                if (((r1 < ONE_AND_HALF_PI))) {
                    if (((r2 < r1))) {
                        bottom = -d2;
                    } else {
                        if (((r2 < ONE_AND_HALF_PI))) {
                            bottom = (d2 * sin(r2));
                        } else {
                            bottom =
                            -d2;
                        }
                    }
                } else {
                    if (((r2 < PI))) {
                        bottom = (d2 * sin(r1));
                    } else {
                        if (((r2 < ONE_AND_HALF_PI))) {
                            double b1 = (d2 * sin(r1));
                            double b2 = (d2 * sin(r2));
                            bottom = b1 < b2 ? b1 : b2;
                        } else {
                            if (((r2 < r1))) {
                                bottom = -d2;
                            } else {
                                bottom = (d2 * sin(r1));
                            }
                        }
                    }
                }
            }
        }
        //#ifdef FLIP
        return -bottom;
        //#else
        //	return bottom;
        //#endif
    }
    
    void updateFourPointsWithRotationScale(int seq){
        double r1 = getR1(seq,true),r2 = getR2(seq,true),
        d1 = getD1(true),d2 = getD2(true);
//        assert(r2>r1);
        double& x = _x[seq];double& y = _y[seq];
        double& right = _right[seq]; double& bottom = _bottom[seq];
        if (r1 < 0) {
            if (r2 < HALF_PI) {
                x = d1 * cos(r2);
                y = -d2 * sin(r2);
                right = d2;
                bottom = -d1 * sin(r1);
            }
        }
        else if (r1 < HALF_PI) {
            if (r2 < HALF_PI) {
                    x = d1 * cos(r2);
                    y = -d2 * sin(r2);
                    right = d2 * cos(r1);
                    bottom = -d1 * sin(r1);
                } else if(r2 < PI) {
                    x = (d2 * cos(r2));
                    y = -d2;
                    right = d2 * cos(r1);
                    bottom = PI-r1>r2-PI?-d1 * sin(r1):-d1 * sin(r2);
                } else {
                    x = -d2;
                    y = -d2;
                    right = d2;
                    bottom = d2;
                }
        } else if(r1 < PI) {
            y = -d2 * sin(r1);
            if (r2 < PI) {
                x = d2 * cos(r2);
                right = d1 * cos(r1);
                bottom = -d1 * sin(r2);
            } else if (r2 < ONE_AND_HALF_PI) {
                x = -d2;
                right = PI-r1 > r2-PI ? d1 * cos(r1) : d1 * cos(r2);
                bottom = -d2 * sin(r2);
            } else {
                x = -d2;
                right = (d2 * cos(r2));
                bottom = d2;
            }
        }
        else if (r1 < ONE_AND_HALF_PI) {
            if (r2 < ONE_AND_HALF_PI) {
                x = d2 * cos(r1);
                y = -d1 * sin(r1);
                right = d1 * cos(r2);
                bottom = -d2 * sin(r2);
            } else {
                x = d2 * cos(r1);
                y = ONE_AND_HALF_PI - r1 > r2 - ONE_AND_HALF_PI ? -d1 * sin(r1) : -d1 * sin(r2);
                right = d2 * cos(r2);
                bottom = d2;
            }
        }
        else {
            x = d1 * cos(r1);
            y = -d1 * sin(r2);
            right = d2 * cos(r2);
            bottom = -d2 * sin(r1);
        }
        
        assert(right>x && bottom>y);
    }
    
	inline double getRotation(int seq){
        return this->root->getRotation(seq);
    }
    inline double getScale(){
        return this->root->getScale();
    }
	inline int getCurrentStamp(int seq){
        return this->root->getCurrentStamp(seq);
    }
	inline bool getCurrentDStamp(){
        return this->root->getCurrentDStamp();
    }
	inline PolarRootTree* getRoot(){
        return this->root;
    }
};


#endif

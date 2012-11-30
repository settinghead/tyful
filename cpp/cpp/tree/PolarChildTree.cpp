#include <math.h>

#include "PolarTree.h"
#include "PolarRootTree.h"
#include "PolarTreeBuilder.h"
#include "PolarChildTree.h"
#include "../model/ImageShape.h"
#include "../model/Flip.h"


PolarChildTree::~PolarChildTree() {
}
inline int PolarChildTree::getRootX(int seq) {
	return this->root->getRootX(seq);
}

inline int PolarChildTree::getRootY(int seq) {
	return this->root->getRootY(seq);
}

inline int PolarChildTree::getFinalSeq(){
    return root->getFinalSeq();
}

inline void PolarChildTree::setFinalSeq(int seq){
    root->setFinalSeq(seq);
}


inline double PolarChildTree::computeX(int seq,bool rotate) {
	double x;
	if (((this->getR1(seq,rotate) < HALF_PI))) {
		if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
			x = (this->d2 * cos(PI));
		} else {
			if (((this->getR2(seq,rotate) < HALF_PI))) {
				x = (this->d1 * cos(this->getR2(seq,rotate)));
			} else {
				if (((this->getR2(seq,rotate) < PI))) {
					x = (this->d2 * cos(this->getR2(seq,rotate)));
				} else {
					x = (this->d2 * cos(PI));
				}
			}
		}
	} else {
		if (((this->getR1(seq,rotate) < PI))) {
			if (((this->getR2(seq,rotate) < HALF_PI))) {
				x = (this->d2 * cos(PI));
			} else {
				if (((this->getR2(seq,rotate) < PI))) {
					x = (this->d2 * cos(this->getR2(seq,rotate)));
				} else {
					if (((this->getR2(seq,rotate) < ONE_AND_HALF_PI))) {
						x = (this->d2 * cos(PI));
					} else {
						x = (this->d2 * cos(PI));
					}
				}
			}
		} else {
			if (((this->getR1(seq,rotate) < ONE_AND_HALF_PI))) {
				if (((this->getR2(seq,rotate) < HALF_PI))) {
					x = (this->d2 * cos(this->getR1(seq,rotate)));
				} else {
					if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
						double x1 = (this->d2 * cos(this->getR1(seq,rotate)));
						double x2 = (this->d2 * cos(this->getR2(seq,rotate)));
						x = ((((x1 < x2))) ? double(x1) : double(x2));
					} else {
						if (((this->getR2(seq,rotate)
								< ONE_AND_HALF_PI))) {
							x = (this->d2 * cos(this->getR1(seq,rotate)));
						} else {
							x = (this->d2 * cos(this->getR1(seq,rotate)));
						}
					}
				}
			} else {
				if (((this->getR2(seq,rotate) < HALF_PI))) {
					double xx1 = (this->d1 * cos(this->getR1(seq,rotate)));
					double xx2 = (this->d1 * cos(this->getR2(seq,rotate)));
					x = ((((xx1 < xx2))) ? double(xx1) : double(xx2));
				} else {
					if (((this->getR2(seq,rotate) < PI))) {
						x = (this->d2 * cos(this->getR2(seq,rotate)));
					} else {
						if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
							x = (this->d2 * cos(PI));
						} else {
							x = (this->d1 * cos(this->getR1(seq,rotate)));
						}
					}
				}
			}
		}
	}
	return x;
}

inline double PolarChildTree::computeY(int seq,bool rotate) {
	double y;
	if (((this->getR1(seq,rotate) < HALF_PI))) {
		if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
			y = (this->d1 * sin(HALF_PI));
		} else {
			if (((this->getR2(seq,rotate) < HALF_PI))) {
				y = (this->d2 * sin(this->getR2(seq,rotate)));
			} else {
				if (((this->getR2(seq,rotate) < PI))) {
					y = (this->d2 * sin(HALF_PI));
				} else {
					y = (this->d2 * sin(HALF_PI));
				}
			}
		}
	} else {
		if (((this->getR1(seq,rotate) < PI))) {
			if (((this->getR2(seq,rotate) < HALF_PI))) {
				double y1 = (this->d2 * sin(this->getR1(seq,rotate)));
				double y2 = (this->d2 * sin(this->getR2(seq,rotate)));
				y = ((((y1 > y2))) ? double(y1) : double(y2));
			} else {
				if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
					y = (this->d2 * sin(HALF_PI));
				} else {
					y = (this->d2 * sin(this->getR1(seq,rotate)));
				}
			}
		} else {
			if (((this->getR1(seq,rotate) < ONE_AND_HALF_PI))) {
				if (((this->getR2(seq,rotate) < PI))) {
					y = (this->d2 * sin(HALF_PI));
				} else {
					if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
						y = (this->d1 * sin(this->getR2(seq,rotate)));
					} else {
						if (((this->getR2(seq,rotate)
								< ONE_AND_HALF_PI))) {
							y = (this->d1 * sin(this->getR1(seq,rotate)));
						} else {
							double val1 = (this->d1 * sin(this->getR2(seq,rotate)));
							double val2 = (this->d1 * sin(this->getR1(seq,rotate)));
							y =
									((((val1 > val2))) ?
											double(val1) : double(val2));
						}
					}
				}
			} else {
				if (((this->getR2(seq,rotate) < HALF_PI))) {
					y = (this->d2 * sin(this->getR2(seq,rotate)));
				} else {
					if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
						y = (this->d2 * sin(HALF_PI));
					} else {
						y = (this->d1 * sin(this->getR2(seq,rotate)));
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

inline double PolarChildTree::computeRight(int seq,bool rotate) {
	double right;
	if (((this->getR1(seq,rotate) < HALF_PI))) {
		if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
			right = (this->d2 * cos((int) 0));
		} else {
			if (((this->getR2(seq,rotate) < HALF_PI))) {
				right = (this->d2 * cos(this->getR1(seq,rotate)));
			} else {
				if (((this->getR2(seq,rotate) < PI))) {
					right = (this->d2 * cos(this->getR1(seq,rotate)));
				} else {
					right = (this->d2 * cos((int) 0));
				}
			}
		}
	} else {
		if (((this->getR1(seq,rotate) < PI))) {
			if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
				right = (this->d2 * cos((int) 0));
			} else {
				if (((this->getR2(seq,rotate) < PI))) {
					right = (this->d1 * cos(this->getR1(seq,rotate)));
				} else {
					if (((this->getR2(seq,rotate) < ONE_AND_HALF_PI))) {
						double val1 = (this->d1 * cos(this->getR1(seq,rotate)));
						double val2 = (this->d1 * cos(this->getR2(seq,rotate)));
						right =
								((((val1 > val2))) ? double(val1) : double(val2));
					} else {
						right = (this->d2 * cos(this->getR2(seq,rotate)));
					}
				}
			}
		} else {
			if (((this->getR1(seq,rotate) < ONE_AND_HALF_PI))) {
				if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
					right = (this->d2 * cos((int) 0));
				} else {
					if (((this->getR2(seq,rotate) < ONE_AND_HALF_PI))) {
						right = (this->d1 * cos(this->getR2(seq,rotate)));
					} else {
						right = (this->d2 * cos(this->getR2(seq,rotate)));
					}
				}
			} else {
				if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
					right = (this->d2 * cos((int) 0));
				} else {
					right = (this->d2 * cos(this->getR2(seq,rotate)));
				}
			}
		}
	}
	return right;
}

inline double PolarChildTree::computeBottom(int seq,bool rotate) {
	double bottom;
	if (((this->getR1(seq,rotate) < HALF_PI))) {
		if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
			bottom = (this->d1 * sin(ONE_AND_HALF_PI));
		} else {
			if (((this->getR2(seq,rotate) < HALF_PI))) {
				bottom = (this->d1 * sin(this->getR1(seq,rotate)));
			} else {
				if (((this->getR2(seq,rotate) < PI))) {
					double val1 = (this->d1 * sin(this->getR1(seq,rotate)));
					double val2 = (this->d1 * sin(this->getR2(seq,rotate)));
					bottom = ((((val1 < val2))) ? double(val1) : double(val2));
				} else {
					bottom = (this->d2 * sin(ONE_AND_HALF_PI));
				}
			}
		}
	} else {
		if (((this->getR1(seq,rotate) < PI))) {
			if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
				bottom = (this->d1 * sin(ONE_AND_HALF_PI));
			} else {
				if (((this->getR2(seq,rotate) < PI))) {
					bottom = (this->d1 * sin(this->getR2(seq,rotate)));
				} else {
					if (((this->getR2(seq,rotate) < ONE_AND_HALF_PI))) {
						bottom = (this->d2 * sin(this->getR2(seq,rotate)));
					} else {
						bottom =
								(this->d2 * sin(ONE_AND_HALF_PI));
					}
				}
			}
		} else {
			if (((this->getR1(seq,rotate) < ONE_AND_HALF_PI))) {
				if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
					bottom = (this->d2 * sin(ONE_AND_HALF_PI));
				} else {
					if (((this->getR2(seq,rotate) < ONE_AND_HALF_PI))) {
						bottom = (this->d2 * sin(this->getR2(seq,rotate)));
					} else {
						bottom =
								(this->d2 * sin(ONE_AND_HALF_PI));
					}
				}
			} else {
				if (((this->getR2(seq,rotate) < PI))) {
					bottom = (this->d2 * sin(this->getR1(seq,rotate)));
				} else {
					if (((this->getR2(seq,rotate) < ONE_AND_HALF_PI))) {
						double b1 = (this->d2 * sin(this->getR1(seq,rotate)));
						double b2 = (this->d2 * sin(this->getR2(seq,rotate)));
						bottom = ((((b1 < b2))) ? double(b1) : double(b2));
					} else {
						if (((this->getR2(seq,rotate) < this->getR1(seq,rotate)))) {
							bottom = cos(ONE_AND_HALF_PI);
						} else {
							bottom = (this->d2 * sin(this->getR1(seq,rotate)));
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

inline double PolarChildTree::getRotation(int seq) {
	return this->root->getRotation(seq);
}

inline int PolarChildTree::getCurrentStamp(int seq) {
	return this->root->getCurrentStamp(seq);
}

inline PolarRootTree* PolarChildTree::getRoot() {
	return this->root;
}

inline int PolarChildTree::getMinBoxSize() {
	return this->root->getMinBoxSize();
}

ImageShape* PolarChildTree::getShape() {
	return this->root->getShape();
}


#include <math.h>

#include "PolarTree.h"
#include "PolarRootTree.h"
#include "PolarTreeBuilder.h"
#include "PolarChildTree.h"
#include "ImageShape.h"


PolarChildTree::PolarChildTree(double r1, double r2, double d1,
		double d2, PolarRootTree* root, int minBoxSize) :
		PolarTree::PolarTree(r1, r2, d1, d2, minBoxSize) {
	this->root = root;
}

PolarChildTree::~PolarChildTree() {
}
int PolarChildTree::getRootX() {
	return this->root->getRootX();
}

int PolarChildTree::getRootY() {
	return this->root->getRootY();
}

double PolarChildTree::computeX(bool rotate) {
	double x;
	if (((this->getR1(rotate) < HALF_PI))) {
		if (((this->getR2(rotate) < this->getR1(rotate)))) {
			x = (this->d2 * cos(PI));
		} else {
			if (((this->getR2(rotate) < HALF_PI))) {
				x = (this->d1 * cos(this->getR2(rotate)));
			} else {
				if (((this->getR2(rotate) < PI))) {
					x = (this->d2 * cos(this->getR2(rotate)));
				} else {
					x = (this->d2 * cos(PI));
				}
			}
		}
	} else {
		if (((this->getR1(rotate) < PI))) {
			if (((this->getR2(rotate) < HALF_PI))) {
				x = (this->d2 * cos(PI));
			} else {
				if (((this->getR2(rotate) < PI))) {
					x = (this->d2 * cos(this->getR2(rotate)));
				} else {
					if (((this->getR2(rotate) < ONE_AND_HALF_PI))) {
						x = (this->d2 * cos(PI));
					} else {
						x = (this->d2 * cos(PI));
					}
				}
			}
		} else {
			if (((this->getR1(rotate) < ONE_AND_HALF_PI))) {
				if (((this->getR2(rotate) < HALF_PI))) {
					x = (this->d2 * cos(this->getR1(rotate)));
				} else {
					if (((this->getR2(rotate) < this->getR1(rotate)))) {
						double x1 = (this->d2 * cos(this->getR1(rotate)));
						double x2 = (this->d2 * cos(this->getR2(rotate)));
						x = ((((x1 < x2))) ? double(x1) : double(x2));
					} else {
						if (((this->getR2(rotate)
								< ONE_AND_HALF_PI))) {
							x = (this->d2 * cos(this->getR1(rotate)));
						} else {
							x = (this->d2 * cos(this->getR1(rotate)));
						}
					}
				}
			} else {
				if (((this->getR2(rotate) < HALF_PI))) {
					double xx1 = (this->d1 * cos(this->getR1(rotate)));
					double xx2 = (this->d1 * cos(this->getR2(rotate)));
					x = ((((xx1 < xx2))) ? double(xx1) : double(xx2));
				} else {
					if (((this->getR2(rotate) < PI))) {
						x = (this->d2 * cos(this->getR2(rotate)));
					} else {
						if (((this->getR2(rotate) < this->getR1(rotate)))) {
							x = (this->d2 * cos(PI));
						} else {
							x = (this->d1 * cos(this->getR1(rotate)));
						}
					}
				}
			}
		}
	}
	return x;
}

double PolarChildTree::computeY(bool rotate) {
	double y;
	if (((this->getR1(rotate) < HALF_PI))) {
		if (((this->getR2(rotate) < this->getR1(rotate)))) {
			y = (this->d1 * sin(HALF_PI));
		} else {
			if (((this->getR2(rotate) < HALF_PI))) {
				y = (this->d2 * sin(this->getR2(rotate)));
			} else {
				if (((this->getR2(rotate) < PI))) {
					y = (this->d2 * sin(HALF_PI));
				} else {
					y = (this->d2 * sin(HALF_PI));
				}
			}
		}
	} else {
		if (((this->getR1(rotate) < PI))) {
			if (((this->getR2(rotate) < HALF_PI))) {
				double y1 = (this->d2 * sin(this->getR1(rotate)));
				double y2 = (this->d2 * sin(this->getR2(rotate)));
				y = ((((y1 > y2))) ? double(y1) : double(y2));
			} else {
				if (((this->getR2(rotate) < this->getR1(rotate)))) {
					y = (this->d2 * sin(HALF_PI));
				} else {
					y = (this->d2 * sin(this->getR1(rotate)));
				}
			}
		} else {
			if (((this->getR1(rotate) < ONE_AND_HALF_PI))) {
				if (((this->getR2(rotate) < PI))) {
					y = (this->d2 * sin(HALF_PI));
				} else {
					if (((this->getR2(rotate) < this->getR1(rotate)))) {
						y = (this->d1 * sin(this->getR2(rotate)));
					} else {
						if (((this->getR2(rotate)
								< ONE_AND_HALF_PI))) {
							y = (this->d1 * sin(this->getR1(rotate)));
						} else {
							double val1 = (this->d1 * sin(this->getR2(rotate)));
							double val2 = (this->d1 * sin(this->getR1(rotate)));
							y =
									((((val1 > val2))) ?
											double(val1) : double(val2));
						}
					}
				}
			} else {
				if (((this->getR2(rotate) < HALF_PI))) {
					y = (this->d2 * sin(this->getR2(rotate)));
				} else {
					if (((this->getR2(rotate) < this->getR1(rotate)))) {
						y = (this->d2 * sin(HALF_PI));
					} else {
						y = (this->d1 * sin(this->getR2(rotate)));
					}
				}
			}
		}
	}
	y = -(y);
	return y;
}

double PolarChildTree::computeRight(bool rotate) {
	double right;
	if (((this->getR1(rotate) < HALF_PI))) {
		if (((this->getR2(rotate) < this->getR1(rotate)))) {
			right = (this->d2 * cos((int) 0));
		} else {
			if (((this->getR2(rotate) < HALF_PI))) {
				right = (this->d2 * cos(this->getR1(rotate)));
			} else {
				if (((this->getR2(rotate) < PI))) {
					right = (this->d2 * cos(this->getR1(rotate)));
				} else {
					right = (this->d2 * cos((int) 0));
				}
			}
		}
	} else {
		if (((this->getR1(rotate) < PI))) {
			if (((this->getR2(rotate) < this->getR1(rotate)))) {
				right = (this->d2 * cos((int) 0));
			} else {
				if (((this->getR2(rotate) < PI))) {
					right = (this->d1 * cos(this->getR1(rotate)));
				} else {
					if (((this->getR2(rotate) < ONE_AND_HALF_PI))) {
						double val1 = (this->d1 * cos(this->getR1(rotate)));
						double val2 = (this->d1 * cos(this->getR2(rotate)));
						right =
								((((val1 > val2))) ? double(val1) : double(val2));
					} else {
						right = (this->d2 * cos(this->getR2(rotate)));
					}
				}
			}
		} else {
			if (((this->getR1(rotate) < ONE_AND_HALF_PI))) {
				if (((this->getR2(rotate) < this->getR1(rotate)))) {
					right = (this->d2 * cos((int) 0));
				} else {
					if (((this->getR2(rotate) < ONE_AND_HALF_PI))) {
						right = (this->d1 * cos(this->getR2(rotate)));
					} else {
						right = (this->d2 * cos(this->getR2(rotate)));
					}
				}
			} else {
				if (((this->getR2(rotate) < this->getR1(rotate)))) {
					right = (this->d2 * cos((int) 0));
				} else {
					right = (this->d2 * cos(this->getR2(rotate)));
				}
			}
		}
	}
	return right;
}

double PolarChildTree::computeBottom(bool rotate) {
	double bottom;
	if (((this->getR1(rotate) < HALF_PI))) {
		if (((this->getR2(rotate) < this->getR1(rotate)))) {
			bottom = (this->d1 * sin(ONE_AND_HALF_PI));
		} else {
			if (((this->getR2(rotate) < HALF_PI))) {
				bottom = (this->d1 * sin(this->getR1(rotate)));
			} else {
				if (((this->getR2(rotate) < PI))) {
					double val1 = (this->d1 * sin(this->getR1(rotate)));
					double val2 = (this->d1 * sin(this->getR2(rotate)));
					bottom = ((((val1 < val2))) ? double(val1) : double(val2));
				} else {
					bottom = (this->d2 * sin(ONE_AND_HALF_PI));
				}
			}
		}
	} else {
		if (((this->getR1(rotate) < PI))) {
			if (((this->getR2(rotate) < this->getR1(rotate)))) {
				bottom = (this->d1 * sin(ONE_AND_HALF_PI));
			} else {
				if (((this->getR2(rotate) < PI))) {
					bottom = (this->d1 * sin(this->getR2(rotate)));
				} else {
					if (((this->getR2(rotate) < ONE_AND_HALF_PI))) {
						bottom = (this->d2 * sin(this->getR2(rotate)));
					} else {
						bottom =
								(this->d2 * sin(ONE_AND_HALF_PI));
					}
				}
			}
		} else {
			if (((this->getR1(rotate) < ONE_AND_HALF_PI))) {
				if (((this->getR2(rotate) < this->getR1(rotate)))) {
					bottom = (this->d2 * sin(ONE_AND_HALF_PI));
				} else {
					if (((this->getR2(rotate) < ONE_AND_HALF_PI))) {
						bottom = (this->d2 * sin(this->getR2(rotate)));
					} else {
						bottom =
								(this->d2 * sin(ONE_AND_HALF_PI));
					}
				}
			} else {
				if (((this->getR2(rotate) < PI))) {
					bottom = (this->d2 * sin(this->getR1(rotate)));
				} else {
					if (((this->getR2(rotate) < ONE_AND_HALF_PI))) {
						double b1 = (this->d2 * sin(this->getR1(rotate)));
						double b2 = (this->d2 * sin(this->getR2(rotate)));
						bottom = ((((b1 < b2))) ? double(b1) : double(b2));
					} else {
						if (((this->getR2(rotate) < this->getR1(rotate)))) {
							bottom = cos(ONE_AND_HALF_PI);
						} else {
							bottom = (this->d2 * sin(this->getR1(rotate)));
						}
					}
				}
			}
		}
	}
	bottom = -(bottom);
	return bottom;
}

double PolarChildTree::getRotation() {
	return this->root->getRotation();
}

int PolarChildTree::getCurrentStamp() {
	return this->root->getCurrentStamp();
}

PolarRootTree* PolarChildTree::getRoot() {
	return this->root;
}

int PolarChildTree::getMinBoxSize() {
	return this->root->getMinBoxSize();
}

ImageShape* PolarChildTree::getShape() {
	return this->root->getShape();
}


#include <hxcpp.h>

#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_polartree_BBPolarChildTreeVO
#include <polartree/BBPolarChildTreeVO.h>
#endif
#ifndef INCLUDED_polartree_BBPolarRootTreeVO
#include <polartree/BBPolarRootTreeVO.h>
#endif
#ifndef INCLUDED_polartree_BBPolarTreeVO
#include <polartree/BBPolarTreeVO.h>
#endif
#ifndef INCLUDED_polartree_IImageShape
#include <polartree/IImageShape.h>
#endif
namespace polartree{

Void BBPolarChildTreeVO_obj::__construct(double r1,double r2,double d1,double d2,::polartree::BBPolarRootTreeVO root,int minBoxSize)
{
{
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",9)
	super::__construct(r1,r2,d1,d2,minBoxSize);
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",10)
	this->root = root;
}
;
	return null();
}

BBPolarChildTreeVO_obj::~BBPolarChildTreeVO_obj() { }

Dynamic BBPolarChildTreeVO_obj::__CreateEmpty() { return  new BBPolarChildTreeVO_obj; }
hx::ObjectPtr< BBPolarChildTreeVO_obj > BBPolarChildTreeVO_obj::__new(double r1,double r2,double d1,double d2,::polartree::BBPolarRootTreeVO root,int minBoxSize)
{  hx::ObjectPtr< BBPolarChildTreeVO_obj > result = new BBPolarChildTreeVO_obj();
	result->__construct(r1,r2,d1,d2,root,minBoxSize);
	return result;}

Dynamic BBPolarChildTreeVO_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BBPolarChildTreeVO_obj > result = new BBPolarChildTreeVO_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4],inArgs[5]);
	return result;}

int BBPolarChildTreeVO_obj::getRootX( ){
	HX_SOURCE_PUSH("BBPolarChildTreeVO_obj::getRootX")
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",14)
	return this->root->getRootX();
}


int BBPolarChildTreeVO_obj::getRootY( ){
	HX_SOURCE_PUSH("BBPolarChildTreeVO_obj::getRootY")
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",19)
	return this->root->getRootY();
}


double BBPolarChildTreeVO_obj::computeX( bool rotate){
	HX_SOURCE_PUSH("BBPolarChildTreeVO_obj::computeX")
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",25)
	double x;
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",26)
	if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
		HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",26)
		if (((this->getR2(rotate) < this->getR1(rotate)))){
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",27)
			x = (this->d2 * ::Math_obj::cos(::polartree::BBPolarTreeVO_obj::PI));
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",29)
			if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",29)
				x = (this->d1 * ::Math_obj::cos(this->getR2(rotate)));
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",31)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",31)
					x = (this->d2 * ::Math_obj::cos(this->getR2(rotate)));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",33)
					x = (this->d2 * ::Math_obj::cos(::polartree::BBPolarTreeVO_obj::PI));
				}
			}
		}
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",37)
		if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",37)
			if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",38)
				x = (this->d2 * ::Math_obj::cos(::polartree::BBPolarTreeVO_obj::PI));
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",40)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",40)
					x = (this->d2 * ::Math_obj::cos(this->getR2(rotate)));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",42)
					if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",42)
						x = (this->d2 * ::Math_obj::cos(::polartree::BBPolarTreeVO_obj::PI));
					}
					else{
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",44)
						x = (this->d2 * ::Math_obj::cos(::polartree::BBPolarTreeVO_obj::PI));
					}
				}
			}
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",47)
			if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",47)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",48)
					x = (this->d2 * ::Math_obj::cos(this->getR1(rotate)));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",50)
					if (((this->getR2(rotate) < this->getR1(rotate)))){
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",51)
						double x1 = (this->d2 * ::Math_obj::cos(this->getR1(rotate)));
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",52)
						double x2 = (this->d2 * ::Math_obj::cos(this->getR2(rotate)));
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",53)
						x = (  (((x1 < x2))) ? double(x1) : double(x2) );
					}
					else{
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",54)
						if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
							HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",54)
							x = (this->d2 * ::Math_obj::cos(this->getR1(rotate)));
						}
						else{
							HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",56)
							x = (this->d2 * ::Math_obj::cos(this->getR1(rotate)));
						}
					}
				}
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",59)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",61)
					double xx1 = (this->d1 * ::Math_obj::cos(this->getR1(rotate)));
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",62)
					double xx2 = (this->d1 * ::Math_obj::cos(this->getR2(rotate)));
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",63)
					x = (  (((xx1 < xx2))) ? double(xx1) : double(xx2) );
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",64)
					if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",64)
						x = (this->d2 * ::Math_obj::cos(this->getR2(rotate)));
					}
					else{
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",66)
						if (((this->getR2(rotate) < this->getR1(rotate)))){
							HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",66)
							x = (this->d2 * ::Math_obj::cos(::polartree::BBPolarTreeVO_obj::PI));
						}
						else{
							HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",69)
							x = (this->d1 * ::Math_obj::cos(this->getR1(rotate)));
						}
					}
				}
			}
		}
	}
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",71)
	return x;
}


double BBPolarChildTreeVO_obj::computeY( bool rotate){
	HX_SOURCE_PUSH("BBPolarChildTreeVO_obj::computeY")
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",76)
	double y;
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",77)
	if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
		HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",77)
		if (((this->getR2(rotate) < this->getR1(rotate)))){
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",78)
			y = (this->d1 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::HALF_PI));
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",80)
			if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",80)
				y = (this->d2 * ::Math_obj::sin(this->getR2(rotate)));
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",82)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",82)
					y = (this->d2 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::HALF_PI));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",84)
					y = (this->d2 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::HALF_PI));
				}
			}
		}
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",88)
		if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",88)
			if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",90)
				double y1 = (this->d2 * ::Math_obj::sin(this->getR1(rotate)));
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",91)
				double y2 = (this->d2 * ::Math_obj::sin(this->getR2(rotate)));
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",92)
				y = (  (((y1 > y2))) ? double(y1) : double(y2) );
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",93)
				if (((this->getR2(rotate) < this->getR1(rotate)))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",94)
					y = (this->d2 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::HALF_PI));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",96)
					y = (this->d2 * ::Math_obj::sin(this->getR1(rotate)));
				}
			}
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",97)
			if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",97)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",98)
					y = (this->d2 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::HALF_PI));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",100)
					if (((this->getR2(rotate) < this->getR1(rotate)))){
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",100)
						y = (this->d1 * ::Math_obj::sin(this->getR2(rotate)));
					}
					else{
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",102)
						if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
							HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",102)
							y = (this->d1 * ::Math_obj::sin(this->getR1(rotate)));
						}
						else{
							HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",105)
							double val1 = (this->d1 * ::Math_obj::sin(this->getR2(rotate)));
							HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",106)
							double val2 = (this->d1 * ::Math_obj::sin(this->getR1(rotate)));
							HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",107)
							y = (  (((val1 > val2))) ? double(val1) : double(val2) );
						}
					}
				}
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",110)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",111)
					y = (this->d2 * ::Math_obj::sin(this->getR2(rotate)));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",113)
					if (((this->getR2(rotate) < this->getR1(rotate)))){
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",113)
						y = (this->d2 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::HALF_PI));
					}
					else{
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",116)
						y = (this->d1 * ::Math_obj::sin(this->getR2(rotate)));
					}
				}
			}
		}
	}
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",118)
	y = -(y);
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",119)
	return y;
}


double BBPolarChildTreeVO_obj::computeRight( bool rotate){
	HX_SOURCE_PUSH("BBPolarChildTreeVO_obj::computeRight")
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",124)
	double right;
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",125)
	if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
		HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",125)
		if (((this->getR2(rotate) < this->getR1(rotate)))){
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",126)
			right = (this->d2 * ::Math_obj::cos((int)0));
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",128)
			if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",128)
				right = (this->d2 * ::Math_obj::cos(this->getR1(rotate)));
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",130)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",130)
					right = (this->d2 * ::Math_obj::cos(this->getR1(rotate)));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",132)
					right = (this->d2 * ::Math_obj::cos((int)0));
				}
			}
		}
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",136)
		if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",136)
			if (((this->getR2(rotate) < this->getR1(rotate)))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",137)
				right = (this->d2 * ::Math_obj::cos((int)0));
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",139)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",139)
					right = (this->d1 * ::Math_obj::cos(this->getR1(rotate)));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",141)
					if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",142)
						double val1 = (this->d1 * ::Math_obj::cos(this->getR1(rotate)));
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",143)
						double val2 = (this->d1 * ::Math_obj::cos(this->getR2(rotate)));
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",144)
						right = (  (((val1 > val2))) ? double(val1) : double(val2) );
					}
					else{
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",145)
						right = (this->d2 * ::Math_obj::cos(this->getR2(rotate)));
					}
				}
			}
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",148)
			if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",148)
				if (((this->getR2(rotate) < this->getR1(rotate)))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",149)
					right = (this->d2 * ::Math_obj::cos((int)0));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",151)
					if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",151)
						right = (this->d1 * ::Math_obj::cos(this->getR2(rotate)));
					}
					else{
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",153)
						right = (this->d2 * ::Math_obj::cos(this->getR2(rotate)));
					}
				}
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",157)
				if (((this->getR2(rotate) < this->getR1(rotate)))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",158)
					right = (this->d2 * ::Math_obj::cos((int)0));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",161)
					right = (this->d2 * ::Math_obj::cos(this->getR2(rotate)));
				}
			}
		}
	}
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",164)
	return right;
}


double BBPolarChildTreeVO_obj::computeBottom( bool rotate){
	HX_SOURCE_PUSH("BBPolarChildTreeVO_obj::computeBottom")
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",170)
	double bottom;
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",171)
	if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
		HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",171)
		if (((this->getR2(rotate) < this->getR1(rotate)))){
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",172)
			bottom = (this->d1 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI));
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",174)
			if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::HALF_PI))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",174)
				bottom = (this->d1 * ::Math_obj::sin(this->getR1(rotate)));
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",176)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",177)
					double val1 = (this->d1 * ::Math_obj::sin(this->getR1(rotate)));
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",178)
					double val2 = (this->d1 * ::Math_obj::sin(this->getR2(rotate)));
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",179)
					bottom = (  (((val1 < val2))) ? double(val1) : double(val2) );
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",180)
					bottom = (this->d2 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI));
				}
			}
		}
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",184)
		if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",184)
			if (((this->getR2(rotate) < this->getR1(rotate)))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",185)
				bottom = (this->d1 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI));
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",187)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",187)
					bottom = (this->d1 * ::Math_obj::sin(this->getR2(rotate)));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",189)
					if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",189)
						bottom = (this->d2 * ::Math_obj::sin(this->getR2(rotate)));
					}
					else{
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",191)
						bottom = (this->d2 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI));
					}
				}
			}
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",194)
			if (((this->getR1(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",194)
				if (((this->getR2(rotate) < this->getR1(rotate)))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",195)
					bottom = (this->d2 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",197)
					if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",197)
						bottom = (this->d2 * ::Math_obj::sin(this->getR2(rotate)));
					}
					else{
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",199)
						bottom = (this->d2 * ::Math_obj::sin(::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI));
					}
				}
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",203)
				if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::PI))){
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",204)
					bottom = (this->d2 * ::Math_obj::sin(this->getR1(rotate)));
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",206)
					if (((this->getR2(rotate) < ::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI))){
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",207)
						double b1 = (this->d2 * ::Math_obj::sin(this->getR1(rotate)));
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",208)
						double b2 = (this->d2 * ::Math_obj::sin(this->getR2(rotate)));
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",209)
						bottom = (  (((b1 < b2))) ? double(b1) : double(b2) );
					}
					else{
						HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",210)
						if (((this->getR2(rotate) < this->getR1(rotate)))){
							HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",210)
							bottom = ::Math_obj::cos(::polartree::BBPolarTreeVO_obj::ONE_AND_HALF_PI);
						}
						else{
							HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",213)
							bottom = (this->d2 * ::Math_obj::sin(this->getR1(rotate)));
						}
					}
				}
			}
		}
	}
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",215)
	bottom = -(bottom);
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",216)
	return bottom;
}


double BBPolarChildTreeVO_obj::getRotation( ){
	HX_SOURCE_PUSH("BBPolarChildTreeVO_obj::getRotation")
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",220)
	return this->root->getRotation();
}


int BBPolarChildTreeVO_obj::getCurrentStamp( ){
	HX_SOURCE_PUSH("BBPolarChildTreeVO_obj::getCurrentStamp")
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",225)
	return this->root->getCurrentStamp();
}


::polartree::BBPolarRootTreeVO BBPolarChildTreeVO_obj::getRoot( ){
	HX_SOURCE_PUSH("BBPolarChildTreeVO_obj::getRoot")
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",229)
	return this->root;
}


int BBPolarChildTreeVO_obj::getMinBoxSize( ){
	HX_SOURCE_PUSH("BBPolarChildTreeVO_obj::getMinBoxSize")
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",234)
	return this->root->getMinBoxSize();
}


::polartree::IImageShape BBPolarChildTreeVO_obj::getShape( ){
	HX_SOURCE_PUSH("BBPolarChildTreeVO_obj::getShape")
	HX_SOURCE_POS("polartree/BBPolarChildTreeVO.hx",239)
	return this->root->getShape();
}



BBPolarChildTreeVO_obj::BBPolarChildTreeVO_obj()
{
}

void BBPolarChildTreeVO_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BBPolarChildTreeVO);
	HX_MARK_MEMBER_NAME(root,"root");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic BBPolarChildTreeVO_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"root") ) { return root; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"getRoot") ) { return getRoot_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"getRootX") ) { return getRootX_dyn(); }
		if (HX_FIELD_EQ(inName,"getRootY") ) { return getRootY_dyn(); }
		if (HX_FIELD_EQ(inName,"computeX") ) { return computeX_dyn(); }
		if (HX_FIELD_EQ(inName,"computeY") ) { return computeY_dyn(); }
		if (HX_FIELD_EQ(inName,"getShape") ) { return getShape_dyn(); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"getRotation") ) { return getRotation_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"computeRight") ) { return computeRight_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"computeBottom") ) { return computeBottom_dyn(); }
		if (HX_FIELD_EQ(inName,"getMinBoxSize") ) { return getMinBoxSize_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"getCurrentStamp") ) { return getCurrentStamp_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BBPolarChildTreeVO_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"root") ) { root=inValue.Cast< ::polartree::BBPolarRootTreeVO >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BBPolarChildTreeVO_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("root"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("root"),
	HX_CSTRING("getRootX"),
	HX_CSTRING("getRootY"),
	HX_CSTRING("computeX"),
	HX_CSTRING("computeY"),
	HX_CSTRING("computeRight"),
	HX_CSTRING("computeBottom"),
	HX_CSTRING("getRotation"),
	HX_CSTRING("getCurrentStamp"),
	HX_CSTRING("getRoot"),
	HX_CSTRING("getMinBoxSize"),
	HX_CSTRING("getShape"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class BBPolarChildTreeVO_obj::__mClass;

void BBPolarChildTreeVO_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("polartree.BBPolarChildTreeVO"), hx::TCanCast< BBPolarChildTreeVO_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void BBPolarChildTreeVO_obj::__boot()
{
}

} // end namespace polartree

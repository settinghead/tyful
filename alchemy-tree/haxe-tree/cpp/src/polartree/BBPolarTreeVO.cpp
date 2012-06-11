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
#ifndef INCLUDED_polartree_BBPolarTreeBuilder
#include <polartree/BBPolarTreeBuilder.h>
#endif
#ifndef INCLUDED_polartree_BBPolarTreeVO
#include <polartree/BBPolarTreeVO.h>
#endif
#ifndef INCLUDED_polartree_ImageShape
#include <polartree/ImageShape.h>
#endif
namespace polartree{

Void BBPolarTreeVO_obj::__construct(double r1,double r2,double d1,double d2,int minBoxSize)
{
{
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",31)
	this->_computedR1 = ::Math_obj::NaN;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",32)
	this->_computedR2 = ::Math_obj::NaN;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",33)
	this->swelling = (int)0;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",34)
	this->_leaf = false;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",35)
	this->_r1 = r1;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",36)
	this->_r2 = r2;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",37)
	this->d1 = d1;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",38)
	this->d2 = d2;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",40)
	this->_relativeX = ::Math_obj::NaN;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",41)
	this->_relativeY = ::Math_obj::NaN;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",42)
	this->_relativeRight = ::Math_obj::NaN;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",43)
	this->_relativeBottom = ::Math_obj::NaN;
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",45)
	double r = (r2 - r1);
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",46)
	double d = (double(((::polartree::BBPolarTreeVO_obj::PI * ((d1 + d2))) * r)) / double(::polartree::BBPolarTreeVO_obj::TWO_PI));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",48)
	bool tooSmallToContinue = (bool((d <= minBoxSize)) || bool(((d2 - d1) <= minBoxSize)));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",51)
	if ((tooSmallToContinue)){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",52)
		this->setLeaf(true);
	}
}
;
	return null();
}

BBPolarTreeVO_obj::~BBPolarTreeVO_obj() { }

Dynamic BBPolarTreeVO_obj::__CreateEmpty() { return  new BBPolarTreeVO_obj; }
hx::ObjectPtr< BBPolarTreeVO_obj > BBPolarTreeVO_obj::__new(double r1,double r2,double d1,double d2,int minBoxSize)
{  hx::ObjectPtr< BBPolarTreeVO_obj > result = new BBPolarTreeVO_obj();
	result->__construct(r1,r2,d1,d2,minBoxSize);
	return result;}

Dynamic BBPolarTreeVO_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BBPolarTreeVO_obj > result = new BBPolarTreeVO_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

Void BBPolarTreeVO_obj::addKids( Array< ::polartree::BBPolarChildTreeVO > kidList){
{
		HX_SOURCE_PUSH("BBPolarTreeVO_obj::addKids")
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",55)
		this->_kids = kidList;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,addKids,(void))

int BBPolarTreeVO_obj::getRootX( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getRootX")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",60)
	hx::Throw (HX_CSTRING("NotImplementedError"));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",61)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getRootX,return )

int BBPolarTreeVO_obj::getRootY( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getRootY")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",65)
	hx::Throw (HX_CSTRING("NotImplementedError"));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",66)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getRootY,return )

bool BBPolarTreeVO_obj::overlaps( ::polartree::BBPolarTreeVO otherTree){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::overlaps")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",71)
	if ((this->collide(otherTree))){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",71)
		if (((bool(this->isLeaf()) && bool(otherTree->isLeaf())))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",72)
			return true;
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",74)
			if ((this->isLeaf())){
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",75)
				int _g = (int)0;
				Array< ::polartree::BBPolarChildTreeVO > _g1 = otherTree->getKids();
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",75)
				while(((_g < _g1->length))){
					HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",75)
					::polartree::BBPolarChildTreeVO otherKid = _g1->__get(_g);
					HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",75)
					++(_g);
					HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",76)
					if ((this->overlaps(otherKid))){
						HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",76)
						return true;
					}
				}
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",81)
				int _g = (int)0;
				Array< ::polartree::BBPolarChildTreeVO > _g1 = this->getKids();
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",81)
				while(((_g < _g1->length))){
					HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",81)
					::polartree::BBPolarChildTreeVO myKid = _g1->__get(_g);
					HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",81)
					++(_g);
					HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",82)
					if ((otherTree->overlaps(myKid))){
						HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",82)
						return true;
					}
				}
			}
		}
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",88)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,overlaps,return )

Array< ::polartree::BBPolarChildTreeVO > BBPolarTreeVO_obj::getKids( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getKids")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",92)
	if (((bool(!(this->isLeaf())) && bool((this->_kids == null()))))){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",93)
		::polartree::BBPolarTreeBuilder_obj::makeChildren(hx::ObjectPtr<OBJ_>(this),this->getShape(),this->getMinBoxSize(),this->getRoot());
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",95)
	return this->_kids;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getKids,return )

Array< ::polartree::BBPolarChildTreeVO > BBPolarTreeVO_obj::getKidsNoGrowth( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getKidsNoGrowth")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",98)
	return this->_kids;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getKidsNoGrowth,return )

::polartree::BBPolarRootTreeVO BBPolarTreeVO_obj::getRoot( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getRoot")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",103)
	hx::Throw (HX_CSTRING("NotImplementedError"));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",104)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getRoot,return )

int BBPolarTreeVO_obj::getMinBoxSize( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getMinBoxSize")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",108)
	hx::Throw (HX_CSTRING("NotImplementedError"));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",109)
	return (int)0;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getMinBoxSize,return )

::polartree::ImageShape BBPolarTreeVO_obj::getShape( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getShape")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",113)
	hx::Throw (HX_CSTRING("NotImplementedError"));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",114)
	return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getShape,return )

bool BBPolarTreeVO_obj::overlapsCoord( double x,double y,double right,double bottom){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::overlapsCoord")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",119)
	if ((this->rectCollideCoord(x,y,right,bottom))){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",119)
		if ((this->isLeaf())){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",120)
			return true;
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",123)
			int _g = (int)0;
			Array< ::polartree::BBPolarChildTreeVO > _g1 = this->getKids();
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",123)
			while(((_g < _g1->length))){
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",123)
				::polartree::BBPolarChildTreeVO myKid = _g1->__get(_g);
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",123)
				++(_g);
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",124)
				if ((myKid->overlapsCoord(x,y,right,bottom))){
					HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",124)
					return true;
				}
			}
		}
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",130)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC4(BBPolarTreeVO_obj,overlapsCoord,return )

bool BBPolarTreeVO_obj::contains( double x,double y,double right,double bottom){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::contains")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",133)
	if ((this->rectContain(x,y,right,bottom))){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",135)
		if ((this->isLeaf())){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",137)
			return true;
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",139)
			{
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",139)
				int _g = (int)0;
				Array< ::polartree::BBPolarChildTreeVO > _g1 = this->getKids();
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",139)
				while(((_g < _g1->length))){
					HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",139)
					::polartree::BBPolarChildTreeVO myKid = _g1->__get(_g);
					HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",139)
					++(_g);
					HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",140)
					if ((myKid->contains(x,y,right,bottom))){
						HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",140)
						return true;
					}
				}
			}
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",144)
			return false;
		}
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",147)
		return false;
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",133)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC4(BBPolarTreeVO_obj,contains,return )

double BBPolarTreeVO_obj::computeX( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::computeX")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",150)
	hx::Throw (HX_CSTRING("NotImplementedError"));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",150)
	return ::Math_obj::NaN;
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,computeX,return )

double BBPolarTreeVO_obj::computeY( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::computeY")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",151)
	hx::Throw (HX_CSTRING("NotImplementedError"));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",151)
	return ::Math_obj::NaN;
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,computeY,return )

double BBPolarTreeVO_obj::computeRight( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::computeRight")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",152)
	hx::Throw (HX_CSTRING("NotImplementedError"));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",152)
	return ::Math_obj::NaN;
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,computeRight,return )

double BBPolarTreeVO_obj::computeBottom( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::computeBottom")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",153)
	hx::Throw (HX_CSTRING("NotImplementedError"));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",153)
	return ::Math_obj::NaN;
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,computeBottom,return )

double BBPolarTreeVO_obj::getR1( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getR1")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",155)
	if ((rotate)){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",157)
		this->checkRecompute();
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",158)
		return this->_computedR1;
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",160)
		return this->_r1;
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",155)
	return 0.;
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,getR1,return )

double BBPolarTreeVO_obj::getR2( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getR2")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",163)
	if ((rotate)){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",165)
		this->checkRecompute();
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",166)
		return this->_computedR2;
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",168)
		return this->_r2;
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",163)
	return 0.;
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,getR2,return )

Void BBPolarTreeVO_obj::checkRecompute( ){
{
		HX_SOURCE_PUSH("BBPolarTreeVO_obj::checkRecompute")
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",171)
		if (((this->rStamp != this->getCurrentStamp()))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",173)
			this->computeR1();
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",174)
			this->computeR2();
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",175)
			this->rStamp = this->getCurrentStamp();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,checkRecompute,(void))

Void BBPolarTreeVO_obj::computeR1( ){
{
		HX_SOURCE_PUSH("BBPolarTreeVO_obj::computeR1")
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",180)
		this->_computedR1 = (this->_r1 + this->getRotation());
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",181)
		if (((this->_computedR1 > ::polartree::BBPolarTreeVO_obj::TWO_PI))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",182)
			this->_computedR1 = hx::Mod(this->_computedR1,::polartree::BBPolarTreeVO_obj::TWO_PI);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,computeR1,(void))

Void BBPolarTreeVO_obj::computeR2( ){
{
		HX_SOURCE_PUSH("BBPolarTreeVO_obj::computeR2")
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",187)
		this->_computedR2 = (this->_r2 + this->getRotation());
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",188)
		if (((this->_computedR2 > ::polartree::BBPolarTreeVO_obj::TWO_PI))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",189)
			this->_computedR2 = hx::Mod(this->_computedR2,::polartree::BBPolarTreeVO_obj::TWO_PI);
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,computeR2,(void))

Void BBPolarTreeVO_obj::checkUpdatePoints( ){
{
		HX_SOURCE_PUSH("BBPolarTreeVO_obj::checkUpdatePoints")
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",193)
		if (((this->pointsStamp != this->getCurrentStamp()))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",195)
			this->_px = ((this->getRootX() - this->swelling) + this->getX(true));
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",196)
			this->_py = ((this->getRootY() - this->swelling) + this->getY(true));
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",197)
			this->_pright = ((this->getRootX() + this->swelling) + this->getRight(true));
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",198)
			this->_pbottom = ((this->getRootY() + this->swelling) + this->getBottom(true));
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",199)
			this->pointsStamp = this->getCurrentStamp();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,checkUpdatePoints,(void))

double BBPolarTreeVO_obj::px( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::px")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",214)
	this->checkUpdatePoints();
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",215)
	return this->_px;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,px,return )

double BBPolarTreeVO_obj::py( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::py")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",219)
	this->checkUpdatePoints();
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",220)
	return this->_py;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,py,return )

double BBPolarTreeVO_obj::pright( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::pright")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",224)
	this->checkUpdatePoints();
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",225)
	return this->_pright;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,pright,return )

double BBPolarTreeVO_obj::pbottom( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::pbottom")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",229)
	this->checkUpdatePoints();
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",230)
	return this->_pbottom;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,pbottom,return )

bool BBPolarTreeVO_obj::collide( ::polartree::BBPolarTreeVO bTree){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::collide")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",235)
	double dist = ::Math_obj::sqrt((::Math_obj::pow((this->getRootX() - bTree->getRootX()),(int)2) + ::Math_obj::pow((this->getRootY() - bTree->getRootY()),(int)2)));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",236)
	if (((dist > (this->d2 + bTree->d2)))){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",236)
		return false;
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",238)
		return this->rectCollide(bTree);
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",236)
	return false;
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,collide,return )

bool BBPolarTreeVO_obj::rectCollide( ::polartree::BBPolarTreeVO bTree){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::rectCollide")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",254)
	return this->rectCollideCoord(bTree->px(),bTree->py(),bTree->pright(),bTree->pbottom());
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,rectCollide,return )

bool BBPolarTreeVO_obj::rectContain( double x,double y,double right,double bottom){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::rectContain")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",258)
	return (bool((bool((bool((this->px() <= x)) && bool((this->py() <= y)))) && bool((this->pright() >= right)))) && bool((this->pbottom() >= bottom)));
}


HX_DEFINE_DYNAMIC_FUNC4(BBPolarTreeVO_obj,rectContain,return )

bool BBPolarTreeVO_obj::rectCollideCoord( double x,double y,double right,double bottom){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::rectCollideCoord")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",262)
	return (bool((bool((bool((this->pbottom() > y)) && bool((this->py() < bottom)))) && bool((this->pright() > x)))) && bool((this->px() < right)));
}


HX_DEFINE_DYNAMIC_FUNC4(BBPolarTreeVO_obj,rectCollideCoord,return )

bool BBPolarTreeVO_obj::isLeaf( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::isLeaf")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",268)
	return this->_leaf;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,isLeaf,return )

Void BBPolarTreeVO_obj::swell( int extra){
{
		HX_SOURCE_PUSH("BBPolarTreeVO_obj::swell")
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",275)
		hx::AddEq(this->swelling,extra);
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",276)
		if ((!(this->isLeaf()))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",277)
			int i = (int)0;
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",278)
			while(((i < this->getKids()->length))){
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",279)
				this->getKids()->__get(i)->swell(extra);
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",280)
				(i)++;
			}
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,swell,(void))

double BBPolarTreeVO_obj::getWidth( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getWidth")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",287)
	return (this->getRight(rotate) - this->getX(rotate));
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,getWidth,return )

double BBPolarTreeVO_obj::getHeight( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getHeight")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",291)
	return (this->getBottom(rotate) - this->getY(rotate));
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,getHeight,return )

Void BBPolarTreeVO_obj::checkComputeX( ){
{
		HX_SOURCE_PUSH("BBPolarTreeVO_obj::checkComputeX")
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",300)
		if (((this->xStamp != this->getCurrentStamp()))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",302)
			this->_x = this->computeX(true);
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",303)
			this->xStamp = this->getCurrentStamp();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,checkComputeX,(void))

Void BBPolarTreeVO_obj::checkComputeY( ){
{
		HX_SOURCE_PUSH("BBPolarTreeVO_obj::checkComputeY")
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",307)
		if (((this->yStamp != this->getCurrentStamp()))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",309)
			this->_y = this->computeY(true);
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",310)
			this->yStamp = this->getCurrentStamp();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,checkComputeY,(void))

Void BBPolarTreeVO_obj::checkComputeRight( ){
{
		HX_SOURCE_PUSH("BBPolarTreeVO_obj::checkComputeRight")
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",315)
		if (((this->rightStamp != this->getCurrentStamp()))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",317)
			this->_right = this->computeRight(true);
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",318)
			this->rightStamp = this->getCurrentStamp();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,checkComputeRight,(void))

Void BBPolarTreeVO_obj::checkComputeBottom( ){
{
		HX_SOURCE_PUSH("BBPolarTreeVO_obj::checkComputeBottom")
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",322)
		if (((this->bottomStamp != this->getCurrentStamp()))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",324)
			this->_bottom = this->computeBottom(true);
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",325)
			this->bottomStamp = this->getCurrentStamp();
		}
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,checkComputeBottom,(void))

double BBPolarTreeVO_obj::getRelativeX( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getRelativeX")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",330)
	if ((::Math_obj::isNaN(this->_relativeX))){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",331)
		this->_relativeX = this->computeX(false);
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",332)
	return this->_relativeX;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getRelativeX,return )

double BBPolarTreeVO_obj::getRelativeY( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getRelativeY")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",336)
	if ((::Math_obj::isNaN(this->_relativeY))){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",337)
		this->_relativeY = this->computeY(false);
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",338)
	return this->_relativeY;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getRelativeY,return )

double BBPolarTreeVO_obj::getRelativeRight( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getRelativeRight")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",342)
	if ((::Math_obj::isNaN(this->_relativeRight))){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",343)
		this->_relativeRight = this->computeRight(false);
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",344)
	return this->_relativeRight;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getRelativeRight,return )

double BBPolarTreeVO_obj::getRelativeBottom( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getRelativeBottom")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",348)
	if ((::Math_obj::isNaN(this->_relativeBottom))){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",349)
		this->_relativeBottom = this->computeBottom(false);
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",350)
	return this->_relativeBottom;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getRelativeBottom,return )

double BBPolarTreeVO_obj::getX( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getX")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",353)
	if ((rotate)){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",355)
		this->checkComputeX();
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",356)
		return (this->_x - ::polartree::BBPolarTreeVO_obj::MARGIN);
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",358)
		return this->getRelativeX();
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",353)
	return 0.;
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,getX,return )

double BBPolarTreeVO_obj::getY( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getY")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",361)
	if ((rotate)){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",363)
		this->checkComputeY();
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",364)
		return (this->_y - ::polartree::BBPolarTreeVO_obj::MARGIN);
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",366)
		return this->getRelativeY();
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",361)
	return 0.;
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,getY,return )

double BBPolarTreeVO_obj::getRight( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getRight")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",369)
	if ((rotate)){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",371)
		this->checkComputeRight();
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",372)
		return (this->_right + ::polartree::BBPolarTreeVO_obj::MARGIN);
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",374)
		return this->getRelativeRight();
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",369)
	return 0.;
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,getRight,return )

double BBPolarTreeVO_obj::getBottom( bool rotate){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getBottom")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",378)
	if ((rotate)){
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",379)
		this->checkComputeBottom();
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",380)
		return (this->_bottom + ::polartree::BBPolarTreeVO_obj::MARGIN);
	}
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",382)
	return this->getRelativeBottom();
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,getBottom,return )

double BBPolarTreeVO_obj::getRotation( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getRotation")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",389)
	hx::Throw (HX_CSTRING("NotImplementedError"));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",390)
	return ::Math_obj::NaN;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getRotation,return )

int BBPolarTreeVO_obj::getCurrentStamp( ){
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::getCurrentStamp")
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",394)
	hx::Throw (HX_CSTRING("NotImplementedError"));
	HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",395)
	return (int)-1;
}


HX_DEFINE_DYNAMIC_FUNC0(BBPolarTreeVO_obj,getCurrentStamp,return )

Void BBPolarTreeVO_obj::setLeaf( bool b){
{
		HX_SOURCE_PUSH("BBPolarTreeVO_obj::setLeaf")
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",398)
		this->_leaf = b;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,setLeaf,(void))

::String BBPolarTreeVO_obj::toString( hx::Null< int >  __o_indent){
int indent = __o_indent.Default(0);
	HX_SOURCE_PUSH("BBPolarTreeVO_obj::toString");
{
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",404)
		::String indentStr = HX_CSTRING("");
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",405)
		int i = (int)0;
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",406)
		while(((i < indent))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",407)
			hx::AddEq(indentStr,HX_CSTRING(" "));
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",408)
			(i)++;
		}
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",410)
		::String childrenStr = HX_CSTRING("");
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",412)
		Array< ::polartree::BBPolarChildTreeVO > kids = this->getKids();
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",413)
		if (((kids != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",414)
			int _g = (int)0;
			HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",414)
			while(((_g < kids->length))){
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",414)
				::polartree::BBPolarChildTreeVO k = kids->__get(_g);
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",414)
				++(_g);
				HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",417)
				if (((k != null()))){
					HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",418)
					hx::AddEq(childrenStr,k->toString((indent + (int)1)));
				}
			}
		}
		HX_SOURCE_POS("polartree/BBPolarTreeVO.hx",423)
		return ((((((((((indentStr + HX_CSTRING("R1: ")) + this->getR1(false)) + HX_CSTRING(", R2: ")) + this->getR2(false)) + HX_CSTRING(", D1: ")) + this->d1) + HX_CSTRING(", D2: ")) + this->d2) + HX_CSTRING("\r\n")) + childrenStr);
	}
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeVO_obj,toString,return )

double BBPolarTreeVO_obj::HALF_PI;

double BBPolarTreeVO_obj::TWO_PI;

double BBPolarTreeVO_obj::PI;

double BBPolarTreeVO_obj::ONE_AND_HALF_PI;

double BBPolarTreeVO_obj::MARGIN;


BBPolarTreeVO_obj::BBPolarTreeVO_obj()
{
}

void BBPolarTreeVO_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BBPolarTreeVO);
	HX_MARK_MEMBER_NAME(rStamp,"rStamp");
	HX_MARK_MEMBER_NAME(_x,"_x");
	HX_MARK_MEMBER_NAME(_y,"_y");
	HX_MARK_MEMBER_NAME(_right,"_right");
	HX_MARK_MEMBER_NAME(_bottom,"_bottom");
	HX_MARK_MEMBER_NAME(_r1,"_r1");
	HX_MARK_MEMBER_NAME(d1,"d1");
	HX_MARK_MEMBER_NAME(_r2,"_r2");
	HX_MARK_MEMBER_NAME(d2,"d2");
	HX_MARK_MEMBER_NAME(_kids,"_kids");
	HX_MARK_MEMBER_NAME(_computedR1,"_computedR1");
	HX_MARK_MEMBER_NAME(_computedR2,"_computedR2");
	HX_MARK_MEMBER_NAME(pointsStamp,"pointsStamp");
	HX_MARK_MEMBER_NAME(_px,"_px");
	HX_MARK_MEMBER_NAME(_py,"_py");
	HX_MARK_MEMBER_NAME(_pright,"_pright");
	HX_MARK_MEMBER_NAME(_pbottom,"_pbottom");
	HX_MARK_MEMBER_NAME(xStamp,"xStamp");
	HX_MARK_MEMBER_NAME(yStamp,"yStamp");
	HX_MARK_MEMBER_NAME(rightStamp,"rightStamp");
	HX_MARK_MEMBER_NAME(bottomStamp,"bottomStamp");
	HX_MARK_MEMBER_NAME(_leaf,"_leaf");
	HX_MARK_MEMBER_NAME(_relativeX,"_relativeX");
	HX_MARK_MEMBER_NAME(_relativeY,"_relativeY");
	HX_MARK_MEMBER_NAME(_relativeRight,"_relativeRight");
	HX_MARK_MEMBER_NAME(_relativeBottom,"_relativeBottom");
	HX_MARK_MEMBER_NAME(swelling,"swelling");
	HX_MARK_END_CLASS();
}

Dynamic BBPolarTreeVO_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"PI") ) { return PI; }
		if (HX_FIELD_EQ(inName,"_x") ) { return _x; }
		if (HX_FIELD_EQ(inName,"_y") ) { return _y; }
		if (HX_FIELD_EQ(inName,"d1") ) { return d1; }
		if (HX_FIELD_EQ(inName,"d2") ) { return d2; }
		if (HX_FIELD_EQ(inName,"px") ) { return px_dyn(); }
		if (HX_FIELD_EQ(inName,"py") ) { return py_dyn(); }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"_r1") ) { return _r1; }
		if (HX_FIELD_EQ(inName,"_r2") ) { return _r2; }
		if (HX_FIELD_EQ(inName,"_px") ) { return _px; }
		if (HX_FIELD_EQ(inName,"_py") ) { return _py; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"getX") ) { return getX_dyn(); }
		if (HX_FIELD_EQ(inName,"getY") ) { return getY_dyn(); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"_kids") ) { return _kids; }
		if (HX_FIELD_EQ(inName,"_leaf") ) { return _leaf; }
		if (HX_FIELD_EQ(inName,"getR1") ) { return getR1_dyn(); }
		if (HX_FIELD_EQ(inName,"getR2") ) { return getR2_dyn(); }
		if (HX_FIELD_EQ(inName,"swell") ) { return swell_dyn(); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"TWO_PI") ) { return TWO_PI; }
		if (HX_FIELD_EQ(inName,"MARGIN") ) { return MARGIN; }
		if (HX_FIELD_EQ(inName,"rStamp") ) { return rStamp; }
		if (HX_FIELD_EQ(inName,"_right") ) { return _right; }
		if (HX_FIELD_EQ(inName,"xStamp") ) { return xStamp; }
		if (HX_FIELD_EQ(inName,"yStamp") ) { return yStamp; }
		if (HX_FIELD_EQ(inName,"pright") ) { return pright_dyn(); }
		if (HX_FIELD_EQ(inName,"isLeaf") ) { return isLeaf_dyn(); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"HALF_PI") ) { return HALF_PI; }
		if (HX_FIELD_EQ(inName,"_bottom") ) { return _bottom; }
		if (HX_FIELD_EQ(inName,"_pright") ) { return _pright; }
		if (HX_FIELD_EQ(inName,"addKids") ) { return addKids_dyn(); }
		if (HX_FIELD_EQ(inName,"getKids") ) { return getKids_dyn(); }
		if (HX_FIELD_EQ(inName,"getRoot") ) { return getRoot_dyn(); }
		if (HX_FIELD_EQ(inName,"pbottom") ) { return pbottom_dyn(); }
		if (HX_FIELD_EQ(inName,"collide") ) { return collide_dyn(); }
		if (HX_FIELD_EQ(inName,"setLeaf") ) { return setLeaf_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"_pbottom") ) { return _pbottom; }
		if (HX_FIELD_EQ(inName,"getRootX") ) { return getRootX_dyn(); }
		if (HX_FIELD_EQ(inName,"getRootY") ) { return getRootY_dyn(); }
		if (HX_FIELD_EQ(inName,"overlaps") ) { return overlaps_dyn(); }
		if (HX_FIELD_EQ(inName,"getShape") ) { return getShape_dyn(); }
		if (HX_FIELD_EQ(inName,"contains") ) { return contains_dyn(); }
		if (HX_FIELD_EQ(inName,"computeX") ) { return computeX_dyn(); }
		if (HX_FIELD_EQ(inName,"computeY") ) { return computeY_dyn(); }
		if (HX_FIELD_EQ(inName,"swelling") ) { return swelling; }
		if (HX_FIELD_EQ(inName,"getWidth") ) { return getWidth_dyn(); }
		if (HX_FIELD_EQ(inName,"getRight") ) { return getRight_dyn(); }
		if (HX_FIELD_EQ(inName,"toString") ) { return toString_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"computeR1") ) { return computeR1_dyn(); }
		if (HX_FIELD_EQ(inName,"computeR2") ) { return computeR2_dyn(); }
		if (HX_FIELD_EQ(inName,"getHeight") ) { return getHeight_dyn(); }
		if (HX_FIELD_EQ(inName,"getBottom") ) { return getBottom_dyn(); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"rightStamp") ) { return rightStamp; }
		if (HX_FIELD_EQ(inName,"_relativeX") ) { return _relativeX; }
		if (HX_FIELD_EQ(inName,"_relativeY") ) { return _relativeY; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"_computedR1") ) { return _computedR1; }
		if (HX_FIELD_EQ(inName,"_computedR2") ) { return _computedR2; }
		if (HX_FIELD_EQ(inName,"pointsStamp") ) { return pointsStamp; }
		if (HX_FIELD_EQ(inName,"bottomStamp") ) { return bottomStamp; }
		if (HX_FIELD_EQ(inName,"rectCollide") ) { return rectCollide_dyn(); }
		if (HX_FIELD_EQ(inName,"rectContain") ) { return rectContain_dyn(); }
		if (HX_FIELD_EQ(inName,"getRotation") ) { return getRotation_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"computeRight") ) { return computeRight_dyn(); }
		if (HX_FIELD_EQ(inName,"getRelativeX") ) { return getRelativeX_dyn(); }
		if (HX_FIELD_EQ(inName,"getRelativeY") ) { return getRelativeY_dyn(); }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"getMinBoxSize") ) { return getMinBoxSize_dyn(); }
		if (HX_FIELD_EQ(inName,"overlapsCoord") ) { return overlapsCoord_dyn(); }
		if (HX_FIELD_EQ(inName,"computeBottom") ) { return computeBottom_dyn(); }
		if (HX_FIELD_EQ(inName,"checkComputeX") ) { return checkComputeX_dyn(); }
		if (HX_FIELD_EQ(inName,"checkComputeY") ) { return checkComputeY_dyn(); }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"_relativeRight") ) { return _relativeRight; }
		if (HX_FIELD_EQ(inName,"checkRecompute") ) { return checkRecompute_dyn(); }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"ONE_AND_HALF_PI") ) { return ONE_AND_HALF_PI; }
		if (HX_FIELD_EQ(inName,"_relativeBottom") ) { return _relativeBottom; }
		if (HX_FIELD_EQ(inName,"getKidsNoGrowth") ) { return getKidsNoGrowth_dyn(); }
		if (HX_FIELD_EQ(inName,"getCurrentStamp") ) { return getCurrentStamp_dyn(); }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"rectCollideCoord") ) { return rectCollideCoord_dyn(); }
		if (HX_FIELD_EQ(inName,"getRelativeRight") ) { return getRelativeRight_dyn(); }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"checkUpdatePoints") ) { return checkUpdatePoints_dyn(); }
		if (HX_FIELD_EQ(inName,"checkComputeRight") ) { return checkComputeRight_dyn(); }
		if (HX_FIELD_EQ(inName,"getRelativeBottom") ) { return getRelativeBottom_dyn(); }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"checkComputeBottom") ) { return checkComputeBottom_dyn(); }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BBPolarTreeVO_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 2:
		if (HX_FIELD_EQ(inName,"PI") ) { PI=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_x") ) { _x=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_y") ) { _y=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"d1") ) { d1=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"d2") ) { d2=inValue.Cast< double >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"_r1") ) { _r1=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_r2") ) { _r2=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_px") ) { _px=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_py") ) { _py=inValue.Cast< double >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"_kids") ) { _kids=inValue.Cast< Array< ::polartree::BBPolarChildTreeVO > >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_leaf") ) { _leaf=inValue.Cast< bool >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"TWO_PI") ) { TWO_PI=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"MARGIN") ) { MARGIN=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"rStamp") ) { rStamp=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_right") ) { _right=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"xStamp") ) { xStamp=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"yStamp") ) { yStamp=inValue.Cast< double >(); return inValue; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"HALF_PI") ) { HALF_PI=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_bottom") ) { _bottom=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_pright") ) { _pright=inValue.Cast< double >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"_pbottom") ) { _pbottom=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"swelling") ) { swelling=inValue.Cast< int >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"rightStamp") ) { rightStamp=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_relativeX") ) { _relativeX=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_relativeY") ) { _relativeY=inValue.Cast< double >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"_computedR1") ) { _computedR1=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_computedR2") ) { _computedR2=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"pointsStamp") ) { pointsStamp=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"bottomStamp") ) { bottomStamp=inValue.Cast< double >(); return inValue; }
		break;
	case 14:
		if (HX_FIELD_EQ(inName,"_relativeRight") ) { _relativeRight=inValue.Cast< double >(); return inValue; }
		break;
	case 15:
		if (HX_FIELD_EQ(inName,"ONE_AND_HALF_PI") ) { ONE_AND_HALF_PI=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_relativeBottom") ) { _relativeBottom=inValue.Cast< double >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BBPolarTreeVO_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("rStamp"));
	outFields->push(HX_CSTRING("_x"));
	outFields->push(HX_CSTRING("_y"));
	outFields->push(HX_CSTRING("_right"));
	outFields->push(HX_CSTRING("_bottom"));
	outFields->push(HX_CSTRING("_r1"));
	outFields->push(HX_CSTRING("d1"));
	outFields->push(HX_CSTRING("_r2"));
	outFields->push(HX_CSTRING("d2"));
	outFields->push(HX_CSTRING("_kids"));
	outFields->push(HX_CSTRING("_computedR1"));
	outFields->push(HX_CSTRING("_computedR2"));
	outFields->push(HX_CSTRING("pointsStamp"));
	outFields->push(HX_CSTRING("_px"));
	outFields->push(HX_CSTRING("_py"));
	outFields->push(HX_CSTRING("_pright"));
	outFields->push(HX_CSTRING("_pbottom"));
	outFields->push(HX_CSTRING("xStamp"));
	outFields->push(HX_CSTRING("yStamp"));
	outFields->push(HX_CSTRING("rightStamp"));
	outFields->push(HX_CSTRING("bottomStamp"));
	outFields->push(HX_CSTRING("_leaf"));
	outFields->push(HX_CSTRING("_relativeX"));
	outFields->push(HX_CSTRING("_relativeY"));
	outFields->push(HX_CSTRING("_relativeRight"));
	outFields->push(HX_CSTRING("_relativeBottom"));
	outFields->push(HX_CSTRING("swelling"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("HALF_PI"),
	HX_CSTRING("TWO_PI"),
	HX_CSTRING("PI"),
	HX_CSTRING("ONE_AND_HALF_PI"),
	HX_CSTRING("MARGIN"),
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("rStamp"),
	HX_CSTRING("_x"),
	HX_CSTRING("_y"),
	HX_CSTRING("_right"),
	HX_CSTRING("_bottom"),
	HX_CSTRING("_r1"),
	HX_CSTRING("d1"),
	HX_CSTRING("_r2"),
	HX_CSTRING("d2"),
	HX_CSTRING("_kids"),
	HX_CSTRING("_computedR1"),
	HX_CSTRING("_computedR2"),
	HX_CSTRING("pointsStamp"),
	HX_CSTRING("_px"),
	HX_CSTRING("_py"),
	HX_CSTRING("_pright"),
	HX_CSTRING("_pbottom"),
	HX_CSTRING("xStamp"),
	HX_CSTRING("yStamp"),
	HX_CSTRING("rightStamp"),
	HX_CSTRING("bottomStamp"),
	HX_CSTRING("_leaf"),
	HX_CSTRING("_relativeX"),
	HX_CSTRING("_relativeY"),
	HX_CSTRING("_relativeRight"),
	HX_CSTRING("_relativeBottom"),
	HX_CSTRING("addKids"),
	HX_CSTRING("getRootX"),
	HX_CSTRING("getRootY"),
	HX_CSTRING("overlaps"),
	HX_CSTRING("getKids"),
	HX_CSTRING("getKidsNoGrowth"),
	HX_CSTRING("getRoot"),
	HX_CSTRING("getMinBoxSize"),
	HX_CSTRING("getShape"),
	HX_CSTRING("overlapsCoord"),
	HX_CSTRING("contains"),
	HX_CSTRING("computeX"),
	HX_CSTRING("computeY"),
	HX_CSTRING("computeRight"),
	HX_CSTRING("computeBottom"),
	HX_CSTRING("getR1"),
	HX_CSTRING("getR2"),
	HX_CSTRING("checkRecompute"),
	HX_CSTRING("computeR1"),
	HX_CSTRING("computeR2"),
	HX_CSTRING("checkUpdatePoints"),
	HX_CSTRING("px"),
	HX_CSTRING("py"),
	HX_CSTRING("pright"),
	HX_CSTRING("pbottom"),
	HX_CSTRING("collide"),
	HX_CSTRING("rectCollide"),
	HX_CSTRING("rectContain"),
	HX_CSTRING("rectCollideCoord"),
	HX_CSTRING("isLeaf"),
	HX_CSTRING("swelling"),
	HX_CSTRING("swell"),
	HX_CSTRING("getWidth"),
	HX_CSTRING("getHeight"),
	HX_CSTRING("checkComputeX"),
	HX_CSTRING("checkComputeY"),
	HX_CSTRING("checkComputeRight"),
	HX_CSTRING("checkComputeBottom"),
	HX_CSTRING("getRelativeX"),
	HX_CSTRING("getRelativeY"),
	HX_CSTRING("getRelativeRight"),
	HX_CSTRING("getRelativeBottom"),
	HX_CSTRING("getX"),
	HX_CSTRING("getY"),
	HX_CSTRING("getRight"),
	HX_CSTRING("getBottom"),
	HX_CSTRING("getRotation"),
	HX_CSTRING("getCurrentStamp"),
	HX_CSTRING("setLeaf"),
	HX_CSTRING("toString"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BBPolarTreeVO_obj::HALF_PI,"HALF_PI");
	HX_MARK_MEMBER_NAME(BBPolarTreeVO_obj::TWO_PI,"TWO_PI");
	HX_MARK_MEMBER_NAME(BBPolarTreeVO_obj::PI,"PI");
	HX_MARK_MEMBER_NAME(BBPolarTreeVO_obj::ONE_AND_HALF_PI,"ONE_AND_HALF_PI");
	HX_MARK_MEMBER_NAME(BBPolarTreeVO_obj::MARGIN,"MARGIN");
};

Class BBPolarTreeVO_obj::__mClass;

void BBPolarTreeVO_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("polartree.BBPolarTreeVO"), hx::TCanCast< BBPolarTreeVO_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void BBPolarTreeVO_obj::__boot()
{
	hx::Static(HALF_PI) = (double(::Math_obj::PI) / double((int)2));
	hx::Static(TWO_PI) = (::Math_obj::PI * (int)2);
	hx::Static(PI) = ::Math_obj::PI;
	hx::Static(ONE_AND_HALF_PI) = (::Math_obj::PI + ::polartree::BBPolarTreeVO_obj::HALF_PI);
	hx::Static(MARGIN) = (int)0;
}

} // end namespace polartree

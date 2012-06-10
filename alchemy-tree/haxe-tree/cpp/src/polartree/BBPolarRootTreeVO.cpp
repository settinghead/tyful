#include <hxcpp.h>

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

Void BBPolarRootTreeVO_obj::__construct(::polartree::IImageShape shape,int centerX,int centerY,double d,int minBoxSize)
{
{
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",12)
	super::__construct((int)0,::polartree::BBPolarTreeVO_obj::TWO_PI,(int)0,d,minBoxSize);
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",14)
	this->_rotation = (int)0;
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",15)
	this->rootStamp = (int)0;
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",16)
	this->rootX = centerX;
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",17)
	this->rootY = centerY;
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",18)
	this->shape = shape;
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",19)
	this->_minBoxSize = minBoxSize;
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",20)
	(this->rootStamp)++;
}
;
	return null();
}

BBPolarRootTreeVO_obj::~BBPolarRootTreeVO_obj() { }

Dynamic BBPolarRootTreeVO_obj::__CreateEmpty() { return  new BBPolarRootTreeVO_obj; }
hx::ObjectPtr< BBPolarRootTreeVO_obj > BBPolarRootTreeVO_obj::__new(::polartree::IImageShape shape,int centerX,int centerY,double d,int minBoxSize)
{  hx::ObjectPtr< BBPolarRootTreeVO_obj > result = new BBPolarRootTreeVO_obj();
	result->__construct(shape,centerX,centerY,d,minBoxSize);
	return result;}

Dynamic BBPolarRootTreeVO_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BBPolarRootTreeVO_obj > result = new BBPolarRootTreeVO_obj();
	result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return result;}

Void BBPolarRootTreeVO_obj::setLocation( int centerX,int centerY){
{
		HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::setLocation")
		HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",24)
		this->rootX = centerX;
		HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",25)
		this->rootY = centerY;
		HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",26)
		(this->rootStamp)++;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC2(BBPolarRootTreeVO_obj,setLocation,(void))

int BBPolarRootTreeVO_obj::getRootX( ){
	HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::getRootX")
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",30)
	return this->rootX;
}


int BBPolarRootTreeVO_obj::getRootY( ){
	HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::getRootY")
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",35)
	return this->rootY;
}


double BBPolarRootTreeVO_obj::computeX( bool rotate){
	HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::computeX")
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",40)
	return -(this->d2);
}


double BBPolarRootTreeVO_obj::computeY( bool rotate){
	HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::computeY")
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",48)
	return -(this->d2);
}


double BBPolarRootTreeVO_obj::computeRight( bool rotate){
	HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::computeRight")
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",56)
	return this->d2;
}


double BBPolarRootTreeVO_obj::computeBottom( bool rotate){
	HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::computeBottom")
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",64)
	return this->d2;
}


Void BBPolarRootTreeVO_obj::setRotation( double rotation){
{
		HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::setRotation")
		HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",72)
		this->_rotation = hx::Mod(rotation,::polartree::BBPolarTreeVO_obj::TWO_PI);
		HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",73)
		if (((this->_rotation < (int)0))){
			HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",74)
			this->_rotation = (::polartree::BBPolarTreeVO_obj::TWO_PI + this->_rotation);
		}
		HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",75)
		(this->rootStamp)++;
	}
return null();
}


HX_DEFINE_DYNAMIC_FUNC1(BBPolarRootTreeVO_obj,setRotation,(void))

double BBPolarRootTreeVO_obj::getRotation( ){
	HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::getRotation")
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",79)
	return this->_rotation;
}


int BBPolarRootTreeVO_obj::getCurrentStamp( ){
	HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::getCurrentStamp")
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",84)
	return this->rootStamp;
}


::polartree::BBPolarRootTreeVO BBPolarRootTreeVO_obj::getRoot( ){
	HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::getRoot")
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",89)
	return hx::ObjectPtr<OBJ_>(this);
}


int BBPolarRootTreeVO_obj::getMinBoxSize( ){
	HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::getMinBoxSize")
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",94)
	return this->_minBoxSize;
}


::polartree::IImageShape BBPolarRootTreeVO_obj::getShape( ){
	HX_SOURCE_PUSH("BBPolarRootTreeVO_obj::getShape")
	HX_SOURCE_POS("polartree/BBPolarRootTreeVO.hx",99)
	return this->shape;
}



BBPolarRootTreeVO_obj::BBPolarRootTreeVO_obj()
{
}

void BBPolarRootTreeVO_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BBPolarRootTreeVO);
	HX_MARK_MEMBER_NAME(rootX,"rootX");
	HX_MARK_MEMBER_NAME(rootY,"rootY");
	HX_MARK_MEMBER_NAME(_rotation,"_rotation");
	HX_MARK_MEMBER_NAME(rootStamp,"rootStamp");
	HX_MARK_MEMBER_NAME(shape,"shape");
	HX_MARK_MEMBER_NAME(_minBoxSize,"_minBoxSize");
	super::__Mark(HX_MARK_ARG);
	HX_MARK_END_CLASS();
}

Dynamic BBPolarRootTreeVO_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"rootX") ) { return rootX; }
		if (HX_FIELD_EQ(inName,"rootY") ) { return rootY; }
		if (HX_FIELD_EQ(inName,"shape") ) { return shape; }
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
	case 9:
		if (HX_FIELD_EQ(inName,"_rotation") ) { return _rotation; }
		if (HX_FIELD_EQ(inName,"rootStamp") ) { return rootStamp; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"_minBoxSize") ) { return _minBoxSize; }
		if (HX_FIELD_EQ(inName,"setLocation") ) { return setLocation_dyn(); }
		if (HX_FIELD_EQ(inName,"setRotation") ) { return setRotation_dyn(); }
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

Dynamic BBPolarRootTreeVO_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"rootX") ) { rootX=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"rootY") ) { rootY=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"shape") ) { shape=inValue.Cast< ::polartree::IImageShape >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"_rotation") ) { _rotation=inValue.Cast< double >(); return inValue; }
		if (HX_FIELD_EQ(inName,"rootStamp") ) { rootStamp=inValue.Cast< int >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"_minBoxSize") ) { _minBoxSize=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BBPolarRootTreeVO_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_CSTRING("rootX"));
	outFields->push(HX_CSTRING("rootY"));
	outFields->push(HX_CSTRING("_rotation"));
	outFields->push(HX_CSTRING("rootStamp"));
	outFields->push(HX_CSTRING("shape"));
	outFields->push(HX_CSTRING("_minBoxSize"));
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	String(null()) };

static ::String sMemberFields[] = {
	HX_CSTRING("rootX"),
	HX_CSTRING("rootY"),
	HX_CSTRING("_rotation"),
	HX_CSTRING("rootStamp"),
	HX_CSTRING("shape"),
	HX_CSTRING("_minBoxSize"),
	HX_CSTRING("setLocation"),
	HX_CSTRING("getRootX"),
	HX_CSTRING("getRootY"),
	HX_CSTRING("computeX"),
	HX_CSTRING("computeY"),
	HX_CSTRING("computeRight"),
	HX_CSTRING("computeBottom"),
	HX_CSTRING("setRotation"),
	HX_CSTRING("getRotation"),
	HX_CSTRING("getCurrentStamp"),
	HX_CSTRING("getRoot"),
	HX_CSTRING("getMinBoxSize"),
	HX_CSTRING("getShape"),
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
};

Class BBPolarRootTreeVO_obj::__mClass;

void BBPolarRootTreeVO_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("polartree.BBPolarRootTreeVO"), hx::TCanCast< BBPolarRootTreeVO_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void BBPolarRootTreeVO_obj::__boot()
{
}

} // end namespace polartree

#include <hxcpp.h>

#ifndef INCLUDED_polartree_SplitType
#include <polartree/SplitType.h>
#endif
namespace polartree{

Void SplitType_obj::__construct()
{
	return null();
}

SplitType_obj::~SplitType_obj() { }

Dynamic SplitType_obj::__CreateEmpty() { return  new SplitType_obj; }
hx::ObjectPtr< SplitType_obj > SplitType_obj::__new()
{  hx::ObjectPtr< SplitType_obj > result = new SplitType_obj();
	result->__construct();
	return result;}

Dynamic SplitType_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< SplitType_obj > result = new SplitType_obj();
	result->__construct();
	return result;}

int SplitType_obj::_3RAYS;

int SplitType_obj::_2RAYS1CUT;

int SplitType_obj::_1RAY1CUT;

int SplitType_obj::_1RAY2CUTS;

int SplitType_obj::_3CUTS;


SplitType_obj::SplitType_obj()
{
}

void SplitType_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(SplitType);
	HX_MARK_END_CLASS();
}

Dynamic SplitType_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"_3RAYS") ) { return _3RAYS; }
		if (HX_FIELD_EQ(inName,"_3CUTS") ) { return _3CUTS; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"_1RAY1CUT") ) { return _1RAY1CUT; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"_2RAYS1CUT") ) { return _2RAYS1CUT; }
		if (HX_FIELD_EQ(inName,"_1RAY2CUTS") ) { return _1RAY2CUTS; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic SplitType_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"_3RAYS") ) { _3RAYS=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_3CUTS") ) { _3CUTS=inValue.Cast< int >(); return inValue; }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"_1RAY1CUT") ) { _1RAY1CUT=inValue.Cast< int >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"_2RAYS1CUT") ) { _2RAYS1CUT=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"_1RAY2CUTS") ) { _1RAY2CUTS=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void SplitType_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("_3RAYS"),
	HX_CSTRING("_2RAYS1CUT"),
	HX_CSTRING("_1RAY1CUT"),
	HX_CSTRING("_1RAY2CUTS"),
	HX_CSTRING("_3CUTS"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(SplitType_obj::_3RAYS,"_3RAYS");
	HX_MARK_MEMBER_NAME(SplitType_obj::_2RAYS1CUT,"_2RAYS1CUT");
	HX_MARK_MEMBER_NAME(SplitType_obj::_1RAY1CUT,"_1RAY1CUT");
	HX_MARK_MEMBER_NAME(SplitType_obj::_1RAY2CUTS,"_1RAY2CUTS");
	HX_MARK_MEMBER_NAME(SplitType_obj::_3CUTS,"_3CUTS");
};

Class SplitType_obj::__mClass;

void SplitType_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("polartree.SplitType"), hx::TCanCast< SplitType_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void SplitType_obj::__boot()
{
	hx::Static(_3RAYS) = (int)0;
	hx::Static(_2RAYS1CUT) = (int)1;
	hx::Static(_1RAY1CUT) = (int)2;
	hx::Static(_1RAY2CUTS) = (int)3;
	hx::Static(_3CUTS) = (int)4;
}

} // end namespace polartree

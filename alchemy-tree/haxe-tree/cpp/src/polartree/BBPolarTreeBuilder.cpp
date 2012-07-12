#include <hxcpp.h>

#ifndef INCLUDED_hxMath
#include <hxMath.h>
#endif
#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_haxe_Log
#include <haxe/Log.h>
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
#ifndef INCLUDED_polartree_IImageShape
#include <polartree/IImageShape.h>
#endif
#ifndef INCLUDED_polartree_SplitType
#include <polartree/SplitType.h>
#endif
namespace polartree{

Void BBPolarTreeBuilder_obj::__construct()
{
	return null();
}

BBPolarTreeBuilder_obj::~BBPolarTreeBuilder_obj() { }

Dynamic BBPolarTreeBuilder_obj::__CreateEmpty() { return  new BBPolarTreeBuilder_obj; }
hx::ObjectPtr< BBPolarTreeBuilder_obj > BBPolarTreeBuilder_obj::__new()
{  hx::ObjectPtr< BBPolarTreeBuilder_obj > result = new BBPolarTreeBuilder_obj();
	result->__construct();
	return result;}

Dynamic BBPolarTreeBuilder_obj::__Create(hx::DynamicArray inArgs)
{  hx::ObjectPtr< BBPolarTreeBuilder_obj > result = new BBPolarTreeBuilder_obj();
	result->__construct();
	return result;}

double BBPolarTreeBuilder_obj::STOP_COMPUTE_TREE_THRESHOLD;

Void BBPolarTreeBuilder_obj::_assert( bool cond,Dynamic pos){
{
		HX_SOURCE_PUSH("BBPolarTreeBuilder_obj::assert")
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",7)
		if ((!(cond))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",9)
			::haxe::Log_obj::trace((((HX_CSTRING("Assert in ") + pos->__Field(HX_CSTRING("className"),true)) + HX_CSTRING("::")) + pos->__Field(HX_CSTRING("methodName"),true)),pos);
		}
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BBPolarTreeBuilder_obj,_assert,(void))

::polartree::BBPolarRootTreeVO BBPolarTreeBuilder_obj::makeTree( ::polartree::IImageShape shape,int swelling){
	HX_SOURCE_PUSH("BBPolarTreeBuilder_obj::makeTree")
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",13)
	int minBoxSize = (int)1;
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",15)
	int x = ::Std_obj::_int((double(shape->getWidth()) / double((int)2)));
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",16)
	int y = ::Std_obj::_int((double(shape->getHeight()) / double((int)2)));
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",20)
	double d = ::Math_obj::sqrt((::Math_obj::pow((double(shape->getWidth()) / double((int)2)),(int)2) + ::Math_obj::pow((double(shape->getHeight()) / double((int)2)),(int)2)));
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",23)
	::polartree::BBPolarRootTreeVO tree = ::polartree::BBPolarRootTreeVO_obj::__new(shape,x,y,d,minBoxSize);
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",27)
	return tree;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(BBPolarTreeBuilder_obj,makeTree,return )

Void BBPolarTreeBuilder_obj::makeChildren( ::polartree::BBPolarTreeVO tree,::polartree::IImageShape shape,int minBoxSize,::polartree::BBPolarRootTreeVO root){
{
		HX_SOURCE_PUSH("BBPolarTreeBuilder_obj::makeChildren")
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",32)
		int type = ::polartree::BBPolarTreeBuilder_obj::determineType(tree);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",34)
		Array< ::polartree::BBPolarChildTreeVO > children = ::polartree::BBPolarTreeBuilder_obj::splitTree(tree,shape,minBoxSize,root,type);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",38)
		tree->addKids(children);
	}
return null();
}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(BBPolarTreeBuilder_obj,makeChildren,(void))

Array< ::polartree::BBPolarChildTreeVO > BBPolarTreeBuilder_obj::splitTree( ::polartree::BBPolarTreeVO tree,::polartree::IImageShape shape,int minBoxSize,::polartree::BBPolarRootTreeVO root,int type){
	HX_SOURCE_PUSH("BBPolarTreeBuilder_obj::splitTree")
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",43)
	Array< ::polartree::BBPolarChildTreeVO > result = Array_obj< ::polartree::BBPolarChildTreeVO >::__new();
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",44)
	::polartree::BBPolarChildTreeVO re;
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",45)
	double r;
	double r1;
	double r2;
	double r3;
	double r4;
	double r5;
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",46)
	double d;
	double d1;
	double d2;
	double d3;
	double d4;
	double d5;
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",48)
	int _switch_1 = (type);
	if (  ( _switch_1==::polartree::SplitType_obj::_3RAYS)){
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",50)
		r = (double(((tree->getR2(false) - tree->getR1(false)))) / double((int)4));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",51)
		r1 = tree->getR1(false);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",52)
		r2 = (r1 + r);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",53)
		r3 = (r2 + r);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",54)
		r4 = (r3 + r);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",55)
		r5 = tree->getR2(false);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",56)
		::polartree::BBPolarTreeBuilder_obj::_assert((bool((bool((bool((r1 < r2)) && bool((r2 < r3)))) && bool((r3 < r4)))) && bool((r4 < r5))),hx::SourceInfo(HX_CSTRING("BBPolarTreeBuilder.hx"),56,HX_CSTRING("polartree.BBPolarTreeBuilder"),HX_CSTRING("splitTree")));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",57)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r2,tree->d1,tree->d2,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",58)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",58)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",59)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r2,r3,tree->d1,tree->d2,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",60)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",60)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",61)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r3,r4,tree->d1,tree->d2,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",62)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",62)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",63)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r4,r5,tree->d1,tree->d2,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",64)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",64)
			result->push(re);
		}
	}
	else if (  ( _switch_1==::polartree::SplitType_obj::_2RAYS1CUT)){
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",68)
		r = (double(((tree->getR2(false) - tree->getR1(false)))) / double((int)3));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",69)
		r1 = tree->getR1(false);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",70)
		r2 = (r1 + r);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",71)
		r3 = (r2 + r);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",72)
		r4 = tree->getR2(false);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",73)
		d1 = tree->d1;
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",74)
		d2 = (tree->d1 + (double(((tree->d2 - tree->d1))) / double((int)2)));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",75)
		d3 = tree->d2;
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",76)
		::polartree::BBPolarTreeBuilder_obj::_assert((bool((bool((r1 < r2)) && bool((r2 < r3)))) && bool((r3 < r4))),hx::SourceInfo(HX_CSTRING("BBPolarTreeBuilder.hx"),76,HX_CSTRING("polartree.BBPolarTreeBuilder"),HX_CSTRING("splitTree")));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",77)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r4,d1,d2,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",78)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",78)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",79)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r2,d2,d3,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",80)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",80)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",81)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r2,r3,d2,d3,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",82)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",82)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",83)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r3,r4,d2,d3,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",84)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",84)
			result->push(re);
		}
	}
	else if (  ( _switch_1==::polartree::SplitType_obj::_1RAY1CUT)){
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",87)
		r = (double(((tree->getR2(false) - tree->getR1(false)))) / double((int)2));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",88)
		r1 = tree->getR1(false);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",89)
		r2 = (r1 + r);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",90)
		r3 = tree->getR2(false);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",91)
		d = (double(((tree->d2 - tree->d1))) / double((int)2));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",92)
		d1 = tree->d1;
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",93)
		d2 = (d1 + d);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",94)
		d3 = tree->d2;
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",95)
		::polartree::BBPolarTreeBuilder_obj::_assert((bool((r1 < r2)) && bool((r2 < r3))),hx::SourceInfo(HX_CSTRING("BBPolarTreeBuilder.hx"),95,HX_CSTRING("polartree.BBPolarTreeBuilder"),HX_CSTRING("splitTree")));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",97)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r2,d1,d2,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",98)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",98)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",99)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r2,r3,d1,d2,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",100)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",100)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",101)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r2,d2,d3,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",102)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",102)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",103)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r2,r3,d2,d3,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",104)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",104)
			result->push(re);
		}
	}
	else if (  ( _switch_1==::polartree::SplitType_obj::_1RAY2CUTS)){
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",107)
		r = (double(((tree->getR2(false) - tree->getR1(false)))) / double((int)2));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",108)
		r1 = tree->getR1(false);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",109)
		r2 = (r1 + r);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",110)
		r3 = tree->getR2(false);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",111)
		d = (double(((tree->d2 - tree->d1))) / double((int)3));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",112)
		d1 = tree->d1;
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",113)
		d2 = (d1 + d);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",114)
		d3 = (d2 + d);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",115)
		d4 = tree->d2;
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",116)
		::polartree::BBPolarTreeBuilder_obj::_assert((bool((r1 < r2)) && bool((r2 < r3))),hx::SourceInfo(HX_CSTRING("BBPolarTreeBuilder.hx"),116,HX_CSTRING("polartree.BBPolarTreeBuilder"),HX_CSTRING("splitTree")));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",118)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r3,d1,d2,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",119)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",119)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",120)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r3,d2,d3,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",121)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",121)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",122)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r2,d3,d4,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",123)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",123)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",124)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r2,r3,d3,d4,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",125)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",125)
			result->push(re);
		}
	}
	else if (  ( _switch_1==::polartree::SplitType_obj::_3CUTS)){
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",128)
		r1 = tree->getR1(false);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",129)
		r2 = tree->getR2(false);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",130)
		d = (double(((tree->d2 - tree->d1))) / double((int)4));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",131)
		d1 = tree->d1;
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",132)
		d2 = (d1 + d);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",133)
		d3 = (d2 + d);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",134)
		d4 = (d3 + d);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",135)
		d5 = tree->d2;
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",136)
		::polartree::BBPolarTreeBuilder_obj::_assert((r1 < r2),hx::SourceInfo(HX_CSTRING("BBPolarTreeBuilder.hx"),136,HX_CSTRING("polartree.BBPolarTreeBuilder"),HX_CSTRING("splitTree")));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",138)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r2,d1,d2,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",139)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",139)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",140)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r2,d2,d3,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",141)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",141)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",142)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r2,d3,d4,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",143)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",143)
			result->push(re);
		}
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",144)
		re = ::polartree::BBPolarTreeBuilder_obj::makeChildTree(shape,minBoxSize,r1,r2,d4,d5,root);
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",145)
		if (((re != null()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",145)
			result->push(re);
		}
	}
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",148)
	return result;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC5(BBPolarTreeBuilder_obj,splitTree,return )

int BBPolarTreeBuilder_obj::determineType( ::polartree::BBPolarTreeVO tree){
	HX_SOURCE_PUSH("BBPolarTreeBuilder_obj::determineType")
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",152)
	double d = (tree->d2 - tree->d1);
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",153)
	double midLength = (double((((tree->d2 + tree->d1)) * ((tree->getR2(false) - tree->getR1(false))))) / double((int)2));
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",155)
	double factor = (double(d) / double(midLength));
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",158)
	if (((factor < 0.7))){
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",159)
		return ::polartree::SplitType_obj::_3RAYS;
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",160)
		if (((factor > 1.3))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",161)
			return ::polartree::SplitType_obj::_3CUTS;
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",163)
			return ::polartree::SplitType_obj::_1RAY1CUT;
		}
	}
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",158)
	return (int)0;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(BBPolarTreeBuilder_obj,determineType,return )

::polartree::BBPolarChildTreeVO BBPolarTreeBuilder_obj::makeChildTree( ::polartree::IImageShape shape,int minBoxSize,double r1,double r2,double d1,double d2,::polartree::BBPolarRootTreeVO root){
	HX_SOURCE_PUSH("BBPolarTreeBuilder_obj::makeChildTree")
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",169)
	::polartree::BBPolarChildTreeVO tree = ::polartree::BBPolarChildTreeVO_obj::__new(r1,r2,d1,d2,root,minBoxSize);
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",171)
	double x = (tree->getX(false) + (double(shape->getWidth()) / double((int)2)));
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",172)
	if (((x > shape->getWidth()))){
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",172)
		tree = null();
	}
	else{
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",174)
		double y = (tree->getY(false) + (double(shape->getHeight()) / double((int)2)));
		HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",175)
		if (((y > shape->getHeight()))){
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",175)
			tree = null();
		}
		else{
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",177)
			double width = (tree->getRight(false) - tree->getX(false));
			HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",179)
			if ((((x + width) < (int)0))){
				HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",179)
				tree = null();
			}
			else{
				HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",181)
				double height = (tree->getBottom(false) - tree->getY(false));
				HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",183)
				if ((((y + height) < (int)0))){
					HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",183)
					tree = null();
				}
				else{
					HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",185)
					::polartree::BBPolarTreeBuilder_obj::_assert((width > (int)0),hx::SourceInfo(HX_CSTRING("BBPolarTreeBuilder.hx"),185,HX_CSTRING("polartree.BBPolarTreeBuilder"),HX_CSTRING("makeChildTree")));
					HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",186)
					::polartree::BBPolarTreeBuilder_obj::_assert((height > (int)0),hx::SourceInfo(HX_CSTRING("BBPolarTreeBuilder.hx"),186,HX_CSTRING("polartree.BBPolarTreeBuilder"),HX_CSTRING("makeChildTree")));
					HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",187)
					if (((bool((shape == null())) || bool(shape->contains(x,y,width,height,(int)0,false))))){
					}
					else{
						HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",188)
						if ((shape->intersects(x,y,width,height,false))){
						}
						else{
							HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",190)
							tree = null();
						}
					}
				}
			}
		}
	}
	HX_SOURCE_POS("polartree/BBPolarTreeBuilder.hx",199)
	return tree;
}


STATIC_HX_DEFINE_DYNAMIC_FUNC7(BBPolarTreeBuilder_obj,makeChildTree,return )

int BBPolarTreeBuilder_obj::correctCount;


BBPolarTreeBuilder_obj::BBPolarTreeBuilder_obj()
{
}

void BBPolarTreeBuilder_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(BBPolarTreeBuilder);
	HX_MARK_END_CLASS();
}

Dynamic BBPolarTreeBuilder_obj::__Field(const ::String &inName,bool inCallProp)
{
	switch(inName.length) {
	case 6:
		if (HX_FIELD_EQ(inName,"assert") ) { return _assert_dyn(); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"makeTree") ) { return makeTree_dyn(); }
		break;
	case 9:
		if (HX_FIELD_EQ(inName,"splitTree") ) { return splitTree_dyn(); }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"makeChildren") ) { return makeChildren_dyn(); }
		if (HX_FIELD_EQ(inName,"correctCount") ) { return correctCount; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"determineType") ) { return determineType_dyn(); }
		if (HX_FIELD_EQ(inName,"makeChildTree") ) { return makeChildTree_dyn(); }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"STOP_COMPUTE_TREE_THRESHOLD") ) { return STOP_COMPUTE_TREE_THRESHOLD; }
	}
	return super::__Field(inName,inCallProp);
}

Dynamic BBPolarTreeBuilder_obj::__SetField(const ::String &inName,const Dynamic &inValue,bool inCallProp)
{
	switch(inName.length) {
	case 12:
		if (HX_FIELD_EQ(inName,"correctCount") ) { correctCount=inValue.Cast< int >(); return inValue; }
		break;
	case 27:
		if (HX_FIELD_EQ(inName,"STOP_COMPUTE_TREE_THRESHOLD") ) { STOP_COMPUTE_TREE_THRESHOLD=inValue.Cast< double >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void BBPolarTreeBuilder_obj::__GetFields(Array< ::String> &outFields)
{
	super::__GetFields(outFields);
};

static ::String sStaticFields[] = {
	HX_CSTRING("STOP_COMPUTE_TREE_THRESHOLD"),
	HX_CSTRING("assert"),
	HX_CSTRING("makeTree"),
	HX_CSTRING("makeChildren"),
	HX_CSTRING("splitTree"),
	HX_CSTRING("determineType"),
	HX_CSTRING("makeChildTree"),
	HX_CSTRING("correctCount"),
	String(null()) };

static ::String sMemberFields[] = {
	String(null()) };

static void sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(BBPolarTreeBuilder_obj::STOP_COMPUTE_TREE_THRESHOLD,"STOP_COMPUTE_TREE_THRESHOLD");
	HX_MARK_MEMBER_NAME(BBPolarTreeBuilder_obj::correctCount,"correctCount");
};

Class BBPolarTreeBuilder_obj::__mClass;

void BBPolarTreeBuilder_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("polartree.BBPolarTreeBuilder"), hx::TCanCast< BBPolarTreeBuilder_obj> ,sStaticFields,sMemberFields,
	&__CreateEmpty, &__Create,
	&super::__SGetClass(), 0, sMarkStatics);
}

void BBPolarTreeBuilder_obj::__boot()
{
	hx::Static(STOP_COMPUTE_TREE_THRESHOLD) = (int)20;
	hx::Static(correctCount) = (int)0;
}

} // end namespace polartree

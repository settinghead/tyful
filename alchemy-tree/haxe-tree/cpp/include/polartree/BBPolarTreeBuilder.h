#ifndef INCLUDED_polartree_BBPolarTreeBuilder
#define INCLUDED_polartree_BBPolarTreeBuilder

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(polartree,BBPolarChildTreeVO)
HX_DECLARE_CLASS1(polartree,BBPolarRootTreeVO)
HX_DECLARE_CLASS1(polartree,BBPolarTreeBuilder)
HX_DECLARE_CLASS1(polartree,BBPolarTreeVO)
HX_DECLARE_CLASS1(polartree,ImageShape)
namespace polartree{


class BBPolarTreeBuilder_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BBPolarTreeBuilder_obj OBJ_;
		BBPolarTreeBuilder_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< BBPolarTreeBuilder_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~BBPolarTreeBuilder_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("BBPolarTreeBuilder"); }

		static double STOP_COMPUTE_TREE_THRESHOLD; /* REM */ 
		static Void _assert( bool cond,Dynamic pos);
		static Dynamic _assert_dyn();

		static ::polartree::BBPolarRootTreeVO makeTree( ::polartree::ImageShape shape,int swelling);
		static Dynamic makeTree_dyn();

		static Void makeChildren( ::polartree::BBPolarTreeVO tree,::polartree::ImageShape shape,int minBoxSize,::polartree::BBPolarRootTreeVO root);
		static Dynamic makeChildren_dyn();

		static Array< ::polartree::BBPolarChildTreeVO > splitTree( ::polartree::BBPolarTreeVO tree,::polartree::ImageShape shape,int minBoxSize,::polartree::BBPolarRootTreeVO root,int type);
		static Dynamic splitTree_dyn();

		static int determineType( ::polartree::BBPolarTreeVO tree);
		static Dynamic determineType_dyn();

		static ::polartree::BBPolarChildTreeVO makeChildTree( ::polartree::ImageShape shape,int minBoxSize,double r1,double r2,double d1,double d2,::polartree::BBPolarRootTreeVO root);
		static Dynamic makeChildTree_dyn();

		static int correctCount; /* REM */ 
};

} // end namespace polartree

#endif /* INCLUDED_polartree_BBPolarTreeBuilder */ 

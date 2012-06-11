#ifndef INCLUDED_polartree_BBPolarChildTreeVO
#define INCLUDED_polartree_BBPolarChildTreeVO

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <polartree/BBPolarTreeVO.h>
HX_DECLARE_CLASS1(polartree,BBPolarChildTreeVO)
HX_DECLARE_CLASS1(polartree,BBPolarRootTreeVO)
HX_DECLARE_CLASS1(polartree,BBPolarTreeVO)
HX_DECLARE_CLASS1(polartree,ImageShape)
namespace polartree{


class BBPolarChildTreeVO_obj : public ::polartree::BBPolarTreeVO_obj{
	public:
		typedef ::polartree::BBPolarTreeVO_obj super;
		typedef BBPolarChildTreeVO_obj OBJ_;
		BBPolarChildTreeVO_obj();
		Void __construct(double r1,double r2,double d1,double d2,::polartree::BBPolarRootTreeVO root,int minBoxSize);

	public:
		static hx::ObjectPtr< BBPolarChildTreeVO_obj > __new(double r1,double r2,double d1,double d2,::polartree::BBPolarRootTreeVO root,int minBoxSize);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~BBPolarChildTreeVO_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("BBPolarChildTreeVO"); }

		::polartree::BBPolarRootTreeVO root; /* REM */ 
		virtual int getRootX( );

		virtual int getRootY( );

		virtual double computeX( bool rotate);

		virtual double computeY( bool rotate);

		virtual double computeRight( bool rotate);

		virtual double computeBottom( bool rotate);

		virtual double getRotation( );

		virtual int getCurrentStamp( );

		virtual ::polartree::BBPolarRootTreeVO getRoot( );

		virtual int getMinBoxSize( );

		virtual ::polartree::ImageShape getShape( );

};

} // end namespace polartree

#endif /* INCLUDED_polartree_BBPolarChildTreeVO */ 

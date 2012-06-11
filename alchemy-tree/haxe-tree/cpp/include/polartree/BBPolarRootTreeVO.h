#ifndef INCLUDED_polartree_BBPolarRootTreeVO
#define INCLUDED_polartree_BBPolarRootTreeVO

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <polartree/BBPolarTreeVO.h>
HX_DECLARE_CLASS1(polartree,BBPolarRootTreeVO)
HX_DECLARE_CLASS1(polartree,BBPolarTreeVO)
HX_DECLARE_CLASS1(polartree,ImageShape)
namespace polartree{


class BBPolarRootTreeVO_obj : public ::polartree::BBPolarTreeVO_obj{
	public:
		typedef ::polartree::BBPolarTreeVO_obj super;
		typedef BBPolarRootTreeVO_obj OBJ_;
		BBPolarRootTreeVO_obj();
		Void __construct(::polartree::ImageShape shape,int centerX,int centerY,double d,int minBoxSize);

	public:
		static hx::ObjectPtr< BBPolarRootTreeVO_obj > __new(::polartree::ImageShape shape,int centerX,int centerY,double d,int minBoxSize);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~BBPolarRootTreeVO_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("BBPolarRootTreeVO"); }

		int rootX; /* REM */ 
		int rootY; /* REM */ 
		double _rotation; /* REM */ 
		int rootStamp; /* REM */ 
		::polartree::ImageShape shape; /* REM */ 
		int _minBoxSize; /* REM */ 
		virtual Void setLocation( int centerX,int centerY);
		Dynamic setLocation_dyn();

		virtual int getRootX( );

		virtual int getRootY( );

		virtual double computeX( bool rotate);

		virtual double computeY( bool rotate);

		virtual double computeRight( bool rotate);

		virtual double computeBottom( bool rotate);

		virtual Void setRotation( double rotation);
		Dynamic setRotation_dyn();

		virtual double getRotation( );

		virtual int getCurrentStamp( );

		virtual ::polartree::BBPolarRootTreeVO getRoot( );

		virtual int getMinBoxSize( );

		virtual ::polartree::ImageShape getShape( );

};

} // end namespace polartree

#endif /* INCLUDED_polartree_BBPolarRootTreeVO */ 

#ifndef INCLUDED_polartree_BBPolarTreeVO
#define INCLUDED_polartree_BBPolarTreeVO

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(polartree,BBPolarChildTreeVO)
HX_DECLARE_CLASS1(polartree,BBPolarRootTreeVO)
HX_DECLARE_CLASS1(polartree,BBPolarTreeVO)
HX_DECLARE_CLASS1(polartree,ImageShape)
namespace polartree{


class BBPolarTreeVO_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef BBPolarTreeVO_obj OBJ_;
		BBPolarTreeVO_obj();
		Void __construct(double r1,double r2,double d1,double d2,int minBoxSize);

	public:
		static hx::ObjectPtr< BBPolarTreeVO_obj > __new(double r1,double r2,double d1,double d2,int minBoxSize);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~BBPolarTreeVO_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("BBPolarTreeVO"); }

		int rStamp; /* REM */ 
		double _x; /* REM */ 
		double _y; /* REM */ 
		double _right; /* REM */ 
		double _bottom; /* REM */ 
		double _r1; /* REM */ 
		double d1; /* REM */ 
		double _r2; /* REM */ 
		double d2; /* REM */ 
		Array< ::polartree::BBPolarChildTreeVO > _kids; /* REM */ 
		double _computedR1; /* REM */ 
		double _computedR2; /* REM */ 
		double pointsStamp; /* REM */ 
		double _px; /* REM */ 
		double _py; /* REM */ 
		double _pright; /* REM */ 
		double _pbottom; /* REM */ 
		double xStamp; /* REM */ 
		double yStamp; /* REM */ 
		double rightStamp; /* REM */ 
		double bottomStamp; /* REM */ 
		bool _leaf; /* REM */ 
		double _relativeX; /* REM */ 
		double _relativeY; /* REM */ 
		double _relativeRight; /* REM */ 
		double _relativeBottom; /* REM */ 
		virtual Void addKids( Array< ::polartree::BBPolarChildTreeVO > kidList);
		Dynamic addKids_dyn();

		virtual int getRootX( );
		Dynamic getRootX_dyn();

		virtual int getRootY( );
		Dynamic getRootY_dyn();

		virtual bool overlaps( ::polartree::BBPolarTreeVO otherTree);
		Dynamic overlaps_dyn();

		virtual Array< ::polartree::BBPolarChildTreeVO > getKids( );
		Dynamic getKids_dyn();

		virtual Array< ::polartree::BBPolarChildTreeVO > getKidsNoGrowth( );
		Dynamic getKidsNoGrowth_dyn();

		virtual ::polartree::BBPolarRootTreeVO getRoot( );
		Dynamic getRoot_dyn();

		virtual int getMinBoxSize( );
		Dynamic getMinBoxSize_dyn();

		virtual ::polartree::ImageShape getShape( );
		Dynamic getShape_dyn();

		virtual bool overlapsCoord( double x,double y,double right,double bottom);
		Dynamic overlapsCoord_dyn();

		virtual bool contains( double x,double y,double right,double bottom);
		Dynamic contains_dyn();

		virtual double computeX( bool rotate);
		Dynamic computeX_dyn();

		virtual double computeY( bool rotate);
		Dynamic computeY_dyn();

		virtual double computeRight( bool rotate);
		Dynamic computeRight_dyn();

		virtual double computeBottom( bool rotate);
		Dynamic computeBottom_dyn();

		virtual double getR1( bool rotate);
		Dynamic getR1_dyn();

		virtual double getR2( bool rotate);
		Dynamic getR2_dyn();

		virtual Void checkRecompute( );
		Dynamic checkRecompute_dyn();

		virtual Void computeR1( );
		Dynamic computeR1_dyn();

		virtual Void computeR2( );
		Dynamic computeR2_dyn();

		virtual Void checkUpdatePoints( );
		Dynamic checkUpdatePoints_dyn();

		virtual double px( );
		Dynamic px_dyn();

		virtual double py( );
		Dynamic py_dyn();

		virtual double pright( );
		Dynamic pright_dyn();

		virtual double pbottom( );
		Dynamic pbottom_dyn();

		virtual bool collide( ::polartree::BBPolarTreeVO bTree);
		Dynamic collide_dyn();

		virtual bool rectCollide( ::polartree::BBPolarTreeVO bTree);
		Dynamic rectCollide_dyn();

		virtual bool rectContain( double x,double y,double right,double bottom);
		Dynamic rectContain_dyn();

		virtual bool rectCollideCoord( double x,double y,double right,double bottom);
		Dynamic rectCollideCoord_dyn();

		virtual bool isLeaf( );
		Dynamic isLeaf_dyn();

		int swelling; /* REM */ 
		virtual Void swell( int extra);
		Dynamic swell_dyn();

		virtual double getWidth( bool rotate);
		Dynamic getWidth_dyn();

		virtual double getHeight( bool rotate);
		Dynamic getHeight_dyn();

		virtual Void checkComputeX( );
		Dynamic checkComputeX_dyn();

		virtual Void checkComputeY( );
		Dynamic checkComputeY_dyn();

		virtual Void checkComputeRight( );
		Dynamic checkComputeRight_dyn();

		virtual Void checkComputeBottom( );
		Dynamic checkComputeBottom_dyn();

		virtual double getRelativeX( );
		Dynamic getRelativeX_dyn();

		virtual double getRelativeY( );
		Dynamic getRelativeY_dyn();

		virtual double getRelativeRight( );
		Dynamic getRelativeRight_dyn();

		virtual double getRelativeBottom( );
		Dynamic getRelativeBottom_dyn();

		virtual double getX( bool rotate);
		Dynamic getX_dyn();

		virtual double getY( bool rotate);
		Dynamic getY_dyn();

		virtual double getRight( bool rotate);
		Dynamic getRight_dyn();

		virtual double getBottom( bool rotate);
		Dynamic getBottom_dyn();

		virtual double getRotation( );
		Dynamic getRotation_dyn();

		virtual int getCurrentStamp( );
		Dynamic getCurrentStamp_dyn();

		virtual Void setLeaf( bool b);
		Dynamic setLeaf_dyn();

		virtual ::String toString( hx::Null< int >  indent);
		Dynamic toString_dyn();

		static double HALF_PI; /* REM */ 
		static double TWO_PI; /* REM */ 
		static double PI; /* REM */ 
		static double ONE_AND_HALF_PI; /* REM */ 
		static double MARGIN; /* REM */ 
};

} // end namespace polartree

#endif /* INCLUDED_polartree_BBPolarTreeVO */ 

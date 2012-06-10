#ifndef INCLUDED_polartree_IImageShape
#define INCLUDED_polartree_IImageShape

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(polartree,IImageShape)
namespace polartree{


class IImageShape_obj : public hx::Interface{
	public:
		typedef hx::Interface super;
		typedef IImageShape_obj OBJ_;
		HX_DO_INTERFACE_RTTI;
virtual bool contains( double x,double y,double width,double height,double rotation,bool transformed)=0;
		Dynamic contains_dyn();
virtual bool containsPoint( double x,double y,bool transformed,hx::Null< double >  refX,hx::Null< double >  refY)=0;
		Dynamic containsPoint_dyn();
virtual bool intersects( double x,double y,double width,double height,bool transformed)=0;
		Dynamic intersects_dyn();
virtual double getWidth( )=0;
		Dynamic getWidth_dyn();
virtual double getHeight( )=0;
		Dynamic getHeight_dyn();
};

#define DELEGATE_polartree_IImageShape \
virtual bool contains( double x,double y,double width,double height,double rotation,bool transformed) { return mDelegate->contains(x,y,width,height,rotation,transformed);}  \
virtual Dynamic contains_dyn() { return mDelegate->contains_dyn();}  \
virtual bool containsPoint( double x,double y,bool transformed,hx::Null< double >  refX,hx::Null< double >  refY) { return mDelegate->containsPoint(x,y,transformed,refX,refY);}  \
virtual Dynamic containsPoint_dyn() { return mDelegate->containsPoint_dyn();}  \
virtual bool intersects( double x,double y,double width,double height,bool transformed) { return mDelegate->intersects(x,y,width,height,transformed);}  \
virtual Dynamic intersects_dyn() { return mDelegate->intersects_dyn();}  \
virtual double getWidth( ) { return mDelegate->getWidth();}  \
virtual Dynamic getWidth_dyn() { return mDelegate->getWidth_dyn();}  \
virtual double getHeight( ) { return mDelegate->getHeight();}  \
virtual Dynamic getHeight_dyn() { return mDelegate->getHeight_dyn();}  \


template<typename IMPL>
class IImageShape_delegate_ : public IImageShape_obj
{
	protected:
		IMPL *mDelegate;
	public:
		IImageShape_delegate_(IMPL *inDelegate) : mDelegate(inDelegate) {}
		hx::Object *__GetRealObject() { return mDelegate; }
		DELEGATE_polartree_IImageShape
};

} // end namespace polartree

#endif /* INCLUDED_polartree_IImageShape */ 

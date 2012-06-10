#include <hxcpp.h>

#ifndef INCLUDED_polartree_IImageShape
#include <polartree/IImageShape.h>
#endif
namespace polartree{

HX_DEFINE_DYNAMIC_FUNC6(IImageShape_obj,contains,return )

HX_DEFINE_DYNAMIC_FUNC5(IImageShape_obj,containsPoint,return )

HX_DEFINE_DYNAMIC_FUNC5(IImageShape_obj,intersects,return )

HX_DEFINE_DYNAMIC_FUNC0(IImageShape_obj,getWidth,return )

HX_DEFINE_DYNAMIC_FUNC0(IImageShape_obj,getHeight,return )


Class IImageShape_obj::__mClass;

void IImageShape_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("polartree.IImageShape"), hx::TCanCast< IImageShape_obj> ,0,0,
	0, 0,
	&super::__SGetClass(), 0, 0);
}

} // end namespace polartree

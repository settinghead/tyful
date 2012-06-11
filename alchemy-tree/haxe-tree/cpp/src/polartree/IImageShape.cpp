#include <hxcpp.h>

#ifndef INCLUDED_polartree_ImageShape
#include <polartree/ImageShape.h>
#endif
namespace polartree{

HX_DEFINE_DYNAMIC_FUNC6(ImageShape_obj,contains,return )

HX_DEFINE_DYNAMIC_FUNC5(ImageShape_obj,containsPoint,return )

HX_DEFINE_DYNAMIC_FUNC5(ImageShape_obj,intersects,return )

HX_DEFINE_DYNAMIC_FUNC0(ImageShape_obj,getWidth,return )

HX_DEFINE_DYNAMIC_FUNC0(ImageShape_obj,getHeight,return )


Class ImageShape_obj::__mClass;

void ImageShape_obj::__register()
{
	Static(__mClass) = hx::RegisterClass(HX_CSTRING("polartree.ImageShape"), hx::TCanCast< ImageShape_obj> ,0,0,
	0, 0,
	&super::__SGetClass(), 0, 0);
}

} // end namespace polartree

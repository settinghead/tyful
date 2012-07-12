#include <hxcpp.h>

#include <polartree/SplitType.h>
#include <polartree/IImageShape.h>
#include <polartree/BBPolarTreeBuilder.h>
#include <polartree/BBPolarRootTreeVO.h>
#include <polartree/BBPolarChildTreeVO.h>
#include <polartree/BBPolarTreeVO.h>
#include <haxe/Log.h>
#include <Test.h>
#include <Std.h>

void __boot_all()
{
hx::RegisterResources( hx::GetResources() );
::polartree::SplitType_obj::__register();
::polartree::IImageShape_obj::__register();
::polartree::BBPolarTreeBuilder_obj::__register();
::polartree::BBPolarRootTreeVO_obj::__register();
::polartree::BBPolarChildTreeVO_obj::__register();
::polartree::BBPolarTreeVO_obj::__register();
::haxe::Log_obj::__register();
::Test_obj::__register();
::Std_obj::__register();
::haxe::Log_obj::__boot();
::Std_obj::__boot();
::Test_obj::__boot();
::polartree::BBPolarTreeVO_obj::__boot();
::polartree::BBPolarChildTreeVO_obj::__boot();
::polartree::BBPolarRootTreeVO_obj::__boot();
::polartree::BBPolarTreeBuilder_obj::__boot();
::polartree::IImageShape_obj::__boot();
::polartree::SplitType_obj::__boot();
}


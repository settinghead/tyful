#ifndef INCLUDED_polartree_SplitType
#define INCLUDED_polartree_SplitType

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(polartree,SplitType)
namespace polartree{


class SplitType_obj : public hx::Object{
	public:
		typedef hx::Object super;
		typedef SplitType_obj OBJ_;
		SplitType_obj();
		Void __construct();

	public:
		static hx::ObjectPtr< SplitType_obj > __new();
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~SplitType_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		::String __ToString() const { return HX_CSTRING("SplitType"); }

		static int _3RAYS; /* REM */ 
		static int _2RAYS1CUT; /* REM */ 
		static int _1RAY1CUT; /* REM */ 
		static int _1RAY2CUTS; /* REM */ 
		static int _3CUTS; /* REM */ 
};

} // end namespace polartree

#endif /* INCLUDED_polartree_SplitType */ 

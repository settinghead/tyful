polartree: check
	$(AS3COMPILERARGS) -abcfuture -AS3 \
	-import $(call nativepath,$(FLASCC)/usr/lib/builtin.abc) \
	-import $(call nativepath,$(FLASCC)/usr/lib/ISpecialFile.abc) \
	-import $(call nativepath,$(FLASCC)/usr/lib/playerglobal.abc) \
	Console.as -outdir . -out Console
	# "$(FLASCC)/usr/bin/g++" -c polartree.cpp -DOSX -O3 -swc
	# "$(FLASCC)/usr/bin/g++" -c BBPolarChildTreeVO.cpp -DOSX -O3 -swc
	# "$(FLASCC)/usr/bin/g++" -c BBPolarRootTreeVO.cpp -DOSX -O3 -swc
	# "$(FLASCC)/usr/bin/g++" -c BBPolarTreeVO.cpp -DOSX -O3 -swc
	# "$(FLASCC)/usr/bin/g++" -c BBPolarTreeBuilder.cpp -DOSX -O3 -swc
	# "$(FLASCC)/usr/bin/g++" -c ImageShape.cpp -DOSX -O3 -swc

	"$(FLASCC)/usr/bin/g++" *.cpp -emit-swf -symbol-abc=Console.abc -swf-size=800x600 -lm -o polartree.swf
#
include ./Makefile.common

clean:
	rm -f *.swf *.bc *.exe

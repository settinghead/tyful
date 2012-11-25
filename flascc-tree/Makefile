polartree: check
	# $(AS3COMPILERARGS) -abcfuture -AS3 \
	# -import $(call nativepath,$(FLASCC)/usr/lib/builtin.abc) \
	# -import $(call nativepath,$(FLASCC)/usr/lib/ISpecialFile.abc) \
	# -import $(call nativepath,$(FLASCC)/usr/lib/playerglobal.abc) \
	# Console.as -outdir . -out Console

	# $(AS3COMPILERARGS) -strict -AS3 \
	# 	-import $(call nativepath,$(FLASCC)/usr/lib/builtin.abc) \
	# 	-import $(call nativepath,$(FLASCC)/usr/lib/ISpecialFile.abc) \
	# 	-import $(call nativepath,$(FLASCC)/usr/lib/CModule.abc) \
	# 	-import $(call nativepath,$(FLASCC)/usr/lib/playerglobal.abc) \
	# 	Console.as -outdir . -out Console

	"$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) -O3 -strict ../cpp_common/polartree/*.cpp ./*.cpp -emit-swc=polartree.PolarTree -o PolarTree.swc
	"$(FLEX)/bin/mxmlc" -static-link-runtime-shared-libraries -compiler.omit-trace-statements=false -default-size 1024 768 -library-path=PolarTree.swc,"$(FLEX)frameworks/libs/framework.swc" -debug=true runexperiment.as -o runexperiment.swf


	# "$(FLEX)/bin/mxmlc" -compiler.omit-trace-statements=false -library-path=PolarTree.swc -debug=true runexperiment.as -o runexperiment.swf
	# "$(FLASCC)/usr/bin/g++"  $(BASE_CFLAGS) $(OPT_CFLAGS) -g -O0 ../cpp_common/polartree/*.cpp ./*.cpp -emit-swc=polartree.PolarTree -swf-version=17 -swf-size=1024x768 -lFlash++ -lAS3++ -o PolarTree.swc $(EXTRACFLAGS)
	# "$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) $(OPT_CFLAGS) GameOfLife.cpp -symbol-abc=Console.abc -emit-swf -swf-version=17 -swf-size=800x600 -o GameOfLife.swf $(EXTRACFLAGS)


#
include ./Makefile.common

clean:
	rm -f *.swf *.swc *.bc *.exe

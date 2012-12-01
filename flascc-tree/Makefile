FLASCC=~/flascc/sdk
FLEX=~/flex

polartree: check
	@echo "-> Generate SWIG wrappers around the functions in the library"
	"$(FLASCC)/usr/bin/swig" -as3 -module PolarTreeAPI -package polartree.PolarTree -outdir ./swig -includeall -ignoremissing -o ./polartreeapi_wrapper.c swig.h

	@echo "-> Compile the SWIG wrapper to ABC"
	$(AS3COMPILERARGS) -import $(call nativepath,$(FLASCC)/usr/lib/builtin.abc) -import $(call nativepath,$(FLASCC)/usr/lib/playerglobal.abc) swig/PolarTreeAPI.as
	# rename the output so the compiler doesn't accidentally use both this .as file along with the .abc file we just produced
	mv swig/PolarTreeAPI.as swig/PolarTreeAPI.as3

	@echo "-> Compile the library into a SWC"
	"$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) -O4 -strip-all -strict -pthread ./swig/PolarTreeAPI.abc ./polartreeapi_wrapper.c ./*.cpp ../cpp/cpp/**/*.cpp -emit-swc=polartree.PolarTree -swf-version=18 -o ./bin/PolarTree.swc
	cp ./bin/PolarTree.swc ../flash/libs/
	# "$(FLEX)/bin/mxmlc" -static-link-runtime-shared-libraries -compiler.omit-trace-statements=false -default-size 1024 768 -swf-version=18 -library-path=./bin/PolarTree.swc,../flash_shared_code/bin/flash_shared_code.swc,"$(FLEX)frameworks/libs/framework.swc" -debug=true runexperiment.as -o ./bin/runexperiment.swf

include ./Makefile.common

clean:
	rm -f *.swf *.swc *.bc *.exe

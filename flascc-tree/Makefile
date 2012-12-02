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
	"$(FLASCC)/usr/bin/g++" -O4 -pthread ./swig/PolarTreeAPI.abc ./polartreeapi_wrapper.c ./main.cpp ../cpp/cpp/*.cpp ../cpp/cpp/**/*.cpp -emit-swc=polartree.PolarTree -o ./bin/PolarTree.swc
	# "$(FLASCC)/usr/bin/g++" -pthread ./swig/PolarTreeAPI.abc ./polartreeapi_wrapper.c ./main_flash.cpp ../cpp/cpp/*.cpp ../cpp/cpp/**/*.cpp -emit-swc=polartree.PolarTree -lAS3++ -lFlash++ -o ./bin/PolarTree.swc
	cp ./bin/PolarTree.swc ../flash/libs/
	
	# "$(FLEX)/bin/mxmlc" -static-link-runtime-shared-libraries -compiler.omit-trace-statements=false -default-size 1024 768 -swf-version=18 -library-path=./bin/PolarTree.swc,../flash_shared_code/bin/flash_shared_code.swc,"$(FLEX)frameworks/libs/framework.swc" -debug=true dummy.as -o ./bin/dummy.swf
	# cp ./bin/dummy.swf ../static/f/client/
	# "$(FLEX)/bin/mxmlc" -static-link-runtime-shared-libraries -compiler.omit-trace-statements=false -default-size 1024 768 -swf-version=18 -library-path=./bin/PolarTree.swc,../flash_shared_code/bin/flash_shared_code.swc,"$(FLEX)frameworks/libs/framework.swc" -debug=true runexperiment.as -o ./bin/runexperiment.swf

include ./Makefile.common

clean:
	rm -f bin/*
	rm -f swig/*

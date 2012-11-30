polartree: check
	"$(FLASCC)/usr/bin/g++" $(BASE_CFLAGS) -O4 -strip-all -strict -pthread ./*.cpp ../cpp/cpp/**/*.cpp -emit-swc=polartree.PolarTree -o ./PolarTree.swc
	cp ./PolarTree.swc ../flash/libs/
	"$(FLEX)/bin/mxmlc" -static-link-runtime-shared-libraries -compiler.omit-trace-statements=false -default-size 1024 768 -library-path=PolarTree.swc,"$(FLEX)frameworks/libs/framework.swc" -debug=true runexperiment.as -o runexperiment.swf

include ./Makefile.common

clean:
	rm -f *.swf *.swc *.bc *.exe

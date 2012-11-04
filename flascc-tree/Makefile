polartree: check
	# $(AS3COMPILERARGS) -abcfuture -AS3 \
	# -import $(call nativepath,$(FLASCC)/usr/lib/builtin.abc) \
	# -import $(call nativepath,$(FLASCC)/usr/lib/ISpecialFile.abc) \
	# -import $(call nativepath,$(FLASCC)/usr/lib/playerglobal.abc) \
	# Console.as -outdir . -out Console

	"$(FLASCC)/usr/bin/g++" -04 polartree/*.cpp -emit-swc=polartree.PolarTree -lFlash++ -lAS3++ -o polartree/PolarTree.swc
	"$(FLEX)/bin/mxmlc" -compiler.omit-trace-statements=false -library-path=polartree/PolarTree.swc -debug=true runexperiment.as -o runwxperiment.swf

#
include ./Makefile.common

clean:
	rm -f *.swf *.swc *.bc *.exe

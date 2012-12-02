$?FLASCC=$(PWD)/../sdk


workers.swf: check
	$(AS3COMPILERARGS) -strict -AS3 \
	-import $(call nativepath,$(FLASCC)/usr/lib/builtin.abc) \
	-import $(call nativepath,$(FLASCC)/usr/lib/ISpecialFile.abc) \
	-import $(call nativepath,$(FLASCC)/usr/lib/CModule.abc) \
	-import $(call nativepath,$(FLASCC)/usr/lib/playerglobal.abc) \
	Console.as -outdir . -out Console

	$(FLASCC)/usr/bin/g++ -O0 -emit-swf -pthread -symbol-abc=Console.abc workers.cpp -o workers.swf

include ./Makefile.common

clean:
	rm -f $(SWFS)

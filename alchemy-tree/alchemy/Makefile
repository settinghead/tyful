T02: check
	@echo "-------- Tutorial 2 --------"
	@echo "\nFirst let's compile it as a projector:"
	"$(FLASCC)/usr/bin/gcc" hellointerop.c -o hellointerop.exe

	@echo "\nNow lets compile it as a SWF:"
	"$(FLASCC)/usr/bin/gcc" hellointerop.c -emit-swf -swf-size=200x200 -o hellointerop.swf

	@echo "\nSome more advanced C++ interop:"
	"$(FLASCC)/usr/bin/g++" c++interop.cpp -emit-swf -swf-size=200x200 -lFlash++ -lAS3++ -o c++interop.swf

include ../Makefile.common

clean:
	rm -f *.swf *.bc *.exe

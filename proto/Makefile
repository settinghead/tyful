all:
	protoc template.proto --cpp_out=../cpp/cpp/proto
	for file in ../cpp/cpp/proto/*.cc; do \
    	mv "$$file" "$${file%.cc}.cpp"; \
	done
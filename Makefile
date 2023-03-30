LLVM_BUILD_TYPE=Release # or RelWithDebInfo for debugging
DLLVM_CCACHE_BUILD=OFF # or ON for ccache installed
PWD=$(shell pwd)
BUILD_PATH = $(PWD)/build
INSTALL_PATH = $(PWD)/install

# if you have mold installed, you can use it to speed up the build
MOLD:= $(INSTALL_PATH)/mold-1.8.0-x86_64-linux/bin/mold -run

.PHONY: clang llvm configure/llvm example

# only build clang and lld
clang: $(BUILD_PATH)/llvm/build.ninja install/mold
	$(MOLD) cmake --build $(BUILD_PATH)/llvm --config ${LLVM_BUILD_TYPE} -j $(shell nproc) --target clang lld
	cp $(BUILD_PATH)/llvm/bin/clang-17 install/llvm/bin/clang-17
	cp $(BUILD_PATH)/llvm/bin/lld install/llvm/bin/lld

# build whole llvm projects
llvm: $(BUILD_PATH)/llvm/build.ninja install/mold
	mkdir -p $(INSTALL_PATH)/llvm
	$(MOLD) cmake --build $(BUILD_PATH)/llvm --config ${LLVM_BUILD_TYPE} -j $(shell nproc) --target install
	$(MOLD) cmake --build $(BUILD_PATH)/llvm --config ${LLVM_BUILD_TYPE} -j $(shell nproc) --target install-profile

# run example
example: example/main.c
	$(INSTALL_PATH)/llvm/bin/clang-17 -O3 -mllvm -EnablePushPopProfile example/main.c $(INSTALL_PATH)/llvm/lib/clang/17/lib/x86_64-unknown-linux-gnu/clang_rt.hp.o   -o example/main
	cd example && ./main 

install/mold:
	cd $(INSTALL_PATH)/ && wget https://github.com/rui314/mold/releases/download/v1.8.0/mold-1.8.0-x86_64-linux.tar.gz
	cd $(INSTALL_PATH)/ && tar -xvf mold-1.8.0-x86_64-linux.tar.gz && rm mold-1.8.0-x86_64-linux.tar.gz
	touch $@

configure/llvm: $(BUILD_PATH)/llvm/build.ninja

$(BUILD_PATH)/llvm/build.ninja:
	mkdir -p $(BUILD_PATH)/llvm
	cmake -G Ninja -B $(BUILD_PATH)/llvm -S $(PWD)/llvm \
		-DCMAKE_BUILD_TYPE=${LLVM_BUILD_TYPE} \
		-DLLVM_ENABLE_ASSERTIONS=ON \
		-DBUILD_SHARED_LIBS=ON \
		-DLLVM_INCLUDE_TESTS=OFF \
		-DLLVM_BUILD_TESTS=OFF \
		-DLLVM_CCACHE_BUILD=OFF \
		-DLLVM_PARALLEL_LINK_JOBS=8 \
		-DLLVM_OPTIMIZED_TABLEGEN=ON \
		-DLLVM_TARGETS_TO_BUILD="X86" \
		-DLLVM_ENABLE_RTTI=ON \
		-DLLVM_ENABLE_PROJECTS="clang;lld;llvm;compiler-rt" \
		-DCMAKE_INSTALL_PREFIX=$(INSTALL_PATH)/llvm \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=1
SRCDIR = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
override CXXFLAGS += -g -std=c++11 -Ideps/include
CPPSRC = main.cpp
DEPS_LIBS = deps/avcpp/build/src/libavcpp.a
LIBS_FLAGS = -lavcodec -lavfilter -lavutil -lavformat -lavdevice -lswscale -lswresample
EXE = avcpp_example
CPPSRC_ALL = $(CPPSRC)

DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td
DEPDIR := objs
POSTCOMPILE = @mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d && touch $@

.PHONY: build install clean
.DEFAULT_GOAL := build


$(patsubst %.cpp,objs/%.o,$(CPPSRC_ALL)): objs/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(DEPFLAGS) -c -o $@ $<
	$(POSTCOMPILE)


$(EXE): $(patsubst %.cpp,objs/%.o,$(CPPSRC_ALL)) $(DEPS_LIBS)
	$(CXX) $(CXXFLAGS) $(LFLAGS) -o $@ $^ $(LIBS_FLAGS)

build: $(EXE)

clean:
	rm $(EXE) || true
	rm -r objs || true


deps/avcpp/build/src/libavcpp.a:
	rm -r deps/avcpp/build || true
	mkdir -p deps/avcpp/build
	cd deps/avcpp/build && cmake -DAV_ENABLE_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="$(CXXFLAGS)" -DCMAKE_EXE_LINKER_FLAGS="$(LFLAGS)" -DCMAKE_AR=`which gcc-ar` -DCMAKE_RANLIB=`which gcc-ranlib` .. && make -j`nproc`

.PRECIOUS: objs/%.d

include $(wildcard $(patsubst %.cpp,objs/%.d,$(CPPSRC_ALL)))

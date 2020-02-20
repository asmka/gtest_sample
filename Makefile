# main makefile
# directory
SRCDIR = ./src
INCDIR = ./include
LIBDIR = ./lib
OBJDIR = ./obj
TRGDIR = ./target

# files
TRG = $(TRGDIR)/gtest_sample
SRCS = $(wildcard $(SRCDIR)/*.cpp)
OBJS = $(addprefix $(OBJDIR)/, $(notdir $(SRCS:.cpp=.o)))
DEPS = $(OBJS:.o=.d)

# param
CXX = g++
COMPFLAGS = -I$(INCDIR) -std=c++17 -Wall -MMD -MP
LINKFLAGS = -L$(LIBDIR) -lgtest_main -lgtest -lpthread
RM = rm -f

# optimization
# to build with debug mode, run "make buildtype=debug"
buildtype = release
ifeq ($(buildtype), release)
	COMPFLAGS += -O3
else ifeq ($(buildtype), debug)
	COMPFLAGS += -O0 -g -D_DEBUG
	LINKFLAGS += -g
else
	$(error buildtype must be release or debug)
endif

# link
$(TRG): $(OBJS)
	$(CXX) -o $@ $(LINKFLAGS) $^

# resolve header dependency from the second time
-include $(DEPS)

# each compile
$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	$(CXX) -o $@ -c $(COMPFLAGS) $<

# empty target
.PHONY: clean
clean: 
	$(RM) $(TRG) $(OBJS) $(DEPS)

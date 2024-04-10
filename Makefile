# Define compiler
CXX=g++

# Compiler flags
CXXFLAGS=-std=c++14 -pthread -I/usr/include -I./generated -I./src/include -I./json/single_include -fPIC
# debugging
CXXFLAGS+=-g -O0

# Linker flags
LDFLAGS=-lgrpc++ -lgrpc -lgrpc++_reflection -lprotobuf -ldl

# Source files
SOURCES= $(wildcard generated/*.cpp) $(wildcard src/impl/*.cpp)
SOURCES += $(wildcard src/impl/types/*.cpp)

# Object files
OBJECTS=$(SOURCES:.cpp=.o)

# Output binary
LIBRARY=libmilvus.so

all: $(SOURCES) $(LIBRARY)

$(LIBRARY): $(OBJECTS)
	$(CXX) $(CXXFLAGS) $(OBJECTS) -shared -o $(LIBRARY) $(LDFLAGS)

.cpp.o:
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean: uninstall
	rm -f $(OBJECTS) $(LIBRARY)

install: $(LIBRARY)
	# copy libmilvus.so to /usr/lib
	cp $(LIBRARY) /usr/lib
	# copy ./src/include to /usr/include
	cp -r ./src/include/milvus /usr/include

uninstall:
	# remove libmilvus.so from /usr/lib
	rm -f /usr/lib/$(LIBRARY)
	# remove ./src/include from /usr/include
	rm -rf /usr/include/milvus
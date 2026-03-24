import std.stdio;

@nogc {
    // 1. Define the fallback for Linux
    version(linux) {
        import core.stdc.stdlib : malloc, realloc, free;
        
        struct DVector(T) {
            private T* _data;
            private size_t _capacity;
            private size_t _length;

            @disable this(this);

            ~this() { if (_data) free(_data); }

            void reserve(size_t newCap) {
                if (newCap <= _capacity) return;
                _data = cast(T*) realloc(_data, newCap * T.sizeof);
                _capacity = newCap;
            }

            void push_back(T value) {
                if (_length == _capacity) reserve(_capacity == 0 ? 4 : _capacity * 2);
                _data[_length++] = value;
            }

            size_t size() const { return _length; }
            bool empty() const { return _length == 0; }
            T* data() { return _data; }

            ref T opIndex(size_t index) in { assert(index < _length); } do {
                return _data[index];
            }
        }
    }

    // 2. Build the Heap using version blocks
    struct Heap(T) {
        
        // Use the C++ vector on Windows
        version(Windows) {
            import core.stdcpp.vector : vector, Default;
            private auto vec = new vector!T(Default);
        } 
        // Use the custom D vector on Linux
        else version(linux) {
            private DVector!T vec;
        } 
        // Catch any other unsupported operating systems
        else {
            static assert(0, "Platform not supported");
        }

        @disable this(this);

        this(scope T[] arg) {
            vec.reserve(arg.length);
            foreach(res; arg) {
                vec.push_back(res);
            }
        }

        ref T opIndex(size_t index) {
            return vec[index];
        }

        T[] opSlice() {
            if (vec.empty()) return [];
            return vec.data()[0 .. vec.size()];
        }
    }
}

void main() {
    Heap!int p = [10, 20, 30, 40, 50];
    // This now compiles and runs on both using OS-specific backends!
}
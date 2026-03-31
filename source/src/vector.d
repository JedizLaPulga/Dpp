module src.vector;

    struct Vector(T){

        // private members
        private T* _data = null;
        private size_t _length;
        private size_t _capacity;
        import core.stdc.stdlib : malloc, free;

        // default constructor allowed
        @disable this(this);

        this(Args...)(Args args) if (args.length > 0) {
            this._length = args.length;
            this._capacity = args.length;
            this._data = cast(T*)malloc(this._capacity * T.sizeof);

            static foreach (i; 0 .. args.length) {
            // Check if the argument can actually be assigned to T
            static assert(is( typeof(args[i]) : T),  "Incompactible type for Vector!T: " 
                ~typeof(args[i]).stringof);
                import core.lifetime : emplace;
                emplace(&this._data[i], args[i]);
            }
        }

        void opAssign(Vector!T other) {
            import std.algorithm : swap;
            swap(this._data, other._data);
            swap(this._length, other._length);
            swap(this._capacity, other._capacity);
        }

        @property size_t length() const { return _length; }
        @property size_t capacity() const { return _capacity; }

        ~this(){
            if (_data !is null) {
            // If T has a destructor (like a string or another struct), 
            // you should call it for each element before freeing.
            static if (__traits(hasMember, T, "__dtor")) {
                foreach (i; 0 .. _length) {
                    destroy(_data[i]);
                }
            }
                free(_data);
                _data = null;
            }
        }

        void reserve(size_t newCapacity) {
            if (newCapacity <= _capacity) return;
            import core.stdc.stdlib : realloc;
            T* newData = cast(T*)realloc(_data, newCapacity * T.sizeof);
            if (newData) {
                _data = newData;
                _capacity = newCapacity;
            } else {
                import core.exception : OutOfMemoryError;
                throw new OutOfMemoryError("Failed to allocate memory for Vector");
            }
        }

        void pushBack(T value) {
            if (_length == _capacity) {
                reserve(_capacity == 0 ? 4 : _capacity * 2);
            }
            import core.lifetime : emplace;
            emplace(&_data[_length], value);
            _length++;
module src.vector;

    struct Vector(T){

        // private members
        private T* _data = null;
        private size_t _length;
        private size_t _capacity;
        import core.stdc.stdlib : malloc, free;

        // default constructor allowed
        @disable this(this);

        this(Args...)(Args args) if (args.length > 0) {
            this._length = args.length;
            this._capacity = args.length;
            this._data = cast(T*)malloc(this._capacity * T.sizeof);

            static foreach (i; 0 .. args.length) {
            // Check if the argument can actually be assigned to T
            static assert(is( typeof(args[i]) : T),  "Incompactible type for Vector!T: " 
                ~typeof(args[i]).stringof);
                import core.lifetime : emplace;
                emplace(&this._data[i], args[i]);
            }
        }

        void opAssign(Vector!T other) {
            import std.algorithm : swap;
            swap(this._data, other._data);
            swap(this._length, other._length);
            swap(this._capacity, other._capacity);
        }

        @property size_t length() const { return _length; }
        @property size_t capacity() const { return _capacity; }

        ~this(){
            if (_data !is null) {
            // If T has a destructor (like a string or another struct), 
            // you should call it for each element before freeing.
            static if (__traits(hasMember, T, "__dtor")) {
                foreach (i; 0 .. _length) {
                    destroy(_data[i]);
                }
            }
                free(_data);
                _data = null;
            }
        }

        void reserve(size_t newCapacity) {
            if (newCapacity <= _capacity) return;
            import core.stdc.stdlib : realloc;
            T* newData = cast(T*)realloc(_data, newCapacity * T.sizeof);
            if (newData) {
                _data = newData;
                _capacity = newCapacity;
            } else {
                import core.exception : OutOfMemoryError;
                throw new OutOfMemoryError("Failed to allocate memory for Vector");
            }
        }

        void pushBack(T value) {
            if (_length == _capacity) {
                reserve(_capacity == 0 ? 4 : _capacity * 2);
            }
            import core.lifetime : emplace;
            emplace(&_data[_length], value);
            _length++;
        }

        void opOpAssign(string op)(T value) if (op == "~") {
            pushBack(value);
        }

        T popBack() {
            assert(_length > 0, "Cannot pop from an empty vector.");
            _length--;
            T val = _data[_length];
            static if (__traits(hasMember, T, "__dtor")) {
                destroy(_data[_length]);
            }
            return val;
        }

        @property ref inout(T) front() inout {
            assert(_length > 0, "Cannot access front of an empty vector.");
            return _data[0];
        }

        @property ref inout(T) back() inout {
            assert(_length > 0, "Cannot access back of an empty vector.");
            return _data[_length - 1];
        }

        void popFront() {
            assert(_length > 0, "Cannot popFront from an empty vector.");
            removeAt(0);
        }

        void insertAt(size_t index, T value) {
            assert(index <= _length, "Index out of bounds");
            if (_length == _capacity) {
                reserve(_capacity == 0 ? 4 : _capacity * 2);
            }
            import core.stdc.string : memmove;
            if (index < _length) {
                memmove(&_data[index + 1], &_data[index], (_length - index) * T.sizeof);
            }
            import core.lifetime : emplace;
            emplace(&_data[index], value);
            _length++;
        }

        T removeAt(size_t index) {
            assert(index < _length, "Index out of bounds");
            import core.lifetime : move;
            T val = move(_data[index]);
            import core.stdc.string : memmove;
            if (index < _length - 1) {
                memmove(&_data[index], &_data[index + 1], (_length - index - 1) * T.sizeof);
            }
            _length--;
            import core.stdc.string : memset;
            memset(&_data[_length], 0, T.sizeof);
            return val;
        }

        inout(T)[] opSlice() inout {
            return _data[0 .. _length];
        }

        void shrinkToFit() {
            if (_capacity == _length) return;
            if (_length == 0) {
                import core.stdc.stdlib : free;
                free(_data);
                _data = null;
                _capacity = 0;
            } else {
                import core.stdc.stdlib : realloc;
                T* newData = cast(T*)realloc(_data, _length * T.sizeof);
                if (newData) {
                    _data = newData;
                    _capacity = _length;
                }
            }
        }

        ref inout(T) opIndex(size_t index) inout {
            assert(index < _length, "Index out of bounds");
            return _data[index];
        }

        void opIndexAssign(T value, size_t index) {
            assert(index < _length, "Index out of bounds");
            _data[index] = value;
        }

        void clear() {
            static if (__traits(hasMember, T, "__dtor")) {
                foreach (i; 0 .. _length) {
                    destroy(_data[i]);
                }
            }
            _length = 0;
        }

        @property bool empty() const { return _length == 0; }

    }

    unittest {
        Vector!int vec;
        assert(vec.empty);
        assert(vec.length == 0);
        assert(vec.capacity == 0);

        vec.pushBack(10);
        assert(!vec.empty);
        assert(vec.length == 1);
        assert(vec.capacity >= 1);
        assert(vec[0] == 10);

        vec ~= 20;
        assert(vec.length == 2);
        assert(vec[1] == 20);

        vec[1] = 30;
        assert(vec[1] == 30);

        int popped = vec.popBack();
        assert(popped == 30);
        assert(vec.length == 1);

        vec.clear();
        assert(vec.empty);
        assert(vec.capacity > 0);

        // Test new features
        Vector!int vec2;
        vec2.pushBack(1);
        vec2.pushBack(2);
        vec2.pushBack(3);

        assert(vec2.front == 1);
        assert(vec2.back == 3);

        vec2.popFront();
        assert(vec2.length == 2);
        assert(vec2.front == 2);

        vec2.insertAt(1, 10);
        assert(vec2.length == 3);
        assert(vec2[1] == 10);
        assert(vec2[2] == 3);

        int rem = vec2.removeAt(1);
        assert(rem == 10);
        assert(vec2.length == 2);
        assert(vec2[1] == 3);

        int[] slice = vec2.opSlice();
        assert(slice.length == 2);
        assert(slice[0] == 2);
        assert(slice[1] == 3);

        vec2.shrinkToFit();
        assert(vec2.capacity == 2);
    }

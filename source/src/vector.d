module src.vector;

    struct Vector(T){

        // private members
        private T* _data = null;
        private size_t _length;
        private size_t _capacity;
        import core.stdc.stdlib : malloc, free;

        @disable this();
        @disable this(this);

        this(Args...)(Args args){
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
            }
            free(null); // Just to be safe, set _data to null after freeing
        }

    

    }



module src.vector;

    struct Vector(T){

        // private members
        private T* data = null;
        private size_t length;
        private size_t capacity;
        import core.stdc.stdlib : malloc, free;

        @disable this();
        @disable this(this);

        this(Args...)(Args args){
            this.length = args.length;
            this.capacity = args.length;
            this.data = cast(T*)malloc(this.capacity * T.sizeof);

            static foreach (i; 0 .. args.length) {
            // Check if the argument can actually be assigned to T
            static assert(is( typeof(args[i]) : T),  "Argument at index "  ~ i.stringof ~  
            " is not compatible with " ~ T.stringof);
                import core.lifetime : emplace;
                emplace(&data[i], args[i]);
            }
        }



        ~this(){
            free(data);
        }

    

    }



module src.vector;
extern(C){
    
    struct Vector(T){
        private T* data = void;
        private size_t length;
        private size_t capacity;

        this(size_t length){
            this.length = length;
            this.data = cast(T*)malloc(length * T.sizeof);
        }



        ~this(){
            free(data);
        }

    

    }



}
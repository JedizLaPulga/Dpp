module src.vector;
extern(C){
    
    struct Vector(T){
        private T* data = void;
        private size_t length;

        this(size_t length){
            this.length = length;
            this.data = cast(T*)malloc(length * T.sizeof);
        }



        ~this(){
            free(data);
        }

    

    }



}
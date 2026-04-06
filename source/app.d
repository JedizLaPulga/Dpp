
import std.stdio;

void main() {
    int counter = 0;

    while(true){
        stdout.writefln("Counter: %d", counter++);
        if(counter >= 10){
            break;
        }

        stdout.writeln(counter.alignof);



    }

}
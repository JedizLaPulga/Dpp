
import src.vector;
import std.stdio;
import core.lifetime : emplace, move;

void main(){

    auto vec = Vector!int(1, 2, 3, 4, 5);
    auto vec2 = move(vec); // Move vec into vec2, vec should now be empty
  
    writeln("Vector length: ", vec2.length);
    writeln("Vector capacity: ", vec2.capacity);
   

}
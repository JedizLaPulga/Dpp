import std.stdio;
import std.typecons;

void main() {
    // Create the tuple
    auto tup = tuple(500, 6.4, 1);
    // Unpack (destructure) the tuple
    auto x = tup[0];
    auto y = tup[1];
    auto z = tup[2];

    writeln("The value of y is: ", y);
    
}
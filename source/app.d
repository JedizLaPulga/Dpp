import std.stdio;
import std.typecons;

void main() {
    // Create the tuple
    auto tup = tuple(500, 6.4, 1);

    // Loop over the tuple elements
    foreach (i, elem; tup.tupleof) {
        writeln("Element ", i, ": ", elem);
    }

    foreach (i, elem; tup.tupleof) {
        writeln("Element ", i, ": ", elem);
    }

    // The tuple remembers its length
    writeln("Tuple length: ", tup.length);
}
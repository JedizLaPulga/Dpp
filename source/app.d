import std.stdio;

import core.stdcpp.vector: vector, Default;

struct Vec(T){

	auto vec = vector!T(Default);	

	this(T[] arg){
		vec.reserve(arg.length); // ensuring memory
		foreach( res ; arg){
			vec.push_back(res);
		}
	}

	ref T opIndex(size_t index)
	in{
		assert(index < vec.size(), "Index out of bound");
	}do{
		return vec[index];
	}
}




void main()
{
	Vec!int p = [10,20,30];
	writeln(p[0]);
}

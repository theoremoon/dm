module value;

import std.conv;
import dcnum;

struct Value {
  protected:
    DCNum v;

  public:
    this(DCNum v) {
      this.v = v;
    }

    Value opBinary(string op)(Value rhs)
    {
      return Value(mixin("this.v" ~ op ~ "rhs.v"));
    }

    string toString() {
      return this.v.to!string;
    }

    long toLong() {
      return v.toLong();
    }
}

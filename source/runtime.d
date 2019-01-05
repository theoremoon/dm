module runtime;

import token;
import value;
import stack;
import exception;
import func;
import dcnum;
import std.range;
import std.stdio;


class Runtime {
  protected:
    Stack stack_;
    BuiltinFuncT[string] builtins;
    // string[string] funcs;
    Token[] source_;
    ulong ip_;
    uint scale_;

  public:

    this(uint max_stack_size, uint max_stack_num, uint scale) {
      stack_ = new Stack(max_stack_size, max_stack_num);
      scale_ = scale;

      builtins = [
        "+": &builtin_add,
        "-": &builtin_sub,
        "*": &builtin_mul,
        "/": &builtin_div,
        ".": &builtin_print,
        "#": &builtin_size,
        "[": &builtin_puship,
        "]": &builtin_jump,
        "~": &builtin_swap,
        "&": &builtin_dup,
        "!": &builtin_incsp,
        "?": &builtin_decsp,
        "}": &builtin_next,
        "{": &builtin_prev,
      ];

      ip_ = 0;
    }

    Value makeValue(string s) {
      return Value(DCNum(s, scale_));
    }
    Value makeValue(long v) {
      return Value(DCNum(v, scale_));
    }

    @property Stack stack() { return this.stack_; }
    BuiltinFuncT* getBuiltin(string f) { return f in builtins; }

    @property void setNewSource(Token[] s) {
      this.source_ = s;
      this.ip_ = 0;
    }
    @property bool end() { return source_.length <= ip_; }
    @property ulong ip() { return ip_; }
    void next() { ip_++; }
    Token getCmd() { return source_[ip_]; }
    void jump(ulong ip) { this.ip_ = ip; }
}

void execute(Runtime runtime, Token[] source) {
  runtime.setNewSource(source);

  for (; !runtime.end; runtime.next()) {
    auto cmd = runtime.getCmd;

    try {
      final switch (cmd.type) {
        case Token.Type.NUMBER:
          // push value to stack
          runtime.stack.push(runtime.makeValue(cmd.str));
          break;

        case Token.Type.SYMBOL:
          if (auto f = runtime.getBuiltin(cmd.str)) {
            (*f)(runtime);
            break;
          } 
          throw new DMRuntimeError("no such function: " ~ cmd.str);
        case Token.Type.NEWLINE:
          break;
      }
    }
    catch (DMRuntimeError e) {
      writefln("%s on \"%s\" at %s", e.msg, cmd.str, cmd.loc);
      writeln(runtime.stack.dump);
      return;
    }
  }
}

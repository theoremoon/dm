module func;

import stack;
import value;
import runtime;
import std.conv;
import std.stdio;

alias BuiltinFuncT = void function(Runtime);

void builtin_add(Runtime r) {
  auto v2 = r.stack.pop();
  auto v1 = r.stack.pop();
  r.stack.push( v1 + v2 );
}
void builtin_sub(Runtime r) {
  auto v2 = r.stack.pop();
  auto v1 = r.stack.pop();
  r.stack.push( v1 - v2 );
}
void builtin_mul(Runtime r) {
  auto v2 = r.stack.pop();
  auto v1 = r.stack.pop();
  r.stack.push( v1 * v2 );
}
void builtin_div(Runtime r) {
  auto v2 = r.stack.pop();
  auto v1 = r.stack.pop();
  r.stack.push( v1 / v2 );
}
void builtin_size(Runtime r) {
  auto v = r.makeValue(r.stack.sp);
  r.stack.push(v);
}
void builtin_swap(Runtime r) {
  auto v2 = r.stack.pop();
  auto v1 = r.stack.pop();
  r.stack.push(v2);
  r.stack.push(v1);
}
void builtin_dup(Runtime r) {
  auto v = r.stack.pop();
  r.stack.push(v);
  r.stack.push(v);
}
void builtin_puship(Runtime r) {
  auto v = r.makeValue(r.ip);
  r.stack.push(v);
}
void builtin_jump(Runtime r) {
  auto ip = r.stack.pop().toLong();
  r.jump(ip-1);
}
void builtin_incsp(Runtime r) {
  r.stack.inc();
}
void builtin_decsp(Runtime r) {
  r.stack.dec();
}
void builtin_next(Runtime r) {
  r.stack.next();
}
void builtin_prev(Runtime r) {
  r.stack.prev();
}

void builtin_print(Runtime r) {
  auto v1 = r.stack.pop();
  writeln(v1.to!string());
}

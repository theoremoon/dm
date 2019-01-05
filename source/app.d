import std.stdio;
import std.string;
import std.conv;
import std.file;

import tokenize : tokenize;
import token;
import runtime;

void main(string[] args) {
  uint max_stack_size = 50000;
  uint max_stack_num = 1000;
  uint scale = 0;
  bool help_flag = false;
  bool read_stdin_flag = false;
  Token[][] sources;

  for (uint i = 1; i < args.length; i++) {
    // scale
    if (args[i] == "--scale" || args[i] == "-s") {
      if (++i < args.length) {
        scale = args[i].to!uint;
      } else {
        help_flag = true;
        break;
      }
    }

    // max_stack_size
    else if (args[i] == "--stack-size") {
      if (++i < args.length) {
        max_stack_size = args[i].to!uint;
      } else {
        help_flag = true;
        break;
      }
    }

    // max_stack_num
    else if (args[i] == "--stack-num") {
      if (++i < args.length) {
        max_stack_num = args[i].to!uint;
      } else {
        help_flag = true;
        break;
      }
    }

    // source by -e
    else if (args[i] == "-e") { 
      if (++i < args.length) {
        sources ~= tokenize("-e", args[i]);
      } else {
        help_flag = true;
        break;
      }
    }

    // source file
    else if (args[i].exists && args[i].isFile){
      sources ~= tokenize(args[i], args[i].readText);
    }

    // stdin
    else if (args[i] == "-") {
      read_stdin_flag = true;
    }

    // help
    else {
      help_flag = true;
      break;
    }
  }

  if (help_flag) {
    writefln("Usage: %s [OPTION...] [FILE...]", args[0]);
    writeln(" -e              EXPR   evaluate expression");
    writeln(" -s --scale      SCALE  set default scale");
    writeln("    --stack-size SIZE   set max stack size");
    writeln("    --stack-num  NUM    set max number of stacks");
    writeln(" -h --help              show this help");
    writeln("                 FILE   evaluate source file");
    writeln("");
    return;
  }

  auto runtime = new Runtime(max_stack_size, max_stack_num, scale);

  foreach (source; sources) {
    runtime.execute(source);
  }

  if (read_stdin_flag || sources.length == 0) {
    foreach (line; stdin.byLine) {
      auto source = tokenize("-", line.dup);
      runtime.execute(source);
    }
  }
}

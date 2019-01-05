module tokenize;

import loc;
import token;
import exception;
import std.algorithm;
import std.regex;
import std.format;

Token[] tokenize(string file, string s) {
  Token[] ts;
  int line = 1;
  int col = 1;
  int p = 0;

  while (p < s.length) {
    while (p < s.length && s[p] == ' ') {
      p++;
      col++;
    }

    ulong l = capture_num(s[p..$]);
    if (l > 0) {
      ts ~= Token(Loc(file, line, col), Token.Type.NUMBER, s[p..p+l]);
      p += l;
      col += l;
      continue;
    }

    l = capture_symbol(s[p..$]);
    if (l > 0) {
      ts ~= Token(Loc(file, line, col), Token.Type.SYMBOL, s[p..p+l]);
      p += l;
      col += l;
      continue;
    }

    if (s[p] == '\n' || s[p] == '\r') {
      ts ~= Token(Loc(file, line, col), Token.Type.NEWLINE, "\n");
      p++;
      if (s[p] == '\r' && p + 1 < s.length && s[p+1] == '\n') {
        p++;
      }
      col = 1;
      line++;
      continue;
    }

    if (s[p] == ';') {
      ts ~= Token(Loc(file, line, col), Token.Type.NEWLINE, ";");
      p++;
      col++;
      continue;
    }

    throw new DMParseError("Illegal character: " ~ s[p]);
  }

  return ts;
}

ulong capture_num(string s) {
  // const hex_pattern = "-?0x[A-F0-9]+"; 
  // const dec_pattern = r"-?([1-9][0-9]*|0)(\.[0-9]+)?"; 
  // const pattern = ctRegex!("^(%s|%s)".format(hex_pattern, dec_pattern));
  const dec_pattern = r"-?([1-9][0-9]*|0)(\.[0-9]+)?"; 
  const pattern = ctRegex!("^%s".format(dec_pattern));

  auto cap = matchFirst(s, pattern);
  return (cap.empty) ? 0 : cap[0].length;
}

ulong capture_symbol(string s) {
  const string[] syms = ["+", "-", "*", "/", "@", "!", "?", "{", "}", ".", "#", "[", "]", "~", "&"];
  
  ulong l = 0;
  foreach (sym; syms) {
    if (s.startsWith(sym)) {
      l = max(sym.length, l);
    }
  }
  return l;
}

unittest {
  auto tokens = tokenize("stdin", `1 0.1234 +.`);
  assert(tokens.length == 4);
  assert(tokens[0] == Token(Loc("stdin", 1, 1), Token.Type.NUMBER, "1"));
  assert(tokens[1] == Token(Loc("stdin", 1, 3), Token.Type.NUMBER, "0.1234"));
  assert(tokens[2] == Token(Loc("stdin", 1, 10), Token.Type.SYMBOL, "+"));
  assert(tokens[3] == Token(Loc("stdin", 1, 11), Token.Type.SYMBOL, "."));
}

unittest {
  assert(capture_num("1") == 1);
  assert(capture_num("123") == 3);
  assert(capture_num("123.45") == 6);
  assert(capture_num("0.5") == 3);
  assert(capture_num("-123") == 4);

  assert(capture_num("0x1FB") == 5);
  assert(capture_num("0x1FB.C") == 5);

  assert(capture_num("012") == 1);
  assert(capture_num(".5") == 0);
  assert(capture_num("0.") == 1);
}

unittest {
  assert(capture_symbol("+*?/") == 1);
  assert(capture_symbol("<<") == 0);
  assert(capture_symbol("{}") == 1);
}


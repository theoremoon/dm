module loc;

import std.format;
struct Loc {
  protected:
    string file;
    int line;
    int col;

  public:
    this(string file, int line, int col) {
      this.file = file;
      this.line = line;
      this.col = col;
    }

    string toString() {
      return "file: %s, line: %d, column: %d".format(file, line, col);
    }
}

module token;
import loc;


struct Token {
  public:
    enum Type {
      NUMBER,
      SYMBOL,
      NEWLINE,
    }

  protected:
    Loc loc_;
    Type type_;
    string s_;

  public:
    this(Loc loc, Type t, string s) {
      this.loc_ = loc;
      this.type_ = t;
      this.s_ = s;
    }

    @property Loc loc() { return this.loc_; }
    @property Type type() { return this.type_; }
    @property string str() { return this.s_; }
}

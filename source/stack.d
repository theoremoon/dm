module stack;

import value;
import exception;
import std.conv;

class InnerStack {
  protected:
    uint max_stack_size_;

    Value[] stack_;
    uint sp_;
  public:
    this(uint max_stack_size) {
      this.max_stack_size_ = max_stack_size;
      this.sp_ = 0;
      this.stack_.length = 1;
    }

    @property ulong sp() {
      return this.sp_;
    }

    void push(in Value v) {
      // extending stack size
      while (this.stack_.length <= sp_) {
        if (this.stack_.length * 2 >= max_stack_size_) {
          this.stack_.length = this.max_stack_size_;
        } else {
          this.stack_.length = this.stack_.length * 2;
        }
      }

      this.stack_[sp_] = v;
      sp_++;

      if (sp_ >= this.max_stack_size_) {
        throw new DMRuntimeError("stack error");
      }
    }

    Value pop() {
      if (sp_ == 0) {
        throw new DMRuntimeError("stack error");
      } 
      sp_--;
      return this.stack_[sp_];
    }

    ulong inc() {
      this.sp_++;
      if (sp_ >= this.max_stack_size_) {
        throw new DMRuntimeError("stack error");
      }
      return this.sp_;
    }
    ulong dec() {
      if (sp_ == 0) {
        throw new DMRuntimeError("stack error");
      } 
      this.sp_--;
      return this.sp_;
    }

    string dump() {
      return this.stack_[0..sp_].to!string;
    }
}

class Stack {
  protected:
    uint max_stack_num_;
    uint max_stack_size_;
    uint si_;    /// stack id

    InnerStack[] stack_;
  public:
    this(uint max_stack_size, uint max_stack_num) {
      this.max_stack_size_ = max_stack_size;
      this.max_stack_num_ = max_stack_num;

      this.si_ = 0;
      this.stack_ = [ new InnerStack(max_stack_size_) ];
    }

    @property InnerStack inner() { return this.stack_[si_]; }
    @property ulong sp() {
      return this.inner.sp;
    }

    void next() {
      this.si_++;
      if (this.si_ >= max_stack_num_) {
        throw new DMRuntimeError("too many stacks");
      }
      if (this.si_ >= stack_.length) {
        this.stack_ ~= new InnerStack(max_stack_size_);
      }
    }

    void prev() {
      if (this.si_ == 0) {
        throw new DMRuntimeError("negative stack id");
      }
      this.si_--;
    }
    
    void push(in Value v) {
      this.inner.push(v);
    }
    Value pop() {
      return this.inner.pop();
    }
    ulong inc() {
      return this.inner.inc();
    }
    ulong dec() {
      return this.inner.dec();
    }
    string dump() {
      return this.inner.dump();
    }
}

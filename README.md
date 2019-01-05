# dm - an arbitrary precision mathematical processor

## Usage

```
$ ./dm --help
Usage: ./dm [OPTION...] [FILE...]
 -e              EXPR   evaluate expression
 -s --scale      SCALE  set default scale
    --stack-size SIZE   set max stack size
    --stack-num  NUM    set max number of stacks
 -h --help              show this help
                 FILE   evaluate source file

$ ./dm -e '1 2+.'
3
$ cat fibonacci.dmc
1&&.}[{&.&?+!~}]
$ ./dm fibonacci.dmc
1
1
2
3
5
8
13
21
34
^C
```

## Build

`dub build`

## Author

theoldmoon0602

## Lisence

MIT

## Nix is a package manager, a functional programming language with lazy evaluation.
惰性求值的函数式编程语言。

## Attribute set 属性集
A set of name/value pairs.
{ a = 0; b = "bar"; c = true; d = (6 / 2); }

lists 列表
[ 1 "foo" true ]


## Derivation 派生

## Nixpkgs
The official collection of Nix packages.

.drv
这是一个推导。 它是一种由 Nix 编写和读取的特殊格式，它为 Nix 商店中的任何内容提供构建说明。 Nix 商店中的几乎所有东西（除了 Derivations）都是通过构建 Derivation 来放置的。

nixos-install 命令是幂等的，所以多次运行它是完全没问题的。

没有浮点数


# Rubocop::Crystal

The beginnings of a RuboCop extension for converting Ruby to Crystal.

## TODO

Many things. In particular, how are types going to work?

Getting static type information about Ruby files isn't the difficult part, the problem is conveying this information to the Crystal compiler while still maintaining valid syntax.

Inserting Crystal types into Ruby code is a no-go, because that causes `Lint/Syntax` errors in RuboCop.

Possible paths forward:
- Modify the parser to accept Crystal type declarations, or at least not break on them.
- Modify Crystal to accept type declarations from `.rbs` and/or `.rbi` files.
- Modify Crystal to accept type declarations from sorbet/rbs-inline/other annotations.
  - Write [Ameba](https://github.com/crystal-ameba/ameba) [extension](https://crystal-ameba.github.io/2019/07/22/how-to-write-extension/) to convert the type annotations, as it works with Crystal syntax.
- Find a way to convey type information to Crystal using valid Ruby syntax.

Interesting repos:
- [rbs](https://github.com/ruby/rbs)
- [steep](https://github.com/soutaro/steep)
- [sorbet](https://github.com/sorbet/sorbet)
- [tapioca](https://github.com/Shopify/tapioca)
- [parlour](https://github.com/AaronC81/parlour)
- [gloss](https://github.com/johansenja/gloss)
- [claret](https://github.com/stevegeek/claret)
- [irbs](https://github.com/diaphragm/irbs)
- [rbs-inline](https://github.com/soutaro/rbs-inline)
- [syntax-tree-rbs](https://github.com/ruby-syntax-tree/syntax_tree-rbs)

## Installation

```
gem install rubocop-crystal
```

## Usage

```
rubocop --plugin rubocop-crystal
```

Note that there are some differences between Ruby and Crystal that can be automatically resolved, while some (at least for now) require manual intervention.

If you wish to only process the autocorrectable offenses, add `--disable-uncorrectable`, while reporting only the offenses requiring manual intervention is waiting on rubocop/rubocop#13275.

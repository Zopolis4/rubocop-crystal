# Rubocop::Crystal

The beginnings of a RuboCop extension for converting Ruby to Crystal.

## Testing

Right now it is being tested on [basictest/test.rb](https://github.com/ruby/ruby/blob/master/basictest/test.rb) from the Ruby tree.

Because that only gets to line 4, and certainly doesnt get far enough to give a pass/fail number, I am only testing it locally.

Once it supports enough to run minitest, I'll convert it into a proper testing setup.

## Versioning

The end goal is to be able to run everything inside `basictest`, `boostraptest`, and `test` from the Ruby tree.

Minor versions are incremented when a directory now passes all tests (`basictest`, `test/json`).

My sincere apologies to dedicated [0ver](https://0ver.org/) fans, but there will be a major release once all tests pass.

## Installation

```
gem install rubocop-crystal
```

## Usage

```
rubocop --require rubocop-crystal
```

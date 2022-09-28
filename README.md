# A partial implementation of the beancount language in Racket

[Beancount](https://github.com/beancount/beancount) is a double-entry bookkeeping
computer language that uses plain text files for entry.

## Usage
When used as `lang beancount` it provides a single `data` attribute with a list of
statements.

If called as `main` it just prints syntax-tree to stdout:
```
cat example.beancount | racket -l beancount
```

## Limitations:
Some syntax nodes are not properly defined (impossible to distinguish a tag from a string).
Although based on official beancount grammar, indent handling is a bit different,
which might trigger some corner-cases.



visit is useful for reading complex configuration data.
visit can handle arbitrary nesting with ease.

# Example Use As Configuration
1. Pick one or more data types that you wish to implement (for example `lambda`).  Define `lambda = track : ... `.  You can use `track.reduced` to access the lambda.  You can use track.index to get a unique index to the lambda.  You can use `track.path` to get (an also unique) path to the lambda.
2. Pick zero or more data types that you wish to not implement (they should cover the entire spectrum).  I recommend `undefined = track : track.throw`.  This will throw an error if one of these forbidden types is used.  The error will hopefully be helpful in debugging.
3. Decide if you want to nest.  I recommend `list = track : track.reduced' and `set = track : track.reduced`.  This causes recursion over lists and sets.  If the user puts in a list or a set, then we will visit that list or set as well.

```
[
  { a = conf : ... ; b = conf : ... ; }
  { c = conf : ... ; d = conf : ... ;
]
```
becomes
```
[
  { a = ...evaluation ; b = ...evaluation... ; }
  { c = ...evaluation ; d = ...evaulation... ;
]
```
Notice the output has the exact same form as the input except that lambdas are evaluated.
This can be helpful if the lambda are configurations.

In contrast,
```
[
  { d = conf : ... ; e = conf : ... ; }
  { f = conf : ... ; g = "some string" ;
]
```
becomes a thrown error with the type string and path e.  Hopefully this provides the user with the helpful debugging information that there is an error, that they specified a string where they should not specify a string, and where that string is.

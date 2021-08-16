# Mutability & Initial Confusion
- > Erlang has this very pragmatic approach with functional programming: obey
  its purest principles (referential transparency, avoiding mutable data, etc),
  but break away from them when real world problems pop up.
- Variables are immutable (not mutable, as in not changeable)!
- Functions must return the same result each time they're ran!
- ```
  1> OneHundredThirtyFive = 135.
  135
  2> OneHundredThirtyFive = 135/2.
  ** exception error: no match of right hand side value 67.5
  ```
  This is because the result of `135/2` has a floating point, and we set `135` as
  an integer.  One way to fix this is to initially set the value to `135.0`;
  another way to fix it is by using the `div`/`mod`/`rem` operators which can only be
  used for integers.
- The `=` operator has the role of comparing values and complaining if they're
  different. If they're the same, it returns the value. That explains the fact
  that you can still assign values to a variable as long as they're the same it
  already has.

# REPL
- ^G (Ctrl G) is actually different than ^C (Ctrl C) and pretty powerful

# General Syntax
- Expressions must end with a `.`!
- Variables names must be capitalized!

# Numbers
- Use the syntax `Base#Number` to use different bases
- Comparing numbers is as usual: `>`, `<`, `>=`, `=<`

# Atoms
- Atoms are strings whose values are themselves. They may be in quotes in which
  case any character is allowed. If they're not on quotes, they must be
  lowercase, have no spaces in them, and only some special characters are
  allowed.
- They sit in a so-called Atom Table, and are not garbage collected!
- > Atoms should not be generated dynamically for whatever reason; if your
  system has to be reliable and user input lets someone crash it at will by
  telling it to create atoms, you're in serious trouble. Atoms should be seen
  as tools for the developer because honestly, it's what they are.
- Blacklisted Atoms: `after`, `and`, `andalso`, `band`, `begin`, `bnot`, `bor`, `bsl`, `bsr`,
  `bxor`, `case`, `catch`, `cond`, `div`, `end`, `fun`, `if`, `let`, `not`, `of`, `or`, `orelse`, `query`,
  `receive`, `rem`, `try`, `when`, `xor`.

# Booleans
- `true`, and `false`: they're atoms!
- `not`, `or`, `and`, and `xor` operators.

  btw: `xor` is true if both arguments differ,
  example: `true xor false => true`
           `true xor true => false`

  Also: `andalso`, and `orelse` which
  from my understanding only evaluate (that also means executing a function if
  that is an operand) the right hand side if it needs to, so if the first
  condition applies, it skips the second?
- Testing for equality is done by using `=:=`, while testing for inequaity is
  done using `=/=` (although the not operator can be used (but note that in
  this case the expression has to be inside parentheses, example:
  ```
  1> not (1 =:= 2).
  true
  ```
  )

# Tuples
- They're just weird lists
- No main type, a Tuple can hold values of different types
- To get a value of a Tuple, apparently you have to know the length of the
  Tuple when you're writing the code, because that's how you do it:
  ```
  3> Point = {4,5}.
  {4,5}
  4> {X,Y} = Point.
  {4,5}
  5> X.
  4
  ```

  To get a single (or more, as long as you know their position) value, you can
  replace the rest of the values with _ since you won't need them
  ```
  6> {X,_} = Point.
  {4,5}
  7> X.
  4
  ```

  If you don't give a shit about the values:
  ```
  8> {_,_} = Point.
  {4,5}
  ```

- They can also be used for stuff like determining the (humanized) type of the
  second member of the tuple,
  ```
  1> Length = {centimeters,4}.
  {centimeters,4}
  2> {feet,_} = Length.
  ** exception error: no match of right hand side value {centimeters,4}
  ```

# Lists
- No main type
- Classic syntax:
  ```
  1> [1, 2, 3, {numbers,[4,5,6]}, 5.34, atom].
  [1,2,3,{numbers,[4,5,6]},5.34,atom]
  ```

- Lists with numbers where all numbers also represent the character code of a
  character return the string of all characters:
  ```
  2> [97, 98, 99].
  "abc"
  ```

- `++` is used for adding two lists together, and `--` is used for removing
  elements from one (which must be in a list as well, even if it's just one)
  
  note: when you remove an element, it returns the list that misses that
  element, it obviously doesn't change the value of the variable that the
  original list lived on.

  note II: both operators are "right-associative" which means that expression
  are executed from right to left if chained.

- the first element of a list is named head, and **the rest of the list! (NOT
  THE LAST ELEMENT)** is named tail, `hd()` and `tl()` can be used to get them.

- `length()` method returns the length of a list

- pattern matching magic:
  ```
  1> List = [2,3,4].
  [2,3,4]
  2> NewList = [1|List].
  [1,2,3,4]
  ```

  the main part, `[1|List]` essentially constructs a list by first head, and then
  its tail.

  note: only the tail can be a list! if the head (first part) is a list, it
  will actually use the list as a head.
- they can be unpacked like tuples, using:
  ```
  3> [Head|Tail] = List.
  [2,3,4]
  4> Head.
  2
  5> Tail.
  [3,4]
  ```

- that `|` we use sometimes is called the constructor (cons) operator
  note: you can't use multiple cons operators, but you can recurse lists:
  ```
  1> Numbers = [1 | [2 | [3]]].
  [1,2,3]
  ```

  note II: when we create lists like that (using the cons operator in general),
  we don't actually create a list but a datatype similar to one called improper
  list.

# List Comprehensions
- Just a notation that constructs a list from another list by filtering out
  elements and stuff.

- It's based off of the Set (Builder) Notation

  Example: `{x ∈ ℜ x = x^2}`
  Result of this will be all real numbers who are equal to their own square.

  I suppose `∈` says that there is a condition incoming, and obviously `ℜ x` is a
  predicate that returns true if the number is a real number, and thus the `ℜ`
  (retarded R.) I don't understand where it gets all the numbers, and if we
  could possibly give it a specific set of numbers to do all of that stuff on,
  and how the part after the `=` works.

  (from wikipedia)
  Set-builder notation can be used to describe a set that is defined by a
  predicate, that is, a logical formula that evaluates to true for an element
  of the set, and false otherwise. In this form, set-builder notation has three
  parts: a variable, a colon or vertical bar separator, and a predicate.  Thus
  there is a variable on the left of the separator, and a rule on the right of
  it. These three parts are contained in curly brackets.
  
  A better example of that would be:
  `{x : x > 0}`

  As List Comprehensions are based on Set-builder Notation, we have a pretty
  (lol) similar syntax in Erlang:
  ```
  1> [2*N || N <- [1,2,3,4]].
  [2,4,6,8]
  ```

  my explanation btw:
  On the first side, before the `||`, is what is added to the list, and we can
  modify it as we want (in this case, we multiply it by 2). After the `||` and
  before the `<-`, we have specify what we want to give to the previous map kinda
  thing, and how to name it, we can also have multiple values if we're doing
  this on a list of tuples, we can do that by putting what we want to pass on
  inside `{}`, Example:

  ```
  1> RestaurantMenu = [{steak, 5.99}, {beer, 3.99}, {poutine, 3.50}, {kitten, 20.99}, {water, 0.00}].
  [{steak,5.99},
  {beer,3.99},
  {poutine,3.5},
  {kitten,20.99},
  {water,0.0}]
  2> [{Item, Price*1.07} || {Item, Price} <- RestaurantMenu, Price >= 3, Price =< 10].
  [{steak,6.409300000000001},{beer,4.2693},{poutine,3.745}]
  ```
  why's there a kitten in there btw??????????????

- Filters!
  ```
  1> [X || X <- [1,2,3,4,5,6,7,8,9,10], X rem 2 =:= 0].
  [2,4,6,8,10]
  ```

  the thing after the comma is a condition that must be met for each element 
  for it to pass on the list

# Compiling
  `erlc` best fren

  you can pass 

# Functions
- Pattern matching is awesome!

  ```erlang
  greet(male, Name) ->
      io:format("Hello, Mr. ~s!", [Name]);
  greet(female, Name) ->
      io:format("Hello, Mrs. ~s!", [Name]);
  greet(_, Name) ->
      io:format("Hello, ~s!", [Name]).
  ```

  however, notice how function clauses are separated with a `;` but the last
  one ends with a `.`.

  ```
  function(X) ->
      Expression;
  function(Y) ->
      Expression;
  function(_) ->
      Expression.
  ```

- In arguments, you can use the cons operator:
    ```erlang
    head([H|_]) -> H.
    ```

- Some more stuff about arguments... uhhhh
    ```erlang
    valid_time({Date = {Y,M,D}, Time = {H,Min,S}}) ->
        io:format("The Date tuple (~p) says today is: ~p/~p/~p,~n",[Date,Y,M,D]),
        io:format("The time tuple (~p) indicates: ~p:~p:~p.~n", [Time,H,Min,S]);
    valid_time(_) ->
        io:format("Stop feeding me wrong data!~n").

    ```
    ```
    functions:valid_time({{2011,09,06},{09,04,43}}).
    ```

# Guards
omg this is awesome

-
  ```erlang
  old_enough(X) when X >= 16 -> true;
  old_enough(_) -> false.
  ```

- and you can even add more!
  ```erlang
  right_age(X) when X >= 16, X =< 104 ->
      true;
  right_age(_) ->
      false.
  ```

- OR!!
  ```erlang
  wrong_age(X) when X < 16; X > 104 ->
      true;
  wrong_age(_) ->
      false.
  ```

# If Statements (Guard Patterns)

- `;` acts as an `else` when returning
  ```erlang
  oh_god(N) ->
      if N =:= 2 -> might_succeed;
          true -> always_does
      end.
  ```

-
  ```erlang
  help_me(Animal) ->
      Talk = if Animal == cat  -> "meow";
                Animal == beef -> "mooo";
                Animal == dog  -> "bark";
                Animal == tree -> "bark";
                true -> "fgdadfgna"
             end,
      {Animal, "says " ++ Talk ++ "!"}.
  ```
note: this would be better with just pattern matching

# Case ... of
-
  ```erlang
  insert(X,[]) ->
      [X];
  insert(X,Set) ->
      case lists:member(X,Set) of
          true  -> Set;
          false -> [X|Set]
      end.
  ```

- a more advanced one:
  ```erlang
  beach(Temperature) ->
      case Temperature of
          {celsius, N} when N >= 20, N =< 45 ->
              'favorable';
          {kelvin, N} when N >= 293, N =< 318 ->
              'scientifically favorable';
          {fahrenheit, N} when N >= 68, N =< 113 ->
              'favorable in the US';
          _ ->
              'avoid beach'
      end.
  ```
  where the first part inside the brackets extracts `{x, N}` from
  `Temperature` and fails if the structure of the extraction doesn't match

# Standard
- When formatting a string, the escape character is `~`, it can be used for
  formatting purposes, or like `~n` for newlines. Another one is `~p` which
  will prettify output (I think)
  ```erlang
  io:format("Hello, Mr. ~s!", ["Joe"]);
  ```

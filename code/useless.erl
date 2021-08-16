-module(useless).
-export([add/2, multiply/2, divide/2, sum/1]).

%% Adds two numbers A and B
add(A,B) ->
    A + B.

%% Multiplies number A with B
multiply(A,B) ->
    A * B.

%% Divides number A with B
divide(A,B) ->
    A / B.

%% Sums numbers
sum(_) ->
    'not implemented'.

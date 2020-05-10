Nonterminals data_list list elements element.

Terminals open_parens_data open_parens close_parens symbol.

Rootsymbol list.

list -> open_parens close_parens : nil.
list -> open_parens elements close_parens : '$2'.
%% elements -> element elements : {'$1', '$2'}.
%% elements -> element open_parens elements close_parens : ['$1' | '$3'].

%% might be ['$1'].
elements -> element : '$1'.
elements -> element elements : join('$1', '$2').
%% elements -> element elements : {'$1' , '$2'}.
%% elements -> element elements : '$1'.
%% elements -> '$empty' : ni.
%% elements -> '$empty' : [].
element -> symbol : value_of('$1').
element -> list : '$1'.


Erlang code.
value_of(Token) ->
    element(3, Token).

% this overly flattens so that means line 9 is probably too greedy.
join(Symbol, NilOrList) ->
    case NilOrList of
        nil ->
            erlang:display("here"),
            [Symbol, []];
        Atom when is_atom(Atom) ->
            erlang:display({Symbol, Atom}),
            [Symbol, Atom];
        %% List ->
            %% [Symbol | List]
            %% [Symbol, List]
        [Atom | List] ->
            erlang:display({Symbol, [Atom | List]}),
            %% [Symbol, join(Atom, List)];
            %% [Symbol, Atom | List];
            {Symbol, [Atom | List]};
        [] ->
            Symbol;
        Other ->
            erlang:display({"Other", Other}),
            {Symbol, [Other]}

    end.

%% (defmodule A (def f (x) (+ x x)))

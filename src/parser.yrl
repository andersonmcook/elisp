Nonterminals data_list list elements element.

Terminals open_parens_data open_parens close_parens symbol.

Rootsymbol list.

list -> open_parens close_parens : nil.
list -> open_parens elements close_parens : '$2'.

elements -> element : '$1'.
elements -> element elements : join('$1', '$2').
element -> symbol : value_of('$1').
element -> list : '$1'.

Erlang code.
value_of(Token) ->
    element(3, Token).

join(Symbol, NilOrList) ->
    case NilOrList of
        nil ->
            [Symbol, []];
        Atom when is_atom(Atom) ->
            [Symbol, Atom];
        [Atom | List] ->
            {Symbol, [Atom | List]};
        [] ->
            Symbol;
        Other ->
            {Symbol, [Other]}
    end.

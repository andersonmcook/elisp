Nonterminals data_list list elements element.

Terminals open_parens_data open_parens close_parens symbol.

Rootsymbol list.

list -> open_parens elements close_parens : '$2'.
elements -> element elements : ['$1' | lists:flatten('$2')].
elements -> '$empty' : [].
element -> symbol : value_of('$1').
element -> list : {'$1'}.

Erlang code.
value_of(Token) ->
    element(3, Token).

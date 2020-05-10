Definitions.

Whitespace = [\s\t]
Terminator = \n|\r\n|\r

OpenParensData = '\( 
OpenParens = \(
CloseParens = \)
Symbol = [a-zA-z+]*
AllElse = [^a-zA-z\(\)('\()+]*

Rules.

{Whitespace} : skip_token.
{Terminator} : skip_token.
{OpenParensData} : {token, {open_parens_data, TokenLine, list_to_atom(TokenChars)}}.
{OpenParens} : {token, {open_parens, TokenLine, list_to_atom(TokenChars)}}.
{CloseParens} : {token, {close_parens, TokenLine, list_to_atom(TokenChars)}}.
{Symbol} : {token, {symbol, TokenLine, list_to_atom(TokenChars)}}.
{AllElse} : {error, TokenChars}.

Erlang code.

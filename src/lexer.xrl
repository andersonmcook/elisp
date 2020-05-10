Definitions.

Whitespace = [\s\t\n\r]+
Terminator = \n|\r\n|\r

OpenParensData = '\( 
OpenParens = \(
CloseParens = \)
Symbol = [a-zA-z0-9+*]*
AllElse = [^a-zA-z0-9\(\)('\()+*]*

Rules.

{Whitespace} : skip_token.
{Terminator} : skip_token.
{OpenParensData} : {token, {open_parens_data, TokenLine, list_to_atom(TokenChars)}}.
{OpenParens} : {token, {open_parens, TokenLine, list_to_atom(TokenChars)}}.
{CloseParens} : {token, {close_parens, TokenLine, list_to_atom(TokenChars)}}.
{Symbol} : {token, {symbol, TokenLine, list_to_atom(TokenChars)}}.
{AllElse} : {error, TokenChars}.

Erlang code.

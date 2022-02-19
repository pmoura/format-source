:- object(fp_lex).

	:- info([
		version is 1:0:0,
		author is 'Lindsey Spratt',
		date is 2022-2-22,
		comment is 'lexical analysis for the format prolog source system.'
	]).

	:- public(lex_file/2).
	:- mode(lex_file(+file_path, -list), one).
	:- info(lex_file/2, [
		comment is 'Parse a text file into a list of tokens.',
		argnames is ['SourceFile', 'Tokens']
	]).

	:- uses(fpl_whitespace, [whitespace//3, punctuation//2]).
	:- uses(fpl_token, [token//3]).
	
	lex(V) -->
	  item_list(V, code).

	item_list([H|T], ModeIn) -->
	  item(H, ModeIn, ModeNext),
	  !,
	  item_list(T, ModeNext).
	item_list([], _) --> [].

	item(w(V), ModeIn, ModeOut) -->
	  whitespace(V, ModeIn, ModeOut),
	  !.
	item(p(V), Mode, Mode) -->
	  punctuation(V, Mode),
	  !.
	item(t(V), ModeIn, ModeOut) -->
	  token(V, ModeIn, ModeOut).

	lex_file(File, Token_list) :-
	  open(File, read, S),
	  listify(Source, S),
	  close(S),
	  lex(Token_list, Source, []).

	listify(L, S) :-
	  get_code(S, H),
	  (H = -1
	   -> L = []
	  ; L = [H|T],
	    listify(T, S)
	  ).

:- end_object.

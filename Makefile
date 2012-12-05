all:
	./rebar compile

.PHONY: test

test:
	./rebar -v eunit


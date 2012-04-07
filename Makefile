MOCHA = ./node_modules/.bin/mocha
REPORTER = dot
GREP = ""

test:
	@$(MOCHA) \
		--compilers coffee:coffee-script \
		--repoter $(REPORTER) \
		--grep $(GREP) \
		test/*.coffee
	
.PHONY: test

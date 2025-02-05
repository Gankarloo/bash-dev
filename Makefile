clean:
	# rm -rf ./tmp/*.tmp
	rm -rf /tmp/bats-mock.*
	rm -rf /tmp/bats-func.*
clean-tests: clean
	rm -f ./tout/*
test: clean-tests
	./test/sourceAble.bats
# test.sourceAble:
# *: test
all-tests: clean-tests
	/usr/bin/env -S bats --verbose-run --gather-test-outputs-in tout -j 4 ./test
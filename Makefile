.PHONY: test
test:
	cat test/learn.golf | ./bin/golf > test/new.go
	diff -u test/learn.go test/new.go && rm test/new.go

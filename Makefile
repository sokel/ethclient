#!/usr/bin/env make

GO ?= go

vet:
	@echo "+ $@"
	@go vet ./...

fmt:
	@echo "+ $@"
	@test -z "$$(gofmt -s -l . 2>&1 | grep -v ^vendor/ | tee /dev/stderr)" || \
		(echo >&2 "+ please format Go code with 'gofmt -s'" && false)

test:
	@echo "+ $@"
	${GO} test -tags nocgo $(shell go list ./... | grep -vE 'vendor')

build_mockgen:
	@go get github.com/golang/mock/mockgen@v1.2.0

mock: build_mockgen
	mockgen -package ethclient -destination client_mock.go -source client.go

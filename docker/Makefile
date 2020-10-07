.ONESHELL:


all: pipenv sbt
.PHONY: all

pip:
	docker-inherit python:latest -t $@
.PHONY: pip

pipenv:
	@cat<<-EOF | docker build -f - -t pipenv:tmp .
	    FROM python:latest
	    RUN pip install pipenv
	EOF
	docker-inherit pipenv:tmp -t $@
	docker rmi pipenv:tmp
.PHONY: pipenv

sbt:
	docker-inherit marnikow/sbt -t $@
.PHONY: sbt

cargo:
	docker-inherit rust -t $@
.PHONY: cargo

tsc:
	@cat<<-EOF | docker build -f - -t tsc:tmp .
	    FROM node:latest
	    RUN npm -g install typescript
	    RUN mkdir /src
	    WORKDIR /src
	    ENTRYPOINT tsc
	EOF
	docker-inherit tsc:tmp -t $@
	docker rmi tsc:tmp
.PHONY: tsc

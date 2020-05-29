.ONESHELL:


all: pipenv sbt
.PHONY: all

pip:
	docker-inherit python:latest -t pip
.PHONY: pip

pipenv:
	@cat<<-EOF | docker build -f - -t pipenv:tmp . &&
	    FROM python:latest
	    RUN pip install pipenv
	EOF
	    docker-inherit pipenv:tmp -t pipenv &&
	    docker rmi pipenv:tmp
.PHONY: pipenv

sbt:
	docker-inherit marnikow/sbt -t sbt
.PHONY: sbt

cargo:
	docker-inherit rust -t cargo
.PHONY: cargo

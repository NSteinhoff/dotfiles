all: pipenv sbt
.PHONY: all

pip:
	docker build --build-arg from=python:latest -t pip .
.PHONY: pip

pipenv: pip
	docker build -t pipenv -f Pipenv .
.PHONY: pipenv

sbt:
	docker build --build-arg from=marnikow/sbt -t sbt .
.PHONY: sbt

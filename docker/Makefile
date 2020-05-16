all: pipenv sbt
.PHONY: all

pip:
	docker build --build-arg from=python:latest -t pip .
.PHONY: pip

pipenv: python-pipenv
	docker build --build-arg from=python-pipenv -t pipenv .
.PHONY: pipenv

sbt:
	docker build --build-arg from=marnikow/sbt -t sbt .
.PHONY: sbt

cargo:
	docker build --build-arg from=rust -t cargo .
.PHONY: cargo

python-pipenv:
	docker build -t python-pipenv -f Pipenv .
.PHONY: python-pipenv

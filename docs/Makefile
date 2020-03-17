.PHONY: help install doc

.DEFAULT: help
help:
	@echo "make install"
	@echo "       install documentation dependencies"
	@echo "make doc"
	@echo "       build & serve documentation"

install:
	pip install -r ../requirements.txt
	git clone https://github.com/squidfunk/mkdocs-material.git theme

deploy: install
	mkdocs gh-deploy

doc: install
	mkdocs serve
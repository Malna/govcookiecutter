.PHONY: requirements docs example

.DEFAULT_GOAL := help

## Install the Python requirements
requirements:
	python3 -m pip install -U pip setuptools
	python3 -m pip install -r requirements.txt

## Compile the Sphinx documentation in HTML format in the `docs/_build` folder
docs: requirements
	$(MAKE) -C docs html

## Test build the cookiecutter template in the `example_build` folder - note this will delete any existing example build
example: requirements
	if [ ! -d "./example" ]; then mkdir ./example; fi
	if [ -d "./example/your-new-project-name" ]; then rm -rf ./example/your-new-project-name; fi
	python3 -m cookiecutter . -o ./example --no-input


## Get help on all make commands; taken from https://github.com/drivendata/cookiecutter-data-science
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
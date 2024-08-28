PROJECT=install-rstudio
PYTHON_VERSION=3.11.6

.PHONY: pyenv
pyenv:
	pyenv install ${PYTHON_VERSION} --skip-existing
	pyenv virtualenv-delete ${PROJECT} || true
	pyenv virtualenv ${PYTHON_VERSION} ${PROJECT}
	pyenv local ${PROJECT}

.PHONY: deps
deps:
	pip install -r ./requirements.txt
	pre-commit install

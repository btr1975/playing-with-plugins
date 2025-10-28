# Makefile for project needs
# Author: Ben Trachtenberg
# Version: 2.0.0
#

.PHONY: all info build build-container coverage format pylint pytest start-container stop-container remove-container \
        gh-pages check-vuln pip-export

info:
	@echo "make options"
	@echo "    all                 To run coverage, format, pylint, and check-vuln"
	@echo "    build               To build a distribution"
	@echo "    build-container     To build a container image"
	@echo "    check-vuln          To check for vulnerabilities in the dependencies"
	@echo "    check-security      To check for vulnerabilities in the code"
	@echo "    coverage            To run coverage and display ASCII and output to htmlcov"
	@echo "    format              To format the code with black"
	@echo "    pylint              To run pylint"
	@echo "    pytest              To run pytest with verbose option"
	@echo "    start-container     To start the container"
	@echo "    stop-container      To stop the container"
	@echo "    remove-container    To remove the container"
	@echo "    gh-pages           To create the GitHub pages"



all: format pylint coverage check-security pip-export

build:
	@uv build --wheel --sdist

coverage:
	@uv run pytest --cov --cov-report=html -vvv

format:
	@uv run black playing_with_plugins/
	@uv run black tests/

pylint:
	@uv run pylint playing_with_plugins/

pytest:
	@uv run pytest --cov -vvv

check-security:
	@uv run bandit -c pyproject.toml -r .

pip-export:
	@uv export --no-dev --no-emit-project --no-editable > requirements.txt
	@uv export --no-emit-project --no-editable > requirements-dev.txt


gh-pages:
	@rm -rf ./docs/source/code
	@uv run sphinx-apidoc -o ./docs/source/code ./playing_with_plugins
	@uv run sphinx-build ./docs ./docs/gh-pages





build-container:
	@cd containers && podman build --ssh=default --build-arg=build_branch=main -t playing-with-plugins:latest -f Containerfile

start-container:
	@podman run -itd --name playing-with-plugins -p 8080:8080 localhost/playing-with-plugins:latest

stop-container:
	@podman stop playing-with-plugins

remove-container:
	@podman rm playing-with-plugins




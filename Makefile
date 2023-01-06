.DEFAULT_GOAL := help
.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

up:
	docker compose up -d

stop:
	docker compose stop

kill:
	docker compose kill

down:
	docker compose down -v

build:
	docker compose build --no-cache

install-wp:
	if [ -f "wp.zip" ]; then rm  wp.zip; fi
	if [ -d "wordpress" ]; then rm -rf  wordpress; fi
	curl https://wordpress.org/latest.zip -o wp.zip
	unzip -q wp.zip
	cp -r wordpress/* www/
	rm -rf wordpress/
	rm wp.zip
	rm -rf .git/
	make up

curr_path=$(shell pwd)
root_path=$(shell pwd | xargs dirname | xargs dirname)
HOME=$(shell echo $$HOME)


build:
	sudo docker compose \
		-f docker-compose.yml \
		build

run:
	sudo docker compose \
		-f docker-compose.yml \
		up -d

stop:
	sudo docker compose \
		-f docker-compose.yml \
		down --remove-orphans

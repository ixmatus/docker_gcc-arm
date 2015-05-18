.PHONY: build push

build:
	sudo docker build -t plumlife/gcc-arm:4.9 .

push:
	sudo docker push plumlife/gcc-arm:4.9

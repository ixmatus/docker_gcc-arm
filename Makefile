.PHONY: build push bash

build:
	sudo docker build -t plumlife/crosstool-ng:gcc-4.9_eglibc-2.21_linux-4.x .

push:
	sudo docker push plumlife/crosstool-ng:gcc-4.9_eglibc-2.21_linux-4.x

bash:
	docker run --rm -i -t plumlife/crosstool-ng:gcc-4.9_eglibc-2.21_linux-4.x bash

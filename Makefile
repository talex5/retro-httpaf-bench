run: build
	mkdir -p output
	docker run --rm -it --ulimit memlock=819200000:819200000 --privileged -v $(PWD)/output:/output wrk2

build:
	docker build -t wrk2 .

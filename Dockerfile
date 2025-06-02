FROM aflplusplus/aflplusplus:latest

RUN apt-get update &&\
	apt-get install -y llvm

WORKDIR /lesson

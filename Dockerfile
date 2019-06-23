FROM golang:1.12-stretch as build

RUN apt-get update && apt-get -uy upgrade \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 --branch=v0.1.0 https://github.com/twitchyliquid64/subnet /go/src/github.com/twitchyliquid64/subnet
WORKDIR /go/src/github.com/twitchyliquid64/subnet
ENV GO111MODULE=on
RUN go install .

FROM debian:stretch-slim

RUN apt-get update && apt-get -uy upgrade \
 && apt-get install -y net-tools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /go/bin/subnet /usr/local/bin/subnet

EXPOSE 3234
ENTRYPOINT ["/usr/local/bin/subnet"]

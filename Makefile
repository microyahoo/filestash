GOPATH ?= /go
CMD := "NODE_ENV=production npm install --silent && npm run build"
BUILDER_IMAGE ?= reg.deeproute.ai/deeproute-public/node:14

all:
	make build_init
	make build_frontend
	GOARCH=amd64 GOOS=linux make build_backend

build_init:
	go generate -x ./server/...

build_frontend:
	@docker run \
		-v "$$(pwd):/$(GOPATH)/src/deeproute.ai/filestash" \
		-w /$(GOPATH)/src/deeproute.ai/filestash \
		$(BUILDER_IMAGE) \
		/bin/sh -c $(CMD)

build_backend:
	CGO_ENABLED=0 go build -ldflags="-extldflags=-static" -mod=vendor --tags "fts5" -o dist/filestash server/main.go

clean_frontend:
	rm -rf server/ctrl/static/www/

build_base_image:
	docker build -t reg.deeproute.ai/deeproute-public/filestash-base:v$(shell date +"%Y%m%d") -f docker/Dockerfile.base .

build_image:
	docker build -t reg.deeproute.ai/deeproute-public/filestash:v$(shell date +"%Y%m%d") -f docker/Dockerfile .

include vars.mk

IMAGE = kubikvest/xodos
CONTAINER = kubikvest_webhook
PORT = -p 8301:80

build: buildfs
	@docker build -t $(IMAGE) .

buildfs:
	@docker run --rm \
		-v $(CURDIR)/runner:/runner \
		-v $(CURDIR)/build:/build \
		-v $(CURDIR)/src:/src \
		imega/base-builder \
		--packages=" \
			nginx-lua \
			lua5.1-cjson \
			git \
			curl \
			make \
			docker@v32 \
			" \
		-d="lua5.1 luarocks@community"

start: build
	@docker run -d --name $(CONTAINER) \
		-v /root/.dockercfg:/root/.dockercfg \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e WEBHOOK=$(KV_WEBHOOK) \
		--restart=always \
		$(PORT) $(IMAGE)

stop:
	@-docker stop $(CONTAINER)

clean: stop
	@-docker rm -fv $(CONTAINER)

destroy:
	@-docker rmi $(IMAGE)

.PHONY: build

include vars.mk

IMAGE = kubikvest/xodos
CONTAINERS = kubikvest_webhook
PORT = -p 8301:80

build:
	@docker build -t $(IMAGE) .

start:
	@docker run -d --name kubikvest_webhook \
		-v /root/.dockercfg:/root/.dockercfg \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e WEBHOOK=$(WEBHOOK) \
		--restart=always \
		$(PORT) $(IMAGE)

stop:
	@-docker stop $(CONTAINERS)

clean: stop
	@-docker rm -fv $(CONTAINERS)

destroy: clean
	@-docker rmi -f $(IMAGE)

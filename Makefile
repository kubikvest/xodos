include vars.mk

IMAGE = imegateleport/xodos
CONTAINER = kubikvest_webhook
PORT = -p 8301:80

start:
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

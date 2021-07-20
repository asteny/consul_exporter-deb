all: build


build: download
	chmod -Rv 644 build/contrib/
	fpm -s dir -f -t deb \
		-n consul_exporter \
		-v $(VERSION) \
		--iteration $(ITERATION) \
		--after-install build/contrib/consul_exporter.postinstall \
		--after-remove build/contrib/consul_exporter.postrm \
		-p build/packages \
		/tmp/consul_exporter/consul_exporter=/usr/bin/consul_exporter \
		build/contrib/consul_exporter.service=/lib/systemd/system/consul_exporter.service \
		build/contrib/consul_exporter.defaults=/etc/default/consul_exporter \
		build/contrib/consul_exporter.preset=/usr/lib/systemd/system-preset/consul_exporter.preset


download:
	cd /tmp && curl -Lo consul_exporter.tar.gz https://github.com/prometheus/consul_exporter/releases/download/v$(VERSION)/consul_exporter-$(VERSION).linux-amd64.tar.gz
	cd /tmp && tar -xvzf /tmp/consul_exporter.tar.gz && mv consul_exporter-$(VERSION).linux-amd64 consul_exporter

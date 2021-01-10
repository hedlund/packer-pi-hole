.PHONY: build

build:
	packer build -var-file vars.json pi-hole.json

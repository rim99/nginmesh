MODULE_ROOT_DIR=$(shell dirname $$PWD)
DEST_MODULE_PROJ_NAME=ngx-stream-nginmesh-dest
DEST_MODULE_NAME=ngx_stream_nginmesh_dest_module
DEST_VERSION=0.2.12-RC2
COPY_MODULE=release

MODULES_DIR=$(BUILD_DIR)/modules
LIBS_DIR=$(BUILD_DIR)/libs
BUILDER_IMAGE=tracing_builder:0.1

modules-dirs:
	mkdir -p $(MODULES_DIR)
	mkdir -p $(LIBS_DIR)

modules: tracing-modules
	cd $(BUILD_DIR)/modules; \
	wget -N https://github.com/nginmesh/${DEST_MODULE_PROJ_NAME}/releases/download/${DEST_VERSION}/${DEST_MODULE_NAME}.so

# copy modules from local repo
modules-local:
	cd $(BUILD_DIR)/modules; \
	cp ${MODULE_ROOT_DIR}/${DEST_MODULE_PROJ_NAME}/module/release/${DEST_MODULE_NAME}.so .; 


container-tracing-modules-builder:
	make BUILDER_IMAGE=$(BUILDER_IMAGE) -C docker-tracing

tracing-modules:
	docker run --rm -v $(shell pwd)/build:/build $(BUILDER_IMAGE)

clean-modules:
	rm -rf $(MODULES_DIR)
	rm -rf $(LIBS_DIR) 
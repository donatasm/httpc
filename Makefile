CC= gcc
CFLAGS= -m64 -Wall -ansi -pedantic -O3 -std=c99
UV= uv
UV_VERSION= 1.0.0
HTTP_PARSER= http_parser
HTTPC= httpc

$(HTTPC): uv/libuv.a $(HTTP_PARSER).c
	$(CC) $(CFLAGS) \
	-dynamiclib -o $(HTTPC).dylib \
	$(HTTP_PARSER).c \
	./$(UV)/build/Release/libuv.a \
	-framework CoreFoundation \
	-framework CoreServices

uv:
	wget -qO- https://github.com/joyent/libuv/archive/v$(UV_VERSION).tar.gz | \
	(mkdir $(UV) ; tar xf - --strip-components=1 -C $(UV)) ; \
	mkdir -p ./$(UV)/build ; \
	git clone https://git.chromium.org/external/gyp.git $(UV)/build/gyp ; \
	./$(UV)/gyp_uv.py -f xcode ; \
	xcodebuild -ARCHS="x86_64" -project ./$(UV)/uv.xcodeproj \
		-configuration Release -target All

uv/libuv.a: uv

clean:
	rm -rf $(UV)
	rm -f $(HTTPC).dylib

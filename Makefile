build: build-html build-linux build-osx build-windows


build-html: mkdir-bin
	godot --export HTML5 bin/html/index.html
	cd bin/html/ && zip ../beat-the-witch-html.zip *


build-linux: mkdir-bin
	godot --export Linux bin/linux/beat-the-witch
	cd bin/linux/ && tar czvf ../beat-the-witch-linux.tar.xz *


build-osx: mkdir-bin
	godot --export OSX bin/osx/beat-the-witch.zip
	cp bin/osx/beat-the-witch.zip bin/beat-the-witch-osx.zip


build-windows: mkdir-bin
	godot --export Windows bin/windows/beat-the-witch.exe
	cd bin/windows/ && zip ../beat-the-witch-windows.zip *


mkdir-bin:
	mkdir -p bin/html/
	mkdir -p bin/linux/
	mkdir -p bin/osx/
	mkdir -p bin/windows/
	touch bin/.gdignore


clean:
	rm -rf bin/

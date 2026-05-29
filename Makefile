FLUTTER = C:/Users/Frant/flutter/bin/flutter.bat
CHROME_PROFILE = C:/Users/Frant/AppData/Local/dart-dev-chrome

dev:
	$(FLUTTER) run -d chrome --web-port=8080 "--web-browser-flag=--user-data-dir=$(CHROME_PROFILE)"

build:
	$(FLUTTER) build web

analyze:
	$(FLUTTER) analyze

gen:
	$(FLUTTER) pub run build_runner build --delete-conflicting-outputs

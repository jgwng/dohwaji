# Makefile for Flutter project

# Variables
VARIABLE1 :=  getting the dependencies


format:
	@dart format .


clean:
	@echo "Clean The Project"
	@rm -rf pubspec.lock
	@flutter clean

hosting:
	@echo "Hosting the Project"
	@flutter build web --web-renderer canvaskit --dart-define=BROWSER_IMAGE_DECODING_ENABLED=false
	@firebase deploy --only hosting
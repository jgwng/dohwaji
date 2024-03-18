# Makefile for Flutter project

# Variables
VARIABLE1 :=  getting the dependencies

ci:
	@read -p "Commit 메세지를 입력해주세요 : " message && \
	(echo "Your commit message is: $$message" && \
	git add . && \
	git commit -m "$$message" && \
	git push origin main)

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
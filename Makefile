include Makefile.version

envout:
	@echo "VERSION=$(VERSION)"
	@echo "BUILDARG_VERSION=$(BUILDARG_VERSION)"
	@echo "IMAGENAME=$(IMAGENAME)"
	@echo "BUILDARG_PLATFORM=$(BUILDARG_PLATFORM)"
	@echo "NGRAM_DE=$(NGRAM_DE)"
	@echo "NGRAM_EN=$(NGRAM_EN)"
	@echo "FASTTEXTMODEL=$(FASTTEXTMODEL)"
prepare:
	sudo apt-get -qq -y install curl unzip
build:
	if test ! -d ngram; then mkdir ngram; fi
	if test ! -f ngram/NGRAM_DE.zip; then curl -# -o ngram/NGRAM_DE.zip $(NGRAM_DE); fi
	unzip -n ngram/NGRAM_DE.zip -d ngram/

	if test ! -f ngram/NGRAM_EN.zip; then curl -# -o ngram/NGRAM_EN.zip $(NGRAM_EN); fi
	unzip -n ngram/NGRAM_EN.zip -d ngram/

	if test ! -f lid.bin; then curl -# -o lid.bin $(FASTTEXTMODEL); fi
	
	docker buildx build $(BUILDARG_VERSION) --build-arg NGRAM_DE=$(NGRAM_DE) --build-arg NGRAM_EN=$(NGRAM_EN)  --build-arg FASTTEXTMODEL=$(FASTTEXTMODEL) $(BUILDARG_PLATFORM) -t $(IMAGENAME):latest .
	docker buildx build $(BUILDARG_VERSION) --load -t $(IMAGENAME):latest .

test: test-cleanup.1
test: TESTIPADDRESS=$(subst ",,$(shell docker inspect languagetool | jq '.[0].NetworkSettings.IPAddress'))
test: test-print-ip-address
test: test-start
test: test-run-test-lang
test: test-run-test-en
test: test-run-test-fr
test: test-cleanup.2

test-start:
	docker run -d --name languagetool -p 8010:8010 $(IMAGENAME):latest
	sleep 3

test-print-ip-address:
	@echo "IP address of languagetools docker container: $(TESTIPADDRESS)"

test-run-test-lang:
	curl \
		-X GET \
		--header 'Accept: application/json' \
		'http://$(TESTIPADDRESS):8010/v2/languages'

test-run-test-en:
	curl \
		-X POST \
		--header 'Content-Type: application/x-www-form-urlencoded' \
		--header 'Accept: application/json' \
		-d 'text=hello%20woorld&language=en-US&motherTongue=de-DE&enabledOnly=false' \
		'http://$(TESTIPADDRESS):8010/v2/check'

test-run-test-fr:
	curl -X POST \
		--header 'Content-Type: application/x-www-form-urlencoded' \
		--header 'Accept: application/json' \
		-d 'text=hello%20woorld&language=fr&motherTongue=de-DE&enabledOnly=false' \
		'http://$(TESTIPADDRESS):8010/v2/check'

.PHONY: test-cleanup
test-cleanup.%:
	-docker stop languagetool
	-docker rm languagetool

.PHONY: tag
tag: tag-push

.PHONY: tag-push
tag-push:
	docker buildx build $(BUILDARG_VERSION) $(BUILDARG_PLATFORM) -t $(IMAGENAME):latest . --push
	docker buildx build $(BUILDARG_VERSION) $(BUILDARG_PLATFORM) -t $(IMAGENAME):$(VERSION) . --push

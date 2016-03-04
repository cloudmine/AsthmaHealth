pod-install: clean-xcode clean-pods
	pod install

pod-update: clean-xcode clean-pods
	-@rm -f Podfile.lock
	pod install

clean-xcode:
	-@rm -rf ~/Library/Developer/Xcode/DerivedData/AsthmaHealth-*
	xcodebuild -alltargets clean

clean-pods:
	-@rm -rf Pods/

get-version:
	$(eval VERSION := $(shell agvtool what-version -terse))
	@echo ${VERSION}

tag-version: get-version
	git tag -s ${VERSION} -m "version ${VERSION}"

verify-tag: get-version
	git tag --verify ${VERSION}

push-origin: get-version
	git push origin ${VERSION}

bump-patch:
	$(eval VERSION := $(shell agvtool what-version -terse | perl -pe 's/(\d+)$$/($$1+1).$$2/e'))
	agvtool -noscm new-version -all ${VERSION}
	@$(MAKE) get-version

bump-minor:
	$(eval VERSION := $(shell agvtool what-version -terse | perl -pe 's/(\d+)(\.\d+)$$/($$1+1).$$2/e'))
	agvtool -noscm new-version -all ${VERSION}
	@$(MAKE) get-version

bump-major:
	$(eval VERSION := $(shell agvtool what-version -terse | perl -pe 's/(\d+)(\.\d+\.\d+)$$/($$1+1).$$2/e'))
	agvtool -noscm new-version -all ${VERSION}
	@$(MAKE) get-version

release: get-version tag-version verify-tag push-origin bump-patch

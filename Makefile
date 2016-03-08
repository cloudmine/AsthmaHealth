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

push-tag-to-origin: get-version
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

stage-next-release: bump-patch
	git commit -m"bump to ${VERSION}" AsthmaHealth.xcodeproj/project.pbxproj AsthmaHealth/SupportingFiles/Info.plist AsthmaHealthTests/Info.plist
	git push origin master

create-signatures: get-version
	curl https://github.com/cloudmine/AsthmaHealth/archive/${VERSION}.tar.gz -o AsthmaHealth-${VERSION}.tar.gz 1>/dev/null 2>&1
	curl https://github.com/cloudmine/AsthmaHealth/archive/${VERSION}.zip -o AsthmaHealth-${VERSION}.zip 1>/dev/null 2>&1
	gpg --armor --detach-sign AsthmaHealth-${VERSION}.tar.gz
	gpg --verify AsthmaHealth-${VERSION}.tar.gz.asc AsthmaHealth-${VERSION}.tar.gz
	-@rm -f AsthmaHealth-${VERSION}.tar.gz
	gpg --armor --detach-sign AsthmaHealth-${VERSION}.zip
	gpg --verify AsthmaHealth-${VERSION}.zip.asc AsthmaHealth-${VERSION}.zip
	-@rm -f AsthmaHealth-${VERSION}.zip

# only for the brave...
release: get-version tag-version verify-tag push-tag-to-origin create-signatures stage-next-release


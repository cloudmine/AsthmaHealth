pod-install: clean-xcode clean-pods
	pod install

pod-update: clean-xcode clean-pods
	-@rm -f Podfile.lock
	pod install

clean-xcode:
	xcodebuild -alltargets clean

clean-pods:
	-@rm -rf Pods/

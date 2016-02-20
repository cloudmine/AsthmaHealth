pod-install:
	-@rm -rf Pods/
	pod install

pod-update:
	-@rm -rf Pods/
	-@rm -f Podfile.lock
	pod install

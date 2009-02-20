---
layout: default
title: Testing Davenport
section: hacking
---

http://chanson.livejournal.com/120740.html

-SenTest All
DYLD_INSERT_LIBRARIES        $(DEVELOPER_LIBRARY_DIR)/PrivateFrameworks
XCInjectBundle               $(BUILT_PRODUCTS_DIR)/IntegrationTests.octest
XCInjectBundleInto           $(BUILT_PRODUCTS_DIR)/Davenport.app/Contents/MacOS/Davenport
DYLD_FALLBACK_FRAMEWORK_PATH $(DEVELOPER_LIBRARY_DIR)/Frameworks


Troubleshooting note: Troubleshooting note: If this doesn't work — that is, if your test bundle isn't found and run — change the executable's working directory (in the General tab) to Built Products Directory and remove $(BUILT_PRODUCTS_DIR) above. Generally this is caused by $(BUILT_PRODUCTS_DIR) not being expanded to a full path, but rather to a partial path relative to your project directory.
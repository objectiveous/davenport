//
//  SVDavenport.h
//  
//
//  Created by Robert Evans on 1/11/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#include <asl.h>

extern int LOCAL_PORT;

//#define SV_NOTIFICATION_RUN_SLOW_VIEW           @"_slow_view"
#define SV_MENU_ITEM_NAME_TEMPORARY_VIEW          @"Slow View"

//#define DPLocalDatabaseNeedsRefreshNotification @"SVLocalDatabaseNeedsRefreshNotification"

/*
Send logging information to syslog and use the console to filter out what you need. 
Be sure to adjust the filters if you want DEBUG and INFO

sudo syslog -c syslogd -d
sudo syslog -c 0 -d

The DEBUG Flag
--------------
  Add "DEBUG=1" to your "extra preprocessor defines" for your Debug target, so assertions are quiet in the Release target.
  In Xcode's "Debug" configuration, in the "Preprocessing" collection set the "Preprocessor Macros" value to "DEBUG=1"
  In your project or target build settings set "OTHER_CFLAGS" to "$(value) -DDEBUG=1" for the "Debug" configuration.
  http://developer.apple.com/qa/qa2006/qa1431.html
*/



#ifdef DEBUG

#define SVLog(level, format, ...){ \
    aslmsg m = asl_new(ASL_TYPE_MSG); \
    asl_set(m, ASL_KEY_FACILITY, __PRETTY_FUNCTION__); \
    asl_log(NULL, m, level, "%s", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]); \
    asl_log(NULL, m, level, "%s", [[NSString stringWithFormat:[NSString stringWithFormat:@"%s %@", __PRETTY_FUNCTION__, format], ##__VA_ARGS__] UTF8String]); \
}

#define SVDebug(format, ...){ \
    aslmsg msg = asl_new(ASL_TYPE_MSG); \
    asl_set(msg, ASL_KEY_FACILITY, "davenport"); \
    asl_log(NULL, msg, ASL_LEVEL_DEBUG, "%s", [[NSString stringWithFormat:[NSString stringWithFormat:@"%s %@", __PRETTY_FUNCTION__,format], ##__VA_ARGS__] UTF8String]); \
}

#define SVInfo(format, ...){ \
    aslmsg msg = asl_new(ASL_TYPE_MSG); \
    asl_set(msg, ASL_KEY_FACILITY, __PRETTY_FUNCTION__); \
    asl_log(NULL, msg, ASL_LEVEL_INFO, "%s", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]); \
    asl_log(NULL, msg, ASL_LEVEL_INFO, "%s", [[NSString stringWithFormat:[NSString stringWithFormat:@"%s %@", __PRETTY_FUNCTION__, format], ##__VA_ARGS__] UTF8String]); \
}


#else

#define SVDebug(format, ...){}
#define SVInfo(format, ...){}
#define SVLog(level, format, ...){}

#endif

//
//  SVAppDelegate.h
//  
//
//  Created by Robert Evans on 12/29/08.
//  Copyright 2008 South And Valley. All rights reserved.
//
#import <CouchObjC/SBCouchServer.h>
#import <Cocoa/Cocoa.h>
#import "SVMainWindowController.h"



@interface SVAppDelegate : NSObject {
	SVMainWindowController *mainWindowController;
    NSOperationQueue       *queue;
    NSTask                 *task;
    NSPipe                 *in, *out;
    NSLock                 *lock;
    // This will eventually become a dictionary of servers when we start supporting 
    // multiple couch servers. 
    SBCouchServer          *couchServer;
}

@property (retain) SVMainWindowController *mainWindowController;
@property (retain) SBCouchServer          *couchServer;

-(void)loadMainWindow;
-(void)performFetch:(NSNotification *)notification;
- (void) performFetchServerInfoOperation;
@end

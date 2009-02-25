//
//  SVConstants.h
//  Davenport
//
//  Created by Robert Evans on 2/22/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum sharedViewControllers{
    DPSharedFunctionEditorController  = 1,
    
} DPSharedViewContollers;



#pragma mark - 
#pragma mark Notifications

extern NSString * const DPContributionPluginDidLoadNavigationItemsNotification;
extern NSString * const SV_NOTIFICATION_RUN_SLOW_VIEW;
extern NSString * const DPLocalDatabaseNeedsRefreshNotification;


#pragma mark -
#pragma mark Other

/// Is DPNamedControllers are UI elements that are sharable amongst 
/// plugins. We could go crazy with this idea but for now we'll 
/// keep it simple. 
extern NSString * const DPNamedControllerFunctionEditor;
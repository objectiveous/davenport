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
/// TODO keep naming consistent
extern NSString * const DPRunSlowViewNotification;
extern NSString * const DPLocalDatabaseNeedsRefreshNotification;
extern NSString * const DPServerNeedsRefreshNotification;
extern NSString * const DPRefreshNotification;
extern NSString * const DPCreateDatabaseAction;
extern NSString * const DPDeleteItemAction;
extern NSString * const DPDisplayView;



#pragma mark -
#pragma mark Other

/// Is DPNamedControllers are UI elements that are sharable amongst 
/// plugins. We could go crazy with this idea but for now we'll 
/// keep it simple. 
extern NSString * const DPNamedControllerFunctionEditor;
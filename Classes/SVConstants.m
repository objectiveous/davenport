//
//  SVConstants.m
//  Davenport
//
//  Created by Robert Evans on 2/22/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVConstants.h"

/*!
 This NSNotification constant is used by plugins to signal that they are ready to contribute 
 navigation items to the Davenport left hand navigation. 
 */

NSString * const DPContributionPluginDidLoadNavigationItemsNotification = @"DPContributionPluginDidLoadNavigationItemsNotification";
NSString * const DPRunSlowViewNotification                              = @"DPRunSlowViewNotification";
NSString * const DPLocalDatabaseNeedsRefreshNotification                = @"DPLocalDatabaseNeedsRefreshNotification";
NSString * const DPServerNeedsRefreshNotification                       = @"DPServerNeedsRefreshNotification";
NSString * const DPRefreshNotification                                  = @"DPRefreshNotification";
NSString * const DPCreateDatabaseAction                                 = @"DPCreateDatabaseAction";
NSString * const DPDeleteItemAction                                     = @"DPDeleteDatabaseAction";
NSString * const DPDisplayView                                          = @"DPDisplayView";


#pragma mark - 

NSString * const DPNamedControllerFunctionEditor = @"DPNamedControllerFunctionEditor";
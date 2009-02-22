//
//  SVContributionNav.h
//  Davenport
//
//  Created by Robert Evans on 2/13/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#pragma mark -
#pragma mark Notifications

//#define DPLocalDatabaseNeedsRefreshNotification @"SVLocalDatabaseNeedsRefreshNotification"

//= @"DPContributionPluginDidLoadNavigationItemsNotification";


#pragma mark -
/*!
 This is the entry point into the contribution model. All contributions are 
 made by providing a class that conforms to this protocol. 
 */
@protocol DPContributionPlugin

// Return an empty root who's children will be added to the NSOutlineView that makes 
// up the left-hand nav of davenport. The root node is said to be "empty" when it has 
// no represented object. All child nodes MUST contain represented objects that conform 
// to the XXX protocol. 
// 
// Returning nil is also allowed. 

@required

/*! 
 pluginID is the unique ID used to identify a contribution. For example, when a user clicks 
 on a item in the left-hand nav, the NSOutlineView delegate will lookup the registed plugin 
 via its id and delegate event handling to it. 
 */
+(NSString*)pluginID;

/*!
 This instance method only exists because I can't figure our how to call class mathods 
 */

-(NSString*)pluginID;
-(NSTreeNode*)navigationContribution;

/// Is called whenever a user selects a navigation item that has been contributed by this plugin. 
-(void)selectionDidChange:(NSTreeNode*)item;

/// This is called after selectionDidChange. 
-(NSViewController*)mainSectionContribution;

// 
// @optional 

// Provider Name URL
// version 
// Plugin Version 

// start (DVPluginContext*)
- (void)start;
// stop (DVPluginContext*)

@end

//
//  TNavContribution.m
//  DPTestPlugin
//
//  Created by Robert Evans on 2/13/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "TPPlugin.h"
#import "TPBaseDescriptor.h"
#import "TPDatabaseInstallerOperation.h"
#import "TPLoadNavigationOperation.h"
#import "NSTreeNode+TP.h"
#import <CouchObjC/CouchObjC.h>

static NSString *DATABASE_NAME         = @"cushion-tickets";
static NSString *PLUGIN_NODE_NAME      = @"Cushion Tickets";
static NSString *PLUGIN_NODE_MILESTONE = @"milestone";
static NSString *PLUGIN_NODE_TASK      = @"task";


@implementation TPPlugin

@synthesize currentItem;

+(NSString*)databaseName{
    return DATABASE_NAME;
}
+(NSString*)pluginID{
    //return [TPPlugin class];
    // TODO It would be nice to make this dynamic
    return @"TPPlugin";
}


-(NSString*)pluginID{
    //return [TPPlugin class];
    // TODO It would be nice to make this dynamic
    return @"TPPlugin";
}

-(void)start{
    TPDatabaseInstallerOperation *installOperation = [[TPDatabaseInstallerOperation alloc] init];
    TPLoadNavigationOperation *loadNavOperation = [[TPLoadNavigationOperation alloc] init];
    [loadNavOperation addDependency:installOperation];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // XXX What do we do if this fails?
    [queue addOperation:loadNavOperation];
    [queue addOperation:installOperation];
    
    [installOperation release];
    [loadNavOperation release];
    [queue release];
    
    // SVMainWindowController will recieve this notification and call the navigationContribution: selector on self and then 
    // add this plugins lefthand navigation contributions to the Davenport shell. 
     NSLog(@"---> %@", DPContributionPluginDidLoadNavigationItemsNotification);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DPContributionPluginDidLoadNavigationItemsNotification object:[self pluginID]];
    
}


-(NSTreeNode*)navigationContribution{
    NSTreeNode *contributionRoot = [[[NSTreeNode alloc] init] autorelease];            
    NSTreeNode *taskmgmtNode = [contributionRoot addChildWithLabel:PLUGIN_NODE_NAME identity:@"taskmgmt" descriptorType:@"root" group:YES];
        
    NSTreeNode *milestone = [taskmgmtNode addChildWithLabel:@"milestone one" identity:@"milesotneone1" descriptorType:PLUGIN_NODE_MILESTONE];
    [milestone addChildWithLabel:@"Map/Reduce Editor" identity:@"do it" descriptorType:PLUGIN_NODE_TASK ];
    [milestone addChildWithLabel:@"Self Hosting" identity:@"do it" descriptorType:PLUGIN_NODE_TASK ];
    [milestone addChildWithLabel:@"Feature Complete" identity:@"do it" descriptorType:PLUGIN_NODE_TASK ];

    NSTreeNode *milestone2 = [taskmgmtNode addChildWithLabel:@"milestone two" identity:@"milesotneone2" descriptorType:PLUGIN_NODE_MILESTONE];
    [milestone2 addChildWithLabel:@"Network Plugin Loading" identity:@"do it" descriptorType:PLUGIN_NODE_TASK ];
    [milestone2 addChildWithLabel:@"Buffer Interface" identity:@"do it" descriptorType:PLUGIN_NODE_TASK ];
        
    return contributionRoot;
}
/*!
 This is a delegate method that is invoked when a user selects a navigation item 
 that we have contributed to the left hand navigation of Davenport. 
 */
-(void)selectionDidChange:(NSTreeNode*)item{
    NSLog(@"User selected one our navigation items!");
    self.currentItem = item;
}

-(NSViewController*)mainSectionContribution{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSLog(@"Bundle info : %@", bundle);
    NSViewController *controller;
    TPBaseDescriptor *selectedDescriptor = (TPBaseDescriptor*) [currentItem representedObject];
    NSString *descType = [selectedDescriptor descriptorType];
    
    if(descType == @"milestone"){
        controller = [[[NSViewController alloc] initWithNibName:@"TPMilestone" bundle:bundle] autorelease];
        NSLog(@"Trying to load the nib thingy %@", controller);
        NSLog(@" ** view  %@", [controller view]);
    }else{
        controller = [[[NSViewController alloc] initWithNibName:@"TPTaskItem" bundle:bundle] autorelease];
        NSLog(@"Trying to load the nib thingy %@", controller);
        NSLog(@" ** view  %@", [controller view]);
    }
    
    return controller;
}

@end

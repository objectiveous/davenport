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

static NSString *PLUGIN_NAME           = @"TPPlugin";
static NSString *DATABASE_NAME         = @"cushion-tickets";
static NSString *PLUGIN_NODE_NAME      = @"Cushion Tickets";
static NSString *PLUGIN_NODE_MILESTONE = @"milestone";
static NSString *PLUGIN_NODE_TASK      = @"task";


@implementation TPPlugin

@synthesize currentItem;

#pragma mark -
#pragma mark CLass Methods
+(NSString*)databaseName{
    return DATABASE_NAME;
}   
+(NSString*)pluginID{
    //return [TPPlugin class];
    // TODO It would be nice to make this dynamic
    return PLUGIN_NAME;
}

#pragma mark -
- (void)dealloc{
    [queue release];
    [super dealloc];
}

#pragma mark -
#pragma mark DPContributionPlugin Protocol 
-(void)start{
    
    queue = [[NSOperationQueue alloc] init];
    TPDatabaseInstallerOperation *installOperation = [[TPDatabaseInstallerOperation alloc] init];
    TPLoadNavigationOperation *loadNavOperation = [[TPLoadNavigationOperation alloc] init];
    [loadNavOperation addDependency:installOperation];
    
    // Would it make sense to use a queue held by the app delegate. Something like this: 
    //NSOperationQueue* myQueue = [[[NSApplication sharedApplication] delegate] myOperationQueue];
    
    
    // XXX What do we do if this fails?
    [queue addOperation:loadNavOperation];
    [queue addOperation:installOperation];
    
    [loadNavOperation addObserver:self forKeyPath:@"isFinished" options:0 context:NULL];
    [installOperation release];
    [loadNavOperation release];
    [queue release];
    
    // SVMainWindowController will recieve this notification and call the navigationContribution: selector on self and then 
    // add this plugins lefthand navigation contributions to the Davenport shell. 
     NSLog(@"---> %@", DPContributionPluginDidLoadNavigationItemsNotification);
    
   
    
}



-(NSTreeNode*)navigationContribution{
    return navContribution;
}

-(NSViewController*)mainSectionContribution{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSLog(@"Bundle info : %@", bundle);
    NSViewController *controller;
    TPBaseDescriptor *selectedDescriptor = (TPBaseDescriptor*) [currentItem representedObject];
    TPNavigationDescriptorType descType = [selectedDescriptor descriptorType];
    

    if(descType == TPNavigationDescriptorMilestone){
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

#pragma mark -


/*!
 This is a delegate method that is invoked when a user selects a navigation item 
 that we have contributed to the left hand navigation of Davenport. 
 */
-(void)selectionDidChange:(NSTreeNode*)item{
    NSLog(@"User selected one our navigation items!");
    self.currentItem = item;
}

-(NSString*)pluginID{
    //return [TPPlugin class];
    // TODO It would be nice to make this dynamic
    return PLUGIN_NAME;
}


#pragma mark -
#pragma mark KVO
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context{
    // watch for the completion of the nav load operation and assign the nav. 
    if([keyPath isEqual:@"isFinished"] && [object isKindOfClass:[TPLoadNavigationOperation class]]){        
        navContribution = [(TPLoadNavigationOperation*)object rootContributionNode];
        
        // Now tell the world that we are ready to contribute our navigation NSTreeNode. 
        [[NSNotificationCenter defaultCenter] postNotificationName:DPContributionPluginDidLoadNavigationItemsNotification object:[self pluginID]];
    }     
} 



@end

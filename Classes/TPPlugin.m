//
//  TNavContribution.m
//  DPTestPlugin
//
//  Created by Robert Evans on 2/13/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVConstants.h"
#import "DPResourceFactory.h"
#import "DPContributionPlugin.h"
#import "TPPlugin.h"
#import "DPContributionNavigationDescriptor.h"
#import "TPBaseDescriptor.h"
#import "TPDatabaseInstallerOperation.h"
#import "TPLoadNavigationOperation.h"
#import "NSTreeNode+TP.h"
#import <CouchObjC/CouchObjC.h>


static NSString *PLUGIN_NAME           = @"TPPlugin";
static NSString *DATABASE_NAME         = @"cushion-tickets";
//static NSString *PLUGIN_NODE_NAME      = @"Cushion Tickets";
//static NSString *PLUGIN_NODE_MILESTONE = @"milestone";
//static NSString *PLUGIN_NODE_TASK      = @"task";


@implementation TPPlugin

@synthesize bundle;
@synthesize currentItem;
@synthesize resourceFactory;

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

-(id)initWithResourceFactory:(id <DPResourceFactory>)factory{
    self = [super init];
    if(self){
        self.resourceFactory = factory;
    }
    return self;
}

- (void)dealloc{
    [queue release];
    [super dealloc];
}

#pragma mark -
#pragma mark DPContributionPlugin Protocol 
-(void)start{
    self.bundle = [NSBundle bundleForClass:[self class]];
    queue = [[NSOperationQueue alloc] init];
    TPDatabaseInstallerOperation *installOperation = [[TPDatabaseInstallerOperation alloc] init];
    TPLoadNavigationOperation *loadNavOperation = [[TPLoadNavigationOperation alloc] initWithResourceFactory:self.resourceFactory];
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
        
}

-(NSTreeNode*)navigationContribution{
    return navContribution;
}

-(DPNavigationDescriptorTypes)descriptorTypeForCurrentItem{    
    TPBaseDescriptor *selectedDescriptor = (TPBaseDescriptor*) [currentItem representedObject];
    DPNavigationDescriptorTypes descType = [selectedDescriptor type];
    return descType;
}


-(NSViewController*)contributionMainViewController{        
    DPNavigationDescriptorTypes descType = [self descriptorTypeForCurrentItem];    
    NSViewController *controller;
    
   if(descType == DPDescriptorPluginProvided){                
        // controller = [self.resourceFactory namedResource:DPSharedViewContollerNamedFunctionEditor withItem:self.currentItem];

       // XX Way convoluted but we'll get this fixed. 
       id <DPContributionNavigationDescriptor> navDescriptor = [self.currentItem representedObject];
       NSViewController *theMagicController = [ navDescriptor contributionMainViewController];

       return theMagicController;
       
        // XXX This is magic. Users will have no idea that this is possible. This needs to be part of the contract. 
        //[controller setTreeNode:self.currentItem];
    }else{
        controller = [[[NSViewController alloc] initWithNibName:@"TPMilestone" bundle:bundle] autorelease];
        NSLog(@"Trying to load the nib thingy %@", controller);
        NSLog(@" ** view  %@", [controller view]);
    }
    return controller;
}

-(NSViewController*)contributionInspectorViewController{
    id <DPContributionNavigationDescriptor> navDescriptor = [self.currentItem representedObject];
    NSViewController *theMagicController = [ navDescriptor contributionInspectorViewController];
    
    return theMagicController;        
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

//
//  TPBaseDescriptor.m
//  Davenport
//
//  Created by Robert Evans on 2/14/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "DPResourceFactory.h"
#import "DPContributionNavigationDescriptor.h"
#import "TPBaseDescriptor.h"
#import "DPContributionPlugin.h"
#import "TPPlugin.h"
#import "DPSharedController.h"
#import "SVConstants.h"
#import "TPNewTaskController.h"
#import "SVKeyBindingsResponder.h"
#import "DPKeyBindingManager.h"
@interface TPBaseDescriptor (Private)

@end


@implementation TPBaseDescriptor
@synthesize label; 
@synthesize identity;
@synthesize groupItem;
@synthesize pluginID;
@synthesize type;
@synthesize resourceFactory;
@synthesize couchDatabase;
@synthesize privateType;
@synthesize couchDocument;
@synthesize bodyController;
@synthesize inspectorController;
@synthesize userInfo;

-(id)init{    
    self = [super init];
    if(self){
        self.groupItem = NO;                 
    }
    return self;
}


-(id)initWithPluginID:(NSString*)pluginId label:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(DPNavigationDescriptorTypes)aType resourceFactory:(id<DPResourceFactory>)rezFactory group:(BOOL)isGroup{
    self = [self initWithLabel:alabel identity:anIdentity descriptorType:aType resourceFactory:rezFactory group:isGroup];
    if(self){
        self.pluginID = pluginId;
    }
    return self;
}

-(id)initWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(DPNavigationDescriptorTypes)aType resourceFactory:(id<DPResourceFactory>)rezFactory group:(BOOL)isGroup{    
    self = [super init];
    if(self){
        self.label = alabel;
        self.identity = anIdentity;
        self.groupItem = isGroup;
        self.type = aType;
        self.resourceFactory = rezFactory;        
        id <DPKeyBindingManager> keyBindingManager = [self.resourceFactory keyBindingManager];
        
        [keyBindingManager registerBindingForKey:@"m" target:self selector:@selector(showNewTaskFormAction)]; 
    }
    return self;
}


#pragma mark -
/*
- (BOOL)performKeyEquivalent:(NSEvent *)theEvent{
    return YES;
}

- (BOOL)acceptsFirstResponder{
    return YES;
}
*/
 
 
#pragma mark -

-(BOOL)isGroupItem{
    return self.groupItem;
}

// XXX Item may be sorta stupid to pass in because it is the item 
// representing an instance of this class. I suspect that if you 
// look at the call path up to this point, it will become obvious
// how to remove the need for item. 

- (NSViewController*) contributionMainViewController{
    if(self.privateType == DPDescriptorCouchDesign){
        //id <DPSharedController> sharedController = [self.resourceFactory namedResource:DPSharedViewContollerNamedFunctionEditor];
        //NSString *urlPath = [self identity];
        //id designDoc = [self.couchDatabase getDesignDocument:urlPath];
        //[sharedController provision:designDoc];
        //self.bodyController = (NSViewController*) sharedController;
        id <DPContributionPlugin> plugin = [[NSApp delegate] lookupPlugin:self.pluginID];
        
        
        self.bodyController = [[[NSViewController alloc] initWithNibName:@"TPMilestone" bundle:[plugin bundle]] autorelease];
    }
    if(self.privateType == DPDescriptorCouchView) {
        id <DPSharedController> sharedController = [self.resourceFactory namedResource:DPSharedViewContollerNamedViewResults];
        
        [sharedController setOutlineDelegate:self];
        
        SBCouchQueryOptions *queryOptions = [[SBCouchQueryOptions new] autorelease];
        queryOptions.limit = 5;
        SBCouchView *view = [[SBCouchView alloc] initWithName:[self identity] couchDatabase:self.couchDatabase queryOptions:queryOptions ];
        SBCouchEnumerator *viewEnumerator = (SBCouchEnumerator*) [view viewEnumerator];
        
        [sharedController provision:viewEnumerator];
        self.bodyController = (NSViewController*) sharedController;
        [view release];
    }
    return self.bodyController;
}

- (NSViewController*) contributionInspectorViewController{
    self.inspectorController = (NSViewController*) [self.resourceFactory namedResource:DPSharedViewContollerNamedViewResults];
    // Now how do you say something like the following in a generic way: 
    // [self.bodyController setDelegate:self.inspectorController];
    // 
    // Would this be an informal protocol? How does one document these things properly?
    if ( [self.bodyController respondsToSelector:@selector(setDelegate:)] ) {
        [self.bodyController setDelegate:self.inspectorController];
    }
       
    return self.inspectorController;
}
-(NSDictionary*)userInfo{
    return userInfo;
}

- (void)menuNeedsUpdate:(NSMenu *)menu forItem:(NSTreeNode*)item{
    NSMenuItem *menuItem;
    if(menuItem = [menu itemWithTitle:@"New Task"]){
        [menuItem setRepresentedObject:item];
        return;
    }
            
    menuItem = [menu addItemWithTitle:@"New Task" action:@selector(showNewTaskFormAction:) keyEquivalent:@"n"];
    [menuItem setKeyEquivalentModifierMask:NSControlKeyMask];
    [menuItem setTarget:self];
    [menuItem setRepresentedObject:item];
    
    return;
}

#pragma mark -
#pragma mark Action Handlers
- (IBAction)showNewTaskFormAction{
    id <DPContributionPlugin> plugin = [[NSApp delegate] lookupPlugin:self.pluginID];
    // XX Memory leak
    TPNewTaskController *controller = [[TPNewTaskController alloc] initWithNibName:@"TPNewTask" 
                                                                            bundle:[plugin bundle] treeNode:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DPDisplayViewInMainArea object:controller];
    
}
- (IBAction)showNewTaskFormAction:(NSMenuItem*)sender{
     id <DPContributionPlugin> plugin = [[NSApp delegate] lookupPlugin:self.pluginID];
    // XX Memory leak
    TPNewTaskController *controller = [[TPNewTaskController alloc] initWithNibName:@"TPNewTask" bundle:[plugin bundle] treeNode:self];

     [[NSNotificationCenter defaultCenter] postNotificationName:DPDisplayViewInMainArea object:controller];
}

#pragma mark -
#pragma mark NSOutlineView Delegate 
- (void)outlineViewSelectionDidChange:(NSNotification *)notification{
    id <DPContributionPlugin> plugin = [[NSApp delegate] lookupPlugin:self.pluginID];
    TPNewTaskController *controller = [[[TPNewTaskController alloc] initWithNibName:@"TPNewTask" bundle:[plugin bundle] treeNode:self.couchDocument] autorelease];
    //TPNewTaskController *controller = [[TPNewTaskController alloc] initWithNibName:@"TPNewTask" bundle:nil treeNode:self.couchDocument];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DPDisplayViewInInspectorArea object:controller];
}

@end

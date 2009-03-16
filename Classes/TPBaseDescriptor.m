//
//  TPBaseDescriptor.m
//  Davenport
//
//  Created by Robert Evans on 2/14/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "TPBaseDescriptor.h"
#import "DPSharedController.h"

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
    }
    return self;
}

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
        id <DPSharedController> sharedController = [self.resourceFactory namedResource:DPSharedViewContollerNamedFunctionEditor];
        NSString *urlPath = [self identity];
        id designDoc = [self.couchDatabase getDesignDocument:urlPath];
        [sharedController provision:designDoc];
        self.bodyController = (NSViewController*) sharedController;
    }
    if(self.privateType == DPDescriptorCouchView) {
        id <DPSharedController> sharedController = [self.resourceFactory namedResource:DPSharedViewContollerNamedViewResults];
               
        SBCouchQueryOptions *queryOptions = [SBCouchQueryOptions new];
        SBCouchView *view = [[SBCouchView alloc] initWithName:[self identity] couchDatabase:self.couchDatabase queryOptions:queryOptions ];
        SBCouchEnumerator *viewEnumerator = (SBCouchEnumerator*) [view viewEnumerator];
        
        [sharedController provision:viewEnumerator];
        self.bodyController = (NSViewController*) sharedController;                
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
@end

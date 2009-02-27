//
//  TPBaseDescriptor.m
//  Davenport
//
//  Created by Robert Evans on 2/14/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "TPBaseDescriptor.h"


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
    
    /*
    DPDescriptorCouchDesign    = 1,
    DPDescriptorCouchView      = 2,
    DPDescriptorCouchDatabase  = 3,
    DPDescriptorCouchServer    = 4,    
    DPDescriptorSection        = 5,
    
    
    DPSharedViewContollerNamedFunctionEditor
    DPSharedViewContollerNamedViewResults     
     */
    if(self.privateType == DPDescriptorCouchDesign) 
        return [self.resourceFactory namedResource:DPSharedViewContollerNamedFunctionEditor navContribution:self];  
    
    if(self.privateType == DPDescriptorCouchView) 
        return [self.resourceFactory namedResource:DPSharedViewContollerNamedViewResults navContribution:self];  
        
    return nil;
}


- (NSViewController*) contributionInspectorViewController{
    return nil;
}


@end

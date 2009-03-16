//
//  SVAbstractDescriptor.m
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "SVBaseNavigationDescriptor.h"
#import "DPResourceFactory.h"
#import "DPSharedController.h"

@implementation SVBaseNavigationDescriptor

@synthesize label;
@synthesize nodeIcon;
@synthesize identity;
@synthesize groupItem;
@synthesize type;
@synthesize couchDatabase;
@synthesize resourceFactory;


-(id)initWithLabel:(NSString*)nodeLabel andIdentity:(NSString*)nodeIdentity type:(DPNavigationDescriptorTypes)aType userInfo:(NSMutableDictionary*)info{
    self = [self initWithLabel:nodeLabel andIdentity:nodeIdentity type:aType];
    if(self){
        userInfo = [info copy];
        [userInfo retain];
    }
    return self;
}

-(id)initWithLabel:(NSString*)nodeLabel andIdentity:(NSString*)nodeIdentity type:(DPNavigationDescriptorTypes)aType{
    self = [super init];
    if(self){
        self.label = nodeLabel;
        self.identity = nodeIdentity;
        self.groupItem = NO;
        self.type = aType;        
    }
    return self;
}

-(void)dealloc{
    [userInfo release], userInfo = nil;
    [super dealloc];
}

-(BOOL)isGroupItem{
    return self.groupItem;
}
- (NSViewController*) contributionInspectorViewController{
    return nil;
}

// XXX Now that we've introduced userinfo as a way of passing around couch objects, this entire 
//     method should be rethought. 
- (NSViewController*) contributionMainViewController{    
    if(self.type == DPDescriptorCouchDatabase){
        NSEnumerator *couchResults = [self.couchDatabase allDocsInBatchesOf:100];
        // This call will set self as the data source to the NSOutlineView. This may or may not be 
        // a good approach. 
        id <DPSharedController> sharedController = [self.resourceFactory namedResource:DPSharedViewContollerNamedViewResults];
        [sharedController provision:couchResults];
        return (NSViewController*) sharedController; 
    }else if(self.type == DPDescriptorCouchView){
        SBCouchView *view = [userInfo objectForKey:@"couchobject"];
        NSEnumerator *couchResults = [view viewEnumerator];
        
        id <DPSharedController> sharedController = [self.resourceFactory namedResource:DPSharedViewContollerNamedViewResults];
        [sharedController provision:couchResults];
        return (NSViewController*) sharedController;         
    }
        
    return nil;
}

- (NSString*)pluginID{
    return nil;
}
-(NSDictionary*)userInfo{
    return userInfo;
}

@end

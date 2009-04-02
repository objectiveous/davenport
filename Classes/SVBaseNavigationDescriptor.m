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


+ (NSMutableDictionary *) createUserInfoDictionary:(id) couchObject  {
    //XXX why not a capcity of 1? 
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    [userInfo setObject:couchObject forKey:@"couchobject"];
    return userInfo;
}
+(id) serverDescriptor:(SBCouchServer*)couchServer resourceFactory:(id <DPResourceFactory>)factory{
    NSString *serverName = [NSString stringWithFormat:@"%@:%u", couchServer.host, couchServer.port];
    
    SVBaseNavigationDescriptor *descriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:serverName
                                                                                   andIdentity:serverName
                                                                                          type:DPDescriptorCouchServer
                                                                                      userInfo:[self createUserInfoDictionary:couchServer]];

    descriptor.resourceFactory = factory;
    descriptor.groupItem = YES;
    return [descriptor autorelease];
}

+(id) databaseDescriptor:(SBCouchDatabase*)couchDatabase resourceFactory:(id <DPResourceFactory>)factory{
    
    SVBaseNavigationDescriptor *databaseDescriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:couchDatabase.name
                                                                                           andIdentity:couchDatabase.name
                                                                                                  type:DPDescriptorCouchDatabase
                                                                                              userInfo:[self createUserInfoDictionary:couchDatabase]];
    databaseDescriptor.resourceFactory = factory;
    databaseDescriptor.couchDatabase = couchDatabase;
    return [databaseDescriptor autorelease];
}

+(id) designDescriptor:(SBCouchDesignDocument*)couchDesignDoc resourceFactory:(id <DPResourceFactory>)factory{
    SVBaseNavigationDescriptor *designDescriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:[couchDesignDoc.identity lastPathComponent]
                                                                                         andIdentity:couchDesignDoc.identity
                                                                                                type:DPDescriptorCouchDesign
                                                                                            userInfo:[self createUserInfoDictionary:couchDesignDoc]];
    designDescriptor.resourceFactory = factory;
    designDescriptor.couchDatabase = couchDesignDoc.couchDatabase;
    return [designDescriptor autorelease];    
}

+(id) viewDescriptor:(SBCouchView*)couchView resourceFactory:(id <DPResourceFactory>)factory{
    SVBaseNavigationDescriptor *viewDescriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:couchView.name
                                                                                         andIdentity:couchView.identity
                                                                                                type:DPDescriptorCouchView
                                                                                            userInfo:[self createUserInfoDictionary:couchView]];
    viewDescriptor.resourceFactory = factory;
    viewDescriptor.couchDatabase = couchView.couchDatabase;
    return [viewDescriptor autorelease]; 
}
#pragma mark -

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
        SBCouchQueryOptions *queryOptions = [[SBCouchQueryOptions new] autorelease];

        if(view.reduce){
            queryOptions.group = YES;
        }else{
            queryOptions.group = NO;            
        }

        view.queryOptions = queryOptions;
        
        NSLog(@"ID %@", view.identity);
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

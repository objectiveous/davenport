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

-(id)init{    
    self = [super init];
    if(self){
        self.groupItem = NO;
    }
    return self;
}


-(id)initWithPluginID:(NSString*)pluginId label:(NSString*)alabel identity:(NSString*)anIdentity group:(BOOL)isGroup{
    self = [self initWithLabel:alabel identity:anIdentity group:isGroup];
    if(self){
        self.pluginID = pluginId;
    }
    return self;
}

-(id)initWithLabel:(NSString*)alabel identity:(NSString*)anIdentity group:(BOOL)isGroup{    
    self = [super init];
    if(self){
        self.label = alabel;
        self.identity = anIdentity;
        self.groupItem = isGroup;
    }
    return self;
}

#pragma mark -

-(BOOL)isGroupItem{
    return self.groupItem;
}

-(NSString*)getPluginID{
    return pluginID;
}

@end

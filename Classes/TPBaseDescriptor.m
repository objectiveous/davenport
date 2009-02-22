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
@synthesize descriptorType;

-(id)init{    
    self = [super init];
    if(self){
        self.groupItem = NO;
    }
    return self;
}


-(id)initWithPluginID:(NSString*)pluginId label:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(NSString*)aType group:(BOOL)isGroup{
    self = [self initWithLabel:alabel identity:anIdentity descriptorType:aType group:isGroup];
    if(self){
        self.pluginID = pluginId;
    }
    return self;
}

-(id)initWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(NSString*)aType  group:(BOOL)isGroup{    
    self = [super init];
    if(self){
        self.label = alabel;
        self.identity = anIdentity;
        self.groupItem = isGroup;
        self.descriptorType = aType;
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

-(NSString*)getLabel{
    return self.label;
}

-(NSString*)getIdentity{
    return self.identity;
}

@end

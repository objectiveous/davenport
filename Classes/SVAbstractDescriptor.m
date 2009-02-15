//
//  SVAbstractDescriptor.m
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "SVAbstractDescriptor.h"


@implementation SVAbstractDescriptor

@synthesize label;
@synthesize nodeIcon;
@synthesize identity;
@synthesize groupItem;

-(id)initWithLabel:(NSString*)nodeLabel andIdentity:(NSString*)nodeIdentity{
    self = [super init];
    if(self){
        self.label = nodeLabel;
        self.identity = nodeIdentity;
        self.groupItem = NO;
    }
    return self;
}
-(BOOL)isGroupItem{
    return self.groupItem;
}
@end

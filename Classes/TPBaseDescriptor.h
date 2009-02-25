//
//  TPBaseDescriptor.h
//  Davenport
//
//  Created by Robert Evans on 2/14/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TPBaseDescriptor.h"
#import "DPContributionNavigationDescriptor.h"
#import "TPPlugin.h"

@interface TPBaseDescriptor : NSObject <DPContributionNavigationDescriptor>{
    NSString *label;
    NSString *pluginID;
    NSString *identity; 
    DPNavigationDescriptorTypes type;
    BOOL      groupItem;
    
}

@property (retain) NSString *label;
@property (retain) NSString *pluginID;
@property (retain) NSString *identity;
@property DPNavigationDescriptorTypes type;
@property BOOL groupItem;


-(id)initWithPluginID:(NSString*)pluginId label:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(DPNavigationDescriptorTypes)aType group:(BOOL)isGroup;
-(id)initWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(DPNavigationDescriptorTypes)aType group:(BOOL)isGroup;
-(BOOL)isGroupItem;

@end

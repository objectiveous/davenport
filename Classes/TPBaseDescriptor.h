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
#import "DPResourceFactory.h"
#import "TPPlugin.h"
#import <CouchObjC/CouchObjC.h>

@interface TPBaseDescriptor : NSObject <DPContributionNavigationDescriptor>{
    SBCouchDatabase            *couchDatabase;
    SBCouchDocument            *couchDocument;
    NSString                   *label;
    NSString                   *pluginID;
    NSString                   *identity; 

    // XXX All this type crap needs to go away. 
    DPNavigationDescriptorTypes type;
    DPNavigationDescriptorTypes privateType;    
    id <DPResourceFactory>      resourceFactory;
    BOOL                        groupItem;    
}

@property (retain) SBCouchDatabase     *couchDatabase;
@property (retain) SBCouchDocument     *couchDocument;
@property (retain) NSString            *label;
@property (retain) NSString            *identity;
@property (retain) NSString            *pluginID;
@property DPNavigationDescriptorTypes  type;
@property DPNavigationDescriptorTypes  privateType;
@property (retain) <DPResourceFactory> resourceFactory;

@property BOOL groupItem;


- (id)initWithPluginID:(NSString*)pluginId label:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(DPNavigationDescriptorTypes)aType resourceFactory:(id<DPResourceFactory>)rezFactory group:(BOOL)isGroup;

- (id)initWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(DPNavigationDescriptorTypes)aType resourceFactory:(id<DPResourceFactory>)rezFactory group:(BOOL)isGroup;
- (BOOL)isGroupItem;
//- (NSViewController*)mainController:(NSTreeNode*)item;
//- (NSViewController*)inspectorController:(NSTreeNode*)item;

- (NSViewController*) contributionInspectorViewController;
- (NSViewController*) contributionMainViewController;

@end

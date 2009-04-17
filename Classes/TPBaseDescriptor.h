//
//  TPBaseDescriptor.h
//  Davenport
//
//  Created by Robert Evans on 2/14/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>
#import "DPContributionNavigationDescriptor.h"

@class TPBaseDescriptor;
@class DPContributionNavigationDescriptor;
@class DPResourceFactory;
@class TPPlugin;

@interface TPBaseDescriptor : NSObject <DPContributionNavigationDescriptor>{
    SBCouchDatabase            *couchDatabase;
    SBCouchDocument            *couchDocument;
    NSString                   *label;
    NSString                   *pluginID;
    NSString                   *identity; 

    // XXX All this type crap needs to go away. 
    DPNavigationDescriptorTypes type;
    DPNavigationDescriptorTypes privateType;    

    // Since we have a shared resource factory, we can provide do that fancy stuff like returning 
    // body and inspector controllers for ourselves.
    id <DPResourceFactory>      resourceFactory;
    BOOL                        groupItem;
    
    NSViewController            *bodyController;
    NSViewController            *inspectorController;
    NSDictionary                *userInfo;
    
}

@property (retain) SBCouchDatabase     *couchDatabase;
@property (retain) SBCouchDocument     *couchDocument;
@property (retain) NSString            *label;
@property (retain) NSString            *identity;
@property (retain) NSString            *pluginID;
@property DPNavigationDescriptorTypes   type;
@property DPNavigationDescriptorTypes   privateType;
@property (retain) <DPResourceFactory>  resourceFactory;
@property (retain) NSViewController    *bodyController;
@property (retain) NSViewController    *inspectorController;
@property (retain) NSDictionary        *userInfo;

@property BOOL groupItem;


- (id)initWithPluginID:(NSString*)pluginId label:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(DPNavigationDescriptorTypes)aType resourceFactory:(id<DPResourceFactory>)rezFactory group:(BOOL)isGroup;

- (id)initWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(DPNavigationDescriptorTypes)aType resourceFactory:(id<DPResourceFactory>)rezFactory group:(BOOL)isGroup;
- (BOOL)isGroupItem;


- (NSViewController*) contributionInspectorViewController;
- (NSViewController*) contributionMainViewController;
- (NSDictionary*)userInfo;

- (void)menuNeedsUpdate:(NSMenu *)menu forItem:(NSTreeNode*)item;
- (IBAction)showNewTaskFormAction:(NSMenuItem*)sender;
@end

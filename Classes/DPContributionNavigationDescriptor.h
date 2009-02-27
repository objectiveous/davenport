//
//  DPContributionNavigationDescriptor.h
//  Davenport
//
//  Created by Robert Evans on 2/14/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

/// XXX Normalize these names. 

#import <CouchObjC/CouchObjC.h>

typedef enum documentTypes{
    DPDescriptorCouchDesign    = 1,
    DPDescriptorCouchView      = 2,
    DPDescriptorCouchDatabase  = 3,
    DPDescriptorCouchServer    = 4,    
    DPDescriptorSection        = 5,
    DPDescriptorPluginProvided = 6, 
    
} DPNavigationDescriptorTypes;

@protocol DPContributionNavigationDescriptor

- (NSString*)label;
- (NSString*)identity;
- (NSString*)pluginID;
- (SBCouchDatabase*)couchDatabase;
- (DPNavigationDescriptorTypes)type;           
- (NSViewController*) contributionInspectorViewController;
- (NSViewController*) contributionMainViewController;

// If set to true, the NSOutlineView row will be drawn in the “group row” style
// See NSOutlineView outlineView:isGroupItem: for more information
-(BOOL)isGroupItem;
@end

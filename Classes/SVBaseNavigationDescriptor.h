//
//  SVAbstractDescriptor.h
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DPContributionNavigationDescriptor.h"
#import <CouchObjC/CouchObjC.h>

@interface SVBaseNavigationDescriptor : NSObject <DPContributionNavigationDescriptor>{
    // A label is the text show to the user. For example, in an outline view we might display a design document named _design/numberOfJazzBands as Number Of Jazz Bands
    NSString                    *label;    
    NSString                    *identity; // Identity is the actual resource name that a Descriptor represents. For example  _design/numberOfJazzBands
    NSImage	                    *nodeIcon;
    BOOL                         groupItem;
    DPNavigationDescriptorTypes  type;    
    SBCouchDatabase             *couchDatabase;
}

@property (retain) NSString           *label;
@property (retain) NSImage            *nodeIcon;
@property (retain) NSString           *identity;
@property          BOOL                groupItem;
@property DPNavigationDescriptorTypes  type;
@property (retain) SBCouchDatabase    *couchDatabase;

-(id)initWithLabel:(NSString*)nodeLabel andIdentity:(NSString*)nodeIdentity type:(DPNavigationDescriptorTypes)aType;
-(BOOL)isGroupItem;
@end

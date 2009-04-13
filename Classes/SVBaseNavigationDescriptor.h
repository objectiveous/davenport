//  SVAbstractDescriptor.h
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>
#import "DPContributionNavigationDescriptor.h"
#import "DPResourceFactory.h"

/*!
 * @class       SVBaseNavigationDescriptor
 * @abstract    XXX
 * @discussion  xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *              xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *              xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *              xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *
 */

@interface SVBaseNavigationDescriptor : NSObject <DPContributionNavigationDescriptor>{
    // A label is the text show to the user. For example, in an outline view we might display a design document named _design/numberOfJazzBands as Number Of Jazz Bands
    NSString                    *label;    
    NSString                    *identity; // Identity is the actual resource name that a Descriptor represents. For example  _design/numberOfJazzBands
    NSImage	                    *nodeIcon;
    BOOL                         groupItem;
    DPNavigationDescriptorTypes  type;    
    SBCouchDatabase             *couchDatabase;
    id <DPResourceFactory>       resourceFactory;
    NSMutableDictionary         *userInfo;
    BOOL                         contributed;
}

@property (retain) NSString              *label;
@property (retain) NSImage               *nodeIcon;
@property (retain) NSString              *identity;
@property          BOOL                   groupItem;
@property          BOOL                   contributed;
@property DPNavigationDescriptorTypes     type;
@property (retain) SBCouchDatabase       *couchDatabase;
@property (retain) id <DPResourceFactory> resourceFactory;

+(id) serverDescriptor:(SBCouchServer*)couchServer resourceFactory:(id <DPResourceFactory>)factory;
+(id) databaseDescriptor:(SBCouchDatabase*)couchDatabase resourceFactory:(id <DPResourceFactory>)factory;
+(id) designDescriptor:(SBCouchDesignDocument*)couchDesignDoc resourceFactory:(id <DPResourceFactory>)factory;
+(id) viewDescriptor:(SBCouchView*)couchView resourceFactory:(id <DPResourceFactory>)factory;

#pragma mark -
-(id)initWithLabel:(NSString*)nodeLabel andIdentity:(NSString*)nodeIdentity type:(DPNavigationDescriptorTypes)aType userInfo:(NSMutableDictionary*)userInfo;
-(id)initWithLabel:(NSString*)nodeLabel andIdentity:(NSString*)nodeIdentity type:(DPNavigationDescriptorTypes)aType;
-(BOOL)isGroupItem;

/*!
 * @method      userInfo
 * @discussion  Returns an NSDictionary holding user information. Typically
 *   a key named couchobject will be found in this dictionary. The value of
 *   this key, if available, will be an instance of a CouchObject. 
 */
-(NSDictionary*)userInfo;
- (void)menuNeedsUpdate:(NSMenu *)menu forItem:(NSTreeNode*)item;


@end

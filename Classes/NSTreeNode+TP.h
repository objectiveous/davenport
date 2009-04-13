//
//  NSTreeNode+TP.h
//  Davenport
//
//  Created by Robert Evans on 2/14/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TPPlugin;
@class DPContributionNavigationDescriptor;
@class DPResourceFactory;

/*!
 * @class       NSTreeNode+TP
 * @abstract    xxx
 * @discussion  xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *              xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *              xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *              xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *
 */

@interface NSTreeNode(TP) 

+(NSTreeNode*)nodeWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(DPNavigationDescriptorTypes)aType resourceFactory:(id<DPResourceFactory>)rezFactory  group:(BOOL)isGroup;

-(NSTreeNode*)addChildWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(DPNavigationDescriptorTypes)aType resourceFactory:(id<DPResourceFactory>)rezFactory group:(BOOL)isGroup;
-(NSTreeNode*)addChildWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(DPNavigationDescriptorTypes)aType resourceFactory:(id<DPResourceFactory>)rezFactory;

@end

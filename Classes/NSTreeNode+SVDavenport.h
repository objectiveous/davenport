//
//  NSTreeNode+SVDavenport.h
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CouchObjC/CouchObjC.h>

@class DPResourceFactory;

@interface NSTreeNode (SVDavenport) 
    
- (NSTreeNode*) addSection:(NSString *)sectionName __attribute__ ((deprecated));


- (NSTreeNode*) addCouchServerSection:(NSString *)sectionName;
- (NSTreeNode*) addCouchServerNode:(SBCouchServer*)couchServer resourceFactory:(id <DPResourceFactory>)resourceFactory;
- (NSTreeNode*) addCouchDatabaseNode:(SBCouchDatabase*)couchDatabase resourceFactory:(id <DPResourceFactory>)resourceFactory;
- (NSTreeNode*) addCouchDesignNode:(SBCouchDesignDocument*)couchDesign resourceFactory:(id <DPResourceFactory>)resourceFactory;

- (NSTreeNode*) addCouchViewNode:(SBCouchView*)couchView resourceFactory:(id <DPResourceFactory>)resourceFactory;

- (NSTreeNode*) addDatabase:(NSString *)addDatabase;
- (NSTreeNode*) addChildNodeWithObject:(id)object;
- (NSDictionary*)asDictionary;

// returns the value of the couchobject key, held by the DPContributionNavigationDescriptor or 
// nil in the event that the reciever is not representing a DPContributionNavigationDescriptor
// or, if the reciever is lacking userinfo. 
- (id)couchObject;

// Returns an array of NSTreeNodes representing/holding DPContributionNavigationDescriptors that 
// in turn are holding an instance of type clazz. The instance in question is held in the 
// userData dictionary supplied by DPContributionNavigationDescriptor
- (NSArray*) nodesWithCouchObjectOfType:(Class)clazz;
#pragma mark -

- (NSString*) prettyPrint;
- (void)logTree;
@end

//
//  NSTreeNode+SVDavenport.h
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSTreeNode (SVDavenport) 
    
- (NSTreeNode*) addSection:(NSString *)sectionName;
- (NSTreeNode*) addCouchServerSection:(NSString *)sectionName;
- (NSTreeNode*) addDatabase:(NSString *)addDatabase;
- (NSTreeNode*) addChildNodeWithObject:(id)object;
- (NSDictionary*)asDictionary;

// Returns an array of NSTreeNodes representing DPContributionNavigationDescriptors that 
// in turn are holding an instance of type clazz. The instance in question is held in the 
// userData dictionary supplied by DPContributionNavigationDescriptor
- (NSArray*) nodesHoldingUserDataOfType:(Class)clazz;
#pragma mark -

- (NSString*) prettyPrint;
- (void)logTree;
@end

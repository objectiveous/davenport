//
//  NSTreeNode+SVDavenport.h
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSTreeNode (SVDavenport) 
    
-(NSTreeNode *) addSection:(NSString *)sectionName;
-(NSTreeNode *) addDatabase:(NSString *)addDatabase;
-(NSTreeNode *) addChildNodeWithObject:(id)object;
-(NSDictionary *)asDictionary;
@end

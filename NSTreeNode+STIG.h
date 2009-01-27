//
//  NSTreeNode+STIG.h
//  stigmergic
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSTreeNode (STIG) 
    
-(NSTreeNode *) addSection:(NSString *)sectionName;
-(NSTreeNode *) addDatabase:(NSString *)addDatabase;
-(NSTreeNode *) addChildNodeWithObject:(id)object;

@end

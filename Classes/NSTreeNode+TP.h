//
//  NSTreeNode+TP.h
//  Davenport
//
//  Created by Robert Evans on 2/14/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSTreeNode(TP) 

+(NSTreeNode*)nodeWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(NSString*)aType group:(BOOL)isGroup;

-(NSTreeNode*)addChildWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(NSString*)aType group:(BOOL)isGroup;
-(NSTreeNode*)addChildWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(NSString*)aType;

@end

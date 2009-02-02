//
//  NSDictionary+SVDavenport.h
//  Davenport
//
//  Created by Robert Evans on 2/1/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSDictionary (SVDavenport)

- (NSTreeNode*)convertHash:(NSDictionary*)dictionary forKey:(NSString*)keyName;
- (NSTreeNode*)convertArray:(NSArray*)array forKey:(NSString*)keyName;
- (NSTreeNode *)asNSTreeNode;

@end

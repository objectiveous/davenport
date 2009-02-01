//
//  NSTreeNode+SVDavenport.m
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "NSTreeNode+SVDavenport.h"
#import "SVSectionDescriptor.h"
#import "SVDatabaseDescriptor.h"


@implementation NSTreeNode (SVDavenport)

-(NSTreeNode *) addSection:(NSString *)sectionName{
    SVSectionDescriptor *section = [[[SVSectionDescriptor alloc] init] autorelease];
    section.label = sectionName;
    return [self addChildNodeWithObject:section];
    
}

-(NSTreeNode *) addDatabase:(NSString *)databaseName{
    SVDatabaseDescriptor *database = [[[SVDatabaseDescriptor alloc] init] autorelease];
    database.label = databaseName;
    return [self addChildNodeWithObject:database];
}

-(NSTreeNode *) addChildNodeWithObject:(id)object{
    NSTreeNode *node = [[[NSTreeNode alloc] initWithRepresentedObject:object] autorelease];
    [[self mutableChildNodes] addObject:node];
    return node;
}

@end

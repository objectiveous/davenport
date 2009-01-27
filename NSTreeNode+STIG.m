//
//  NSTreeNode+STIG.m
//  stigmergic
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "NSTreeNode+STIG.h"
#import "STIGSectionDescriptor.h"
#import "STIGDatabaseDescriptor.h"


@implementation NSTreeNode (STIG)

-(NSTreeNode *) addSection:(NSString *)sectionName{
    STIGSectionDescriptor *section = [[[STIGSectionDescriptor alloc] init] autorelease];
    section.label = sectionName;
    return [self addChildNodeWithObject:section];
    
}

-(NSTreeNode *) addDatabase:(NSString *)databaseName{
    STIGDatabaseDescriptor *database = [[[STIGDatabaseDescriptor alloc] init] autorelease];
    database.label = databaseName;
    return [self addChildNodeWithObject:database];
}

-(NSTreeNode *) addChildNodeWithObject:(id)object{
    NSTreeNode *node = [[[NSTreeNode alloc] initWithRepresentedObject:object] autorelease];
    [[self mutableChildNodes] addObject:node];
    return node;
}

@end

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
#import "SVJSONDescriptor.h"

@interface  NSTreeNode (Private)

-(NSDictionary*)convertJSONObjectToDictionary:(NSTreeNode*)treeNode;
-(NSArray*)convertJSONArrayToDictionary:(NSTreeNode*)treeNode;


@end

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

-(NSDictionary *)asDictionary{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[[self childNodes] count]];
    
    for(NSTreeNode *node in [self childNodes]){
        SVJSONDescriptor *jsonDesc = [node representedObject];

        if(jsonDesc.jsonType == JSON_TYPE_OBJECT){
            NSDictionary *childDictionary = [self convertJSONObjectToDictionary:node];
            [dict setObject:childDictionary forKey:jsonDesc.label];
        }else if(jsonDesc.jsonType == JSON_TYPE_ARRAY){
            
        }else if(jsonDesc.jsonType == JSON_TYPE_SCALAR){
            [dict setObject:[jsonDesc value] forKey:[jsonDesc label]];
        }
    }    
    return dict;
}

-(NSDictionary*)convertJSONObjectToDictionary:(NSTreeNode*)treeNode{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[[treeNode childNodes] count]];

    for(NSTreeNode *node in [treeNode childNodes]){
        SVJSONDescriptor *jsonDesc = [node representedObject];
        
        if(jsonDesc.jsonType == JSON_TYPE_OBJECT){
            NSDictionary *childDictionary = [treeNode convertJSONObjectToDictionary:node];
            [dict setObject:childDictionary forKey:[jsonDesc label]];
        }else if(jsonDesc.jsonType == JSON_TYPE_ARRAY){
            NSArray *childArray = [treeNode convertJSONArrayToDictionary:node];
            [dict setObject:childArray forKey:jsonDesc.label];
        }else if(jsonDesc.jsonType == JSON_TYPE_SCALAR){
            [dict setObject:[jsonDesc value] forKey:jsonDesc.label];
        }                
    }    
    return dict;
}


-(NSArray*)convertJSONArrayToDictionary:(NSTreeNode*)treeNode{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[[treeNode childNodes] count]];
    
    for(NSTreeNode *node in [treeNode childNodes]){
        SVJSONDescriptor *jsonDesc = [node representedObject];
                
        if(jsonDesc.jsonType == JSON_TYPE_OBJECT){
            NSDictionary *childDictionary = [treeNode convertJSONObjectToDictionary:node];
            [array insertObject:childDictionary atIndex:[jsonDesc.label integerValue]];
        }else if(jsonDesc.jsonType == JSON_TYPE_ARRAY){
            NSArray *childArray = [treeNode convertJSONArrayToDictionary:node];
            [array insertObject:childArray atIndex:[jsonDesc.label integerValue]];
        }else if(jsonDesc.jsonType == JSON_TYPE_SCALAR){
            [array insertObject:jsonDesc.value atIndex:[jsonDesc.label integerValue]];
        }                
    }    
    return array;
    
}

@end

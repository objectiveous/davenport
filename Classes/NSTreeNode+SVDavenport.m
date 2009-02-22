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
#import "SVAbstractDescriptor.h"
#import "SVViewDescriptor.h"
#import "SVDesignDocumentDescriptor.h"
#import "SVCouchServerDescriptor.h"
@interface  NSTreeNode (Private)

-(NSDictionary*)convertJSONObjectToDictionary:(NSTreeNode*)treeNode;
-(NSArray*)convertJSONArrayToDictionary:(NSTreeNode*)treeNode;


@end

@implementation NSTreeNode (SVDavenport)

-(NSTreeNode *) addCouchServerSection:(NSString *)sectionName{
    SVCouchServerDescriptor *section = [[[SVCouchServerDescriptor alloc] initWithLabel:sectionName andIdentity:sectionName] autorelease];
    [section setGroupItem:YES];
    return [self addChildNodeWithObject:section]; 
}

-(NSTreeNode *) addSection:(NSString *)sectionName{
    SVSectionDescriptor *section = [[[SVSectionDescriptor alloc] initWithLabel:sectionName andIdentity:sectionName] autorelease];
    [section setGroupItem:YES];
    return [self addChildNodeWithObject:section];    
}

-(NSTreeNode *) addDatabase:(NSString *)databaseName{
    SVDatabaseDescriptor *database = [[[SVDatabaseDescriptor alloc] initWithLabel:databaseName andIdentity:databaseName] autorelease];
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

#pragma mark - 
#pragma mark Descriptor Magic

-(NSString*) deriveDatabaseName{
    
    SVAbstractDescriptor *desc = [self representedObject];
    if([desc isKindOfClass:[SVDatabaseDescriptor class]]){
        return desc.identity;
    }else{
        return [[self parentNode] deriveDatabaseName];
    }
}

// Will derive a path structure like the following _design/docId if given an instance 
// of SVViewDescriptor. 

-(NSString*) deriveDesignDocumentPath{
    SVAbstractDescriptor *desc = [self representedObject];
    if([desc isKindOfClass:[SVViewDescriptor class]]){
        //NSMutableString *viewPathPart = [NSMutableString stringWithString:desc.identity];
        SVDesignDocumentDescriptor *designDesc = [[self parentNode] representedObject];
        NSMutableString *urlPath = [NSMutableString stringWithFormat:@"_design/%@",designDesc.label];
        return urlPath;
    }    
        
    return nil;    
}

-(NSString*) deriveDocumentIdentity{
    SVAbstractDescriptor *desc = [self representedObject];
    if([desc isKindOfClass:[SVViewDescriptor class]]){ 
        NSMutableString *viewPathPart = [NSMutableString stringWithString:desc.identity];
        // The parent of a view is a esign doc. 
        SVDesignDocumentDescriptor *designDesc = [[self parentNode] representedObject];
        
        // sofa-blog/_view/datacenter/hardware
        // database/_view/domain/view
        NSMutableString *urlPath = [NSMutableString stringWithFormat:@"_view/%@/%@",designDesc.label,viewPathPart];
        
        return urlPath;
    }else if([desc isKindOfClass:[SVDatabaseDescriptor class]]){
        //NSMutableString *viewPathPart = [NSMutableString stringWithFormat:@"/%@/_all_docs",desc.identity];
        return @"_all_docs";
    }else{        
        return desc.identity;
        //[self theNodesDatabase:[node parentNode]];
    }
    
}


-(void)logTree{
    NSLog(@"%@", [self prettyPrint]);
    
    for(NSTreeNode *node in [self childNodes]){
        [node prettyPrint];
        [node logTree];
    }
    
}

-(NSString*) prettyPrint{    
    id object = [self representedObject];
    if(object == NULL){
        NSString *plainDescription = [super description];
        return [NSString stringWithFormat:@"No represented Object (root) : %@", plainDescription];
    }
        
    
    if([object conformsToProtocol:@protocol(DPContributionNavigationDescriptor)])
        return [object label];
    
    if([object isKindOfClass:[SVAbstractDescriptor class]])
        return [object label];
    
    return @"No idea what this tree node is";
}

@end

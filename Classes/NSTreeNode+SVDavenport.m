//
//  NSTreeNode+SVDavenport.m
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "DPResourceFactory.h"
#import "NSTreeNode+SVDavenport.h"
#import "SVBaseNavigationDescriptor.h"
#import "SVJSONDescriptor.h"
#import "SVBaseNavigationDescriptor.h"
#import "DPContributionNavigationDescriptor.h"

@interface  NSTreeNode (Private)

-(NSDictionary*)convertJSONObjectToDictionary:(NSTreeNode*)treeNode;
-(NSArray*)convertJSONArrayToDictionary:(NSTreeNode*)treeNode;
-(NSArray*)findADatabaseTreeNode:(NSArray*)rootNode ofType:(Class)clazz;

@end

@implementation NSTreeNode (SVDavenport)

-(NSTreeNode *) addCouchServerSection:(NSString *)sectionName{
    SVBaseNavigationDescriptor *section = [[SVBaseNavigationDescriptor alloc] initWithLabel:sectionName
                                                                                andIdentity:sectionName
                                                                                       type:DPDescriptorCouchServer];
    [section setGroupItem:YES];
    return [self addChildNodeWithObject:section];
}

- (NSTreeNode*) addCouchServerNode:(SBCouchServer*)couchServer resourceFactory:(id <DPResourceFactory>)resourceFactory{
    SVBaseNavigationDescriptor *serverDescriptor = [SVBaseNavigationDescriptor serverDescriptor:couchServer 
                                                                                resourceFactory:resourceFactory];  
    NSTreeNode *couchServerNode = [self addChildNodeWithObject:serverDescriptor];
    return couchServerNode;
}

- (NSTreeNode*) addCouchDatabaseNode:(SBCouchDatabase*)couchDatabase resourceFactory:(id <DPResourceFactory>)resourceFactory{
    SVBaseNavigationDescriptor *databaseDescriptor = [SVBaseNavigationDescriptor databaseDescriptor:couchDatabase                                                                                             
                                                                                    resourceFactory:resourceFactory];
    NSTreeNode *databaseTreeNode = [self addChildNodeWithObject:databaseDescriptor];
    return databaseTreeNode;
}

- (NSTreeNode*) addCouchDesignNode:(SBCouchDesignDocument*)couchDesign resourceFactory:(id <DPResourceFactory>)resourceFactory{
    SVBaseNavigationDescriptor *designDescriptor = [SVBaseNavigationDescriptor designDescriptor:couchDesign                                                                                            
                                                                                    resourceFactory:resourceFactory];
    NSTreeNode *designTreeNode = [self addChildNodeWithObject:designDescriptor];
    return designTreeNode;
}

- (NSTreeNode*) addCouchViewNode:(SBCouchView*)couchView resourceFactory:(id <DPResourceFactory>)resourceFactory{
    SVBaseNavigationDescriptor *viewDescriptor = [SVBaseNavigationDescriptor viewDescriptor:couchView                                                                                            
                                                                                resourceFactory:resourceFactory];
    NSTreeNode *viewTreeNode = [self addChildNodeWithObject:viewDescriptor];
    return viewTreeNode;
}

-(NSTreeNode *) addSection:(NSString *)sectionName{
    SVBaseNavigationDescriptor *section = [[SVBaseNavigationDescriptor alloc] initWithLabel:sectionName
                                                                                andIdentity:sectionName
                                                                                       type:DPDescriptorSection];
    [section setGroupItem:YES];
    return [self addChildNodeWithObject:section];
}

-(NSTreeNode *) addDatabase:(NSString *)databaseName{
    SVBaseNavigationDescriptor *database = [[SVBaseNavigationDescriptor alloc] initWithLabel:databaseName
                                                                                  andIdentity:databaseName
                                                                                         type:DPDescriptorCouchDatabase];
    return [self addChildNodeWithObject:database];
}

-(NSTreeNode *) addChildNodeWithObject:(id)object{
    [object retain];
    NSTreeNode *node = [[NSTreeNode alloc] initWithRepresentedObject:object];
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

-(void)logTree{
    SVDebug(@"%@", [self prettyPrint]);
    
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
    
    if([object isKindOfClass:[SVBaseNavigationDescriptor class]])
        return [object label];
    
    return @"No idea what this tree node is";
}

- (NSArray*) nodesWithCouchObjectOfType:(Class)clazz{
    return [self findADatabaseTreeNode:[self childNodes] ofType:clazz];
}

-(NSArray*)findADatabaseTreeNode:(NSArray*)nodes ofType:(Class)clazz{
    NSMutableArray *matches = [NSMutableArray arrayWithCapacity:1];
    for(NSTreeNode *node in nodes){
        id nodeCouchDocument = [node couchObject];
        
        if([nodeCouchDocument isKindOfClass:clazz])
            [matches addObject:node];
                
        NSArray *databaseNodes = [node findADatabaseTreeNode:[node childNodes] ofType:clazz];
        [matches addObjectsFromArray:databaseNodes];
    }
    
    return matches;
}

- (id)couchObject{
    id representedObject = [self representedObject];
    if([representedObject respondsToSelector:@selector(userInfo)]){
        NSDictionary *userInfo = [representedObject userInfo];
        id couchobject =  [userInfo objectForKey:@"couchobject"];
        return couchobject;
    }
    
    
    return nil;
}

@end
